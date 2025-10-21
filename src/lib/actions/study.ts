'use server';

/**
 * 학습 관련 Server Actions
 * Supabase와 연동하여 학습 데이터를 처리합니다.
 */

import { createClient } from '@/lib/supabase/server';
import { calculateNextReview, calculateReviewPriority, calculateXP } from '@/lib/srs/algorithm';
import { addXP, updateStreak, recordStudySession } from '@/lib/actions/gamification';
import { calculateResponseXP, calculateDailyGoalXP } from '@/lib/gamification/xp';
import { revalidatePath } from 'next/cache';
import type {
  StudyItemsResponse,
  RecordAnswerResponse,
  CompleteSessionResponse,
  NewLearningItem,
  ReviewItem,
} from '@/lib/types/api';
import type { AnswerQuality } from '@/components/flashcard/types';

/**
 * 인증된 사용자 ID 가져오기
 */
async function requireAuth(): Promise<string> {
  const supabase = await createClient();
  const { data: { user }, error } = await supabase.auth.getUser();

  if (error || !user) {
    throw new Error('인증이 필요합니다');
  }

  return user.id;
}

/**
 * 1. 학습할 항목 가져오기 (신규 + 복습)
 */
export async function getStudyItems(limit: number = 20): Promise<StudyItemsResponse> {
  const userId = await requireAuth();
  const supabase = await createClient();

  try {
    // 1-1. 모든 학습 항목 가져오기 (order_index 순서대로)
    // limit을 충분히 크게 설정하여 모든 항목을 가져옴
    const { data: allItems, error: itemsError } = await supabase
      .from('learning_items')
      .select('*')
      .order('order_index', { ascending: true })
      .limit(1000); // 충분히 큰 숫자로 설정

    if (itemsError) throw itemsError;

    // 1-2. 사용자 진도 가져오기
    const { data: progressData, error: progressError } = await supabase
      .from('user_progress')
      .select('*')
      .eq('user_id', userId);

    if (progressError) throw progressError;

    // 진도 맵 생성
    const progressMap = new Map(
      progressData?.map(p => [p.item_id, p]) || []
    );

    // 1-3. 신규 항목과 복습 항목 분리
    const newItems: NewLearningItem[] = [];
    const reviewItems: ReviewItem[] = [];

    for (const item of allItems || []) {
      const progress = progressMap.get(item.id);

      if (!progress) {
        // 신규 항목
        newItems.push({
          ...item,
          isNew: true,
        });
      } else if (
        progress.next_review_at &&
        new Date(progress.next_review_at) <= new Date()
      ) {
        // 복습 항목
        reviewItems.push({
          ...item,
          ...progress,
          priority: calculateReviewPriority(
            progress.next_review_at,
            progress.ease_factor
          ),
        });
      }
    }

    // 복습 항목 우선순위순 정렬
    reviewItems.sort((a, b) => b.priority - a.priority);

    // 신규 항목 제한 (하루 5-10개)
    const limitedNewItems = newItems.slice(0, Math.min(newItems.length, 10));

    // 복습 + 신규 = limit 개까지
    const allItemsToStudy = [
      ...reviewItems.slice(0, limit),
      ...limitedNewItems.slice(0, Math.max(0, limit - reviewItems.length)),
    ];

    return {
      newItems: limitedNewItems,
      reviewItems: reviewItems.slice(0, limit),
      allItems: allItemsToStudy,
      totalNew: newItems.length,
      totalReview: reviewItems.length,
    };

  } catch (error) {
    console.error('학습 항목 로드 실패:', error);
    throw error;
  }
}

/**
 * 2. 답변 기록 (SRS 알고리즘 적용)
 */
export async function recordAnswer(params: {
  itemId: string;
  quality: AnswerQuality;
  responseTime?: number;
}): Promise<RecordAnswerResponse> {
  const userId = await requireAuth();
  const supabase = await createClient();

  try {
    const { itemId, quality, responseTime = 0 } = params;

    // 2-1. 학습 항목 정보 가져오기 (type 필드 필요)
    const { data: learningItem } = await supabase
      .from('learning_items')
      .select('type')
      .eq('id', itemId)
      .single();

    if (!learningItem) throw new Error('학습 항목을 찾을 수 없습니다');

    // 2-2. 기존 진도 가져오기
    const { data: existingProgress } = await supabase
      .from('user_progress')
      .select('*')
      .eq('user_id', userId)
      .eq('item_id', itemId)
      .single();

    // 2-3. SRS 알고리즘으로 다음 복습일 계산
    const srsResult = calculateNextReview(
      quality,
      existingProgress ? {
        interval: existingProgress.interval || 0,
        repetitions: existingProgress.repetitions || 0,
        easeFactor: existingProgress.ease_factor || 2.5,
        type: learningItem.type as 'hiragana' | 'katakana' | 'vocabulary' | 'grammar' | 'kanji',
      } : {
        interval: 0,
        repetitions: 0,
        easeFactor: 2.5,
        type: learningItem.type as 'hiragana' | 'katakana' | 'vocabulary' | 'grammar' | 'kanji',
      }
    );

    // 2-3. XP 계산
    const xpEarned = calculateResponseXP(
      quality >= 2,
      responseTime,
      !existingProgress
    );

    // 2-4. user_progress 업데이트 (upsert)
    const { error: progressError } = await supabase
      .from('user_progress')
      .upsert({
        user_id: userId,
        item_id: itemId,
        status: srsResult.status,
        ease_factor: srsResult.easeFactor,
        interval: srsResult.interval,
        repetitions: srsResult.repetitions,
        last_reviewed_at: new Date().toISOString(),
        next_review_at: srsResult.nextReviewDate.toISOString(),
        total_reviews: (existingProgress?.total_reviews || 0) + 1,
        correct_reviews: (existingProgress?.correct_reviews || 0) + (quality >= 2 ? 1 : 0),
        incorrect_reviews: (existingProgress?.incorrect_reviews || 0) + (quality < 2 ? 1 : 0),
      }, {
        onConflict: 'user_id,item_id'
      });

    if (progressError) throw progressError;

    // 2-5. XP 지급
    if (xpEarned > 0) {
      await addXP(userId, xpEarned);
    }

    revalidatePath('/dashboard');
    revalidatePath('/learn');

    return {
      success: true,
      srsResult,
      xpEarned,
    };

  } catch (error) {
    console.error('답변 기록 실패:', error);
    throw error;
  }
}

/**
 * 3. 학습 세션 완료
 */
export async function completeStudySession(params: {
  itemsStudied: number;
  itemsCorrect: number;
  newItems: number;
  reviewItems: number;
  duration: number;
}): Promise<CompleteSessionResponse> {
  const userId = await requireAuth();

  try {
    // 3-1. XP 계산
    const baseXP = params.itemsCorrect * 5 + params.newItems * 10;

    // 일일 목표 달성 보너스 (20개 이상)
    const dailyGoalBonus = calculateDailyGoalXP(params.itemsStudied, 20);

    const totalXP = baseXP + dailyGoalBonus;

    // 3-2. 게임화 시스템에 세션 기록
    await recordStudySession(userId, {
      duration: params.duration,
      itemsStudied: params.itemsStudied,
      itemsCorrect: params.itemsCorrect,
      newItems: params.newItems,
      reviewItems: params.reviewItems,
      xpEarned: totalXP,
    });

    // 3-3. XP 지급
    await addXP(userId, totalXP);

    // 3-4. 스트릭 업데이트
    const streakResult = await updateStreak(userId);

    revalidatePath('/dashboard');

    return {
      success: true,
      xpEarned: totalXP,
      newBadges: [],
    };

  } catch (error) {
    console.error('세션 완료 처리 실패:', error);
    throw error;
  }
}

/**
 * 4. 대시보드 통계 가져오기
 */
export async function getDashboardStats() {
  const userId = await requireAuth();
  const supabase = await createClient();

  try {
    // 오늘 복습 대기 수
    const { count: reviewCount } = await supabase
      .from('user_progress')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', userId)
      .lte('next_review_at', new Date().toISOString());

    // 신규 항목 수 (진도가 없는 항목)
    const { data: allItems } = await supabase
      .from('learning_items')
      .select('id');

    const { data: progressItems } = await supabase
      .from('user_progress')
      .select('item_id')
      .eq('user_id', userId);

    const progressIds = new Set(progressItems?.map(p => p.item_id) || []);
    const newItemsCount = (allItems?.length || 0) - progressIds.size;

    // 마스터한 항목 수
    const { count: masteredCount } = await supabase
      .from('user_progress')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', userId)
      .eq('status', 'mastered');

    // 사용자 통계
    const { data: stats } = await supabase
      .from('user_stats')
      .select('*')
      .eq('user_id', userId)
      .single();

    // 정답률 계산
    const { data: progressData } = await supabase
      .from('user_progress')
      .select('total_reviews, correct_reviews')
      .eq('user_id', userId);

    const totalReviews = progressData?.reduce((sum, p) => sum + p.total_reviews, 0) || 0;
    const correctReviews = progressData?.reduce((sum, p) => sum + p.correct_reviews, 0) || 0;
    const accuracyRate = totalReviews > 0 ? Math.round((correctReviews / totalReviews) * 100) : 0;

    return {
      todayReviewCount: reviewCount || 0,
      newItemsCount: Math.max(0, newItemsCount),
      masteredItemsCount: masteredCount || 0,
      currentStreak: stats?.current_streak || 0,
      accuracyRate,
    };

  } catch (error) {
    console.error('대시보드 통계 로드 실패:', error);
    throw error;
  }
}

/**
 * 최근 활동 데이터 가져오기
 */
export async function getRecentActivity(days: number = 30) {
  try {
    const supabase = await createClient();

    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (!user) throw new Error('인증되지 않은 사용자');

    // 최근 N일의 학습 세션 조회
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - days);

    const { data: sessions, error } = await supabase
      .from('study_sessions')
      .select('session_date, items_studied')
      .eq('user_id', user.id)
      .gte('session_date', startDate.toISOString().split('T')[0])
      .order('session_date', { ascending: true });

    if (error) throw error;

    // 날짜별로 학습 항목 수 집계
    const activityMap = new Map<string, number>();

    sessions?.forEach(session => {
      const date = session.session_date;
      const current = activityMap.get(date) || 0;
      activityMap.set(date, current + session.items_studied);
    });

    // 배열로 변환
    const activity = Array.from(activityMap.entries()).map(([date, count]) => ({
      date,
      count,
    }));

    return activity;
  } catch (error) {
    console.error('최근 활동 로드 실패:', error);
    return [];
  }
}

'use server';

// 게임화 시스템 Server Actions
// XP, 레벨, 스트릭 업데이트를 처리합니다

import { createClient } from '@/lib/supabase/server';
import { calculateLevel, checkLevelUp } from '@/lib/gamification/levels';
import { calculateStreak, checkStreakMilestone } from '@/lib/gamification/streaks';
import { getKoreaToday } from '@/lib/utils/timezone';

/**
 * 사용자 통계 가져오기
 */
export async function getUserStats(userId: string) {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from('user_stats')
    .select('*')
    .eq('user_id', userId)
    .single();

  if (error) {
    // 통계가 없으면 새로 생성
    const { data: newStats, error: insertError } = await supabase
      .from('user_stats')
      .insert({
        user_id: userId,
        level: 1,
        total_xp: 0,
        current_streak: 0,
        longest_streak: 0,
        last_study_date: null,
        total_items_mastered: 0,
        total_study_time: 0,
        total_sessions: 0,
      })
      .select()
      .single();

    if (insertError) throw insertError;
    return newStats;
  }

  return data;
}

/**
 * XP 추가 및 레벨업 체크
 * @param userId 사용자 ID
 * @param xpAmount 획득 XP
 * @returns 업데이트된 통계와 레벨업 정보
 */
export async function addXP(userId: string, xpAmount: number) {
  const supabase = await createClient();

  // 현재 통계 가져오기
  const stats = await getUserStats(userId);
  const previousXP = stats.total_xp;
  const newXP = previousXP + xpAmount;

  // 레벨업 체크
  const levelUpInfo = checkLevelUp(previousXP, newXP);
  const newLevel = calculateLevel(newXP);

  // 통계 업데이트
  const { data, error } = await supabase
    .from('user_stats')
    .update({
      total_xp: newXP,
      level: newLevel,
      updated_at: new Date().toISOString(),
    })
    .eq('user_id', userId)
    .select()
    .single();

  if (error) throw error;

  return {
    stats: data,
    levelUp: levelUpInfo,
    xpGained: xpAmount,
  };
}

/**
 * 스트릭 업데이트
 * @param userId 사용자 ID
 * @returns 업데이트된 스트릭 정보
 */
export async function updateStreak(userId: string) {
  const supabase = await createClient();

  // 현재 통계 가져오기
  const stats = await getUserStats(userId);

  // 스트릭 계산
  const streakInfo = calculateStreak(
    stats.last_study_date ? new Date(stats.last_study_date) : null,
    stats.current_streak
  );

  // 최장 스트릭 업데이트
  const longestStreak = Math.max(stats.longest_streak, streakInfo.newStreak);

  // 마일스톤 체크
  const milestone = checkStreakMilestone(streakInfo.newStreak);

  // 통계 업데이트 - 한국 시간대 사용
  const today = getKoreaToday();
  const { data, error } = await supabase
    .from('user_stats')
    .update({
      current_streak: streakInfo.newStreak,
      longest_streak: longestStreak,
      last_study_date: today,
      updated_at: new Date().toISOString(),
    })
    .eq('user_id', userId)
    .select()
    .single();

  if (error) throw error;

  return {
    stats: data,
    streakInfo,
    milestone,
  };
}

/**
 * 학습 세션 기록
 * @param userId 사용자 ID
 * @param sessionData 세션 데이터
 */
export async function recordStudySession(
  userId: string,
  sessionData: {
    duration: number;
    itemsStudied: number;
    itemsCorrect: number;
    newItems: number;
    reviewItems: number;
    xpEarned: number;
  }
) {
  const supabase = await createClient();

  // 한국 시간대로 오늘 날짜 사용
  const today = getKoreaToday();

  // 세션 기록 - camelCase를 snake_case로 변환
  const { data: session, error: sessionError } = await supabase
    .from('study_sessions')
    .insert({
      user_id: userId,
      session_date: today,
      duration: sessionData.duration,
      items_studied: sessionData.itemsStudied,
      items_correct: sessionData.itemsCorrect,
      new_items: sessionData.newItems,
      review_items: sessionData.reviewItems,
      xp_earned: sessionData.xpEarned,
    })
    .select()
    .single();

  if (sessionError) throw sessionError;

  // 통계 업데이트
  const stats = await getUserStats(userId);
  const { error: statsError } = await supabase
    .from('user_stats')
    .update({
      total_sessions: stats.total_sessions + 1,
      total_study_time: stats.total_study_time + sessionData.duration,
      updated_at: new Date().toISOString(),
    })
    .eq('user_id', userId);

  if (statsError) throw statsError;

  return session;
}

/**
 * 오늘 학습 통계 가져오기
 * @param userId 사용자 ID
 */
export async function getTodayStats(userId: string) {
  const supabase = await createClient();

  // 한국 시간대로 오늘 날짜 계산
  const today = getKoreaToday();

  const { data, error } = await supabase
    .from('study_sessions')
    .select('*')
    .eq('user_id', userId)
    .eq('session_date', today);

  if (error) throw error;

  // data가 null일 경우 빈 배열로 처리
  const sessions = data || [];

  // 통계 집계
  const totalItemsStudied = sessions.reduce((sum, session) => sum + (session.items_studied || 0), 0);
  const totalItemsCorrect = sessions.reduce((sum, session) => sum + (session.items_correct || 0), 0);
  const totalXPEarned = sessions.reduce((sum, session) => sum + (session.xp_earned || 0), 0);
  const totalDuration = sessions.reduce((sum, session) => sum + (session.duration || 0), 0);

  return {
    sessions: sessions.length,
    itemsStudied: totalItemsStudied,
    itemsCorrect: totalItemsCorrect,
    xpEarned: totalXPEarned,
    duration: totalDuration,
    accuracy: totalItemsStudied > 0 ? (totalItemsCorrect / totalItemsStudied) * 100 : 0,
  };
}

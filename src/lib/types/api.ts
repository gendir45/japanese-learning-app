/**
 * API 타입 정의
 * Server Actions 및 데이터베이스 스키마 타입
 */

/**
 * 학습 항목 타입
 */
export type LearningItemType = 'hiragana' | 'katakana' | 'vocabulary' | 'grammar' | 'kanji';

/**
 * JLPT 레벨
 */
export type JLPTLevel = 'N5' | 'N4' | 'N3' | 'N2' | 'N1';

/**
 * 학습 상태
 */
export type ProgressStatus = 'new' | 'learning' | 'reviewing' | 'mastered';

/**
 * 학습 항목 (learning_items 테이블)
 */
export interface LearningItem {
  id: string;
  type: LearningItemType;
  jlpt_level: JLPTLevel;
  content: string;
  reading: string | null;
  meaning: string;
  example_sentence?: string | null;
  example_translation?: string | null;
  example_reading?: string | null;
  notes?: string | null;
  category?: string | null;
  subcategory?: string | null;
  order_index?: number | null;
  difficulty_level?: number | null;
  created_at?: string;
  updated_at?: string;
}

/**
 * 사용자 진행률 (user_progress 테이블)
 */
export interface UserProgress {
  id: string;
  user_id: string;
  item_id: string;
  status: ProgressStatus;
  ease_factor: number;
  interval: number;
  repetitions: number;
  last_reviewed_at: string | null;
  next_review_at: string | null;
  total_reviews: number;
  correct_reviews: number;
  incorrect_reviews: number;
  created_at: string;
  updated_at: string;
}

/**
 * 복습 항목 (learning_items + user_progress 조인)
 */
export interface ReviewItem extends LearningItem {
  // user_progress 필드
  ease_factor: number;
  interval: number;
  repetitions: number;
  next_review_at: string;
  total_reviews: number;
  correct_reviews: number;
  // 메타 필드
  isReview: true;
  priority: number;
}

/**
 * 신규 학습 항목
 */
export interface NewLearningItem extends LearningItem {
  isReview: false;
}

/**
 * 학습 항목 응답
 */
export interface StudyItemsResponse {
  reviewItems: ReviewItem[];
  newItems: NewLearningItem[];
  allItems: (ReviewItem | NewLearningItem)[];
  totalNew: number;
  totalReview: number;
}

/**
 * 답변 기록 요청
 */
export interface RecordAnswerRequest {
  userId: string;
  itemId: string;
  quality: 0 | 1 | 2 | 3;
  responseTime?: number; // 선택적: 응답 시간 (밀리초)
}

/**
 * 답변 기록 응답
 */
export interface RecordAnswerResponse {
  success: boolean;
  srsResult: {
    easeFactor: number;
    interval: number;
    repetitions: number;
    nextReviewDate: Date;
    status: ProgressStatus;
  };
  xpEarned: number;
}

/**
 * 학습 세션 완료 요청
 */
export interface CompleteSessionRequest {
  userId: string;
  itemsStudied: number;
  itemsCorrect: number;
  newItems: number;
  reviewItems: number;
  duration: number; // 초 단위
}

/**
 * 학습 세션 완료 응답
 */
export interface CompleteSessionResponse {
  success: boolean;
  xpEarned: number;
  newBadges: Badge[];
}

/**
 * 배지
 */
export interface Badge {
  id: string;
  badge_id: string;
  name: string;
  description: string;
  icon: string;
  earned_at?: string;
}

/**
 * 사용자 통계
 */
export interface UserStats {
  level: number;
  total_xp: number;
  current_streak: number;
  longest_streak: number;
  last_study_date: string | null;
  total_items_mastered: number;
  total_study_time: number; // 초 단위
  total_sessions: number;
}

/**
 * 학습 세션 기록
 */
export interface StudySession {
  id: string;
  user_id: string;
  session_date: string;
  duration: number;
  items_studied: number;
  items_correct: number;
  items_incorrect?: number;
  new_items: number;
  review_items: number;
  xp_earned: number;
  created_at: string;
}

/**
 * 대시보드 통계
 */
export interface DashboardStats {
  todayReviewCount: number;
  newItemsCount: number;
  currentStreak: number;
  masteredItemsCount: number;
  accuracyRate: number; // 0-100
}

/**
 * API 에러
 */
export interface APIError {
  message: string;
  code: string;
  statusCode?: number;
}

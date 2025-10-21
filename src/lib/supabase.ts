// Supabase 클라이언트 설정
import { createClient } from '@supabase/supabase-js';

// 환경 변수에서 Supabase URL과 Key 가져오기
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

// Supabase 클라이언트 생성
export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
  },
});

// 타입 정의
export type Database = {
  public: {
    Tables: {
      learning_items: {
        Row: LearningItem;
        Insert: Omit<LearningItem, 'id' | 'created_at' | 'updated_at'>;
        Update: Partial<Omit<LearningItem, 'id' | 'created_at'>>;
      };
      user_progress: {
        Row: UserProgress;
        Insert: Omit<UserProgress, 'id' | 'created_at' | 'updated_at'>;
        Update: Partial<Omit<UserProgress, 'id' | 'created_at'>>;
      };
      study_sessions: {
        Row: StudySession;
        Insert: Omit<StudySession, 'id' | 'created_at' | 'updated_at'>;
        Update: Partial<Omit<StudySession, 'id' | 'created_at'>>;
      };
      user_stats: {
        Row: UserStats;
        Insert: Omit<UserStats, 'id' | 'created_at' | 'updated_at'>;
        Update: Partial<Omit<UserStats, 'id' | 'created_at'>>;
      };
      user_badges: {
        Row: UserBadge;
        Insert: Omit<UserBadge, 'id' | 'earned_at'>;
        Update: never;
      };
      badge_definitions: {
        Row: BadgeDefinition;
        Insert: Omit<BadgeDefinition, 'created_at'>;
        Update: Partial<Omit<BadgeDefinition, 'badge_id' | 'created_at'>>;
      };
    };
  };
};

// 학습 항목 타입
export interface LearningItem {
  id: string;
  type: 'hiragana' | 'katakana' | 'vocabulary' | 'grammar' | 'kanji';
  jlpt_level: 'N5' | 'N4' | 'N3' | 'N2' | 'N1';
  content: string;
  reading: string | null;
  meaning: string;
  example_sentence: string | null;
  example_translation: string | null;
  notes: string | null;
  category: string | null;
  subcategory: string | null;
  order_index: number | null;
  difficulty_level: number | null;
  created_at: string;
  updated_at: string;
}

// 사용자 진도 타입
export interface UserProgress {
  id: string;
  user_id: string;
  item_id: string;
  status: 'new' | 'learning' | 'reviewing' | 'mastered';
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

// 학습 세션 타입
export interface StudySession {
  id: string;
  user_id: string;
  session_date: string;
  session_start: string | null;
  session_end: string | null;
  duration: number | null;
  items_studied: number;
  items_correct: number;
  items_incorrect: number;
  new_items: number;
  review_items: number;
  items_by_type: Record<string, number>;
  xp_earned: number;
  created_at: string;
  updated_at: string;
}

// 사용자 통계 타입
export interface UserStats {
  id: string;
  user_id: string;
  level: number;
  total_xp: number;
  current_level_xp: number;
  current_streak: number;
  longest_streak: number;
  last_study_date: string | null;
  total_items_learned: number;
  total_items_mastered: number;
  total_study_time: number;
  total_sessions: number;
  mastered_by_type: Record<string, number>;
  jlpt_progress: Record<string, { total: number; mastered: number }>;
  created_at: string;
  updated_at: string;
}

// 사용자 배지 타입
export interface UserBadge {
  id: string;
  user_id: string;
  badge_id: string;
  badge_category: string | null;
  earned_at: string;
  metadata: Record<string, unknown> | null;
}

// 배지 정의 타입
export interface BadgeDefinition {
  badge_id: string;
  name_ko: string;
  name_ja: string | null;
  description: string;
  icon: string | null;
  category: string;
  rarity: 'common' | 'rare' | 'epic' | 'legendary' | null;
  criteria: Record<string, unknown>;
  xp_reward: number;
  display_order: number | null;
  created_at: string;
}

// 복습 대기 항목 타입 (due_reviews 뷰)
export interface DueReview extends UserProgress {
  type: LearningItem['type'];
  content: string;
  reading: string | null;
  meaning: string;
  category: string | null;
}

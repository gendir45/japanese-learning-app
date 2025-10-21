# Supabase 데이터베이스 스키마 완벽 가이드

## 📋 목차
- [데이터베이스 스키마 개요](#데이터베이스-스키마-개요)
- [마이그레이션 실행 방법](#마이그레이션-실행-방법)
- [TypeScript 타입 생성](#typescript-타입-생성)
- [데이터베이스 구조 상세](#데이터베이스-구조-상세)
- [SRS 알고리즘 구현](#srs-알고리즘-구현)
- [게임화 시스템](#게임화-시스템)
- [실전 사용 예시](#실전-사용-예시)

## 데이터베이스 스키마 개요

일본어 학습 애플리케이션을 위한 완전한 데이터베이스 스키마입니다.

### 주요 테이블

| 테이블명 | 설명 | RLS 정책 | 주요 용도 |
|---------|------|----------|----------|
| `learning_items` | 모든 학습 콘텐츠 | 모든 사용자 읽기 가능 | 히라가나, 가타카나, 단어, 문법, 한자 저장 |
| `user_progress` | 사용자별 학습 진도 | 본인만 접근 | SRS 알고리즘 데이터, 복습 스케줄 |
| `study_sessions` | 학습 세션 기록 | 본인만 접근 | 일일 학습 통계, 스트릭 계산 |
| `user_stats` | 게임화 통계 | 본인만 접근 | 레벨, XP, 스트릭, 누적 통계 |
| `user_badges` | 사용자 획득 배지 | 본인만 접근 | 배지 소유 기록 |
| `badge_definitions` | 배지 정의 | 모든 사용자 읽기 가능 | 배지 마스터 데이터 |

## 마이그레이션 실행 방법

### 방법 1: Supabase Dashboard (권장)

1. [Supabase Dashboard](https://app.supabase.com) 접속
2. 프로젝트 선택
3. 좌측 메뉴 **SQL Editor** 클릭
4. **New Query** 클릭
5. 마이그레이션 파일 복사 & 실행:

```
순서대로 실행:
✅ 00_complete_setup.sql      (전체 스키마 - 한 번만 실행)
✅ 07_insert_sample_hiragana.sql (샘플 데이터 - 히라가나 46자 + 추가 데이터)
```

### 방법 2: Supabase CLI

```bash
# CLI 설치
npm install -g supabase

# 프로젝트 연결
supabase link --project-ref your-project-ref

# 마이그레이션 실행
supabase db push
```

### 마이그레이션 확인

```sql
-- 테이블 확인
SELECT tablename FROM pg_tables WHERE schemaname = 'public';

-- 히라가나 데이터 확인
SELECT COUNT(*) as count FROM learning_items WHERE type = 'hiragana';
-- 결과: 46

-- 샘플 데이터 조회
SELECT content, reading, meaning FROM learning_items
WHERE type = 'hiragana' LIMIT 5;
```

## TypeScript 타입 생성

### 1. Supabase CLI로 타입 자동 생성

```bash
# 원격 DB에서 타입 생성
npx supabase gen types typescript --project-id your-project-ref > src/lib/database.types.ts

# 또는 로컬 DB에서 생성
npx supabase gen types typescript --local > src/lib/database.types.ts
```

### 2. 타입 파일 구조

생성된 `database.types.ts`는 다음과 같은 구조를 가집니다:

```typescript
export type Json = string | number | boolean | null | { [key: string]: Json | undefined } | Json[]

export interface Database {
  public: {
    Tables: {
      learning_items: {
        Row: {
          id: string
          type: 'hiragana' | 'katakana' | 'vocabulary' | 'grammar' | 'kanji'
          jlpt_level: 'N5' | 'N4' | 'N3' | 'N2' | 'N1'
          content: string
          reading: string | null
          meaning: string
          // ... 기타 필드
        }
        Insert: {
          id?: string
          type: 'hiragana' | 'katakana' | 'vocabulary' | 'grammar' | 'kanji'
          // ... 필수/선택 필드
        }
        Update: {
          type?: 'hiragana' | 'katakana' | 'vocabulary' | 'grammar' | 'kanji'
          // ... 모든 필드 선택적
        }
      }
      // ... 다른 테이블들
    }
    Views: {
      due_reviews: {
        Row: { /* ... */ }
      }
      user_progress_stats: {
        Row: { /* ... */ }
      }
    }
    Functions: {
      add_user_xp: {
        Args: { p_user_id: string; p_xp_amount: number }
        Returns: { new_level: number; new_total_xp: number; leveled_up: boolean }
      }
      // ... 다른 함수들
    }
  }
}
```

### 3. 편리한 타입 별칭 정의

`src/lib/database.types.ts` 파일 맨 아래 추가:

```typescript
// 테이블 Row 타입
export type LearningItem = Database['public']['Tables']['learning_items']['Row']
export type UserProgress = Database['public']['Tables']['user_progress']['Row']
export type StudySession = Database['public']['Tables']['study_sessions']['Row']
export type UserStats = Database['public']['Tables']['user_stats']['Row']
export type UserBadge = Database['public']['Tables']['user_badges']['Row']
export type BadgeDefinition = Database['public']['Tables']['badge_definitions']['Row']

// Insert 타입
export type LearningItemInsert = Database['public']['Tables']['learning_items']['Insert']
export type UserProgressInsert = Database['public']['Tables']['user_progress']['Insert']
export type StudySessionInsert = Database['public']['Tables']['study_sessions']['Insert']

// Update 타입
export type LearningItemUpdate = Database['public']['Tables']['learning_items']['Update']
export type UserProgressUpdate = Database['public']['Tables']['user_progress']['Update']
export type UserStatsUpdate = Database['public']['Tables']['user_stats']['Update']

// View 타입
export type DueReview = Database['public']['Views']['due_reviews']['Row']
export type ProgressStats = Database['public']['Views']['user_progress_stats']['Row']

// Function 반환 타입
export type XPResult = Database['public']['Functions']['add_user_xp']['Returns']
export type StreakResult = Database['public']['Functions']['update_user_streak']['Returns']
```

### 4. Supabase 클라이언트 설정

```typescript
// src/lib/supabase.ts
import { createClient } from '@supabase/supabase-js'
import type { Database } from './database.types'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!

export const supabase = createClient<Database>(supabaseUrl, supabaseAnonKey)

// 타입 안전한 쿼리 예시
const { data } = await supabase
  .from('learning_items')  // 자동 완성 지원
  .select('*')
  .eq('type', 'hiragana')  // 타입 체크
// data는 LearningItem[] | null 타입
```

## 데이터베이스 구조 상세

### learning_items 테이블

학습 콘텐츠 마스터 테이블입니다.

**스키마**:
```sql
CREATE TABLE learning_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- 항목 타입 및 레벨
  type TEXT NOT NULL CHECK (type IN ('hiragana', 'katakana', 'vocabulary', 'grammar', 'kanji')),
  jlpt_level TEXT NOT NULL CHECK (jlpt_level IN ('N5', 'N4', 'N3', 'N2', 'N1')),

  -- 학습 내용
  content TEXT NOT NULL,          -- 일본어 원문
  reading TEXT,                   -- 히라가나 읽기
  meaning TEXT NOT NULL,          -- 한국어 뜻

  -- 추가 정보
  example_sentence TEXT,          -- 예문
  example_translation TEXT,       -- 예문 번역
  notes TEXT,                     -- 학습 팁

  -- 분류 및 순서
  category TEXT,                  -- 카테고리
  subcategory TEXT,               -- 세부 카테고리
  order_index INTEGER,            -- 학습 순서
  difficulty_level INTEGER CHECK (difficulty_level BETWEEN 1 AND 5),

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
)
```

**인덱스**:
- `idx_learning_items_type`: 타입별 조회 (hiragana, vocabulary 등)
- `idx_learning_items_jlpt_level`: JLPT 레벨별 필터링
- `idx_learning_items_type_jlpt`: 복합 인덱스 (타입 + 레벨)
- `idx_learning_items_order`: 학습 순서 정렬
- `idx_learning_items_category`: 카테고리별 필터링

**사용 예시**:
```typescript
// N5 히라가나 목록
const { data } = await supabase
  .from('learning_items')
  .select('*')
  .eq('type', 'hiragana')
  .eq('jlpt_level', 'N5')
  .order('order_index')

// 카테고리별 단어 목록
const { data } = await supabase
  .from('learning_items')
  .select('*')
  .eq('type', 'vocabulary')
  .eq('category', 'greeting')
  .order('order_index')
```

### user_progress 테이블 (SRS 핵심)

사용자별 학습 진도와 복습 스케줄을 관리하는 핵심 테이블입니다.

**스키마**:
```sql
CREATE TABLE user_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  item_id UUID NOT NULL REFERENCES learning_items(id) ON DELETE CASCADE,

  -- 학습 상태
  status TEXT NOT NULL DEFAULT 'new'
    CHECK (status IN ('new', 'learning', 'reviewing', 'mastered')),

  -- SRS 알고리즘 파라미터 (SM-2)
  ease_factor FLOAT NOT NULL DEFAULT 2.5 CHECK (ease_factor >= 1.3),
  interval INTEGER NOT NULL DEFAULT 1 CHECK (interval >= 1),
  repetitions INTEGER NOT NULL DEFAULT 0 CHECK (repetitions >= 0),

  -- 복습 스케줄
  last_reviewed_at TIMESTAMPTZ,
  next_review_at TIMESTAMPTZ,

  -- 통계
  total_reviews INTEGER NOT NULL DEFAULT 0,
  correct_reviews INTEGER NOT NULL DEFAULT 0,
  incorrect_reviews INTEGER NOT NULL DEFAULT 0,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(user_id, item_id)
)
```

**주요 인덱스**:
```sql
-- 복습 대기 항목 빠른 조회 (가장 중요!)
CREATE INDEX idx_user_progress_due_reviews
ON user_progress(user_id, next_review_at)
WHERE status IN ('learning', 'reviewing');

-- 사용자별 상태 필터링
CREATE INDEX idx_user_progress_user_status
ON user_progress(user_id, status);
```

**상태(status) 의미**:
- `new`: 아직 학습하지 않은 항목
- `learning`: 학습 시작 (interval < 21일)
- `reviewing`: 복습 단계 (interval >= 21일)
- `mastered`: 완전히 습득 (정의에 따라 다름, 예: interval > 180일)

### study_sessions 테이블

각 학습 세션의 상세 기록을 저장합니다.

**스키마**:
```sql
CREATE TABLE study_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

  -- 세션 정보
  session_date DATE NOT NULL DEFAULT CURRENT_DATE,
  session_start TIMESTAMPTZ,
  session_end TIMESTAMPTZ,
  duration INTEGER,               -- 초 단위

  -- 학습 통계
  items_studied INTEGER DEFAULT 0,
  items_correct INTEGER DEFAULT 0,
  items_incorrect INTEGER DEFAULT 0,
  new_items INTEGER DEFAULT 0,
  review_items INTEGER DEFAULT 0,

  -- 타입별 통계 (JSONB)
  items_by_type JSONB DEFAULT '{}'::JSONB,

  -- 게임화
  xp_earned INTEGER DEFAULT 0,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
)
```

**items_by_type 구조**:
```json
{
  "hiragana": 5,
  "katakana": 3,
  "vocabulary": 10,
  "grammar": 2,
  "kanji": 0
}
```

### user_stats 테이블

사용자 게임화 통계 및 누적 데이터를 저장합니다.

**스키마**:
```sql
CREATE TABLE user_stats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,

  -- 레벨 시스템
  level INTEGER NOT NULL DEFAULT 1 CHECK (level >= 1),
  total_xp INTEGER NOT NULL DEFAULT 0,
  current_level_xp INTEGER NOT NULL DEFAULT 0,

  -- 스트릭
  current_streak INTEGER NOT NULL DEFAULT 0,
  longest_streak INTEGER NOT NULL DEFAULT 0,
  last_study_date DATE,

  -- 누적 통계
  total_items_learned INTEGER NOT NULL DEFAULT 0,
  total_items_mastered INTEGER NOT NULL DEFAULT 0,
  total_study_time INTEGER NOT NULL DEFAULT 0,
  total_sessions INTEGER NOT NULL DEFAULT 0,

  -- 타입별 마스터 개수 (JSONB)
  mastered_by_type JSONB DEFAULT '{"hiragana":0,"katakana":0,"vocabulary":0,"grammar":0,"kanji":0}'::JSONB,

  -- JLPT 레벨별 진도 (JSONB)
  jlpt_progress JSONB DEFAULT '{"N5":{"total":0,"mastered":0},...}'::JSONB,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
)
```

### 유용한 뷰 (Views)

#### due_reviews (복습 대기 항목)

```sql
CREATE VIEW due_reviews AS
SELECT
  up.*,
  li.type, li.content, li.reading, li.meaning, li.category
FROM user_progress up
JOIN learning_items li ON up.item_id = li.id
WHERE up.next_review_at IS NOT NULL
  AND up.next_review_at <= NOW()
  AND up.status IN ('learning', 'reviewing')
ORDER BY up.next_review_at ASC;
```

**사용 예시**:
```typescript
// 오늘 복습할 항목 20개 가져오기
const { data: dueItems } = await supabase
  .from('due_reviews')
  .select('*')
  .limit(20)
```

#### user_progress_stats (진도 통계)

```sql
CREATE VIEW user_progress_stats AS
SELECT
  user_id,
  COUNT(*) as total_items,
  COUNT(*) FILTER (WHERE status = 'new') as new_items,
  COUNT(*) FILTER (WHERE status = 'learning') as learning_items,
  COUNT(*) FILTER (WHERE status = 'reviewing') as reviewing_items,
  COUNT(*) FILTER (WHERE status = 'mastered') as mastered_items,
  AVG(CASE WHEN total_reviews > 0
      THEN correct_reviews::FLOAT / total_reviews ELSE 0 END) as avg_accuracy
FROM user_progress
GROUP BY user_id;
```

## SRS 알고리즘 구현

### SM-2 알고리즘 기반 구현

**답변 품질 (AnswerQuality)**:
```typescript
export type AnswerQuality = 0 | 1 | 2 | 3

// 0: Again - 완전히 틀림
// 1: Hard - 어려움
// 2: Good - 보통
// 3: Easy - 쉬움
```

**SRS 계산 로직**:
```typescript
// src/lib/srs.ts
import type { UserProgress } from './database.types'
import type { AnswerQuality } from '@/components/flashcard/types'

interface SRSResult {
  easeFactor: number
  interval: number
  repetitions: number
  nextReviewAt: Date
  status: 'new' | 'learning' | 'reviewing' | 'mastered'
}

export function calculateNextReview(
  quality: AnswerQuality,
  currentProgress: UserProgress
): SRSResult {
  let { ease_factor, interval, repetitions } = currentProgress
  let status = currentProgress.status

  // Ease Factor 계산 (SM-2 알고리즘)
  ease_factor = Math.max(
    1.3,
    ease_factor + (0.1 - (3 - quality) * (0.08 + (3 - quality) * 0.02))
  )

  // 답변에 따른 간격 계산
  if (quality < 2) {
    // Again 또는 Hard - 처음부터 다시
    repetitions = 0
    interval = 1
    status = 'learning'
  } else {
    // Good 또는 Easy - 간격 증가
    repetitions += 1

    if (repetitions === 1) {
      interval = 1
    } else if (repetitions === 2) {
      interval = 6
    } else {
      interval = Math.round(interval * ease_factor)
    }

    // 상태 업데이트
    if (interval >= 21) {
      status = 'reviewing'
    }
    if (interval >= 180) {
      status = 'mastered'
    }
  }

  // 다음 복습일 계산
  const nextReviewAt = new Date()
  nextReviewAt.setDate(nextReviewAt.getDate() + interval)

  return {
    easeFactor: ease_factor,
    interval,
    repetitions,
    nextReviewAt,
    status,
  }
}
```

**답변 제출 함수**:
```typescript
// src/lib/api/progress.ts
import { supabase } from '@/lib/supabase'
import { calculateNextReview } from '@/lib/srs'

export async function submitAnswer(
  itemId: string,
  quality: AnswerQuality
): Promise<{ success: boolean; xpEarned: number }> {
  // 1. 현재 진도 조회
  const { data: progress } = await supabase
    .from('user_progress')
    .select('*')
    .eq('item_id', itemId)
    .single()

  if (!progress) {
    throw new Error('Progress not found')
  }

  // 2. SRS 계산
  const nextReview = calculateNextReview(quality, progress)

  // 3. 진도 업데이트
  await supabase
    .from('user_progress')
    .update({
      ease_factor: nextReview.easeFactor,
      interval: nextReview.interval,
      repetitions: nextReview.repetitions,
      next_review_at: nextReview.nextReviewAt.toISOString(),
      last_reviewed_at: new Date().toISOString(),
      status: nextReview.status,
      total_reviews: progress.total_reviews + 1,
      correct_reviews: quality >= 2
        ? progress.correct_reviews + 1
        : progress.correct_reviews,
      incorrect_reviews: quality < 2
        ? progress.incorrect_reviews + 1
        : progress.incorrect_reviews,
    })
    .eq('id', progress.id)

  // 4. XP 계산 및 부여
  const xpEarned = calculateXP(quality, nextReview.repetitions)
  if (xpEarned > 0) {
    await supabase.rpc('add_user_xp', {
      p_user_id: progress.user_id,
      p_xp_amount: xpEarned,
    })
  }

  return { success: true, xpEarned }
}

function calculateXP(quality: AnswerQuality, repetitions: number): number {
  const baseXP = [5, 10, 15, 20] // Again, Hard, Good, Easy
  const bonusMultiplier = 1 + (repetitions * 0.1) // 연속 성공 보너스
  return Math.round(baseXP[quality] * bonusMultiplier)
}
```

## 게임화 시스템

### 레벨 & XP 시스템

**레벨 공식**:
- 레벨 1→2: 100 XP
- 레벨 2→3: 150 XP (100 × 1.5)
- 레벨 3→4: 225 XP (100 × 1.5²)
- 레벨 n→n+1: 100 × 1.5^(n-1) XP

**XP 추가 함수 사용**:
```typescript
// XP 추가 및 자동 레벨업
const { data: xpResult } = await supabase.rpc('add_user_xp', {
  p_user_id: userId,
  p_xp_amount: 50,
})

// 반환값
xpResult = {
  new_level: 3,
  new_total_xp: 350,
  leveled_up: true,  // 레벨업 발생 시 true
  xp_to_next_level: 75,
}

// 레벨업 발생 시 UI에 축하 메시지 표시
if (xpResult.leveled_up) {
  showLevelUpNotification(xpResult.new_level)
}
```

### 스트릭 시스템

```typescript
// 학습 완료 시 스트릭 업데이트
const { data: streakResult } = await supabase.rpc('update_user_streak', {
  p_user_id: userId,
  p_study_date: new Date().toISOString().split('T')[0], // YYYY-MM-DD
})

// 반환값
streakResult = {
  new_current_streak: 7,
  new_longest_streak: 15,
  streak_broken: false,  // 스트릭이 끊겼는지 여부
}

// 스트릭 끊김 시 안내 메시지
if (streakResult.streak_broken) {
  showStreakBrokenMessage()
} else if (streakResult.new_current_streak > 1) {
  showStreakContinuedMessage(streakResult.new_current_streak)
}
```

### 배지 시스템

**배지 자동 확인 및 부여**:
```typescript
// 학습 완료 후 배지 확인
const { data: newBadges } = await supabase.rpc('check_and_award_badges', {
  p_user_id: userId,
})

// 새로 획득한 배지가 있으면 축하 메시지
if (newBadges && newBadges.length > 0) {
  newBadges.forEach((badge) => {
    showBadgeAwardedNotification(badge.badge_name)
  })
}
```

**배지 목록 조회**:
```typescript
// 사용자가 획득한 모든 배지
const { data: userBadges } = await supabase
  .from('user_badges')
  .select(`
    *,
    badge_definitions (
      badge_id,
      name_ko,
      description,
      icon,
      category,
      rarity
    )
  `)
  .order('earned_at', { ascending: false })

// 아직 획득하지 못한 배지
const { data: availableBadges } = await supabase
  .from('badge_definitions')
  .select('*')
  .not('badge_id', 'in', `(
    SELECT badge_id FROM user_badges WHERE user_id = '${userId}'
  )`)
```

## 실전 사용 예시

### 1. 새로운 학습 세션 시작

```typescript
// src/lib/api/session.ts
export async function startStudySession(userId: string) {
  // 1. 오늘 복습할 항목 가져오기 (20개)
  const { data: dueItems } = await supabase
    .from('due_reviews')
    .select('*')
    .limit(20)

  // 2. 새로운 항목 가져오기 (5개)
  const { data: newItems } = await supabase
    .from('learning_items')
    .select('*')
    .eq('jlpt_level', 'N5')
    .eq('type', 'hiragana')
    .not('id', 'in', `(
      SELECT item_id FROM user_progress WHERE user_id = '${userId}'
    )`)
    .limit(5)

  // 3. 새 항목에 대한 진도 생성
  if (newItems) {
    const progressInserts = newItems.map((item) => ({
      user_id: userId,
      item_id: item.id,
      status: 'new' as const,
    }))

    await supabase.from('user_progress').insert(progressInserts)
  }

  // 4. 세션 항목 합치기
  const sessionItems = [...(dueItems || []), ...(newItems || [])]

  return {
    items: sessionItems,
    dueCount: dueItems?.length || 0,
    newCount: newItems?.length || 0,
  }
}
```

### 2. 학습 세션 완료 처리

```typescript
// src/lib/api/session.ts
export async function completeStudySession(
  userId: string,
  sessionData: {
    startTime: Date
    items: { id: string; quality: AnswerQuality }[]
  }
) {
  const endTime = new Date()
  const duration = Math.floor((endTime.getTime() - sessionData.startTime.getTime()) / 1000)

  // 1. 각 항목에 대한 답변 처리
  let correctCount = 0
  let totalXP = 0

  for (const item of sessionData.items) {
    const result = await submitAnswer(item.id, item.quality)
    if (item.quality >= 2) correctCount++
    totalXP += result.xpEarned
  }

  // 2. 학습 세션 기록
  await supabase.from('study_sessions').insert({
    user_id: userId,
    session_start: sessionData.startTime.toISOString(),
    session_end: endTime.toISOString(),
    duration,
    items_studied: sessionData.items.length,
    items_correct: correctCount,
    items_incorrect: sessionData.items.length - correctCount,
    xp_earned: totalXP,
  })

  // 3. 스트릭 업데이트
  const streakResult = await supabase.rpc('update_user_streak', {
    p_user_id: userId,
  })

  // 4. 배지 확인
  const newBadges = await supabase.rpc('check_and_award_badges', {
    p_user_id: userId,
  })

  return {
    correctCount,
    totalXP,
    duration,
    streakResult: streakResult.data,
    newBadges: newBadges.data,
  }
}
```

### 3. 대시보드 데이터 조회

```typescript
// src/lib/api/dashboard.ts
export async function getDashboardData(userId: string) {
  // 1. 사용자 통계
  const { data: stats } = await supabase
    .from('user_stats')
    .select('*')
    .eq('user_id', userId)
    .single()

  // 2. 진도 통계
  const { data: progressStats } = await supabase
    .from('user_progress_stats')
    .select('*')
    .eq('user_id', userId)
    .single()

  // 3. 오늘 복습 대기 개수
  const { count: dueCount } = await supabase
    .from('due_reviews')
    .select('*', { count: 'exact', head: true })

  // 4. 주간 학습 통계
  const { data: weeklyStats } = await supabase
    .from('weekly_study_stats')
    .select('*')
    .eq('user_id', userId)
    .order('week_start', { ascending: false })
    .limit(1)
    .single()

  // 5. 최근 획득 배지
  const { data: recentBadges } = await supabase
    .from('user_badges')
    .select(`
      *,
      badge_definitions (name_ko, icon, rarity)
    `)
    .order('earned_at', { ascending: false })
    .limit(3)

  return {
    stats,
    progressStats,
    dueCount,
    weeklyStats,
    recentBadges,
  }
}
```

### 4. JLPT 레벨별 진도 조회

```typescript
// src/lib/api/progress.ts
export async function getJLPTProgress(userId: string, jlptLevel: string) {
  // 1. 해당 레벨의 모든 항목 수
  const { count: totalCount } = await supabase
    .from('learning_items')
    .select('*', { count: 'exact', head: true })
    .eq('jlpt_level', jlptLevel)

  // 2. 마스터한 항목 수
  const { count: masteredCount } = await supabase
    .from('user_progress')
    .select('*', { count: 'exact', head: true })
    .eq('user_id', userId)
    .eq('status', 'mastered')
    .eq('learning_items.jlpt_level', jlptLevel)

  // 3. 타입별 진도
  const { data: typeProgress } = await supabase
    .from('user_progress')
    .select(`
      status,
      learning_items (type)
    `)
    .eq('user_id', userId)
    .eq('learning_items.jlpt_level', jlptLevel)

  const byType = {
    hiragana: { total: 0, mastered: 0 },
    katakana: { total: 0, mastered: 0 },
    vocabulary: { total: 0, mastered: 0 },
    grammar: { total: 0, mastered: 0 },
    kanji: { total: 0, mastered: 0 },
  }

  typeProgress?.forEach((item) => {
    const type = item.learning_items.type
    byType[type].total++
    if (item.status === 'mastered') {
      byType[type].mastered++
    }
  })

  return {
    jlptLevel,
    totalItems: totalCount || 0,
    masteredItems: masteredCount || 0,
    progressPercentage: Math.round(((masteredCount || 0) / (totalCount || 1)) * 100),
    byType,
  }
}
```

## 문제 해결

### RLS 정책 디버깅

```sql
-- 현재 사용자 확인
SELECT auth.uid();

-- 특정 테이블의 RLS 정책 확인
SELECT * FROM pg_policies WHERE tablename = 'user_progress';

-- RLS 임시 비활성화 (테스트 전용 - 절대 프로덕션에서 사용 금지!)
ALTER TABLE user_progress DISABLE ROW LEVEL SECURITY;

-- RLS 다시 활성화
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;
```

### 성능 최적화 팁

1. **복습 큐 조회 최적화**: 이미 인덱스가 설정되어 있음
2. **N+1 문제 방지**: `select()` 시 JOIN 사용
3. **JSONB 필드 인덱스**: 자주 조회하는 JSONB 키에 GIN 인덱스 추가

```sql
-- JSONB 필드 인덱스 예시
CREATE INDEX idx_user_stats_mastered_hiragana
ON user_stats ((mastered_by_type->>'hiragana'));
```

## 추가 리소스

- [Supabase 공식 문서](https://supabase.com/docs)
- [PostgreSQL JSONB 가이드](https://www.postgresql.org/docs/current/datatype-json.html)
- [SM-2 알고리즘 상세 설명](https://www.supermemo.com/en/archives1990-2015/english/ol/sm2)

---

**작성일**: 2025-10-20
**버전**: 2.0.0
**마이그레이션 파일**: 00_complete_setup.sql, 07_insert_sample_hiragana.sql

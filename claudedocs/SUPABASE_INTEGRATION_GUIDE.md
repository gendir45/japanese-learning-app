# Supabase 통합 구현 가이드

**프로젝트**: Japanese Learning App
**작성일**: 2025-10-20
**상태**: Phase 3 프론트엔드 구현 준비 완료

---

## 📋 목차

1. [현재 상태 분석](#1-현재-상태-분석)
2. [인증 플로우 구현](#2-인증-플로우-구현)
3. [데이터 페칭 패턴](#3-데이터-페칭-패턴)
4. [RLS 보안 검증](#4-rls-보안-검증)
5. [타입 안전성](#5-타입-안전성)
6. [에러 처리 및 로깅](#6-에러-처리-및-로깅)
7. [구현 우선순위](#7-구현-우선순위)
8. [베스트 프랙티스](#8-베스트-프랙티스)

---

## 1. 현재 상태 분석

### ✅ 구현 완료 항목

#### 1.1 Supabase 클라이언트 설정
```
src/lib/supabase/
├── client.ts          ✅ 브라우저 클라이언트 (Client Components)
├── server.ts          ✅ 서버 클라이언트 (Server Components/Actions)
└── middleware.ts      ✅ 미들웨어 세션 갱신
```

**평가**:
- Next.js 15 App Router 패턴 준수
- `@supabase/ssr` v0.7.0 최신 버전 사용
- 쿠키 기반 세션 관리 올바르게 구현
- 미들웨어에서 자동 세션 갱신 설정

#### 1.2 인증 시스템
```
src/lib/auth/actions.ts  ✅ Server Actions
src/app/login/           ✅ 로그인 페이지
src/app/signup/          ✅ 회원가입 페이지
src/app/dashboard/       ✅ 보호된 대시보드
```

**평가**:
- Server Actions 패턴 올바르게 사용
- 기본 인증 플로우 구현 완료
- `revalidatePath` 활용한 캐시 무효화

#### 1.3 데이터베이스 스키마
```
supabase/migrations/
├── 01_create_learning_items.sql   ✅ 학습 콘텐츠
├── 02_create_user_progress.sql    ✅ SRS 진도 관리
├── 03_create_study_sessions.sql   ✅ 세션 기록
├── 04_create_user_stats.sql       ✅ 게임화 통계
├── 05_create_user_badges.sql      ✅ 배지 시스템
├── 06_setup_rls.sql               ✅ RLS 정책
└── 00_complete_setup.sql          ✅ 통합 마이그레이션
```

**평가**:
- 스키마 설계 우수 (정규화, 인덱싱, 제약조건)
- RLS 정책 철저히 구현
- 유용한 뷰/함수 제공 (due_reviews, calculate_level_from_xp 등)
- SRS 알고리즘 데이터 모델 완비

### ⚠️ 개선 필요 항목

#### 1.4 에러 처리
**현재 문제점**:
```typescript
// ❌ 현재: 에러만 반환하고 사용자 피드백 없음
const { error } = await supabase.auth.signUp(data)
if (error) {
  return { error: error.message }  // UI에 표시되지 않음
}
```

**개선 방안**: 섹션 2.4 참조

#### 1.5 타입 정의
**누락 사항**:
- Supabase Database 타입 자동 생성 미구현
- TypeScript 타입 안전성 부족

**해결책**: 섹션 5 참조

#### 1.6 로딩 상태
**누락 사항**:
- 인증 액션 중 로딩 UI 없음
- 낙관적 UI 업데이트 미구현

**해결책**: 섹션 2.5 참조

#### 1.7 환경 변수 검증
**현재 상태**:
```typescript
// ⚠️ 런타임 에러 가능성
process.env.NEXT_PUBLIC_SUPABASE_URL!
process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
```

**개선 방안**: 섹션 8.1 참조

---

## 2. 인증 플로우 구현

### 2.1 회원가입 플로우

#### Server Action (개선 버전)
```typescript
// src/lib/auth/actions.ts

'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { z } from 'zod'

// 입력 검증 스키마
const signUpSchema = z.object({
  email: z.string().email('유효한 이메일을 입력해주세요'),
  password: z.string().min(6, '비밀번호는 최소 6자 이상이어야 합니다'),
})

export type AuthResult =
  | { success: true; message?: string }
  | { success: false; error: string; field?: string }

export async function signUp(formData: FormData): Promise<AuthResult> {
  const supabase = await createClient()

  // 1. 입력 검증
  const validationResult = signUpSchema.safeParse({
    email: formData.get('email'),
    password: formData.get('password'),
  })

  if (!validationResult.success) {
    const firstError = validationResult.error.errors[0]
    return {
      success: false,
      error: firstError.message,
      field: firstError.path[0] as string,
    }
  }

  const { email, password } = validationResult.data

  try {
    // 2. Supabase 회원가입
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        // 이메일 인증 후 리다이렉트 URL (선택사항)
        emailRedirectTo: `${process.env.NEXT_PUBLIC_SITE_URL}/auth/callback`,
      },
    })

    if (error) {
      // Supabase 에러 메시지 한국어 변환
      return {
        success: false,
        error: getKoreanErrorMessage(error.message),
      }
    }

    // 3. 이메일 인증 필요 여부 확인
    if (data.user && !data.user.confirmed_at) {
      return {
        success: true,
        message: '인증 이메일을 발송했습니다. 이메일을 확인해주세요.',
      }
    }

    // 4. user_stats 초기화 (신규 사용자)
    if (data.user) {
      const { error: statsError } = await supabase
        .from('user_stats')
        .insert({
          user_id: data.user.id,
          level: 1,
          total_xp: 0,
        })

      if (statsError) {
        console.error('Failed to initialize user_stats:', statsError)
        // 치명적이지 않으므로 계속 진행
      }
    }

    revalidatePath('/', 'layout')
    redirect('/dashboard')
  } catch (error) {
    console.error('Signup error:', error)
    return {
      success: false,
      error: '회원가입 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
    }
  }
}

// 에러 메시지 한국어 변환
function getKoreanErrorMessage(message: string): string {
  const errorMap: Record<string, string> = {
    'User already registered': '이미 가입된 이메일입니다',
    'Invalid login credentials': '이메일 또는 비밀번호가 올바르지 않습니다',
    'Email not confirmed': '이메일 인증을 완료해주세요',
    'Password should be at least 6 characters': '비밀번호는 최소 6자 이상이어야 합니다',
  }

  for (const [key, value] of Object.entries(errorMap)) {
    if (message.includes(key)) return value
  }

  return '오류가 발생했습니다. 다시 시도해주세요.'
}
```

### 2.2 로그인 플로우

```typescript
// src/lib/auth/actions.ts

const signInSchema = z.object({
  email: z.string().email('유효한 이메일을 입력해주세요'),
  password: z.string().min(1, '비밀번호를 입력해주세요'),
})

export async function signIn(formData: FormData): Promise<AuthResult> {
  const supabase = await createClient()

  // 입력 검증
  const validationResult = signInSchema.safeParse({
    email: formData.get('email'),
    password: formData.get('password'),
  })

  if (!validationResult.success) {
    const firstError = validationResult.error.errors[0]
    return {
      success: false,
      error: firstError.message,
      field: firstError.path[0] as string,
    }
  }

  const { email, password } = validationResult.data

  try {
    const { error } = await supabase.auth.signInWithPassword({
      email,
      password,
    })

    if (error) {
      return {
        success: false,
        error: getKoreanErrorMessage(error.message),
      }
    }

    revalidatePath('/', 'layout')
    redirect('/dashboard')
  } catch (error) {
    console.error('Login error:', error)
    return {
      success: false,
      error: '로그인 중 오류가 발생했습니다.',
    }
  }
}
```

### 2.3 로그아웃 플로우

```typescript
// src/lib/auth/actions.ts

export async function signOut(): Promise<AuthResult> {
  const supabase = await createClient()

  try {
    const { error } = await supabase.auth.signOut()

    if (error) {
      return {
        success: false,
        error: '로그아웃에 실패했습니다.',
      }
    }

    revalidatePath('/', 'layout')
    redirect('/')
  } catch (error) {
    console.error('Logout error:', error)
    return {
      success: false,
      error: '로그아웃 중 오류가 발생했습니다.',
    }
  }
}
```

### 2.4 사용자 정보 조회

```typescript
// src/lib/auth/actions.ts

export async function getUser() {
  const supabase = await createClient()

  const {
    data: { user },
    error,
  } = await supabase.auth.getUser()

  if (error) {
    console.error('Get user error:', error)
    return null
  }

  return user
}

// 사용자 통계 포함 조회
export async function getUserWithStats() {
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) return null

  // 사용자 통계 조회
  const { data: stats } = await supabase
    .from('user_stats')
    .select('*')
    .eq('user_id', user.id)
    .single()

  return {
    user,
    stats: stats || null,
  }
}
```

### 2.5 클라이언트 컴포넌트 (에러/로딩 처리)

```typescript
// src/components/auth/SignUpForm.tsx

'use client'

import { useFormState, useFormStatus } from 'react-dom'
import { signUp } from '@/lib/auth/actions'

const initialState = {
  success: false as const,
  error: '',
}

function SubmitButton() {
  const { pending } = useFormStatus()

  return (
    <button
      type="submit"
      disabled={pending}
      className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed"
    >
      {pending ? (
        <>
          <svg className="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
            <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          처리 중...
        </>
      ) : (
        '회원가입'
      )}
    </button>
  )
}

export function SignUpForm() {
  const [state, formAction] = useFormState(signUp, initialState)

  return (
    <form action={formAction} className="mt-8 space-y-6">
      {/* 에러 메시지 */}
      {!state.success && state.error && (
        <div className="rounded-md bg-red-50 p-4">
          <div className="flex">
            <div className="flex-shrink-0">
              <svg className="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clipRule="evenodd" />
              </svg>
            </div>
            <div className="ml-3">
              <p className="text-sm font-medium text-red-800">{state.error}</p>
            </div>
          </div>
        </div>
      )}

      {/* 성공 메시지 */}
      {state.success && state.message && (
        <div className="rounded-md bg-green-50 p-4">
          <div className="flex">
            <div className="flex-shrink-0">
              <svg className="h-5 w-5 text-green-400" viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
              </svg>
            </div>
            <div className="ml-3">
              <p className="text-sm font-medium text-green-800">{state.message}</p>
            </div>
          </div>
        </div>
      )}

      <div className="space-y-4">
        {/* 이메일 */}
        <div>
          <label htmlFor="email" className="block text-sm font-medium text-gray-700">
            이메일
          </label>
          <input
            id="email"
            name="email"
            type="email"
            autoComplete="email"
            required
            className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
            placeholder="your@email.com"
          />
        </div>

        {/* 비밀번호 */}
        <div>
          <label htmlFor="password" className="block text-sm font-medium text-gray-700">
            비밀번호
          </label>
          <input
            id="password"
            name="password"
            type="password"
            autoComplete="new-password"
            required
            minLength={6}
            className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
            placeholder="••••••••"
          />
          <p className="mt-1 text-xs text-gray-500">최소 6자 이상</p>
        </div>
      </div>

      <SubmitButton />
    </form>
  )
}
```

### 2.6 세션 관리 전략

#### 자동 세션 갱신 (현재 구현)
```typescript
// src/middleware.ts - 이미 구현됨
export async function middleware(request: NextRequest) {
  return await updateSession(request)  // 모든 요청마다 세션 갱신
}
```

#### 인증 상태 실시간 감지 (선택사항)
```typescript
// src/components/AuthProvider.tsx

'use client'

import { createClient } from '@/lib/supabase/client'
import { useRouter } from 'next/navigation'
import { useEffect } from 'react'

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const router = useRouter()
  const supabase = createClient()

  useEffect(() => {
    // 인증 상태 변경 감지
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((event, session) => {
      if (event === 'SIGNED_OUT') {
        router.push('/login')
      } else if (event === 'SIGNED_IN') {
        router.refresh()
      }
    })

    return () => subscription.unsubscribe()
  }, [router, supabase])

  return <>{children}</>
}
```

---

## 3. 데이터 페칭 패턴

### 3.1 서버 컴포넌트 패턴

#### 학습 데이터 조회
```typescript
// src/app/dashboard/page.tsx

import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'

export default async function DashboardPage() {
  const supabase = await createClient()

  // 1. 사용자 인증 확인
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    redirect('/login')
  }

  // 2. 병렬 데이터 페칭
  const [
    { data: stats },
    { data: dueReviews },
    { data: progressStats },
    { data: badges },
  ] = await Promise.all([
    // 사용자 통계
    supabase
      .from('user_stats')
      .select('*')
      .eq('user_id', user.id)
      .single(),

    // 오늘 복습할 항목 (뷰 활용)
    supabase
      .from('due_reviews')
      .select('*')
      .eq('user_id', user.id)
      .limit(100),

    // 진도 통계 (뷰 활용)
    supabase
      .from('user_progress_stats')
      .select('*')
      .eq('user_id', user.id)
      .single(),

    // 획득한 배지
    supabase
      .from('user_badges')
      .select('*, badge_definitions(*)')
      .eq('user_id', user.id)
      .order('earned_at', { ascending: false }),
  ])

  return (
    <div>
      {/* stats, dueReviews, progressStats, badges 렌더링 */}
    </div>
  )
}
```

#### 학습 항목 목록 조회
```typescript
// src/app/learn/hiragana/page.tsx

import { createClient } from '@/lib/supabase/server'

export default async function HiraganaPage() {
  const supabase = await createClient()

  // 히라가나 학습 항목 조회
  const { data: learningItems, error } = await supabase
    .from('learning_items')
    .select('*')
    .eq('type', 'hiragana')
    .eq('jlpt_level', 'N5')
    .order('order_index', { ascending: true })

  if (error) {
    console.error('Failed to fetch hiragana items:', error)
    return <div>데이터를 불러올 수 없습니다.</div>
  }

  return (
    <div>
      {learningItems?.map(item => (
        <div key={item.id}>
          {item.content} - {item.meaning}
        </div>
      ))}
    </div>
  )
}
```

### 3.2 클라이언트 컴포넌트 패턴

#### 실시간 진도 업데이트
```typescript
// src/components/ProgressTracker.tsx

'use client'

import { createClient } from '@/lib/supabase/client'
import { useEffect, useState } from 'react'
import type { Database } from '@/lib/database.types'

type UserStats = Database['public']['Tables']['user_stats']['Row']

export function ProgressTracker({ userId }: { userId: string }) {
  const [stats, setStats] = useState<UserStats | null>(null)
  const supabase = createClient()

  useEffect(() => {
    // 초기 데이터 로드
    async function loadStats() {
      const { data } = await supabase
        .from('user_stats')
        .select('*')
        .eq('user_id', userId)
        .single()

      setStats(data)
    }

    loadStats()

    // 실시간 구독 (선택사항)
    const channel = supabase
      .channel('user_stats_changes')
      .on(
        'postgres_changes',
        {
          event: 'UPDATE',
          schema: 'public',
          table: 'user_stats',
          filter: `user_id=eq.${userId}`,
        },
        (payload) => {
          setStats(payload.new as UserStats)
        }
      )
      .subscribe()

    return () => {
      supabase.removeChannel(channel)
    }
  }, [userId, supabase])

  if (!stats) return <div>로딩 중...</div>

  return (
    <div>
      <p>레벨: {stats.level}</p>
      <p>총 XP: {stats.total_xp}</p>
      <p>연속 학습: {stats.current_streak}일</p>
    </div>
  )
}
```

### 3.3 Server Actions 패턴

#### 답변 제출 및 SRS 업데이트
```typescript
// src/lib/study/actions.ts

'use server'

import { createClient } from '@/lib/supabase/server'
import { revalidatePath } from 'next/cache'

type ReviewQuality = 0 | 1 | 2 | 3 | 4 | 5

export async function submitReview(
  itemId: string,
  quality: ReviewQuality,
  duration: number // 초 단위
) {
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    return { success: false, error: '인증이 필요합니다' }
  }

  try {
    // 1. 현재 진도 조회
    const { data: progress, error: progressError } = await supabase
      .from('user_progress')
      .select('*')
      .eq('user_id', user.id)
      .eq('item_id', itemId)
      .single()

    if (progressError) {
      return { success: false, error: '진도 정보를 찾을 수 없습니다' }
    }

    // 2. SRS 알고리즘 계산
    const nextReviewData = calculateNextReview(quality, progress)

    // 3. 진도 업데이트
    const { error: updateError } = await supabase
      .from('user_progress')
      .update({
        ...nextReviewData,
        last_reviewed_at: new Date().toISOString(),
        total_reviews: progress.total_reviews + 1,
        correct_reviews:
          quality >= 3
            ? progress.correct_reviews + 1
            : progress.correct_reviews,
        incorrect_reviews:
          quality < 3
            ? progress.incorrect_reviews + 1
            : progress.incorrect_reviews,
      })
      .eq('id', progress.id)

    if (updateError) {
      return { success: false, error: '업데이트에 실패했습니다' }
    }

    // 4. XP 추가
    const xpEarned = quality >= 3 ? 5 : 2
    await supabase.rpc('add_user_xp', {
      p_user_id: user.id,
      p_xp_amount: xpEarned,
    })

    // 5. 캐시 무효화
    revalidatePath('/dashboard')
    revalidatePath('/review')

    return { success: true, xpEarned }
  } catch (error) {
    console.error('Submit review error:', error)
    return { success: false, error: '오류가 발생했습니다' }
  }
}

// SRS 알고리즘 (SM-2 간소화 버전)
function calculateNextReview(quality: ReviewQuality, currentProgress: any) {
  const { interval, ease_factor, repetitions } = currentProgress

  // 실패 (quality < 3)
  if (quality < 3) {
    return {
      interval: 1,
      ease_factor: Math.max(1.3, ease_factor - 0.2),
      repetitions: 0,
      status: 'learning',
      next_review_at: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(),
    }
  }

  // Ease Factor 계산
  let newEF = ease_factor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
  newEF = Math.max(1.3, Math.min(2.5, newEF))

  // 간격 계산
  let newInterval
  if (repetitions === 0) {
    newInterval = 1
  } else if (repetitions === 1) {
    newInterval = 6
  } else {
    newInterval = Math.round(interval * newEF)
  }

  newInterval = Math.max(1, Math.min(365, newInterval))

  const nextReviewDate = new Date()
  nextReviewDate.setDate(nextReviewDate.getDate() + newInterval)

  return {
    interval: newInterval,
    ease_factor: newEF,
    repetitions: repetitions + 1,
    status: repetitions >= 5 ? 'mastered' : 'reviewing',
    next_review_at: nextReviewDate.toISOString(),
  }
}
```

#### 학습 세션 저장
```typescript
// src/lib/study/actions.ts

export async function saveStudySession(sessionData: {
  duration: number
  itemsStudied: number
  itemsCorrect: number
  newItems: number
  reviewItems: number
}) {
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    return { success: false, error: '인증이 필요합니다' }
  }

  try {
    // 1. 세션 저장
    const { error: sessionError } = await supabase.from('study_sessions').insert({
      user_id: user.id,
      session_date: new Date().toISOString().split('T')[0],
      duration: sessionData.duration,
      items_studied: sessionData.itemsStudied,
      items_correct: sessionData.itemsCorrect,
      items_incorrect: sessionData.itemsStudied - sessionData.itemsCorrect,
      new_items: sessionData.newItems,
      review_items: sessionData.reviewItems,
      xp_earned: sessionData.itemsCorrect * 5,
    })

    if (sessionError) {
      return { success: false, error: '세션 저장에 실패했습니다' }
    }

    // 2. 스트릭 업데이트
    await supabase.rpc('update_user_streak', {
      p_user_id: user.id,
    })

    // 3. 배지 확인
    await supabase.rpc('check_and_award_badges', {
      p_user_id: user.id,
    })

    revalidatePath('/dashboard')

    return { success: true }
  } catch (error) {
    console.error('Save session error:', error)
    return { success: false, error: '오류가 발생했습니다' }
  }
}
```

### 3.4 캐싱 전략

#### Next.js 15 캐싱 패턴
```typescript
// src/lib/supabase/queries.ts

import { createClient } from '@/lib/supabase/server'
import { unstable_cache } from 'next/cache'

// 학습 항목은 자주 변경되지 않으므로 캐싱
export const getCachedLearningItems = unstable_cache(
  async (type: string, jlptLevel: string) => {
    const supabase = await createClient()

    const { data, error } = await supabase
      .from('learning_items')
      .select('*')
      .eq('type', type)
      .eq('jlpt_level', jlptLevel)
      .order('order_index', { ascending: true })

    if (error) throw error
    return data
  },
  ['learning-items'],
  {
    revalidate: 3600, // 1시간 캐싱
    tags: ['learning-items'],
  }
)

// 사용자 통계는 자주 변경되므로 캐싱 안함
export async function getUserStats(userId: string) {
  const supabase = await createClient()

  const { data, error } = await supabase
    .from('user_stats')
    .select('*')
    .eq('user_id', userId)
    .single()

  if (error) throw error
  return data
}
```

---

## 4. RLS 보안 검증

### 4.1 현재 RLS 정책 분석

#### ✅ 올바르게 구현된 정책

**user_progress**:
```sql
-- 조회: 본인만 가능
CREATE POLICY "user_progress는 본인만 조회 가능"
  ON user_progress FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- 삽입: 본인만 가능
CREATE POLICY "user_progress는 본인만 삽입 가능"
  ON user_progress FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- 수정: 본인만 가능
CREATE POLICY "user_progress는 본인만 수정 가능"
  ON user_progress FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
```

**평가**: 완벽한 구현. 모든 CRUD 작업에 대해 본인 확인.

### 4.2 취약점 체크

#### ⚠️ 관리자 정책 개선 필요
```sql
-- 현재: 이메일 패턴으로 관리자 판단
CREATE POLICY "관리자만 learning_items 수정 가능"
  ON learning_items FOR ALL
  TO authenticated
  USING (
    auth.uid() IN (
      SELECT id FROM auth.users WHERE email LIKE '%@admin.com'
    )
  );
```

**문제점**: 이메일만으로 관리자 판단은 보안상 취약

**개선 방안**:
```sql
-- 1. 관리자 역할 테이블 생성
CREATE TABLE IF NOT EXISTS admin_users (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('admin', 'super_admin')),
  granted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  granted_by UUID REFERENCES auth.users(id)
);

-- 2. RLS 정책 업데이트
DROP POLICY IF EXISTS "관리자만 learning_items 수정 가능" ON learning_items;

CREATE POLICY "관리자만 learning_items 수정 가능"
  ON learning_items FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE user_id = auth.uid()
    )
  );
```

### 4.3 RLS 테스트 스크립트

```sql
-- RLS 정책 테스트

-- 1. 사용자 A가 자신의 진도만 볼 수 있는지 확인
SET request.jwt.claims.sub = 'user-a-uuid';

SELECT * FROM user_progress;  -- user_id = 'user-a-uuid'인 것만 보여야 함

-- 2. 사용자 A가 다른 사용자의 진도를 수정할 수 없는지 확인
UPDATE user_progress
SET interval = 999
WHERE user_id = 'user-b-uuid';  -- 0 rows affected 되어야 함

-- 3. 인증되지 않은 사용자는 아무것도 볼 수 없는지 확인
RESET request.jwt.claims.sub;

SELECT * FROM user_progress;  -- 0 rows 되어야 함
```

### 4.4 보안 체크리스트

- [x] **모든 테이블에 RLS 활성화**
  ```sql
  ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;
  ```

- [x] **본인 데이터만 접근 가능**
  - user_progress ✅
  - study_sessions ✅
  - user_stats ✅
  - user_badges ✅

- [x] **공개 데이터는 읽기만 가능**
  - learning_items ✅
  - badge_definitions ✅

- [ ] **관리자 권한 강화** (개선 필요)

- [x] **함수 권한 제한**
  ```sql
  GRANT EXECUTE ON FUNCTION add_user_xp TO authenticated;
  ```

---

## 5. 타입 안전성

### 5.1 Supabase 타입 생성

#### 타입 자동 생성 스크립트
```json
// package.json

{
  "scripts": {
    "types:generate": "supabase gen types typescript --project-id YOUR_PROJECT_ID > src/lib/database.types.ts",
    "types:local": "supabase gen types typescript --local > src/lib/database.types.ts"
  }
}
```

#### 수동 실행
```bash
# Supabase CLI 설치
npm install -g supabase

# 로그인
supabase login

# 타입 생성
supabase gen types typescript --project-id YOUR_PROJECT_ID > src/lib/database.types.ts
```

### 5.2 생성된 타입 사용

```typescript
// src/lib/database.types.ts (자동 생성됨)

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
          example_sentence: string | null
          category: string | null
          order_index: number | null
          created_at: string
        }
        Insert: {
          id?: string
          type: 'hiragana' | 'katakana' | 'vocabulary' | 'grammar' | 'kanji'
          jlpt_level: 'N5' | 'N4' | 'N3' | 'N2' | 'N1'
          content: string
          reading?: string | null
          meaning: string
          example_sentence?: string | null
          category?: string | null
          order_index?: number | null
          created_at?: string
        }
        Update: {
          // ... (생략)
        }
      }
      user_progress: {
        Row: {
          id: string
          user_id: string
          item_id: string
          status: 'new' | 'learning' | 'reviewing' | 'mastered'
          ease_factor: number
          interval: number
          repetitions: number
          last_reviewed_at: string | null
          next_review_at: string | null
          total_reviews: number
          correct_reviews: number
          incorrect_reviews: number
          created_at: string
          updated_at: string
        }
        // ... (Insert, Update)
      }
      // ... (다른 테이블들)
    }
    Views: {
      due_reviews: {
        Row: {
          // ... (뷰 타입)
        }
      }
    }
    Functions: {
      add_user_xp: {
        Args: {
          p_user_id: string
          p_xp_amount: number
        }
        Returns: {
          new_level: number
          new_total_xp: number
          leveled_up: boolean
          xp_to_next_level: number
        }[]
      }
    }
  }
}
```

### 5.3 타입 안전한 쿼리

```typescript
// src/lib/supabase/client.ts (업데이트)

import { createBrowserClient } from '@supabase/ssr'
import type { Database } from '@/lib/database.types'

export function createClient() {
  return createBrowserClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  )
}
```

```typescript
// src/lib/supabase/server.ts (업데이트)

import { createServerClient } from '@supabase/ssr'
import { cookies } from 'next/headers'
import type { Database } from '@/lib/database.types'

export async function createClient() {
  const cookieStore = await cookies()

  return createServerClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll()
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options)
            )
          } catch {
            // Server Component에서는 쿠키를 설정할 수 없음
          }
        },
      },
    }
  )
}
```

### 5.4 타입 안전한 사용 예제

```typescript
// src/app/dashboard/page.tsx

import { createClient } from '@/lib/supabase/server'
import type { Database } from '@/lib/database.types'

type UserStats = Database['public']['Tables']['user_stats']['Row']
type LearningItem = Database['public']['Tables']['learning_items']['Row']

export default async function DashboardPage() {
  const supabase = await createClient()

  // 타입 안전한 쿼리
  const { data: stats, error } = await supabase
    .from('user_stats')
    .select('*')
    .single()

  // stats는 UserStats | null 타입
  if (stats) {
    console.log(stats.level) // ✅ 타입 체크됨
    console.log(stats.invalid_field) // ❌ TypeScript 에러
  }

  // 타입 안전한 삽입
  const { error: insertError } = await supabase
    .from('user_progress')
    .insert({
      user_id: 'uuid',
      item_id: 'uuid',
      status: 'new', // ✅ 'new' | 'learning' | 'reviewing' | 'mastered'만 가능
      ease_factor: 2.5,
      interval: 1,
      repetitions: 0,
    })

  return <div>...</div>
}
```

---

## 6. 에러 처리 및 로깅

### 6.1 에러 타입 정의

```typescript
// src/lib/errors.ts

export class AuthError extends Error {
  constructor(message: string, public code?: string) {
    super(message)
    this.name = 'AuthError'
  }
}

export class DatabaseError extends Error {
  constructor(message: string, public originalError?: any) {
    super(message)
    this.name = 'DatabaseError'
  }
}

export class ValidationError extends Error {
  constructor(message: string, public field?: string) {
    super(message)
    this.name = 'ValidationError'
  }
}
```

### 6.2 에러 핸들러

```typescript
// src/lib/error-handler.ts

import { AuthError, DatabaseError } from './errors'

export function handleSupabaseError(error: any): string {
  // PostgreSQL 에러 코드 매핑
  const postgresErrorMap: Record<string, string> = {
    '23505': '이미 존재하는 데이터입니다',
    '23503': '참조된 데이터가 없습니다',
    '23514': '유효하지 않은 값입니다',
    '42P01': '테이블을 찾을 수 없습니다',
  }

  // PostgreSQL 에러
  if (error.code in postgresErrorMap) {
    return postgresErrorMap[error.code]
  }

  // Supabase Auth 에러
  if (error.message) {
    const authErrorMap: Record<string, string> = {
      'User already registered': '이미 가입된 이메일입니다',
      'Invalid login credentials': '이메일 또는 비밀번호가 올바르지 않습니다',
      'Email not confirmed': '이메일 인증을 완료해주세요',
    }

    for (const [key, value] of Object.entries(authErrorMap)) {
      if (error.message.includes(key)) {
        return value
      }
    }
  }

  return '오류가 발생했습니다. 다시 시도해주세요.'
}
```

### 6.3 로깅 시스템

```typescript
// src/lib/logger.ts

type LogLevel = 'info' | 'warn' | 'error'

interface LogData {
  level: LogLevel
  message: string
  context?: Record<string, any>
  error?: Error
  timestamp: string
}

export class Logger {
  private static log(level: LogLevel, message: string, context?: Record<string, any>, error?: Error) {
    const logData: LogData = {
      level,
      message,
      context,
      error,
      timestamp: new Date().toISOString(),
    }

    // 개발 환경: 콘솔 출력
    if (process.env.NODE_ENV === 'development') {
      console.log(`[${level.toUpperCase()}]`, message, context, error)
    }

    // 프로덕션: 외부 로깅 서비스 전송 (예: Sentry, LogRocket)
    if (process.env.NODE_ENV === 'production' && level === 'error') {
      // TODO: Sentry.captureException(error)
    }

    // 데이터베이스에 로그 저장 (선택사항)
    // this.saveToDatabase(logData)
  }

  static info(message: string, context?: Record<string, any>) {
    this.log('info', message, context)
  }

  static warn(message: string, context?: Record<string, any>) {
    this.log('warn', message, context)
  }

  static error(message: string, error?: Error, context?: Record<string, any>) {
    this.log('error', message, context, error)
  }

  // Supabase 에러 전용 로거
  static supabaseError(operation: string, error: any, context?: Record<string, any>) {
    this.error(
      `Supabase ${operation} failed`,
      error,
      {
        ...context,
        supabaseError: {
          message: error.message,
          code: error.code,
          details: error.details,
        },
      }
    )
  }
}
```

### 6.4 에러 처리 예제

```typescript
// src/lib/study/actions.ts

import { Logger } from '@/lib/logger'
import { handleSupabaseError } from '@/lib/error-handler'

export async function submitReview(itemId: string, quality: number) {
  const supabase = await createClient()

  try {
    const { data, error } = await supabase
      .from('user_progress')
      .update({ /* ... */ })
      .eq('item_id', itemId)

    if (error) {
      Logger.supabaseError('submitReview', error, { itemId, quality })
      return {
        success: false,
        error: handleSupabaseError(error),
      }
    }

    Logger.info('Review submitted successfully', { itemId, quality })
    return { success: true, data }
  } catch (error) {
    Logger.error('Unexpected error in submitReview', error as Error, { itemId })
    return {
      success: false,
      error: '예기치 않은 오류가 발생했습니다.',
    }
  }
}
```

### 6.5 사용자 친화적 에러 메시지

```typescript
// src/components/ErrorBoundary.tsx

'use client'

import { useEffect } from 'react'
import { Logger } from '@/lib/logger'

export function ErrorBoundary({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  useEffect(() => {
    Logger.error('Unhandled error caught by boundary', error)
  }, [error])

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <div className="max-w-md w-full p-8 bg-white rounded-lg shadow-md">
        <h2 className="text-2xl font-bold text-gray-900 mb-4">
          오류가 발생했습니다
        </h2>
        <p className="text-gray-600 mb-6">
          죄송합니다. 일시적인 문제가 발생했습니다. 잠시 후 다시 시도해주세요.
        </p>
        <button
          onClick={reset}
          className="w-full px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
        >
          다시 시도
        </button>
      </div>
    </div>
  )
}
```

---

## 7. 구현 우선순위

### Phase 3.1: 핵심 인증 강화 (1-2일)
1. **에러 처리 개선**
   - [ ] `AuthResult` 타입 추가
   - [ ] 에러 메시지 한국어 변환
   - [ ] 입력 검증 (zod)

2. **클라이언트 컴포넌트 전환**
   - [ ] `SignUpForm` 컴포넌트 생성
   - [ ] `LoginForm` 컴포넌트 생성
   - [ ] 로딩 상태 UI 추가

3. **환경 변수 검증**
   - [ ] `env.ts` 파일 생성
   - [ ] 런타임 검증 추가

### Phase 3.2: 타입 안전성 (1일)
1. **Supabase 타입 생성**
   - [ ] Supabase CLI 설치
   - [ ] 타입 생성 스크립트 추가
   - [ ] `database.types.ts` 생성

2. **타입 적용**
   - [ ] 클라이언트 타입 추가
   - [ ] 서버 클라이언트 타입 추가
   - [ ] 쿼리 타입 체크

### Phase 3.3: 데이터 페칭 구현 (2-3일)
1. **대시보드 데이터 연동**
   - [ ] 사용자 통계 조회
   - [ ] 복습 큐 조회
   - [ ] 진도 통계 조회
   - [ ] 배지 목록 조회

2. **Server Actions 구현**
   - [ ] `submitReview` 액션
   - [ ] `saveStudySession` 액션
   - [ ] `startNewItem` 액션

3. **캐싱 최적화**
   - [ ] 학습 항목 캐싱
   - [ ] 배지 정의 캐싱
   - [ ] Revalidation 전략 수립

### Phase 3.4: 에러 처리 및 로깅 (1일)
1. **에러 핸들링**
   - [ ] 에러 타입 정의
   - [ ] 에러 핸들러 구현
   - [ ] ErrorBoundary 추가

2. **로깅 시스템**
   - [ ] Logger 클래스 구현
   - [ ] Supabase 에러 로깅
   - [ ] 프로덕션 로깅 설정

### Phase 3.5: 보안 강화 (1일)
1. **RLS 개선**
   - [ ] 관리자 테이블 추가
   - [ ] RLS 정책 업데이트
   - [ ] RLS 테스트 스크립트 작성

2. **보안 테스트**
   - [ ] 권한 체크리스트 검증
   - [ ] 취약점 스캔
   - [ ] 보안 문서화

---

## 8. 베스트 프랙티스

### 8.1 환경 변수 검증

```typescript
// src/lib/env.ts

import { z } from 'zod'

const envSchema = z.object({
  NEXT_PUBLIC_SUPABASE_URL: z.string().url(),
  NEXT_PUBLIC_SUPABASE_ANON_KEY: z.string().min(1),
  NEXT_PUBLIC_SITE_URL: z.string().url().optional(),
})

const env = envSchema.parse({
  NEXT_PUBLIC_SUPABASE_URL: process.env.NEXT_PUBLIC_SUPABASE_URL,
  NEXT_PUBLIC_SUPABASE_ANON_KEY: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY,
  NEXT_PUBLIC_SITE_URL: process.env.NEXT_PUBLIC_SITE_URL || 'http://localhost:3000',
})

export default env
```

```typescript
// src/lib/supabase/client.ts (업데이트)

import { createBrowserClient } from '@supabase/ssr'
import env from '@/lib/env'

export function createClient() {
  return createBrowserClient(
    env.NEXT_PUBLIC_SUPABASE_URL,
    env.NEXT_PUBLIC_SUPABASE_ANON_KEY
  )
}
```

### 8.2 쿼리 헬퍼 함수

```typescript
// src/lib/supabase/queries.ts

import { createClient } from '@/lib/supabase/server'
import type { Database } from '@/lib/database.types'

type Tables = Database['public']['Tables']

export async function getUserStats(userId: string) {
  const supabase = await createClient()

  const { data, error } = await supabase
    .from('user_stats')
    .select('*')
    .eq('user_id', userId)
    .single()

  if (error) throw new DatabaseError('Failed to fetch user stats', error)
  return data
}

export async function getDueReviews(userId: string, limit = 100) {
  const supabase = await createClient()

  const { data, error } = await supabase
    .from('due_reviews')
    .select('*')
    .eq('user_id', userId)
    .limit(limit)

  if (error) throw new DatabaseError('Failed to fetch due reviews', error)
  return data || []
}

export async function getLearningItems(
  type: Tables['learning_items']['Row']['type'],
  jlptLevel: Tables['learning_items']['Row']['jlpt_level']
) {
  const supabase = await createClient()

  const { data, error } = await supabase
    .from('learning_items')
    .select('*')
    .eq('type', type)
    .eq('jlpt_level', jlptLevel)
    .order('order_index', { ascending: true })

  if (error) throw new DatabaseError('Failed to fetch learning items', error)
  return data || []
}
```

### 8.3 중복 코드 제거

```typescript
// src/lib/supabase/utils.ts

import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'

/**
 * 현재 사용자 가져오기 (인증 필수)
 * 인증되지 않은 경우 로그인 페이지로 리다이렉트
 */
export async function requireAuth() {
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    redirect('/login')
  }

  return user
}

/**
 * 현재 사용자 가져오기 (인증 선택)
 */
export async function getCurrentUser() {
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  return user
}
```

### 8.4 재사용 가능한 컴포넌트

```typescript
// src/components/ui/LoadingSpinner.tsx

export function LoadingSpinner({ size = 'md' }: { size?: 'sm' | 'md' | 'lg' }) {
  const sizeClasses = {
    sm: 'h-4 w-4',
    md: 'h-8 w-8',
    lg: 'h-12 w-12',
  }

  return (
    <svg
      className={`animate-spin ${sizeClasses[size]} text-blue-600`}
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
    >
      <circle
        className="opacity-25"
        cx="12"
        cy="12"
        r="10"
        stroke="currentColor"
        strokeWidth="4"
      />
      <path
        className="opacity-75"
        fill="currentColor"
        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
      />
    </svg>
  )
}
```

### 8.5 테스트 전략

```typescript
// src/__tests__/auth.test.ts (예시)

import { describe, it, expect } from '@jest/globals'
import { signUp, signIn } from '@/lib/auth/actions'

describe('Authentication', () => {
  it('should validate email format', async () => {
    const formData = new FormData()
    formData.set('email', 'invalid-email')
    formData.set('password', 'password123')

    const result = await signUp(formData)

    expect(result.success).toBe(false)
    expect(result.error).toContain('이메일')
  })

  it('should validate password length', async () => {
    const formData = new FormData()
    formData.set('email', 'test@example.com')
    formData.set('password', '12345') // 6자 미만

    const result = await signUp(formData)

    expect(result.success).toBe(false)
    expect(result.error).toContain('6자')
  })
})
```

---

## 9. 체크리스트

### 보안 체크리스트
- [x] RLS 모든 테이블에 활성화
- [x] 본인 데이터만 접근 가능하도록 정책 설정
- [ ] 관리자 권한 테이블 추가
- [ ] RLS 정책 테스트 스크립트 작성
- [ ] 환경 변수 검증 추가
- [ ] HTTPS 강제 (프로덕션)
- [ ] Rate limiting 설정 (Supabase 대시보드)

### 타입 안전성 체크리스트
- [ ] Supabase 타입 생성 스크립트 추가
- [ ] 모든 쿼리에 타입 적용
- [ ] Zod 스키마로 입력 검증
- [ ] TypeScript strict 모드 활성화

### 에러 처리 체크리스트
- [ ] 모든 Server Actions에 try-catch
- [ ] 사용자 친화적 에러 메시지
- [ ] ErrorBoundary 설정
- [ ] 로깅 시스템 구현
- [ ] 프로덕션 에러 모니터링 (Sentry 등)

### 성능 체크리스트
- [ ] 학습 항목 데이터 캐싱
- [ ] 병렬 쿼리 사용 (Promise.all)
- [ ] 불필요한 revalidation 제거
- [ ] 이미지 최적화 (Next.js Image)
- [ ] 번들 사이즈 최적화

---

## 10. 다음 단계

### 즉시 시작 가능한 작업
1. **환경 변수 검증 추가** (30분)
   ```bash
   npm install zod
   # src/lib/env.ts 생성
   ```

2. **타입 생성** (1시간)
   ```bash
   npm install -g supabase
   supabase login
   supabase gen types typescript --project-id YOUR_ID > src/lib/database.types.ts
   ```

3. **에러 처리 개선** (2시간)
   - `AuthResult` 타입 추가
   - 에러 메시지 한국어 변환
   - 클라이언트 폼 컴포넌트 생성

### 참고 자료
- [Supabase Auth Docs](https://supabase.com/docs/guides/auth)
- [Next.js 15 App Router](https://nextjs.org/docs/app)
- [Supabase RLS Guide](https://supabase.com/docs/guides/auth/row-level-security)
- [TypeScript Supabase](https://supabase.com/docs/guides/api/generating-types)

---

**문서 버전**: 1.0.0
**최종 업데이트**: 2025-10-20
**작성자**: Backend Architect

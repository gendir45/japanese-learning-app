# Phase 3 프론트엔드 아키텍처 설계

**프로젝트**: Japanese Learning App
**작성일**: 2025-10-20
**버전**: 1.0.0
**Phase**: 3 - MVP 프론트엔드 개발

---

## 목차

1. [개요](#개요)
2. [디렉토리 구조](#디렉토리-구조)
3. [컴포넌트 아키텍처](#컴포넌트-아키텍처)
4. [라우팅 구조](#라우팅-구조)
5. [상태 관리 전략](#상태-관리-전략)
6. [접근성 & UX](#접근성--ux)
7. [성능 최적화](#성능-최적화)
8. [Supabase 통합](#supabase-통합)
9. [구현 가이드라인](#구현-가이드라인)
10. [구현 우선순위](#구현-우선순위)

---

## 개요

### 설계 원칙

1. **컴포넌트 재사용성**: 공통 UI 요소를 독립적이고 재사용 가능한 컴포넌트로 분리
2. **타입 안전성**: TypeScript를 활용한 엄격한 타입 정의
3. **접근성 우선**: WCAG 2.1 AA 준수
4. **성능 최적화**: 서버 컴포넌트 우선, 클라이언트 컴포넌트 최소화
5. **반응형 디자인**: 모바일 우선 설계

### 기술 스택

- **Framework**: Next.js 15.5.6 (App Router)
- **Language**: TypeScript 5.x
- **Styling**: Tailwind CSS 4.x
- **State**: React 19 hooks + Context API
- **Auth**: Supabase Auth
- **Database**: Supabase PostgreSQL

---

## 디렉토리 구조

### 전체 구조

```
src/
├── app/                          # Next.js App Router 페이지
│   ├── (auth)/                   # 인증 관련 라우트 그룹
│   │   ├── login/
│   │   │   └── page.tsx          # 로그인 페이지
│   │   └── signup/
│   │       └── page.tsx          # 회원가입 페이지
│   │
│   ├── (main)/                   # 인증 필요 라우트 그룹
│   │   ├── dashboard/
│   │   │   └── page.tsx          # 대시보드
│   │   ├── study/
│   │   │   ├── page.tsx          # 학습 메인
│   │   │   ├── flashcard/
│   │   │   │   └── page.tsx      # 플래시카드 학습
│   │   │   └── quiz/
│   │   │       └── page.tsx      # 퀴즈 모드
│   │   ├── review/
│   │   │   └── page.tsx          # SRS 복습
│   │   ├── progress/
│   │   │   └── page.tsx          # 진도 및 통계
│   │   └── layout.tsx            # 메인 레이아웃 (네비게이션 포함)
│   │
│   ├── layout.tsx                # 루트 레이아웃
│   ├── page.tsx                  # 랜딩 페이지
│   ├── globals.css               # 전역 스타일
│   └── error.tsx                 # 에러 바운더리
│
├── components/                   # 재사용 가능한 컴포넌트
│   ├── layout/                   # 레이아웃 컴포넌트
│   │   ├── Header.tsx            # 헤더 (네비게이션)
│   │   ├── Sidebar.tsx           # 사이드바 (선택적)
│   │   ├── Footer.tsx            # 푸터
│   │   └── Navigation.tsx        # 주요 네비게이션
│   │
│   ├── auth/                     # 인증 관련 컴포넌트
│   │   ├── LoginForm.tsx         # 로그인 폼
│   │   ├── SignupForm.tsx        # 회원가입 폼
│   │   ├── AuthButton.tsx        # 인증 버튼
│   │   └── ProtectedRoute.tsx    # 라우트 보호 래퍼
│   │
│   ├── study/                    # 학습 관련 컴포넌트
│   │   ├── Flashcard.tsx         # 플래시카드
│   │   ├── FlashcardDeck.tsx     # 플래시카드 덱
│   │   ├── Quiz.tsx              # 퀴즈 컴포넌트
│   │   ├── QuizQuestion.tsx      # 퀴즈 질문
│   │   └── AnswerOptions.tsx     # 답변 옵션
│   │
│   ├── dashboard/                # 대시보드 컴포넌트
│   │   ├── DailyGoal.tsx         # 일일 목표
│   │   ├── ReviewQueue.tsx       # 복습 큐
│   │   ├── ProgressOverview.tsx  # 진도 개요
│   │   └── StreakCounter.tsx     # 스트릭 카운터
│   │
│   ├── progress/                 # 진도 추적 컴포넌트
│   │   ├── ProgressBar.tsx       # 프로그레스 바
│   │   ├── CategoryProgress.tsx  # 카테고리별 진도
│   │   ├── LevelIndicator.tsx    # 레벨 표시
│   │   └── StatCard.tsx          # 통계 카드
│   │
│   └── common/                   # 공통 UI 컴포넌트
│       ├── Button.tsx            # 버튼
│       ├── Card.tsx              # 카드
│       ├── Input.tsx             # 입력 필드
│       ├── Loading.tsx           # 로딩 스피너
│       ├── Modal.tsx             # 모달
│       ├── Toast.tsx             # 토스트 알림
│       └── Badge.tsx             # 배지
│
├── lib/                          # 유틸리티 및 헬퍼
│   ├── supabase/                 # Supabase 클라이언트
│   │   ├── client.ts             # 클라이언트 사이드
│   │   ├── server.ts             # 서버 사이드
│   │   └── middleware.ts         # 미들웨어
│   │
│   ├── auth/                     # 인증 헬퍼
│   │   └── actions.ts            # 인증 액션
│   │
│   ├── api/                      # API 헬퍼
│   │   ├── learning.ts           # 학습 데이터 API
│   │   ├── progress.ts           # 진도 API
│   │   └── actions.ts            # 서버 액션
│   │
│   ├── srs/                      # SRS 알고리즘
│   │   ├── algorithm.ts          # SM-2 구현
│   │   ├── scheduler.ts          # 복습 스케줄러
│   │   └── types.ts              # SRS 타입
│   │
│   ├── hooks/                    # 커스텀 훅
│   │   ├── useUser.ts            # 사용자 훅
│   │   ├── useStudySession.ts    # 학습 세션 훅
│   │   ├── useProgress.ts        # 진도 추적 훅
│   │   └── useKeyboard.ts        # 키보드 단축키 훅
│   │
│   └── utils/                    # 유틸리티 함수
│       ├── cn.ts                 # classname 헬퍼
│       ├── formatters.ts         # 포맷팅 함수
│       └── validators.ts         # 유효성 검사
│
├── types/                        # TypeScript 타입 정의
│   ├── database.ts               # Supabase 타입
│   ├── learning.ts               # 학습 관련 타입
│   ├── user.ts                   # 사용자 타입
│   └── index.ts                  # 타입 익스포트
│
├── contexts/                     # React Context
│   ├── AuthContext.tsx           # 인증 컨텍스트
│   ├── StudyContext.tsx          # 학습 세션 컨텍스트
│   └── ToastContext.tsx          # 토스트 알림 컨텍스트
│
└── middleware.ts                 # Next.js 미들웨어 (인증)
```

### 디렉토리별 책임

#### `app/`
- 페이지 라우팅 및 레이아웃
- 서버 컴포넌트 우선 사용
- 데이터 페칭 및 SEO 메타데이터

#### `components/`
- 재사용 가능한 UI 컴포넌트
- 단일 책임 원칙 준수
- props 인터페이스 명확히 정의

#### `lib/`
- 비즈니스 로직 및 유틸리티
- API 통신 로직
- 커스텀 훅

#### `types/`
- 전역 타입 정의
- Supabase 데이터베이스 타입
- 공통 인터페이스

#### `contexts/`
- 전역 상태 관리
- 인증, 알림 등 앱 전역 상태

---

## 컴포넌트 아키텍처

### 컴포넌트 분류

#### 1. 레이아웃 컴포넌트

**Header.tsx**
```typescript
interface HeaderProps {
  user?: User | null
  showNavigation?: boolean
}

export function Header({ user, showNavigation = true }: HeaderProps)
```

**책임**:
- 로고 및 앱 타이틀 표시
- 사용자 정보 표시 (로그인 시)
- 로그아웃 버튼
- 반응형 메뉴 토글

**Navigation.tsx**
```typescript
interface NavigationProps {
  currentPath: string
  items: NavigationItem[]
}

interface NavigationItem {
  label: string
  href: string
  icon?: React.ReactNode
  badge?: number // 복습 개수 등
}

export function Navigation({ currentPath, items }: NavigationProps)
```

**책임**:
- 주요 페이지 네비게이션
- 현재 페이지 하이라이트
- 배지 표시 (복습 개수 등)
- 키보드 네비게이션 지원

#### 2. 인증 컴포넌트

**LoginForm.tsx**
```typescript
interface LoginFormProps {
  onSuccess?: () => void
  redirectTo?: string
}

interface LoginFormData {
  email: string
  password: string
}

export function LoginForm({ onSuccess, redirectTo = '/dashboard' }: LoginFormProps)
```

**책임**:
- 이메일/비밀번호 입력 폼
- 클라이언트 사이드 유효성 검사
- 에러 메시지 표시
- 로딩 상태 관리
- 접근성 (ARIA 레이블)

**SignupForm.tsx**
```typescript
interface SignupFormProps {
  onSuccess?: () => void
  redirectTo?: string
}

interface SignupFormData {
  email: string
  password: string
  confirmPassword: string
  displayName?: string
}

export function SignupForm({ onSuccess, redirectTo = '/dashboard' }: SignupFormProps)
```

**책임**:
- 회원가입 폼 렌더링
- 비밀번호 확인 검증
- 이메일 중복 체크
- 가입 후 자동 로그인

#### 3. 학습 컴포넌트

**Flashcard.tsx**
```typescript
interface FlashcardProps {
  item: LearningItem
  isFlipped: boolean
  onFlip: () => void
  onAnswer: (quality: number) => void
  showAnswer?: boolean
}

interface LearningItem {
  id: string
  type: 'hiragana' | 'katakana' | 'vocabulary' | 'kanji' | 'grammar'
  content: string      // 일본어
  reading?: string     // 읽기
  meaning: string      // 한국어 뜻
  exampleSentence?: string
  category?: string
}

export function Flashcard({
  item,
  isFlipped,
  onFlip,
  onAnswer,
  showAnswer = false
}: FlashcardProps)
```

**책임**:
- 앞면/뒷면 표시
- 플립 애니메이션
- 답변 버튼 (Again, Hard, Good, Easy)
- 키보드 단축키 (스페이스: 플립, 1-4: 답변)

**FlashcardDeck.tsx**
```typescript
interface FlashcardDeckProps {
  items: LearningItem[]
  onComplete: (results: ReviewResult[]) => void
  sessionType: 'study' | 'review'
}

interface ReviewResult {
  itemId: string
  quality: number      // 0-5
  timeSpent: number    // 밀리초
  correct: boolean
}

export function FlashcardDeck({
  items,
  onComplete,
  sessionType
}: FlashcardDeckProps)
```

**책임**:
- 카드 순서 관리
- 진행률 표시
- 세션 타이머
- 결과 수집 및 전달

**Quiz.tsx**
```typescript
interface QuizProps {
  questions: QuizQuestion[]
  onComplete: (results: QuizResult) => void
  timeLimit?: number   // 초 단위, undefined면 무제한
}

interface QuizQuestion {
  id: string
  itemId: string
  question: string
  options: QuizOption[]
  correctAnswer: string
  type: 'multiple_choice' | 'typing'
}

interface QuizOption {
  id: string
  text: string
  isCorrect: boolean
}

interface QuizResult {
  totalQuestions: number
  correctAnswers: number
  timeSpent: number
  questionResults: QuestionResult[]
}

export function Quiz({ questions, onComplete, timeLimit }: QuizProps)
```

**책임**:
- 문제 순차 표시
- 답안 선택/입력
- 즉각적 피드백
- 타이머 표시 (제한 시간 있는 경우)
- 결과 수집

#### 4. 대시보드 컴포넌트

**DailyGoal.tsx**
```typescript
interface DailyGoalProps {
  goal: number         // 목표 학습 개수
  completed: number    // 완료 개수
  onStartStudy: () => void
}

export function DailyGoal({ goal, completed, onStartStudy }: DailyGoalProps)
```

**책임**:
- 일일 목표 진행률 시각화
- 원형 프로그레스 바
- CTA 버튼 (학습 시작)

**ReviewQueue.tsx**
```typescript
interface ReviewQueueProps {
  dueCount: number     // 오늘 복습 개수
  upcomingCount: number // 다가오는 복습
  onStartReview: () => void
}

export function ReviewQueue({
  dueCount,
  upcomingCount,
  onStartReview
}: ReviewQueueProps)
```

**책임**:
- 복습 대기 개수 표시
- 긴급도 표시 (기한 지남, 오늘 예정)
- 복습 시작 버튼

**StreakCounter.tsx**
```typescript
interface StreakCounterProps {
  currentStreak: number
  longestStreak: number
  lastStudyDate?: Date
}

export function StreakCounter({
  currentStreak,
  longestStreak,
  lastStudyDate
}: StreakCounterProps)
```

**책임**:
- 연속 학습 일수 표시
- 스트릭 아이콘 (🔥)
- 최장 기록 표시
- 동기부여 메시지

#### 5. 진도 추적 컴포넌트

**ProgressBar.tsx**
```typescript
interface ProgressBarProps {
  current: number
  total: number
  label?: string
  color?: 'blue' | 'green' | 'purple' | 'orange'
  showPercentage?: boolean
  size?: 'sm' | 'md' | 'lg'
}

export function ProgressBar({
  current,
  total,
  label,
  color = 'blue',
  showPercentage = true,
  size = 'md'
}: ProgressBarProps)
```

**책임**:
- 진행률 시각화
- 퍼센티지 표시
- 접근성 (ARIA 속성)

**CategoryProgress.tsx**
```typescript
interface CategoryProgressProps {
  categories: CategoryData[]
  onCategoryClick?: (category: string) => void
}

interface CategoryData {
  name: string
  type: LearningItemType
  total: number
  learned: number
  mastered: number
  icon?: string
}

export function CategoryProgress({
  categories,
  onCategoryClick
}: CategoryProgressProps)
```

**책임**:
- 카테고리별 진도 표시
- 진행 상태 (신규, 학습 중, 마스터)
- 클릭 시 해당 카테고리 학습

#### 6. 공통 UI 컴포넌트

**Button.tsx**
```typescript
interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost' | 'danger'
  size?: 'sm' | 'md' | 'lg'
  isLoading?: boolean
  leftIcon?: React.ReactNode
  rightIcon?: React.ReactNode
}

export function Button({
  variant = 'primary',
  size = 'md',
  isLoading = false,
  leftIcon,
  rightIcon,
  children,
  className,
  disabled,
  ...props
}: ButtonProps)
```

**책임**:
- 일관된 버튼 스타일
- 로딩 상태 표시
- 아이콘 지원
- 접근성 (포커스, 키보드)

**Card.tsx**
```typescript
interface CardProps {
  children: React.ReactNode
  className?: string
  padding?: 'none' | 'sm' | 'md' | 'lg'
  shadow?: 'none' | 'sm' | 'md' | 'lg'
  hoverable?: boolean
  onClick?: () => void
}

export function Card({
  children,
  className,
  padding = 'md',
  shadow = 'md',
  hoverable = false,
  onClick
}: CardProps)
```

**책임**:
- 일관된 카드 레이아웃
- 그림자 및 패딩 옵션
- 호버 효과 (선택적)

**Loading.tsx**
```typescript
interface LoadingProps {
  size?: 'sm' | 'md' | 'lg'
  text?: string
  fullScreen?: boolean
}

export function Loading({
  size = 'md',
  text,
  fullScreen = false
}: LoadingProps)
```

**책임**:
- 로딩 스피너
- 로딩 텍스트 표시
- 전체 화면 모드 지원

**Toast.tsx**
```typescript
interface ToastProps {
  message: string
  type: 'success' | 'error' | 'warning' | 'info'
  duration?: number  // 밀리초
  onClose: () => void
  position?: 'top' | 'bottom' | 'top-right' | 'bottom-right'
}

export function Toast({
  message,
  type,
  duration = 3000,
  onClose,
  position = 'top-right'
}: ToastProps)
```

**책임**:
- 알림 메시지 표시
- 자동 숨김
- 타입별 색상/아이콘
- 접근성 (role="alert")

---

## 라우팅 구조

### App Router 구조

```
app/
├── layout.tsx                    # 루트 레이아웃
├── page.tsx                      # 랜딩 페이지 (/)
├── error.tsx                     # 에러 페이지
│
├── (auth)/                       # 인증 라우트 그룹
│   ├── layout.tsx                # 인증 전용 레이아웃 (심플)
│   ├── login/
│   │   └── page.tsx              # /login
│   └── signup/
│       └── page.tsx              # /signup
│
└── (main)/                       # 메인 라우트 그룹 (인증 필요)
    ├── layout.tsx                # 메인 레이아웃 (네비게이션 포함)
    ├── dashboard/
    │   └── page.tsx              # /dashboard
    ├── study/
    │   ├── page.tsx              # /study (학습 선택)
    │   ├── flashcard/
    │   │   └── page.tsx          # /study/flashcard
    │   └── quiz/
    │       └── page.tsx          # /study/quiz
    ├── review/
    │   └── page.tsx              # /review (SRS 복습)
    └── progress/
        └── page.tsx              # /progress (통계)
```

### 라우트 그룹 설명

#### `(auth)` 그룹
- **목적**: 인증 페이지 (로그인, 회원가입)
- **레이아웃**: 심플한 중앙 정렬 레이아웃
- **특징**:
  - 네비게이션 없음
  - 이미 로그인된 사용자는 대시보드로 리디렉션
  - 서버 컴포넌트로 SEO 최적화

#### `(main)` 그룹
- **목적**: 인증 필요한 메인 기능
- **레이아웃**: 헤더 + 네비게이션 + 콘텐츠
- **특징**:
  - 미들웨어에서 인증 체크
  - 공통 레이아웃 공유
  - 로그아웃 버튼 포함

### 레이아웃 네스팅

**루트 레이아웃** (`app/layout.tsx`)
```typescript
import type { Metadata } from 'next'
import { Geist, Geist_Mono } from 'next/font/google'
import './globals.css'
import { AuthProvider } from '@/contexts/AuthContext'
import { ToastProvider } from '@/contexts/ToastContext'

const geistSans = Geist({
  variable: '--font-geist-sans',
  subsets: ['latin'],
})

const geistMono = Geist_Mono({
  variable: '--font-geist-mono',
  subsets: ['latin'],
})

export const metadata: Metadata = {
  title: '일본어 학습 앱 | JLPT 합격을 위한 SRS 시스템',
  description: 'JLPT 합격과 일본 여행 회화를 위한 체계적인 학습 플랫폼',
  keywords: '일본어, JLPT, 히라가나, 가타카나, 일본어 학습',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="ko">
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased`}
      >
        <AuthProvider>
          <ToastProvider>
            {children}
          </ToastProvider>
        </AuthProvider>
      </body>
    </html>
  )
}
```

**인증 레이아웃** (`app/(auth)/layout.tsx`)
```typescript
export default function AuthLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="w-full max-w-md">
        {children}
      </div>
    </div>
  )
}
```

**메인 레이아웃** (`app/(main)/layout.tsx`)
```typescript
import { getUser } from '@/lib/auth/actions'
import { redirect } from 'next/navigation'
import { Header } from '@/components/layout/Header'
import { Navigation } from '@/components/layout/Navigation'

export default async function MainLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const user = await getUser()

  // 인증되지 않은 사용자는 로그인으로 리디렉션
  if (!user) {
    redirect('/login')
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <Header user={user} />
      <div className="flex">
        <Navigation />
        <main className="flex-1 p-6 lg:p-8">
          {children}
        </main>
      </div>
    </div>
  )
}
```

### 인증 보호 전략

#### 미들웨어 기반 보호 (`middleware.ts`)
```typescript
import { type NextRequest } from 'next/server'
import { updateSession } from '@/lib/supabase/middleware'

export async function middleware(request: NextRequest) {
  return await updateSession(request)
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
  ],
}
```

#### Supabase 미들웨어 (`lib/supabase/middleware.ts`)
```typescript
import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

export async function updateSession(request: NextRequest) {
  let supabaseResponse = NextResponse.next({
    request,
  })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll()
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value))
          supabaseResponse = NextResponse.next({
            request,
          })
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          )
        },
      },
    }
  )

  const {
    data: { user },
  } = await supabase.auth.getUser()

  // 보호된 경로에 인증되지 않은 사용자 접근 시 리디렉션
  if (
    !user &&
    !request.nextUrl.pathname.startsWith('/login') &&
    !request.nextUrl.pathname.startsWith('/signup') &&
    request.nextUrl.pathname !== '/'
  ) {
    const url = request.nextUrl.clone()
    url.pathname = '/login'
    return NextResponse.redirect(url)
  }

  // 인증된 사용자가 인증 페이지 접근 시 대시보드로 리디렉션
  if (
    user &&
    (request.nextUrl.pathname.startsWith('/login') ||
      request.nextUrl.pathname.startsWith('/signup'))
  ) {
    const url = request.nextUrl.clone()
    url.pathname = '/dashboard'
    return NextResponse.redirect(url)
  }

  return supabaseResponse
}
```

---

## 상태 관리 전략

### 상태 분류

1. **서버 상태**: Supabase 데이터베이스 데이터
2. **클라이언트 상태**: UI 상태, 폼 입력, 임시 데이터
3. **전역 상태**: 인증, 토스트 알림, 테마
4. **URL 상태**: 검색 파라미터, 페이지 번호

### 상태 관리 도구

#### 서버 상태
- **Server Components**: 서버에서 직접 데이터 페칭
- **Server Actions**: 데이터 변경 (mutation)
- **Supabase Client**: 실시간 구독 (선택적)

#### 클라이언트 상태
- **React useState**: 로컬 컴포넌트 상태
- **React useReducer**: 복잡한 상태 로직
- **Custom Hooks**: 재사용 가능한 상태 로직

#### 전역 상태
- **React Context**: 인증, 토스트 등 앱 전역 상태

### Context 구현

#### AuthContext
```typescript
// contexts/AuthContext.tsx
'use client'

import { createContext, useContext, useEffect, useState } from 'react'
import { User } from '@supabase/supabase-js'
import { createBrowserClient } from '@/lib/supabase/client'

interface AuthContextType {
  user: User | null
  loading: boolean
  signOut: () => Promise<void>
}

const AuthContext = createContext<AuthContextType | undefined>(undefined)

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null)
  const [loading, setLoading] = useState(true)
  const supabase = createBrowserClient()

  useEffect(() => {
    // 초기 세션 확인
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null)
      setLoading(false)
    })

    // 인증 상태 변경 리스너
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null)
    })

    return () => subscription.unsubscribe()
  }, [supabase.auth])

  const signOut = async () => {
    await supabase.auth.signOut()
    setUser(null)
  }

  return (
    <AuthContext.Provider value={{ user, loading, signOut }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  const context = useContext(AuthContext)
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider')
  }
  return context
}
```

#### ToastContext
```typescript
// contexts/ToastContext.tsx
'use client'

import { createContext, useContext, useState, useCallback } from 'react'
import { Toast } from '@/components/common/Toast'

type ToastType = 'success' | 'error' | 'warning' | 'info'

interface ToastMessage {
  id: string
  message: string
  type: ToastType
}

interface ToastContextType {
  showToast: (message: string, type: ToastType) => void
}

const ToastContext = createContext<ToastContextType | undefined>(undefined)

export function ToastProvider({ children }: { children: React.ReactNode }) {
  const [toasts, setToasts] = useState<ToastMessage[]>([])

  const showToast = useCallback((message: string, type: ToastType) => {
    const id = Math.random().toString(36).substring(7)
    setToasts((prev) => [...prev, { id, message, type }])
  }, [])

  const removeToast = useCallback((id: string) => {
    setToasts((prev) => prev.filter((toast) => toast.id !== id))
  }, [])

  return (
    <ToastContext.Provider value={{ showToast }}>
      {children}
      <div className="fixed top-4 right-4 z-50 space-y-2">
        {toasts.map((toast) => (
          <Toast
            key={toast.id}
            message={toast.message}
            type={toast.type}
            onClose={() => removeToast(toast.id)}
          />
        ))}
      </div>
    </ToastContext.Provider>
  )
}

export function useToast() {
  const context = useContext(ToastContext)
  if (context === undefined) {
    throw new Error('useToast must be used within a ToastProvider')
  }
  return context
}
```

#### StudyContext (학습 세션)
```typescript
// contexts/StudyContext.tsx
'use client'

import { createContext, useContext, useState, useCallback } from 'react'

interface StudySession {
  startTime: Date
  itemsStudied: number
  itemsCorrect: number
  currentStreak: number
}

interface StudyContextType {
  session: StudySession | null
  startSession: () => void
  endSession: () => Promise<void>
  recordAnswer: (correct: boolean) => void
}

const StudyContext = createContext<StudyContextType | undefined>(undefined)

export function StudyProvider({ children }: { children: React.ReactNode }) {
  const [session, setSession] = useState<StudySession | null>(null)

  const startSession = useCallback(() => {
    setSession({
      startTime: new Date(),
      itemsStudied: 0,
      itemsCorrect: 0,
      currentStreak: 0,
    })
  }, [])

  const endSession = useCallback(async () => {
    if (!session) return

    // 세션 데이터 저장 로직
    // await saveStudySession(session)

    setSession(null)
  }, [session])

  const recordAnswer = useCallback((correct: boolean) => {
    setSession((prev) => {
      if (!prev) return null

      return {
        ...prev,
        itemsStudied: prev.itemsStudied + 1,
        itemsCorrect: correct ? prev.itemsCorrect + 1 : prev.itemsCorrect,
        currentStreak: correct ? prev.currentStreak + 1 : 0,
      }
    })
  }, [])

  return (
    <StudyContext.Provider value={{ session, startSession, endSession, recordAnswer }}>
      {children}
    </StudyContext.Provider>
  )
}

export function useStudySession() {
  const context = useContext(StudyContext)
  if (context === undefined) {
    throw new Error('useStudySession must be used within a StudyProvider')
  }
  return context
}
```

### 커스텀 훅

#### useUser
```typescript
// lib/hooks/useUser.ts
'use client'

import { useAuth } from '@/contexts/AuthContext'

export function useUser() {
  const { user, loading } = useAuth()

  return {
    user,
    loading,
    isAuthenticated: !!user,
  }
}
```

#### useProgress
```typescript
// lib/hooks/useProgress.ts
'use client'

import { useState, useEffect } from 'react'
import { getUserProgress } from '@/lib/api/progress'

interface ProgressData {
  totalItems: number
  learnedItems: number
  masteredItems: number
  reviewsDue: number
}

export function useProgress(userId: string) {
  const [progress, setProgress] = useState<ProgressData | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<Error | null>(null)

  useEffect(() => {
    async function fetchProgress() {
      try {
        setLoading(true)
        const data = await getUserProgress(userId)
        setProgress(data)
      } catch (err) {
        setError(err as Error)
      } finally {
        setLoading(false)
      }
    }

    fetchProgress()
  }, [userId])

  return { progress, loading, error }
}
```

#### useKeyboard
```typescript
// lib/hooks/useKeyboard.ts
'use client'

import { useEffect } from 'react'

interface KeyboardShortcut {
  key: string
  ctrl?: boolean
  shift?: boolean
  alt?: boolean
  callback: () => void
}

export function useKeyboard(shortcuts: KeyboardShortcut[]) {
  useEffect(() => {
    function handleKeyDown(event: KeyboardEvent) {
      for (const shortcut of shortcuts) {
        const ctrlMatch = shortcut.ctrl === undefined || shortcut.ctrl === event.ctrlKey
        const shiftMatch = shortcut.shift === undefined || shortcut.shift === event.shiftKey
        const altMatch = shortcut.alt === undefined || shortcut.alt === event.altKey

        if (
          event.key === shortcut.key &&
          ctrlMatch &&
          shiftMatch &&
          altMatch
        ) {
          event.preventDefault()
          shortcut.callback()
        }
      }
    }

    window.addEventListener('keydown', handleKeyDown)
    return () => window.removeEventListener('keydown', handleKeyDown)
  }, [shortcuts])
}
```

---

## 접근성 & UX

### WCAG 2.1 AA 준수

#### 키보드 네비게이션
- **Tab**: 다음 포커스 가능 요소로 이동
- **Shift + Tab**: 이전 포커스 가능 요소로 이동
- **Enter/Space**: 버튼 활성화
- **Escape**: 모달/드롭다운 닫기
- **Arrow Keys**: 리스트/라디오 버튼 네비게이션

#### 포커스 관리
```typescript
// 플래시카드 컴포넌트에서 포커스 관리 예시
function Flashcard({ item, onAnswer }: FlashcardProps) {
  const cardRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    // 카드가 렌더링될 때 포커스 설정
    cardRef.current?.focus()
  }, [item.id])

  return (
    <div
      ref={cardRef}
      tabIndex={0}
      role="article"
      aria-label={`플래시카드: ${item.content}`}
      className="focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
    >
      {/* 카드 내용 */}
    </div>
  )
}
```

#### ARIA 레이블
```typescript
// 프로그레스 바 접근성
<div
  role="progressbar"
  aria-valuenow={current}
  aria-valuemin={0}
  aria-valuemax={total}
  aria-label={`진행률: ${Math.round((current / total) * 100)}%`}
>
  {/* 시각적 프로그레스 바 */}
</div>

// 버튼 접근성
<button
  aria-label="플래시카드 뒤집기"
  aria-pressed={isFlipped}
  onClick={onFlip}
>
  {isFlipped ? '앞면 보기' : '뒷면 보기'}
</button>

// 로딩 상태
<div role="status" aria-live="polite">
  {loading ? '로딩 중...' : '로드 완료'}
</div>
```

#### 색상 대비
- **텍스트**: 최소 4.5:1 대비 (WCAG AA)
- **큰 텍스트** (18pt+): 최소 3:1 대비
- **UI 컴포넌트**: 최소 3:1 대비

```typescript
// Tailwind CSS 색상 선택 (접근성 고려)
const colorClasses = {
  primary: 'bg-blue-600 text-white hover:bg-blue-700',     // 충분한 대비
  secondary: 'bg-gray-200 text-gray-900 hover:bg-gray-300', // 충분한 대비
  danger: 'bg-red-600 text-white hover:bg-red-700',        // 충분한 대비
}
```

#### 스크린 리더 지원
```typescript
// 시각적으로만 숨기기 (스크린 리더는 읽음)
<span className="sr-only">
  현재 진행률: {current}개 중 {total}개 완료
</span>

// 스크린 리더 전용 설명
<form aria-labelledby="login-heading">
  <h2 id="login-heading" className="sr-only">
    로그인 양식
  </h2>
  {/* 폼 필드 */}
</form>
```

### 반응형 디자인

#### 브레이크포인트 전략 (Tailwind CSS)
```
sm:  640px   - 모바일 가로
md:  768px   - 태블릿
lg:  1024px  - 데스크톱
xl:  1280px  - 큰 데스크톱
2xl: 1536px  - 초대형 화면
```

#### 모바일 우선 설계
```typescript
// 모바일 우선 클래스 예시
<div className="
  p-4              /* 모바일: 16px 패딩 */
  md:p-6           /* 태블릿: 24px 패딩 */
  lg:p-8           /* 데스크톱: 32px 패딩 */

  grid
  grid-cols-1      /* 모바일: 1열 */
  md:grid-cols-2   /* 태블릿: 2열 */
  lg:grid-cols-3   /* 데스크톱: 3열 */

  gap-4            /* 모바일: 16px 간격 */
  lg:gap-6         /* 데스크톱: 24px 간격 */
">
  {/* 카드 그리드 */}
</div>
```

#### 터치 친화적 UI
```typescript
// 터치 타겟 최소 크기: 44x44px (Apple HIG, WCAG)
<button className="
  min-h-[44px]
  min-w-[44px]
  px-4
  py-2
  touch-manipulation  /* 더블탭 줌 방지 */
  active:scale-95     /* 터치 피드백 */
  transition-transform
">
  버튼
</button>
```

### 로딩 상태 처리

#### Suspense 경계
```typescript
// app/(main)/dashboard/page.tsx
import { Suspense } from 'react'
import { DashboardContent } from '@/components/dashboard/DashboardContent'
import { Loading } from '@/components/common/Loading'

export default function DashboardPage() {
  return (
    <Suspense fallback={<Loading text="대시보드 로딩 중..." />}>
      <DashboardContent />
    </Suspense>
  )
}
```

#### 스켈레톤 UI
```typescript
// components/common/SkeletonCard.tsx
export function SkeletonCard() {
  return (
    <div className="animate-pulse">
      <div className="h-4 bg-gray-200 rounded w-3/4 mb-2"></div>
      <div className="h-4 bg-gray-200 rounded w-1/2"></div>
    </div>
  )
}

// 사용
<Suspense fallback={<SkeletonCard />}>
  <ProgressCard />
</Suspense>
```

#### 낙관적 UI 업데이트
```typescript
// 답변 제출 시 즉각적인 UI 업데이트
async function handleAnswer(itemId: string, quality: number) {
  // 1. UI 먼저 업데이트 (낙관적)
  setLocalProgress((prev) => ({
    ...prev,
    itemsStudied: prev.itemsStudied + 1,
  }))

  try {
    // 2. 서버에 저장
    await submitAnswer(itemId, quality)
  } catch (error) {
    // 3. 실패 시 롤백
    setLocalProgress(previousProgress)
    showToast('답변 저장 실패', 'error')
  }
}
```

---

## 성능 최적화

### 서버 vs 클라이언트 컴포넌트 분리

#### 서버 컴포넌트 (기본값)
```typescript
// app/(main)/dashboard/page.tsx
// 서버 컴포넌트 - 데이터 페칭
import { getUser } from '@/lib/auth/actions'
import { getUserProgress } from '@/lib/api/progress'
import { DashboardClient } from './DashboardClient'

export default async function DashboardPage() {
  const user = await getUser()
  const progress = await getUserProgress(user!.id)

  // 데이터를 클라이언트 컴포넌트로 전달
  return <DashboardClient initialProgress={progress} />
}
```

#### 클라이언트 컴포넌트 ('use client')
```typescript
// app/(main)/dashboard/DashboardClient.tsx
'use client'

import { useState } from 'react'
import { ProgressData } from '@/types/progress'

interface DashboardClientProps {
  initialProgress: ProgressData
}

export function DashboardClient({ initialProgress }: DashboardClientProps) {
  const [progress, setProgress] = useState(initialProgress)

  // 인터랙티브 기능
  return (
    <div>
      {/* 대시보드 UI */}
    </div>
  )
}
```

#### 하이브리드 패턴
```typescript
// 서버 컴포넌트에서 클라이언트 컴포넌트 조합
// app/(main)/study/page.tsx
import { getLearningItems } from '@/lib/api/learning'
import { FlashcardDeck } from '@/components/study/FlashcardDeck' // 'use client'

export default async function StudyPage() {
  // 서버에서 데이터 페칭
  const items = await getLearningItems()

  return (
    <div>
      <h1>학습하기</h1>
      {/* 클라이언트 컴포넌트로 전달 */}
      <FlashcardDeck items={items} />
    </div>
  )
}
```

### 코드 스플리팅

#### 동적 임포트
```typescript
// 무거운 컴포넌트를 지연 로딩
import dynamic from 'next/dynamic'

const ChartComponent = dynamic(
  () => import('@/components/progress/Chart'),
  {
    loading: () => <Loading text="차트 로딩 중..." />,
    ssr: false, // 클라이언트에서만 렌더링
  }
)

export function ProgressPage() {
  return (
    <div>
      <h1>진도</h1>
      <ChartComponent data={data} />
    </div>
  )
}
```

#### 라우트 기반 자동 스플리팅
```
// Next.js는 자동으로 페이지별 번들 생성
app/
├── dashboard/page.tsx  → dashboard.js
├── study/page.tsx      → study.js
└── progress/page.tsx   → progress.js
```

### 이미지 최적화

#### Next.js Image 컴포넌트
```typescript
import Image from 'next/image'

<Image
  src="/hiragana-a.png"
  alt="히라가나 あ"
  width={200}
  height={200}
  priority // LCP 이미지인 경우
  placeholder="blur" // 블러 효과
  blurDataURL="data:..." // 블러 데이터 URL
/>
```

#### 아이콘 최적화
```typescript
// SVG 아이콘을 컴포넌트로 사용
import { CheckIcon, XMarkIcon } from '@heroicons/react/24/outline'

<CheckIcon className="h-6 w-6 text-green-500" />
```

### 폰트 최적화

```typescript
// app/layout.tsx
import { Geist, Noto_Sans_JP } from 'next/font/google'

const geistSans = Geist({
  variable: '--font-geist-sans',
  subsets: ['latin'],
  display: 'swap', // FOIT 방지
})

const notoSansJP = Noto_Sans_JP({
  variable: '--font-noto-jp',
  subsets: ['latin'],
  weight: ['400', '700'],
  display: 'swap',
})

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="ko" className={`${geistSans.variable} ${notoSansJP.variable}`}>
      <body>{children}</body>
    </html>
  )
}
```

### 번들 크기 최적화

#### Tree Shaking
```typescript
// ❌ 전체 라이브러리 임포트
import _ from 'lodash'

// ✅ 필요한 함수만 임포트
import { debounce } from 'lodash-es'
```

#### 조건부 로딩
```typescript
// 관리자만 필요한 기능
if (user.role === 'admin') {
  const AdminPanel = await import('@/components/admin/Panel')
  // 관리자 패널 렌더링
}
```

### 메모이제이션

#### React.memo
```typescript
import { memo } from 'react'

const FlashcardComponent = memo(function Flashcard({ item, onAnswer }: FlashcardProps) {
  // 컴포넌트 로직
}, (prevProps, nextProps) => {
  // 커스텀 비교 함수
  return prevProps.item.id === nextProps.item.id
})
```

#### useMemo
```typescript
function CategoryProgress({ items }: CategoryProgressProps) {
  // 비용이 큰 계산 메모이제이션
  const categoryStats = useMemo(() => {
    return items.reduce((acc, item) => {
      // 복잡한 계산...
      return acc
    }, {})
  }, [items])

  return <div>{/* UI */}</div>
}
```

#### useCallback
```typescript
function FlashcardDeck({ items }: FlashcardDeckProps) {
  const [currentIndex, setCurrentIndex] = useState(0)

  // 함수 메모이제이션
  const handleNext = useCallback(() => {
    setCurrentIndex((prev) => (prev + 1) % items.length)
  }, [items.length])

  return <Flashcard onNext={handleNext} />
}
```

---

## Supabase 통합

### 클라이언트 생성 패턴

#### 서버 컴포넌트용
```typescript
// lib/supabase/server.ts
import { createServerClient } from '@supabase/ssr'
import { cookies } from 'next/headers'

export function createServerSupabaseClient() {
  const cookieStore = cookies()

  return createServerClient(
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
            // Server Component에서 호출되는 경우 무시
          }
        },
      },
    }
  )
}
```

#### 클라이언트 컴포넌트용
```typescript
// lib/supabase/client.ts
import { createBrowserClient } from '@supabase/ssr'

export function createBrowserSupabaseClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  )
}
```

### 인증 플로우

#### 로그인
```typescript
// lib/auth/actions.ts
'use server'

import { createServerSupabaseClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'

export async function login(formData: FormData) {
  const email = formData.get('email') as string
  const password = formData.get('password') as string

  const supabase = createServerSupabaseClient()

  const { error } = await supabase.auth.signInWithPassword({
    email,
    password,
  })

  if (error) {
    return { error: error.message }
  }

  redirect('/dashboard')
}
```

#### 회원가입
```typescript
// lib/auth/actions.ts
export async function signup(formData: FormData) {
  const email = formData.get('email') as string
  const password = formData.get('password') as string

  const supabase = createServerSupabaseClient()

  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      emailRedirectTo: `${process.env.NEXT_PUBLIC_SITE_URL}/auth/callback`,
    },
  })

  if (error) {
    return { error: error.message }
  }

  return { success: true, user: data.user }
}
```

#### 로그아웃
```typescript
// lib/auth/actions.ts
export async function logout() {
  const supabase = createServerSupabaseClient()
  await supabase.auth.signOut()
  redirect('/login')
}
```

#### 사용자 정보 가져오기
```typescript
// lib/auth/actions.ts
export async function getUser() {
  const supabase = createServerSupabaseClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  return user
}
```

### 데이터 페칭

#### 서버 컴포넌트에서
```typescript
// app/(main)/dashboard/page.tsx
import { createServerSupabaseClient } from '@/lib/supabase/server'
import { getUser } from '@/lib/auth/actions'

export default async function DashboardPage() {
  const supabase = createServerSupabaseClient()
  const user = await getUser()

  // 사용자 통계 가져오기
  const { data: stats } = await supabase
    .from('user_stats')
    .select('*')
    .eq('user_id', user!.id)
    .single()

  // 오늘 복습할 항목 개수
  const { count: dueCount } = await supabase
    .from('user_progress')
    .select('*', { count: 'exact', head: true })
    .eq('user_id', user!.id)
    .lte('next_review_at', new Date().toISOString())

  return (
    <div>
      <h1>대시보드</h1>
      <p>레벨: {stats?.level}</p>
      <p>복습 대기: {dueCount}개</p>
    </div>
  )
}
```

#### 클라이언트 컴포넌트에서
```typescript
// components/study/FlashcardDeck.tsx
'use client'

import { useState, useEffect } from 'react'
import { createBrowserSupabaseClient } from '@/lib/supabase/client'

export function FlashcardDeck() {
  const [items, setItems] = useState([])
  const supabase = createBrowserSupabaseClient()

  useEffect(() => {
    async function fetchItems() {
      const { data } = await supabase
        .from('learning_items')
        .select('*')
        .eq('type', 'hiragana')
        .order('order_index')

      setItems(data || [])
    }

    fetchItems()
  }, [supabase])

  return <div>{/* 플래시카드 렌더링 */}</div>
}
```

### Server Actions (데이터 변경)

#### 답변 제출
```typescript
// lib/api/actions.ts
'use server'

import { createServerSupabaseClient } from '@/lib/supabase/server'
import { getUser } from '@/lib/auth/actions'
import { calculateNextReview } from '@/lib/srs/algorithm'

export async function submitAnswer(itemId: string, quality: number) {
  const supabase = createServerSupabaseClient()
  const user = await getUser()

  if (!user) {
    throw new Error('Unauthorized')
  }

  // 현재 진도 가져오기
  const { data: progress } = await supabase
    .from('user_progress')
    .select('*')
    .eq('user_id', user.id)
    .eq('item_id', itemId)
    .single()

  // SRS 알고리즘으로 다음 복습 시간 계산
  const nextReview = calculateNextReview(quality, progress)

  // 진도 업데이트
  const { error } = await supabase
    .from('user_progress')
    .upsert({
      user_id: user.id,
      item_id: itemId,
      ease_factor: nextReview.easeFactor,
      interval: nextReview.interval,
      repetitions: nextReview.repetitions,
      next_review_at: nextReview.nextReviewDate,
      last_reviewed_at: new Date().toISOString(),
      total_reviews: (progress?.total_reviews || 0) + 1,
      correct_reviews: quality >= 3 ? (progress?.correct_reviews || 0) + 1 : progress?.correct_reviews,
      updated_at: new Date().toISOString(),
    })

  if (error) {
    throw error
  }

  return { success: true }
}
```

#### 학습 세션 저장
```typescript
// lib/api/actions.ts
export async function saveStudySession(sessionData: {
  duration: number
  itemsStudied: number
  itemsCorrect: number
  newItems: number
  reviewItems: number
  xpEarned: number
}) {
  const supabase = createServerSupabaseClient()
  const user = await getUser()

  if (!user) {
    throw new Error('Unauthorized')
  }

  const { error } = await supabase.from('study_sessions').insert({
    user_id: user.id,
    session_date: new Date().toISOString().split('T')[0],
    duration: sessionData.duration,
    items_studied: sessionData.itemsStudied,
    items_correct: sessionData.itemsCorrect,
    new_items: sessionData.newItems,
    review_items: sessionData.reviewItems,
    xp_earned: sessionData.xpEarned,
  })

  if (error) {
    throw error
  }

  // 사용자 통계 업데이트
  await updateUserStats(user.id, sessionData)

  return { success: true }
}
```

### 실시간 구독 (선택적)

```typescript
// 리더보드 실시간 업데이트 예시
'use client'

import { useEffect, useState } from 'react'
import { createBrowserSupabaseClient } from '@/lib/supabase/client'

export function Leaderboard() {
  const [leaders, setLeaders] = useState([])
  const supabase = createBrowserSupabaseClient()

  useEffect(() => {
    // 초기 데이터 로드
    fetchLeaders()

    // 실시간 구독
    const subscription = supabase
      .channel('leaderboard')
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'user_stats',
        },
        () => {
          fetchLeaders()
        }
      )
      .subscribe()

    return () => {
      subscription.unsubscribe()
    }
  }, [supabase])

  async function fetchLeaders() {
    const { data } = await supabase
      .from('user_stats')
      .select('*')
      .order('total_xp', { ascending: false })
      .limit(10)

    setLeaders(data || [])
  }

  return <div>{/* 리더보드 UI */}</div>
}
```

---

## 구현 가이드라인

### TypeScript 타입 정의

#### 데이터베이스 타입
```typescript
// types/database.ts
export type LearningItemType = 'hiragana' | 'katakana' | 'vocabulary' | 'kanji' | 'grammar'
export type JLPTLevel = 'N5' | 'N4' | 'N3' | 'N2' | 'N1'
export type ProgressStatus = 'new' | 'learning' | 'reviewing' | 'mastered'

export interface LearningItem {
  id: string
  type: LearningItemType
  jlpt_level: JLPTLevel
  content: string
  reading?: string
  meaning: string
  example_sentence?: string
  category?: string
  order_index?: number
  created_at: string
}

export interface UserProgress {
  id: string
  user_id: string
  item_id: string
  status: ProgressStatus
  ease_factor: number
  interval: number
  repetitions: number
  last_reviewed_at?: string
  next_review_at?: string
  total_reviews: number
  correct_reviews: number
  created_at: string
  updated_at: string
}

export interface UserStats {
  id: string
  user_id: string
  level: number
  total_xp: number
  current_streak: number
  longest_streak: number
  last_study_date?: string
  total_items_mastered: number
  total_study_time: number
  total_sessions: number
  created_at: string
  updated_at: string
}
```

#### 컴포넌트 Props 타입
```typescript
// types/components.ts
import { LearningItem, UserProgress } from './database'

export interface FlashcardProps {
  item: LearningItem
  isFlipped: boolean
  onFlip: () => void
  onAnswer: (quality: number) => void
}

export interface ProgressBarProps {
  current: number
  total: number
  label?: string
  color?: 'blue' | 'green' | 'purple' | 'orange'
  showPercentage?: boolean
  size?: 'sm' | 'md' | 'lg'
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost' | 'danger'
  size?: 'sm' | 'md' | 'lg'
  isLoading?: boolean
  leftIcon?: React.ReactNode
  rightIcon?: React.ReactNode
}
```

### 에러 처리

#### 에러 바운더리
```typescript
// app/error.tsx
'use client'

import { useEffect } from 'react'
import { Button } from '@/components/common/Button'

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  useEffect(() => {
    // 에러 로깅
    console.error(error)
  }, [error])

  return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-center">
        <h2 className="text-2xl font-bold mb-4">문제가 발생했습니다</h2>
        <p className="text-gray-600 mb-6">{error.message}</p>
        <Button onClick={reset}>다시 시도</Button>
      </div>
    </div>
  )
}
```

#### try-catch 패턴
```typescript
async function handleSubmit() {
  try {
    setLoading(true)
    await submitAnswer(itemId, quality)
    showToast('답변이 저장되었습니다', 'success')
  } catch (error) {
    console.error('답변 저장 실패:', error)
    showToast('답변 저장에 실패했습니다', 'error')
  } finally {
    setLoading(false)
  }
}
```

### 테스트 전략

#### 단위 테스트 (Jest + React Testing Library)
```typescript
// __tests__/components/Button.test.tsx
import { render, screen, fireEvent } from '@testing-library/react'
import { Button } from '@/components/common/Button'

describe('Button', () => {
  it('renders with text', () => {
    render(<Button>클릭</Button>)
    expect(screen.getByText('클릭')).toBeInTheDocument()
  })

  it('calls onClick when clicked', () => {
    const handleClick = jest.fn()
    render(<Button onClick={handleClick}>클릭</Button>)

    fireEvent.click(screen.getByText('클릭'))
    expect(handleClick).toHaveBeenCalledTimes(1)
  })

  it('shows loading state', () => {
    render(<Button isLoading>로딩</Button>)
    expect(screen.getByRole('button')).toBeDisabled()
  })
})
```

#### 통합 테스트
```typescript
// __tests__/integration/auth.test.tsx
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { LoginForm } from '@/components/auth/LoginForm'

describe('Login Flow', () => {
  it('successfully logs in', async () => {
    render(<LoginForm />)

    // 입력
    fireEvent.change(screen.getByLabelText('이메일'), {
      target: { value: 'test@example.com' },
    })
    fireEvent.change(screen.getByLabelText('비밀번호'), {
      target: { value: 'password123' },
    })

    // 제출
    fireEvent.click(screen.getByRole('button', { name: '로그인' }))

    // 성공 확인
    await waitFor(() => {
      expect(window.location.pathname).toBe('/dashboard')
    })
  })
})
```

### 베스트 프랙티스

#### 1. 컴포넌트 설계
- **단일 책임 원칙**: 각 컴포넌트는 하나의 책임만
- **Props 최소화**: 필요한 props만 전달
- **재사용성**: 공통 UI는 독립 컴포넌트로 분리
- **타입 안전성**: 모든 props에 TypeScript 타입 정의

#### 2. 상태 관리
- **서버 상태 우선**: 가능하면 서버 컴포넌트 사용
- **로컬 상태 선호**: 전역 상태는 최소화
- **Context 신중히**: 성능 이슈 방지 위해 필요시만 사용

#### 3. 성능
- **지연 로딩**: 초기 번들 크기 최소화
- **메모이제이션**: 비용 큰 계산만 메모이제이션
- **이미지 최적화**: Next.js Image 컴포넌트 사용

#### 4. 접근성
- **시맨틱 HTML**: 적절한 HTML 요소 사용
- **ARIA 레이블**: 스크린 리더 지원
- **키보드 네비게이션**: 모든 인터랙션 키보드로 가능

#### 5. 보안
- **환경 변수**: 민감한 정보는 .env.local
- **RLS 정책**: Supabase Row Level Security 활용
- **입력 검증**: 클라이언트 + 서버 양쪽 검증

---

## 구현 우선순위

### Phase 3-1: 기본 레이아웃 (1-2일)

**우선순위**: 높음
**목표**: 앱의 기본 구조와 네비게이션 구축

#### 작업 항목
1. **루트 레이아웃**
   - 폰트 설정 (Geist, Noto Sans JP)
   - 전역 스타일
   - AuthProvider, ToastProvider 설정

2. **공통 UI 컴포넌트**
   - Button (모든 페이지에서 사용)
   - Card
   - Loading
   - Toast

3. **헤더 & 네비게이션**
   - Header 컴포넌트
   - Navigation 컴포넌트
   - 반응형 메뉴

4. **레이아웃 구조**
   - (auth) 레이아웃
   - (main) 레이아웃

**완료 기준**:
- [ ] 모든 페이지에서 공통 레이아웃 작동
- [ ] 네비게이션 라우팅 정상 작동
- [ ] 반응형 디자인 확인 (모바일/데스크톱)

---

### Phase 3-2: 인증 페이지 (2-3일)

**우선순위**: 높음
**목표**: 사용자 인증 플로우 완성

#### 작업 항목
1. **로그인 페이지**
   - LoginForm 컴포넌트
   - 폼 유효성 검사
   - 에러 처리
   - 로딩 상태

2. **회원가입 페이지**
   - SignupForm 컴포넌트
   - 비밀번호 확인
   - 이메일 중복 체크
   - 가입 후 자동 로그인

3. **인증 플로우**
   - AuthContext 구현
   - 미들웨어 인증 체크
   - 로그아웃 기능

4. **리디렉션 처리**
   - 로그인 시 대시보드로
   - 로그아웃 시 로그인 페이지로
   - 인증 필요 페이지 보호

**완료 기준**:
- [ ] 회원가입/로그인/로그아웃 정상 작동
- [ ] 인증되지 않은 사용자 접근 차단
- [ ] 에러 메시지 적절히 표시
- [ ] 접근성 (키보드, ARIA) 확인

---

### Phase 3-3: 대시보드 (3-4일)

**우선순위**: 높음
**목표**: 사용자 학습 현황 한눈에 보기

#### 작업 항목
1. **대시보드 페이지**
   - 일일 목표 (DailyGoal)
   - 복습 큐 (ReviewQueue)
   - 진도 개요 (ProgressOverview)
   - 스트릭 카운터 (StreakCounter)

2. **진도 추적 컴포넌트**
   - ProgressBar
   - CategoryProgress
   - LevelIndicator
   - StatCard

3. **데이터 페칭**
   - 서버 컴포넌트에서 초기 데이터
   - 사용자 통계 가져오기
   - 복습 대기 개수 계산

4. **인터랙션**
   - 학습 시작 버튼
   - 복습 시작 버튼
   - 카테고리 클릭 시 해당 학습으로 이동

**완료 기준**:
- [ ] 대시보드에서 주요 정보 표시
- [ ] 데이터 정확히 표시
- [ ] CTA 버튼 작동
- [ ] 로딩 상태 처리

---

### Phase 3-4: 플래시카드 학습 (4-5일)

**우선순위**: 높음
**목표**: 핵심 학습 기능 구현

#### 작업 항목
1. **Flashcard 컴포넌트**
   - 앞면/뒷면 표시
   - 플립 애니메이션
   - 답변 버튼 (Again, Hard, Good, Easy)
   - 키보드 단축키

2. **FlashcardDeck 컴포넌트**
   - 카드 순서 관리
   - 진행률 표시
   - 세션 타이머
   - 결과 수집

3. **학습 페이지**
   - /study/flashcard 라우트
   - 학습 항목 선택
   - 세션 시작/종료

4. **데이터 연동**
   - 학습 항목 가져오기
   - 답변 제출 (Server Action)
   - 진도 업데이트

**완료 기준**:
- [ ] 플래시카드 정상 작동
- [ ] 답변 버튼 클릭 시 저장
- [ ] 키보드 단축키 작동
- [ ] 세션 완료 후 결과 표시

---

### Phase 3-5: 퀴즈 기능 (3-4일)

**우선순위**: 중간
**목표**: 즉시 테스트 기능 제공

#### 작업 항목
1. **Quiz 컴포넌트**
   - 4지선다 문제 표시
   - 답안 선택
   - 즉각적 피드백
   - 타이머 (선택적)

2. **QuizQuestion 컴포넌트**
   - 문제 표시
   - 옵션 렌더링
   - 정답/오답 표시

3. **퀴즈 페이지**
   - /study/quiz 라우트
   - 문제 생성 로직
   - 결과 화면

4. **데이터 연동**
   - 문제 생성
   - 답안 채점
   - 통계 저장

**완료 기준**:
- [ ] 퀴즈 정상 작동
- [ ] 정답/오답 즉각 피드백
- [ ] 결과 화면 표시
- [ ] 접근성 확인

---

### Phase 3-6: 진도 페이지 (2-3일)

**우선순위**: 중간
**목표**: 상세 통계 및 진도 시각화

#### 작업 항목
1. **진도 페이지**
   - /progress 라우트
   - 카테고리별 진도
   - 학습 캘린더 히트맵 (선택적)
   - 통계 차트 (선택적)

2. **통계 컴포넌트**
   - 일일/주간/월간 통계
   - 정답률 차트
   - 학습 시간 그래프

3. **데이터 시각화**
   - 카테고리별 마스터 개수
   - 레벨별 진행률
   - 스트릭 기록

**완료 기준**:
- [ ] 진도 페이지 표시
- [ ] 통계 정확히 계산
- [ ] 시각화 요소 작동
- [ ] 반응형 디자인

---

### Phase 3-7: 폴리싱 & 최적화 (2-3일)

**우선순위**: 중간
**목표**: 사용자 경험 개선 및 버그 수정

#### 작업 항목
1. **UX 개선**
   - 로딩 상태 개선
   - 에러 메시지 개선
   - 애니메이션 추가
   - 토스트 알림

2. **접근성 점검**
   - 키보드 네비게이션 확인
   - ARIA 레이블 추가
   - 스크린 리더 테스트
   - 색상 대비 확인

3. **성능 최적화**
   - 번들 크기 확인
   - 이미지 최적화
   - 코드 스플리팅 확인
   - Lighthouse 점수 확인

4. **버그 수정**
   - 크로스 브라우저 테스트
   - 모바일 테스트
   - 엣지 케이스 처리

**완료 기준**:
- [ ] Lighthouse 점수 90+ (Performance, Accessibility)
- [ ] 주요 브라우저에서 정상 작동
- [ ] 모바일에서 정상 작동
- [ ] 알려진 버그 없음

---

## 체크리스트

### 개발 시작 전
- [ ] 디렉토리 구조 확인
- [ ] TypeScript 타입 정의 작성
- [ ] Supabase 클라이언트 설정 확인
- [ ] 환경 변수 설정

### 각 컴포넌트 개발 시
- [ ] TypeScript 인터페이스 정의
- [ ] 접근성 (ARIA, 키보드) 구현
- [ ] 반응형 디자인 확인
- [ ] 에러 처리 구현
- [ ] 로딩 상태 처리

### 페이지 개발 시
- [ ] 서버/클라이언트 컴포넌트 분리
- [ ] 데이터 페칭 구현
- [ ] 레이아웃 적용
- [ ] 메타데이터 설정
- [ ] 에러 바운더리 설정

### 배포 전
- [ ] 모든 환경 변수 설정
- [ ] Lighthouse 점수 확인
- [ ] 크로스 브라우저 테스트
- [ ] 모바일 테스트
- [ ] 접근성 테스트

---

## 다음 단계

Phase 3 완료 후:
1. **Phase 4**: SRS 시스템 구현
2. **Phase 5**: 학습 데이터 준비
3. **Phase 6**: 게임화 시스템
4. **Phase 7**: 통합 및 테스트
5. **Phase 8**: 배포

---

**참고 문서**:
- [Next.js App Router 문서](https://nextjs.org/docs/app)
- [Supabase Auth 가이드](https://supabase.com/docs/guides/auth)
- [Tailwind CSS 문서](https://tailwindcss.com/docs)
- [WCAG 2.1 가이드라인](https://www.w3.org/WAI/WCAG21/quickref/)

**작성**: Frontend Architect Agent
**검토**: 필요시 프로젝트 팀
**업데이트**: 구현 진행에 따라 수정

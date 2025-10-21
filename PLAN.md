# 일본어 학습 사이트 프로젝트 계획서

**프로젝트명**: Japanese Learning App
**목표**: JLPT 단계별 합격 + 일본 여행 기본 회화
**학습 시간**: 하루 30분
**핵심 전략**: 체계적 커리큘럼 + SRS 복습 시스템

---

## 📋 목차

1. [프로젝트 개요](#프로젝트-개요)
2. [핵심 기능](#핵심-기능)
3. [기술 스택](#기술-스택)
4. [학습 커리큘럼](#학습-커리큘럼)
5. [데이터베이스 설계](#데이터베이스-설계)
6. [SRS 알고리즘](#srs-알고리즘)
7. [게임화 시스템](#게임화-시스템)
8. [개발 로드맵](#개발-로드맵)
9. [커스텀 에이전트](#커스텀-에이전트)

---

## 🎯 프로젝트 개요

### 목표
- **최종 목표**: 일본 여행에서 기본적인 의사소통
- **단계별 목표**: JLPT N5 → N4 → N3 → N2 → N1 순차 합격
- **학습 방식**: 체계적 커리큘럼 + SRS(Spaced Repetition System) 복습

### 사용자 페르소나
- 일본어 완전 초보자
- 하루 30분 투자 가능
- 혼자서 꾸준히 공부하고 싶음
- 장기적으로 JLPT 합격 목표

### 핵심 가치
1. **효율성**: 30분 최적 학습 경험
2. **과학적 접근**: SRS 알고리즘 기반 복습
3. **동기부여**: 게임화 요소로 지속성 확보
4. **체계성**: JLPT 기준 명확한 학습 경로

---

## ⚡ 핵심 기능

### 30분 학습 세션 구조
```
1분  - 대시보드 확인 (오늘의 목표)
10분 - SRS 복습 (장기 기억 정착) ⭐ 가장 중요!
15분 - 신규 학습 (새로운 내용)
4분  - 즉시 퀴즈 (오늘 배운 것 테스트)
```

### 주요 기능
1. **학습 시스템**
   - 플래시카드 기반 학습
   - 4지선다 퀴즈
   - 타이핑 연습
   - 즉각적 피드백

2. **SRS 복습 시스템**
   - 자동 복습 스케줄링
   - 망각 곡선 기반 간격 조정
   - 난이도별 차별화 (히라가나/단어/한자)

3. **진도 추적**
   - 레벨별 진행률 시각화
   - 학습 통계 대시보드
   - 카테고리별 숙련도 표시

4. **게임화 요소**
   - 레벨/XP 시스템
   - 배지 및 업적
   - 연속 학습 스트릭 (🔥)
   - 리더보드 (선택적)

5. **사용자 관리**
   - Supabase Auth 기반 인증
   - 학습 기록 클라우드 저장
   - 디바이스 간 동기화

---

## 🛠️ 기술 스택

### Frontend
- **Framework**: Next.js 15.5.6 (App Router)
- **Language**: TypeScript 5.x
- **Styling**: Tailwind CSS 4.x
- **Build Tool**: Turbopack

### Backend & Database
- **BaaS**: Supabase
  - Authentication (이메일/소셜 로그인)
  - PostgreSQL Database
  - Real-time subscriptions (선택적)
  - Row Level Security (RLS)

### 개발 도구
- **Package Manager**: npm
- **Linting**: ESLint 9.x
- **Version Control**: Git

### 배포 (예정)
- **Hosting**: Vercel (추천) 또는 Netlify
- **Database**: Supabase Cloud

---

## 📚 학습 커리큘럼

### Phase 1: 문자 마스터 (2-3주)

#### Week 1-2: 히라가나 46자
- **목표**: 히라가나 완전 숙지
- **방법**: 매일 5-7개씩 신규 학습
- **학습 순서**:
  ```
  1단계: あ행 (あいうえお)
  2단계: か행, さ행
  3단계: た행, な행
  4단계: は행, ま행
  5단계: や행, ら행, わ행
  6단계: ん
  7단계: 탁음/반탁음 (が, ざ, だ, ば, ぱ)
  8단계: 요음 (きゃ, しゃ, ちゃ...)
  ```
- **혼동 방지**: あ/お, は/ほ, わ/れ 등 비슷한 문자 분리 배치

#### Week 2-3: 가타카나 46자
- **목표**: 가타카나 완전 숙지
- **방법**: 히라가나 복습 병행 + 가타카나 신규 학습
- **특징**: 외래어 표기 중심 학습

### Phase 2: N5 기초 (2-3개월)

#### 단어 학습 (800개)
- **카테고리별 학습**:
  - 숫자/시간 (1-100, 시간, 요일, 월)
  - 인물 (가족, 직업, 인칭대명사)
  - 장소 (집, 학교, 가게, 교통)
  - 음식 (과일, 채소, 요리, 음료)
  - 동사 (기본 동작, 일상 생활)
  - 형용사 (い형용사, な형용사)

- **매일 학습량**: 5-7개 신규 단어

#### 문법 학습 (80개 패턴)
- **기본 문장 구조**
  - は, です, ます 기본형
  - 조사 (を, に, で, へ, から, まで)
  - 형용사 활용
  - 동사 활용 (ます형, て형, た형)
  - 부정/과거 표현

- **매일 학습량**: 1개 문법 패턴 + 예문 3-5개

#### 한자 학습 (100개)
- **학습 전략**:
  - 빈도별 우선순위 (日, 月, 人, 山...)
  - 부수 기반 학습
  - 음독/훈독 구분

- **매일 학습량**: 1-2개 신규 한자

### Phase 3: N4 → N3 → N2 → N1 (순차 진행)
- N5 완료 후 단계적 확장
- 각 레벨별 요구사항 충족
- 동일한 SRS 시스템 활용

---

## 🗄️ 데이터베이스 설계

### 테이블 구조 (Supabase PostgreSQL)

#### 1. learning_items (학습 항목)
```sql
CREATE TABLE learning_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  type TEXT NOT NULL, -- 'hiragana', 'katakana', 'vocabulary', 'grammar', 'kanji'
  jlpt_level TEXT NOT NULL, -- 'N5', 'N4', 'N3', 'N2', 'N1'
  content TEXT NOT NULL, -- 일본어 원문
  reading TEXT, -- 히라가나 읽기
  meaning TEXT NOT NULL, -- 한국어 뜻
  example_sentence TEXT, -- 예문
  category TEXT, -- '숫자', '시간', '가족' 등
  order_index INTEGER, -- 학습 순서
  created_at TIMESTAMP DEFAULT NOW()
);

-- 인덱스
CREATE INDEX idx_learning_items_type ON learning_items(type);
CREATE INDEX idx_learning_items_jlpt ON learning_items(jlpt_level);
CREATE INDEX idx_learning_items_category ON learning_items(category);
```

#### 2. user_progress (사용자 학습 진도 - SRS 핵심!)
```sql
CREATE TABLE user_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users NOT NULL,
  item_id UUID REFERENCES learning_items NOT NULL,

  -- 학습 상태
  status TEXT DEFAULT 'new', -- 'new', 'learning', 'reviewing', 'mastered'

  -- SRS 알고리즘 파라미터
  ease_factor FLOAT DEFAULT 2.5, -- 난이도 계수
  interval INTEGER DEFAULT 1, -- 복습 간격 (일 단위)
  repetitions INTEGER DEFAULT 0, -- 연속 성공 횟수

  -- 복습 스케줄
  last_reviewed_at TIMESTAMP,
  next_review_at TIMESTAMP,

  -- 통계
  total_reviews INTEGER DEFAULT 0,
  correct_reviews INTEGER DEFAULT 0,

  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),

  UNIQUE(user_id, item_id)
);

-- 인덱스
CREATE INDEX idx_user_progress_user ON user_progress(user_id);
CREATE INDEX idx_user_progress_next_review ON user_progress(next_review_at);
CREATE INDEX idx_user_progress_status ON user_progress(status);
```

#### 3. study_sessions (학습 세션 기록)
```sql
CREATE TABLE study_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users NOT NULL,

  session_date DATE NOT NULL,
  duration INTEGER, -- 초 단위

  items_studied INTEGER DEFAULT 0,
  items_correct INTEGER DEFAULT 0,
  new_items INTEGER DEFAULT 0,
  review_items INTEGER DEFAULT 0,

  xp_earned INTEGER DEFAULT 0, -- 게임화 요소

  created_at TIMESTAMP DEFAULT NOW()
);

-- 인덱스
CREATE INDEX idx_study_sessions_user ON study_sessions(user_id);
CREATE INDEX idx_study_sessions_date ON study_sessions(session_date);
```

#### 4. user_stats (사용자 통계 - 게임화)
```sql
CREATE TABLE user_stats (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users UNIQUE NOT NULL,

  -- 레벨 시스템
  level INTEGER DEFAULT 1,
  total_xp INTEGER DEFAULT 0,

  -- 스트릭
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_study_date DATE,

  -- 누적 통계
  total_items_mastered INTEGER DEFAULT 0,
  total_study_time INTEGER DEFAULT 0, -- 초 단위
  total_sessions INTEGER DEFAULT 0,

  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

#### 5. user_badges (배지 시스템)
```sql
CREATE TABLE user_badges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users NOT NULL,
  badge_id TEXT NOT NULL, -- 'hiragana_master', '7_day_streak', etc.
  earned_at TIMESTAMP DEFAULT NOW(),

  UNIQUE(user_id, badge_id)
);

-- 인덱스
CREATE INDEX idx_user_badges_user ON user_badges(user_id);
```

---

## 🧠 SRS 알고리즘

### 기본 알고리즘: SM-2 (SuperMemo 2)

#### 핵심 파라미터
```javascript
const DEFAULT_SRS_CONFIG = {
  // 신규 카드
  graduatingInterval: 1,   // 졸업 후 1일
  easyInterval: 4,         // Easy 선택 시 4일

  // 복습 카드
  easyBonus: 1.3,          // Easy 보너스
  intervalModifier: 1.0,   // 전체 간격 조정
  maximumInterval: 365,    // 최대 1년

  // 난이도
  startingEase: 2.5,       // 시작 ease factor

  // 실패 처리
  lapseNewInterval: 0.5,   // 이전 간격의 50%
  minimumInterval: 1,      // 최소 1일
};
```

#### 타입별 복습 간격 조정
```javascript
const TYPE_MULTIPLIERS = {
  hiragana: 1.0,      // 기본
  katakana: 1.0,      // 기본
  vocabulary: 1.0,    // 기본
  kanji: 0.7,         // 30% 더 자주 복습
  grammar: 0.85       // 15% 더 자주 복습
};
```

#### 복습 간격 계산 함수
```javascript
function calculateNextReview(quality, currentCard) {
  const { interval, easeFactor, repetitions, type } = currentCard;

  // quality: 0-5 (0=완전 망각, 5=완벽)

  // 1. 실패 처리 (quality < 3)
  if (quality < 3) {
    return {
      interval: 1,
      easeFactor: Math.max(1.3, easeFactor - 0.2),
      repetitions: 0
    };
  }

  // 2. Ease Factor 업데이트
  let newEF = easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
  newEF = Math.max(1.3, Math.min(2.5, newEF));

  // 3. 간격 계산
  let newInterval;
  if (repetitions === 0) {
    newInterval = 1;
  } else if (repetitions === 1) {
    newInterval = 6;
  } else {
    newInterval = interval * newEF;
  }

  // 4. 타입별 조정
  newInterval = newInterval / (TYPE_MULTIPLIERS[type] || 1.0);

  // 5. 범위 제한
  newInterval = Math.max(1, Math.min(365, Math.round(newInterval)));

  return {
    interval: newInterval,
    easeFactor: newEF,
    repetitions: repetitions + 1,
    nextReviewDate: addDays(new Date(), newInterval)
  };
}
```

### 복습 우선순위
1. **기한 지난 카드** (가장 우선)
2. **오늘 복습 예정 카드**
3. **신규 카드** (일일 제한: 5-10개)

---

## 🎮 게임화 시스템

### 레벨 시스템

#### XP 획득
```javascript
const XP_REWARDS = {
  newCardLearned: 10,      // 새 카드 학습
  reviewCorrect: 5,        // 복습 정답
  reviewPerfect: 8,        // 완벽 정답
  dailyGoalComplete: 50,   // 일일 목표 달성
  weeklyStreakBonus: 100   // 주간 연속 보너스
};
```

#### 레벨 진행
```javascript
// 레벨당 필요 XP (지수 증가)
function calculateLevelXP(level) {
  return Math.floor(100 * Math.pow(1.5, level - 1));
}

// Level 1→2: 100 XP
// Level 5→6: 506 XP
// Level 10→11: 3844 XP
```

### 배지 시스템

#### 배지 카테고리
```yaml
학습_진도_배지:
  - "히라가나 정복자" (46자 완료)
  - "가타카나 마스터" (46자 완료)
  - "N5 단어 컬렉터" (100, 300, 800개)
  - "한자 입문자" (첫 10개 한자)

연속성_배지:
  - "🔥 불꽃" (3일 연속)
  - "⚡ 전기" (7일 연속)
  - "💎 다이아몬드" (30일 연속)
  - "🏆 레전드" (100일 연속)

성취_배지:
  - "완벽주의자" (정답률 95% 이상)
  - "스피드러너" (1분 내 20문제)
  - "얼리버드" (아침 6시 전 학습)

숨겨진_배지:
  - "행운의 번호" (777번째 카드)
  - "부활" (30일 중단 후 복귀)
```

### 스트릭 시스템
```javascript
const STREAK_REWARDS = {
  3: { xp: 50, message: "🔥 3일 연속!" },
  7: { xp: 150, badge: "주간 전사" },
  30: { xp: 1000, badge: "월간 마스터" },
  100: { xp: 5000, badge: "🏆 레전드" }
};
```

### 진도 시각화
- 프로그레스 바 (카테고리별)
- 학습 캘린더 히트맵
- 통계 차트 (일일/주간/월간)

---

## 🛣️ 개발 로드맵

### Phase 1: 기획 및 설계 (Week 1) ✅
- [x] 프로젝트 목표 및 범위 정의
- [x] 기술 스택 선정
- [x] 커스텀 에이전트 생성
- [x] 프로젝트 초기화
- [x] 전체 계획서 작성 (PLAN.md)

### Phase 2: MVP 개발 - 백엔드 (Week 2) ✅
- [x] Supabase 프로젝트 생성
- [x] 데이터베이스 스키마 구현
  - [x] learning_items 테이블
  - [x] user_progress 테이블
  - [x] study_sessions 테이블
  - [x] user_stats 테이블
  - [x] user_badges 테이블
  - [x] badge_definitions 테이블
- [x] Row Level Security (RLS) 정책 설정
- [x] Supabase Auth 설정
- [x] API 엔드포인트 설계

### Phase 3: MVP 개발 - 프론트엔드 (Week 3) ✅
- [x] 레이아웃 구조 구현
  - [x] 네비게이션
  - [x] 대시보드 레이아웃
- [x] 인증 페이지
  - [x] 회원가입
  - [x] 로그인
- [x] 핵심 컴포넌트 개발
  - [x] 플래시카드 컴포넌트
  - [x] 퀴즈 컴포넌트
  - [x] 진도바 컴포넌트

### Phase 4: SRS 시스템 구현 (Week 4) ✅
- [x] SRS 알고리즘 구현
  - [x] 복습 간격 계산 함수
  - [x] 복습 스케줄링 로직
  - [x] 타입별 간격 조정
- [x] 복습 큐 관리
- [x] 복습 페이지 구현 (학습 페이지와 통합)
- [ ] 단위 테스트 작성

### Phase 5: 학습 데이터 준비 (Week 5) ✅
- [x] 히라가나 46자 데이터
  - [x] 문자 + 읽기 + 예제
  - [x] 학습 순서 최적화
- [x] 가타카나 46자 데이터
  - [x] 외래어 예제 포함
  - [x] 혼동 방지 학습 팁
- [x] N5 단어 300개 (목표의 37.5% 달성)
  - [x] 카테고리별 분류
  - [x] 예문 작성
  - [x] 히라가나 읽기 포함
  - [x] Batch 1: 요일, 시간, 음식, 위치, 교통, 날씨, 계절, 동사 (50개)
  - [x] Batch 2: 색상, 신체, 가족, 장소, 시간표현, 형용사 (50개)
  - [x] Batch 3: 숫자, 동사, 형용사, 일상명사 (50개)
- [x] 데이터베이스 마이그레이션
- [x] 플래시카드 UX 개선 (후리가나 표시, 예문 히라가나+번역)

### Phase 6: 게임화 시스템 (Week 6) ✅
- [x] XP 시스템 구현
  - [x] XP 계산 유틸리티 (`src/lib/gamification/xp.ts`)
  - [x] 학습 활동별 XP 보상
  - [x] Server Actions (`addXP`, `recordStudySession`)
- [x] 레벨 시스템
  - [x] 레벨 계산 유틸리티 (`src/lib/gamification/levels.ts`)
  - [x] 레벨업 감지 로직
  - [x] 레벨 진행률 컴포넌트 (`LevelProgress.tsx`)
- [x] 스트릭 추적
  - [x] 스트릭 계산 유틸리티 (`src/lib/gamification/streaks.ts`)
  - [x] 마일스톤 보상 시스템
  - [x] 스트릭 카운터 컴포넌트 (`StreakCounter.tsx`)
- [x] 진도 시각화
  - [x] 오늘의 학습 통계 컴포넌트 (`TodayStats.tsx`)
  - [x] 대시보드 통합
  - [x] 반응형 레이아웃
- [ ] 배지 시스템 (추후 구현)

### Phase 7: 통합 및 테스트 (Week 7)
- [ ] E2E 테스트
- [ ] 사용자 플로우 검증
- [ ] SRS 알고리즘 검증
- [ ] 성능 최적화
- [ ] 버그 수정

### Phase 8: 배포 및 런칭 (Week 8)
- [ ] Vercel 배포 설정
- [ ] 환경 변수 설정
- [ ] 도메인 연결 (선택)
- [ ] 모니터링 설정
- [ ] 소프트 런칭

### Future Enhancements (Post-MVP)
- [ ] N5 문법 80개 추가
- [ ] N5 한자 100개 추가
- [ ] N4 레벨 확장
- [ ] 음성 발음 기능
- [ ] 모바일 앱 (React Native)
- [ ] 소셜 기능 (친구, 리더보드)
- [ ] AI 챗봇 대화 연습

---

## 🤖 커스텀 에이전트

### 생성된 전문 에이전트

#### 1. `/japanese-expert` - 일본어 학습 전문가
**전문 분야**:
- JLPT N5~N1 커리큘럼 설계
- 히라가나/가타카나 학습 순서 최적화
- 한자 학습 전략 (부수, 음독/훈독)
- 실용 회화 표현 큐레이션
- 학습 데이터 검증 및 생성

**활용 단계**:
- Phase 5 (학습 데이터 준비)
- 커리큘럼 검토 및 최적화
- 학습 콘텐츠 생성

#### 2. `/srs-expert` - SRS 알고리즘 전문가
**전문 분야**:
- SM-2, Anki, Leitner 알고리즘 비교
- 망각 곡선 기반 복습 간격 최적화
- 일본어 특화 SRS 파라미터 조정
- A/B 테스트 전략 수립
- 알고리즘 구현 가이드

**활용 단계**:
- Phase 4 (SRS 시스템 구현)
- 알고리즘 최적화
- 성능 분석 및 개선

#### 3. `/gamification-expert` - 게임화 전문가
**전문 분야**:
- Octalysis Framework 기반 설계
- 레벨/배지/스트릭 시스템
- 사용자 동기부여 메커니즘
- 진도 시각화 및 피드백 설계
- 학습 습관 형성 전략

**활용 단계**:
- Phase 6 (게임화 시스템)
- 동기부여 요소 설계
- 사용자 리텐션 전략

### 내장 에이전트 활용

#### `requirements-analyst`
- Phase 2: 상세 기능 명세 작성
- 사용자 스토리 정의

#### `backend-architect`
- Phase 2: Supabase 스키마 최적화
- API 설계 검토

#### `frontend-architect`
- Phase 3: 컴포넌트 아키텍처
- UI/UX 최적화

#### `quality-engineer`
- Phase 7: 테스트 전략 수립
- 품질 보증

---

## 📊 성공 지표 (KPIs)

### 학습 효율성
- 카드당 평균 복습 횟수: < 7회 (마스터까지)
- 정답률: 80-90% (최적)
- 일일 복습 시간: < 15분
- 신규 학습 시간: < 15분

### 사용자 참여
- 일일 활성 사용자 (본인)
- 7일 스트릭 달성률: > 80%
- 30일 스트릭 달성률: > 50%
- 평균 세션 시간: 25-35분

### 학습 성과
- N5 히라가나 마스터: 2주
- N5 가타카나 마스터: 3주
- N5 단어 800개 마스터: 3개월
- N5 시험 준비 완료: 4-6개월

---

## 🎯 MVP 범위 (Phase 2-5)

### ✅ MVP에 포함
1. 회원가입/로그인 (Supabase Auth)
2. 히라가나 46자 학습 (플래시카드)
3. 기본 SRS 복습 시스템
4. 간단한 진도 표시
5. 학습 기록 저장
6. 기본 통계 (학습한 개수, 정답률)

### ⏳ MVP 이후
1. 가타카나 학습
2. N5 단어/문법/한자
3. 게임화 요소 (레벨, 배지, 스트릭)
4. 상세 통계 차트
5. 리더보드
6. 소셜 기능

---

## 📝 참고 자료

### JLPT 공식 정보
- [JLPT 공식 사이트](https://www.jlpt.jp/)
- N5 요구사항: 히라가나, 가타카나, 한자 100개, 단어 800개, 문법 80개

### SRS 알고리즘
- SuperMemo SM-2 알고리즘
- Anki 구현 방식
- Ebbinghaus 망각 곡선

### 게임화 이론
- Yu-kai Chou's Octalysis Framework
- Duolingo 게임화 전략
- Habitica 습관 형성 메커니즘

---

## 📞 다음 액션

### 즉시 시작 가능한 작업
1. **Supabase 프로젝트 생성** (5분)
2. **히라가나 학습 데이터 준비** (japanese-expert 활용)
3. **데이터베이스 스키마 구현** (backend-architect 활용)
4. **플래시카드 컴포넌트 개발** (frontend-architect 활용)

### 추천 시작 순서
```
1. Supabase 프로젝트 설정
   ↓
2. 히라가나 학습 데이터 생성 (/japanese-expert)
   ↓
3. 데이터베이스 테이블 생성
   ↓
4. 플래시카드 UI 구현
   ↓
5. SRS 알고리즘 구현 (/srs-expert)
```

---

**작성일**: 2025-10-19
**버전**: 1.0.0
**상태**: 기획 완료, 개발 준비 완료

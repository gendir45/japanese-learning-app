# 플래시카드 컴포넌트 구현 가이드

## 📋 개요

일본어 학습 앱의 플래시카드 시스템 설계 및 구현 완료.

**작성일**: 2025-10-20
**상태**: 설계 완료, 구현 준비 완료

---

## 🎯 구현된 기능

### 1. 핵심 컴포넌트

#### ✅ Flashcard (단일 카드)
- 3D 플립 애니메이션 (CSS 기반)
- 학습 타입별 콘텐츠 렌더링
- 클릭/Space 키로 뒤집기
- 접근성 지원 (ARIA, 키보드)

#### ✅ FlashcardDeck (카드 세트 관리)
- 진행률 추적
- 카드 네비게이션
- 답변 기록
- 완료 감지 및 통계

#### ✅ AnswerButtons (SRS 평가)
- 4단계 평가 (Again/Hard/Good/Easy)
- 색상 코딩
- 키보드 단축키 (1-4)
- 호버/포커스 효과

#### ✅ ProgressBar (진행률)
- 시각적 진행률
- 퍼센트 표시
- 완료 애니메이션

#### ✅ CardContent (학습 타입별 렌더러)
- **HiraganaCard**: 히라가나/가타카나 전용
- **VocabularyCard**: 단어 전용
- **KanjiCard**: 한자 전용 (부수, 획수, 음독/훈독)
- **GrammarCard**: 문법 전용 (패턴, 설명, 예문)

---

## 🎨 디자인 원칙

### 1. 반응형 디자인
- 모바일 우선 (Mobile-first)
- 태블릿 최적화
- 데스크톱 대화면 지원

### 2. 접근성 (WCAG 2.1 AA)
- 키보드 네비게이션 완벽 지원
- ARIA 레이블 및 역할
- 포커스 관리
- 스크린 리더 호환

### 3. 사용자 경험
- 부드러운 애니메이션 (400ms 플립)
- 즉각적인 피드백
- 직관적인 키보드 단축키
- 시각적 힌트 제공

---

## ⌨️ 키보드 단축키

| 키 | 기능 |
|---|---|
| `Space` | 카드 뒤집기 |
| `1` | Again (완전히 틀림) |
| `2` | Hard (어려웠음) |
| `3` | Good (괜찮음) |
| `4` | Easy (쉬웠음) |
| `←` | 이전 카드 |
| `→` | 다음 카드 |
| `Esc` | 학습 종료 |

---

## 🔧 사용 방법

### 기본 사용 예시

```tsx
'use client';

import { FlashcardDeck } from '@/components/flashcard';
import { LearningItem } from '@/components/flashcard/types';

export default function StudyPage() {
  // 학습 항목 데이터 (API 또는 Supabase에서 가져오기)
  const learningItems: LearningItem[] = [
    {
      id: '1',
      type: 'hiragana',
      jlptLevel: 'N5',
      content: 'あ',
      reading: 'a',
      meaning: '아',
      exampleSentence: 'あさ',
      exampleReading: 'asa',
      exampleMeaning: '아침',
    },
    {
      id: '2',
      type: 'vocabulary',
      jlptLevel: 'N5',
      content: '水',
      reading: 'みず',
      meaning: '물',
      category: '음식',
      exampleSentence: '水を飲みます',
      exampleReading: 'みずをのみます',
      exampleMeaning: '물을 마십니다',
    },
  ];

  // 답변 처리 (SRS 업데이트)
  const handleAnswer = async (itemId: string, quality: number) => {
    // TODO: Supabase user_progress 업데이트
    console.log(`카드 ${itemId}에 대한 답변: ${quality}`);

    // SRS 알고리즘 호출
    // await updateUserProgress(itemId, quality);
  };

  // 학습 완료
  const handleComplete = () => {
    console.log('학습 완료!');
    // TODO: 통계 업데이트, 배지 확인 등
  };

  // 종료
  const handleExit = () => {
    router.push('/dashboard');
  };

  return (
    <FlashcardDeck
      items={learningItems}
      onAnswer={handleAnswer}
      onComplete={handleComplete}
      onExit={handleExit}
    />
  );
}
```

### 단일 카드 사용 (커스텀 구현)

```tsx
import { Flashcard, useFlashcard } from '@/components/flashcard';

export default function CustomCard() {
  const { isFlipped, flip } = useFlashcard();

  const item = {
    id: '1',
    type: 'hiragana',
    jlptLevel: 'N5',
    content: 'あ',
    meaning: '아',
  };

  return (
    <Flashcard
      item={item}
      isFlipped={isFlipped}
      onFlip={flip}
    />
  );
}
```

---

## 📊 데이터 구조

### LearningItem 인터페이스

```typescript
interface LearningItem {
  id: string;
  type: 'hiragana' | 'katakana' | 'vocabulary' | 'grammar' | 'kanji';
  jlptLevel: 'N5' | 'N4' | 'N3' | 'N2' | 'N1';
  content: string;              // 일본어 원문
  reading?: string;             // 히라가나 읽기
  meaning: string;              // 한국어 뜻
  exampleSentence?: string;     // 예문
  exampleReading?: string;      // 예문 읽기
  exampleMeaning?: string;      // 예문 뜻
  category?: string;            // 카테고리
  orderIndex?: number;          // 학습 순서
}
```

### 한자 확장 타입

```typescript
interface KanjiItem extends LearningItem {
  type: 'kanji';
  radical?: string;             // 부수
  radicalMeaning?: string;      // 부수 뜻
  strokeCount?: number;         // 획수
  onyomi?: string[];            // 음독
  kunyomi?: string[];           // 훈독
  examples?: Array<{
    word: string;
    reading: string;
    meaning: string;
  }>;
}
```

### 문법 확장 타입

```typescript
interface GrammarItem extends LearningItem {
  type: 'grammar';
  pattern: string;              // 문법 패턴
  explanation: string;          // 문법 설명
  examples: Array<{
    sentence: string;
    reading: string;
    meaning: string;
  }>;
  notes?: string;
}
```

---

## 🎨 애니메이션 전략

### CSS Transitions (선택됨)

**장점**:
- 성능 우수 (GPU 가속)
- 번들 크기 0KB
- 구현 간단
- 브라우저 호환성 우수

**단점**:
- 복잡한 애니메이션 제한적
- 순서 제어 제한

### Framer Motion (고려됨)

**장점**:
- 강력한 애니메이션 제어
- 제스처 지원
- 순서 애니메이션 쉬움

**단점**:
- 번들 크기 증가 (~60KB)
- 성능 오버헤드
- 의존성 추가

**결론**: CSS Transitions로 충분 (현재 요구사항 기준)

---

## ♿ 접근성 구현

### 1. 키보드 네비게이션
- ✅ Tab으로 모든 인터랙티브 요소 접근
- ✅ Enter/Space로 버튼 활성화
- ✅ 화살표로 카드 이동
- ✅ Esc로 종료

### 2. ARIA 지원
```tsx
<div
  role="button"
  tabIndex={0}
  aria-label="카드 뒤집기"
  aria-pressed={isFlipped}
>
```

### 3. 포커스 관리
- 커스텀 포커스 링 (파란색 2px)
- 포커스 순서 논리적
- 포커스 트랩 (모달에서)

### 4. 스크린 리더
- 의미 있는 ARIA 레이블
- `lang="ja"` 속성으로 일본어 마크업
- 상태 변화 알림

---

## 🚀 성능 최적화

### 1. 컴포넌트 최적화
- `React.memo` 사용 (불필요한 리렌더링 방지)
- `useCallback` 으로 함수 메모이제이션
- `useMemo` 로 계산 결과 캐싱

### 2. 카드 프리로딩
```typescript
// 다음 3개 카드 미리 렌더링 (오프스크린)
const preloadCards = items.slice(currentIndex + 1, currentIndex + 4);
```

### 3. 이미지 최적화 (향후)
- Next.js Image 컴포넌트 사용
- WebP 포맷
- Lazy loading

### 4. 번들 최적화
- CSS Transitions (Framer Motion 대신)
- 트리 쉐이킹
- 코드 스플리팅

---

## 📁 파일 구조

```
src/components/flashcard/
├── index.ts                      # 배럴 내보내기
├── types.ts                      # TypeScript 타입 정의
├── Flashcard.tsx                 # 단일 카드 UI
├── FlashcardDeck.tsx             # 덱 컨테이너
├── AnswerButtons.tsx             # SRS 평가 버튼
├── ProgressBar.tsx               # 진행률 표시
├── CardContent/                  # 학습 타입별 렌더러
│   ├── index.ts
│   ├── HiraganaCard.tsx
│   ├── VocabularyCard.tsx
│   ├── KanjiCard.tsx
│   └── GrammarCard.tsx
└── hooks/                        # 커스텀 훅
    ├── index.ts
    ├── useFlashcard.ts           # 플립 상태
    ├── useDeck.ts                # 덱 관리
    └── useKeyboardShortcuts.ts   # 키보드 단축키
```

---

## ✅ 다음 단계

### 1. 데이터베이스 연동
```typescript
// Supabase에서 학습 항목 가져오기
const { data: items } = await supabase
  .from('learning_items')
  .select('*')
  .eq('type', 'hiragana')
  .order('order_index');
```

### 2. SRS 알고리즘 구현
```typescript
// user_progress 업데이트
const nextReview = calculateNextReview(quality, currentProgress);
await supabase
  .from('user_progress')
  .update({
    ease_factor: nextReview.easeFactor,
    interval: nextReview.interval,
    next_review_at: nextReview.nextReviewDate,
  })
  .eq('item_id', itemId);
```

### 3. 학습 세션 기록
```typescript
// study_sessions 저장
await supabase
  .from('study_sessions')
  .insert({
    user_id: userId,
    session_date: new Date(),
    items_studied: totalItems,
    items_correct: correctCount,
    xp_earned: calculateXP(answers),
  });
```

### 4. 테스트 작성
- 단위 테스트 (Jest + React Testing Library)
- E2E 테스트 (Playwright)
- 접근성 테스트 (axe-core)

---

## 🎯 베스트 프랙티스

### 1. 타입 안전성
- 모든 Props에 TypeScript 인터페이스
- 타입 가드 사용 (`isKanjiItem`, `isGrammarItem`)
- 제네릭 타입 활용

### 2. 컴포넌트 분리
- 단일 책임 원칙
- 재사용 가능한 작은 컴포넌트
- Props Drilling 최소화

### 3. 상태 관리
- 로컬 상태 우선 (useState)
- 필요시 Context API
- 서버 상태는 Supabase

### 4. 에러 처리
- Try-catch 블록
- 에러 바운더리
- 사용자 친화적 메시지

### 5. 코드 문서화
- JSDoc 주석
- 사용 예시 제공
- README 작성

---

## 📚 참고 자료

### 설계 원칙
- [Material Design - Cards](https://material.io/components/cards)
- [Anki Manual - Card Types](https://docs.ankiweb.net/)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

### 애니메이션
- [CSS Tricks - Flip Card](https://css-tricks.com/snippets/css/flip-an-element/)
- [MDN - CSS Transforms](https://developer.mozilla.org/en-US/docs/Web/CSS/transform)

### 접근성
- [A11y Project](https://www.a11yproject.com/)
- [WebAIM](https://webaim.org/)

---

## 🔍 FAQ

### Q: 왜 Framer Motion 대신 CSS Transitions?
A: 현재 요구사항에는 CSS로 충분하고, 번들 크기를 최소화하기 위해.

### Q: 카드 프리로딩은 어떻게?
A: 현재 인덱스 + 1~3까지 오프스크린 렌더링 계획.

### Q: 모바일 제스처 지원?
A: Phase 2에서 Swipe 제스처 추가 예정.

### Q: SRS 알고리즘은 어디에?
A: `src/lib/srs/` 디렉토리에 별도 구현 예정.

---

**작성자**: Claude (Frontend Architect Persona)
**마지막 업데이트**: 2025-10-20

# SRS 알고리즘 사용 가이드

## 개요

이 문서는 일본어 학습 애플리케이션에 구현된 SRS (Spaced Repetition System) 알고리즘의 사용 방법을 설명합니다.

## 알고리즘 특징

### SM-2 기반

- **원본**: SuperMemo SM-2 알고리즘
- **조정**: 4단계 답변 품질 시스템 (0-3)
- **목적**: 최적의 복습 시점을 계산하여 장기 기억 형성

### 답변 품질 (AnswerQuality)

```typescript
type AnswerQuality = 0 | 1 | 2 | 3;

// 0 = Again (완전히 틀림)
// 1 = Hard (어려움)
// 2 = Good (보통)
// 3 = Easy (쉬움)
```

### 주요 파라미터

1. **Ease Factor (난이도 계수)**
   - 범위: 1.3 ~ 3.5
   - 기본값: 2.5
   - 역할: 복습 간격 증가율 결정

2. **Interval (복습 간격)**
   - 단위: 일
   - 범위: 0 ~ 무제한
   - 역할: 다음 복습까지의 기간

3. **Repetitions (연속 성공 횟수)**
   - 범위: 0 ~ 무제한
   - 역할: 학습 진도 추적

## 기본 사용법

### 1. 새 카드 초기화

```typescript
import { initializeCard } from '@/lib/srs/algorithm';

const newCard = initializeCard();
console.log(newCard);
// {
//   easeFactor: 2.5,
//   interval: 0,
//   repetitions: 0,
//   lastReviewDate: Date,
//   nextReviewDate: Date,
//   totalReviews: 0,
//   correctReviews: 0,
// }
```

### 2. 복습 결과 처리

```typescript
import { calculateNextReview, type SRSData } from '@/lib/srs/algorithm';
import type { AnswerQuality } from '@/components/flashcard/types';

// 현재 카드 상태
const currentCard: SRSData = {
  easeFactor: 2.5,
  interval: 6,
  repetitions: 2,
  lastReviewDate: new Date('2025-01-01'),
  nextReviewDate: new Date('2025-01-07'),
  totalReviews: 5,
  correctReviews: 4,
};

// 사용자가 "Good" 답변
const quality: AnswerQuality = 2;

// 다음 복습 일정 계산
const result = calculateNextReview(quality, currentCard);
console.log(result);
// {
//   nextReviewDate: Date (2025-01-22),
//   interval: 15,
//   easeFactor: 2.5,
//   repetitions: 3,
//   reviewCount: 6,
// }
```

### 3. 카드 상태 업데이트

```typescript
// 결과를 카드 상태에 반영
const updatedCard: SRSData = {
  ...currentCard,
  easeFactor: result.easeFactor,
  interval: result.interval,
  repetitions: result.repetitions,
  lastReviewDate: new Date(),
  nextReviewDate: result.nextReviewDate,
  totalReviews: result.reviewCount,
  // Good 이상이면 정답 횟수 증가
  correctReviews: quality >= 2
    ? currentCard.correctReviews + 1
    : currentCard.correctReviews,
};
```

## 고급 사용법

### 복습 여부 확인

```typescript
import { isDue, daysUntilDue } from '@/lib/srs/algorithm';

const card = /* ... */;

// 복습할 시기인가?
if (isDue(card.nextReviewDate)) {
  console.log('복습이 필요합니다!');
}

// 몇 일 남았는가?
const days = daysUntilDue(card.nextReviewDate);
if (days > 0) {
  console.log(`${days}일 후 복습 예정`);
} else if (days < 0) {
  console.log(`${Math.abs(days)}일 지연됨`);
} else {
  console.log('오늘 복습 예정');
}
```

### 정답률 계산

```typescript
import { calculateAccuracy } from '@/lib/srs/algorithm';

const card = /* ... */;
const accuracy = calculateAccuracy(card.correctReviews, card.totalReviews);

console.log(`정답률: ${(accuracy * 100).toFixed(1)}%`);
```

### 학습 상태 판단

```typescript
import { getProgressStatus } from '@/lib/srs/algorithm';

const card = /* ... */;
const status = getProgressStatus(card.repetitions, card.totalReviews);

switch (status) {
  case 'new':
    console.log('새 카드');
    break;
  case 'learning':
    console.log('학습 중');
    break;
  case 'reviewing':
    console.log('복습 중');
    break;
  case 'mastered':
    console.log('마스터');
    break;
}
```

## useDeck Hook과 통합

### 기존 Hook 확장

```typescript
// src/components/flashcard/hooks/useDeck.ts
import { calculateNextReview, initializeCard, type SRSData } from '@/lib/srs/algorithm';

export function useDeck(items: AnyLearningItem[]) {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [answers, setAnswers] = useState<Map<string, AnswerQuality>>(new Map());

  // SRS 데이터 관리 추가
  const [srsDataMap, setSrsDataMap] = useState<Map<string, SRSData>>(new Map());

  const recordAnswer = useCallback((itemId: string, quality: AnswerQuality) => {
    setAnswers((prev) => {
      const newAnswers = new Map(prev);
      newAnswers.set(itemId, quality);
      return newAnswers;
    });

    // SRS 계산 추가
    setSrsDataMap((prev) => {
      const newMap = new Map(prev);
      const currentData = prev.get(itemId) || initializeCard();
      const result = calculateNextReview(quality, currentData);

      newMap.set(itemId, {
        ...currentData,
        easeFactor: result.easeFactor,
        interval: result.interval,
        repetitions: result.repetitions,
        lastReviewDate: new Date(),
        nextReviewDate: result.nextReviewDate,
        totalReviews: result.reviewCount,
        correctReviews: quality >= 2
          ? currentData.correctReviews + 1
          : currentData.correctReviews,
      });

      return newMap;
    });
  }, []);

  return {
    // ... 기존 반환값
    srsDataMap, // SRS 데이터 추가
  };
}
```

## 실전 시나리오

### 시나리오 1: 완벽한 학습

```typescript
let card = initializeCard();

// 1회차: Good 답변
let result = calculateNextReview(2, card);
console.log(`1회: ${result.interval}일 후 복습`); // 1일

// 2회차: Good 답변
card = { ...card, interval: result.interval, repetitions: result.repetitions };
result = calculateNextReview(2, card);
console.log(`2회: ${result.interval}일 후 복습`); // 6일

// 3회차: Good 답변
card = { ...card, interval: result.interval, repetitions: result.repetitions };
result = calculateNextReview(2, card);
console.log(`3회: ${result.interval}일 후 복습`); // 15일

// 4회차: Easy 답변 (쉬움)
card = { ...card, interval: result.interval, repetitions: result.repetitions };
result = calculateNextReview(3, card);
console.log(`4회: ${result.interval}일 후 복습`); // 51일
```

### 시나리오 2: 실패 후 회복

```typescript
let card = initializeCard();

// 1~2회차: 성공적으로 학습
result = calculateNextReview(2, card);
card = { ...card, interval: result.interval, repetitions: result.repetitions };
result = calculateNextReview(2, card);
card = { ...card, interval: result.interval, repetitions: result.repetitions };

// 3회차: 실패 (Again)
result = calculateNextReview(0, card);
console.log(`실패: ${result.interval}일 후 복습`); // 0일 (즉시 다시)
console.log(`Repetitions: ${result.repetitions}`); // 0 (리셋)

// 다시 학습 시작
card = { ...card, interval: result.interval, repetitions: result.repetitions };
result = calculateNextReview(2, card);
console.log(`재학습 1회: ${result.interval}일 후 복습`); // 1일
```

### 시나리오 3: 어려운 카드

```typescript
let card = initializeCard();

// Hard 답변 연속
for (let i = 0; i < 5; i++) {
  result = calculateNextReview(1, card); // Hard
  card = {
    ...card,
    interval: result.interval,
    repetitions: result.repetitions,
    easeFactor: result.easeFactor,
  };
}

console.log(`Ease Factor: ${card.easeFactor}`); // 1.75 (감소)
console.log(`Repetitions: ${card.repetitions}`); // 0 (Hard는 증가 안 함)
```

## 데이터베이스 통합

### UserProgress 타입과 변환

```typescript
import { toUserProgress } from '@/lib/srs/algorithm';

const srsData: SRSData = /* ... */;
const userId = 'user-123';
const itemId = 'item-456';

// UserProgress 형식으로 변환
const progressData = toUserProgress(srsData, userId, itemId);

// Supabase에 저장
await supabase
  .from('user_progress')
  .upsert(progressData);
```

### 데이터 로드 및 적용

```typescript
// Supabase에서 로드
const { data } = await supabase
  .from('user_progress')
  .select('*')
  .eq('user_id', userId)
  .eq('item_id', itemId)
  .single();

if (data) {
  // SRSData 형식으로 변환
  const srsData: SRSData = {
    easeFactor: data.ease_factor,
    interval: data.interval,
    repetitions: data.repetitions,
    lastReviewDate: new Date(data.last_reviewed_at),
    nextReviewDate: new Date(data.next_review_at),
    totalReviews: data.total_reviews,
    correctReviews: data.correct_reviews,
  };

  // 알고리즘 적용
  const result = calculateNextReview(quality, srsData);
}
```

## 알고리즘 동작 원리

### 간격 계산 로직

```
Again (0):
  interval = 0 (즉시 다시)
  repetitions = 0 (리셋)

Hard (1):
  repetitions = 0: interval = 1
  repetitions > 0: interval = currentInterval * 1.2

Good (2):
  repetitions = 0: interval = 1
  repetitions = 1: interval = 6
  repetitions >= 2: interval = currentInterval * easeFactor

Easy (3):
  Good 간격 * 1.3
```

### Ease Factor 조정

```
Again (0): EF - 0.2
Hard (1): EF - 0.15
Good (2): EF (유지)
Easy (3): EF + 0.15

최소: 1.3
최대: 3.5
```

## 테스트

```bash
# 테스트 실행
npm test src/lib/srs/algorithm.test.ts

# 특정 테스트만 실행
npm test src/lib/srs/algorithm.test.ts -- -t "calculateNextReview"
```

## 참고 자료

- [SuperMemo SM-2 Algorithm](https://www.supermemo.com/en/archives1990-2015/english/ol/sm2)
- [Anki SRS System](https://docs.ankiweb.net/studying.html)
- [간격 반복 학습 (위키백과)](https://ko.wikipedia.org/wiki/간격_반복)

## 문제 해결

### Q: Ease Factor가 너무 낮아지는 경우

A: 최소값 1.3이 보장됩니다. 만약 사용자가 지속적으로 어려워한다면, 학습 단계를 재조정하거나 더 쉬운 단계의 콘텐츠를 제공하는 것이 좋습니다.

### Q: 간격이 너무 길어지는 경우

A: Easy Factor의 최대값을 3.5로 제한했습니다. 필요하다면 `MAX_EASE_FACTOR` 상수를 조정할 수 있습니다.

### Q: Hard 답변 시 repetitions가 증가하지 않는 이유

A: Hard는 "정답이지만 어려웠음"을 의미합니다. 연속 성공으로 간주하지 않아 repetitions를 유지합니다. 이는 학습자가 충분히 숙달하지 못했음을 반영합니다.

## 향후 개선 방안

1. **Fuzz 기능**: 같은 날 여러 카드 복습 시 시간 분산
2. **Lapse 관리**: 실패 횟수 추적 및 별도 처리
3. **Graduating Interval**: 학습 단계에서 복습 단계로 전환 시 간격 조정
4. **Maximum Interval**: 최대 간격 제한 옵션
5. **Load Balancing**: 하루에 복습할 카드 수 분산

## 라이선스

MIT License

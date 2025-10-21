# SRS 알고리즘 구현 요약

## 구현 완료 항목

### 1. 핵심 알고리즘 (`src/lib/srs/algorithm.ts`)

#### 타입 정의
- `SRSData`: SRS 카드 데이터 구조
- `SRSResult`: SRS 계산 결과 구조

#### 핵심 함수
- `initializeCard()`: 새 카드 초기화
- `calculateNextReview()`: 메인 SRS 알고리즘
- `updateEaseFactor()`: 난이도 계수 업데이트
- `calculateInterval()`: 복습 간격 계산
- `calculateNextReviewDate()`: 다음 복습 날짜 계산

#### 유틸리티 함수
- `isDue()`: 복습 여부 확인
- `daysUntilDue()`: 남은 일수 계산
- `calculateAccuracy()`: 정답률 계산
- `getProgressStatus()`: 학습 상태 판단
- `toUserProgress()`: UserProgress 형식 변환

### 2. 테스트 코드 (`src/lib/srs/algorithm.test.ts`)

#### 단위 테스트
- `initializeCard`: 초기화 테스트
- `updateEaseFactor`: 난이도 계수 업데이트 테스트 (4개 답변 레벨)
- `calculateInterval`: 간격 계산 테스트 (다양한 시나리오)
- `calculateNextReview`: 메인 알고리즘 테스트
- 유틸리티 함수 테스트

#### 통합 테스트
- 완벽한 학습자 시나리오
- 어려움을 겪는 학습자 시나리오
- 실패 후 회복 시나리오
- 마스터 학습자 시나리오

### 3. 문서화

#### 사용 가이드 (`claudedocs/srs-algorithm-guide.md`)
- 알고리즘 개요 및 특징
- 기본 사용법 (초기화, 복습 처리, 상태 업데이트)
- 고급 사용법 (복습 여부, 정답률, 상태 판단)
- useDeck Hook 통합 방법
- 실전 시나리오 (3가지)
- 데이터베이스 통합 방법
- 알고리즘 동작 원리
- 문제 해결 FAQ
- 향후 개선 방안

#### 예제 코드 (`src/lib/srs/example.ts`)
- 6가지 사용 예제
- 타입 체크 통과
- 주석 포함

## 알고리즘 특징

### SM-2 기반 조정

**원본 SM-2**: 답변 품질 0-5 (6단계)
**우리 시스템**: 답변 품질 0-3 (4단계)

```
0 = Again (완전히 틀림)
1 = Hard (어려움)
2 = Good (보통)
3 = Easy (쉬움)
```

### 주요 파라미터

| 파라미터 | 범위 | 기본값 | 설명 |
|---------|------|--------|------|
| Ease Factor | 1.3-3.5 | 2.5 | 복습 간격 증가율 |
| Interval | 0-무제한 | 0 | 복습 간격 (일) |
| Repetitions | 0-무제한 | 0 | 연속 성공 횟수 |

### Ease Factor 조정값

| 답변 | 조정값 | 설명 |
|------|--------|------|
| Again (0) | -0.2 | 많이 감소 |
| Hard (1) | -0.15 | 약간 감소 |
| Good (2) | 0 | 유지 |
| Easy (3) | +0.15 | 증가 |

### 간격 계산 로직

```typescript
Again (0):
  interval = 0
  repetitions = 0 (리셋)

Hard (1):
  repetitions = 0: interval = 1
  repetitions > 0: interval = currentInterval * 1.2

Good (2):
  repetitions = 0: interval = 1
  repetitions = 1: interval = 6
  repetitions >= 2: interval = currentInterval * easeFactor

Easy (3):
  Good 계산 * 1.3
```

## 기존 코드와 호환성

### 1. 타입 호환
- `AnswerQuality` 타입 사용 (`src/components/flashcard/types.ts`)
- `UserProgress` 인터페이스와 호환 가능

### 2. Hook 통합 가능
- `useDeck` hook (`src/components/flashcard/hooks/useDeck.ts`)에 쉽게 통합 가능
- 기존 `recordAnswer` 함수 확장

## 사용 예시

### 기본 흐름

```typescript
import { initializeCard, calculateNextReview } from '@/lib/srs/algorithm';

// 1. 새 카드 생성
let card = initializeCard();

// 2. 복습 결과 처리 (Good 답변)
const result = calculateNextReview(2, card);

// 3. 카드 상태 업데이트
card = {
  ...card,
  easeFactor: result.easeFactor,
  interval: result.interval,
  repetitions: result.repetitions,
  lastReviewDate: new Date(),
  nextReviewDate: result.nextReviewDate,
  totalReviews: result.reviewCount,
  correctReviews: card.correctReviews + 1,
};
```

### 학습 진도 예시

| 회차 | 답변 | 간격 | Repetitions | Ease Factor |
|------|------|------|-------------|-------------|
| 1 | Good | 1일 | 1 | 2.5 |
| 2 | Good | 6일 | 2 | 2.5 |
| 3 | Good | 15일 | 3 | 2.5 |
| 4 | Easy | 51일 | 4 | 2.65 |
| 5 | Again | 0일 | 0 | 2.45 |

## 테스트 결과

### 커버리지
- 단위 테스트: 모든 핵심 함수
- 통합 테스트: 4가지 학습 시나리오
- 경계값 테스트: 최소/최대 Ease Factor

### 테스트 실행
```bash
npm test src/lib/srs/algorithm.test.ts
```

## 다음 단계

### 즉시 구현 가능
1. **useDeck Hook 통합**
   - `recordAnswer` 함수에 SRS 로직 추가
   - 상태 관리 확장

2. **데이터베이스 연동**
   - Supabase에 복습 데이터 저장
   - `toUserProgress` 함수 활용

3. **복습 스케줄 페이지**
   - `isDue` 함수로 복습할 카드 필터링
   - 복습 목록 UI 구현

### 향후 개선
1. **Fuzz 기능**: 복습 시간 분산
2. **Lapse 관리**: 실패 횟수 추적
3. **Load Balancing**: 하루 복습 카드 수 조정
4. **Maximum Interval**: 최대 간격 제한 옵션

## 파일 구조

```
src/lib/srs/
├── algorithm.ts          # 핵심 알고리즘 구현
├── algorithm.test.ts     # 테스트 코드
└── example.ts            # 사용 예제

claudedocs/
├── srs-algorithm-guide.md           # 상세 사용 가이드
└── srs-implementation-summary.md    # 구현 요약 (이 파일)
```

## 참고 자료

- SuperMemo SM-2 알고리즘: https://www.supermemo.com/en/archives1990-2015/english/ol/sm2
- 간격 반복 학습 (위키백과): https://ko.wikipedia.org/wiki/간격_반복
- Anki 문서: https://docs.ankiweb.net/studying.html

## 라이선스

MIT License

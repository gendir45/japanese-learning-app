/**
 * SRS (Spaced Repetition System) 알고리즘 구현
 * SM-2 (SuperMemo 2) 알고리즘 기반
 */

/**
 * SRS 알고리즘 설정
 */
export const SRS_CONFIG = {
  // 기본 파라미터
  startingEaseFactor: 2.5,
  minimumEaseFactor: 1.3,
  maximumEaseFactor: 2.5,

  // 간격 설정
  minimumInterval: 1,
  maximumInterval: 365,
  graduatingInterval: 1,
  easyInterval: 4,

  // 실패 처리
  lapseMultiplier: 0.5,

  // 타입별 복습 빈도 조정
  typeMultipliers: {
    hiragana: 1.0,    // 기본
    katakana: 1.0,    // 기본
    vocabulary: 1.0,  // 기본
    kanji: 0.7,       // 30% 더 자주 복습
    grammar: 0.85,    // 15% 더 자주 복습
  } as const,

  // 품질 점수 매핑 (0-3 → 0-5)
  qualityMapping: {
    0: 0, // 완전히 틀림 (다시 시작)
    1: 3, // 어려웠음 (간신히 기억)
    2: 4, // 보통 (약간 생각하고 정답)
    3: 5, // 쉬움 (즉시 정답)
  } as const,
} as const;

/**
 * 학습 항목 타입
 */
export type LearningItemType = keyof typeof SRS_CONFIG.typeMultipliers;

/**
 * 답변 품질 (플래시카드 인터페이스)
 * 0: 완전히 틀림
 * 1: 어려웠음
 * 2: 보통
 * 3: 쉬움
 */
export type AnswerQuality = 0 | 1 | 2 | 3;

/**
 * SRS 카드 상태
 */
export interface SRSCard {
  easeFactor: number;
  interval: number;
  repetitions: number;
  type: LearningItemType;
}

/**
 * SRS 계산 결과
 */
export interface SRSResult {
  easeFactor: number;
  interval: number;
  repetitions: number;
  nextReviewDate: Date;
  status: 'new' | 'learning' | 'reviewing' | 'mastered';
}

/**
 * SM-2 알고리즘 기반 다음 복습 간격 계산
 *
 * @param quality - 답변 품질 (0-3)
 * @param currentCard - 현재 카드 상태
 * @returns 업데이트된 SRS 파라미터
 */
export function calculateNextReview(
  quality: AnswerQuality,
  currentCard: SRSCard
): SRSResult {
  const { easeFactor, interval, repetitions, type } = currentCard;

  // Step 1: 품질 점수를 SM-2 형식(0-5)으로 변환
  const sm2Quality = SRS_CONFIG.qualityMapping[quality];

  // Step 2: 실패 처리 (quality < 3 in SM-2 scale, 즉 quality 0-1 in our scale)
  if (quality === 0) {
    // 완전히 틀림 - 처음부터 다시 시작
    return {
      easeFactor: Math.max(
        SRS_CONFIG.minimumEaseFactor,
        easeFactor - 0.2
      ),
      interval: SRS_CONFIG.minimumInterval,
      repetitions: 0,
      nextReviewDate: addDays(new Date(), SRS_CONFIG.minimumInterval),
      status: 'learning',
    };
  }

  if (quality === 1) {
    // 어려웠음 - 간격 줄이고 계속
    const newInterval = Math.max(
      SRS_CONFIG.minimumInterval,
      Math.round(interval * SRS_CONFIG.lapseMultiplier)
    );
    return {
      easeFactor: Math.max(
        SRS_CONFIG.minimumEaseFactor,
        easeFactor - 0.15
      ),
      interval: newInterval,
      repetitions: Math.max(0, repetitions - 1),
      nextReviewDate: addDays(new Date(), newInterval),
      status: 'learning',
    };
  }

  // Step 3: Ease Factor 업데이트 (quality 2-3)
  // SM-2 공식: EF' = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
  let newEF = easeFactor + (0.1 - (5 - sm2Quality) * (0.08 + (5 - sm2Quality) * 0.02));
  newEF = Math.max(
    SRS_CONFIG.minimumEaseFactor,
    Math.min(SRS_CONFIG.maximumEaseFactor, newEF)
  );

  // Step 4: 간격 계산
  let newInterval: number;
  const newRepetitions = repetitions + 1;

  if (newRepetitions === 1) {
    // 첫 번째 성공
    newInterval = quality === 3
      ? SRS_CONFIG.easyInterval
      : SRS_CONFIG.graduatingInterval;
  } else if (newRepetitions === 2) {
    // 두 번째 성공
    newInterval = 6;
  } else {
    // 세 번째 이상: interval * ease_factor
    newInterval = Math.round(interval * newEF);
  }

  // Step 5: 타입별 간격 조정
  const typeMultiplier = SRS_CONFIG.typeMultipliers[type] || 1.0;
  newInterval = Math.round(newInterval / typeMultiplier);

  // Step 6: 간격 범위 제한
  newInterval = Math.max(
    SRS_CONFIG.minimumInterval,
    Math.min(SRS_CONFIG.maximumInterval, newInterval)
  );

  // Step 7: 상태 결정
  const status = determineStatus(newRepetitions, newInterval);

  return {
    easeFactor: newEF,
    interval: newInterval,
    repetitions: newRepetitions,
    nextReviewDate: addDays(new Date(), newInterval),
    status,
  };
}

/**
 * 학습 상태 결정
 */
function determineStatus(
  repetitions: number,
  interval: number
): 'new' | 'learning' | 'reviewing' | 'mastered' {
  if (repetitions === 0) return 'new';
  if (repetitions < 3) return 'learning';
  if (interval >= 21) return 'mastered'; // 3주 이상 간격
  return 'reviewing';
}

/**
 * 날짜에 일수 추가
 */
function addDays(date: Date, days: number): Date {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

/**
 * 복습 우선순위 계산
 * 반환값이 작을수록 우선순위가 높음
 */
export function calculateReviewPriority(
  nextReviewAt: Date,
  easeFactor: number
): number {
  const now = new Date();
  const dueDate = new Date(nextReviewAt);

  // 기한이 지난 정도 (일 단위)
  const overdueDays = Math.max(
    0,
    Math.floor((now.getTime() - dueDate.getTime()) / (1000 * 60 * 60 * 24))
  );

  // 우선순위 = 기한 지난 일수 - ease_factor 보정
  // 어려운 카드(낮은 EF)가 우선
  return -(overdueDays * 10 + (3 - easeFactor) * 5);
}

/**
 * XP 계산 헬퍼 함수
 */
export function calculateXP(quality: AnswerQuality, isNewItem: boolean): number {
  const baseXP = isNewItem ? 10 : 5;
  const qualityBonus = quality * 2;
  return baseXP + qualityBonus;
}

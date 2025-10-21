// XP (경험치) 시스템
// 학습 활동에 따라 XP를 계산하고 보상을 제공합니다

/**
 * XP 보상 규칙
 */
export const XP_REWARDS = {
  // 기본 학습
  newCardLearned: 10,      // 새 카드 학습
  reviewCorrect: 5,        // 복습 정답
  reviewPerfect: 8,        // 완벽한 정답 (빠르고 정확)

  // 보너스
  dailyGoalComplete: 50,   // 일일 목표 달성

  // 스트릭 보너스
  streak3Days: 50,         // 3일 연속
  streak7Days: 150,        // 7일 연속
  streak30Days: 1000,      // 30일 연속
  streak100Days: 5000,     // 100일 연속
} as const;

/**
 * 학습 활동 타입
 */
export type StudyActivityType =
  | 'newCardLearned'
  | 'reviewCorrect'
  | 'reviewPerfect';

/**
 * 학습 활동에 대한 XP 계산
 * @param activityType 활동 타입
 * @param multiplier XP 배수 (기본 1.0)
 * @returns 획득 XP
 */
export function calculateXP(
  activityType: StudyActivityType,
  multiplier: number = 1.0
): number {
  const baseXP = XP_REWARDS[activityType];
  return Math.floor(baseXP * multiplier);
}

/**
 * 정답 속도에 따른 XP 계산
 * @param isCorrect 정답 여부
 * @param responseTime 응답 시간 (밀리초)
 * @param isNewCard 새 카드 여부
 * @returns 획득 XP
 */
export function calculateResponseXP(
  isCorrect: boolean,
  responseTime: number,
  isNewCard: boolean
): number {
  if (!isCorrect) return 0;

  // 새 카드
  if (isNewCard) {
    return XP_REWARDS.newCardLearned;
  }

  // 복습 카드 - 속도에 따라 차등 지급
  // 3초 이내: 완벽한 정답
  if (responseTime < 3000) {
    return XP_REWARDS.reviewPerfect;
  }

  // 3초 이상: 일반 정답
  return XP_REWARDS.reviewCorrect;
}

/**
 * 일일 목표 달성 XP
 * @param cardsStudied 학습한 카드 수
 * @param dailyGoal 일일 목표 (기본 20개)
 * @returns 보너스 XP
 */
export function calculateDailyGoalXP(
  cardsStudied: number,
  dailyGoal: number = 20
): number {
  return cardsStudied >= dailyGoal ? XP_REWARDS.dailyGoalComplete : 0;
}

/**
 * 스트릭 보너스 XP 계산
 * @param streak 현재 스트릭 일수
 * @returns 보너스 XP
 */
export function calculateStreakBonusXP(streak: number): number {
  if (streak >= 100) return XP_REWARDS.streak100Days;
  if (streak >= 30) return XP_REWARDS.streak30Days;
  if (streak >= 7) return XP_REWARDS.streak7Days;
  if (streak >= 3) return XP_REWARDS.streak3Days;
  return 0;
}

// 스트릭 (연속 학습일) 시스템
// 매일 학습을 장려하고 연속 학습일에 따라 보상을 제공합니다

/**
 * 스트릭 보상 마일스톤
 */
export const STREAK_MILESTONES = {
  3: { xp: 50, message: '🔥 3일 연속!' },
  7: { xp: 150, message: '⚡ 주간 전사!' },
  30: { xp: 1000, message: '💎 월간 마스터!' },
  100: { xp: 5000, message: '🏆 레전드!' },
} as const;

/**
 * 두 날짜가 연속된 날인지 확인
 * @param date1 첫 번째 날짜
 * @param date2 두 번째 날짜
 * @returns 연속 여부
 */
export function isConsecutiveDay(date1: Date, date2: Date): boolean {
  const diff = Math.abs(date2.getTime() - date1.getTime());
  const daysDiff = Math.floor(diff / (1000 * 60 * 60 * 24));
  return daysDiff === 1;
}

/**
 * 오늘 학습했는지 확인
 * @param lastStudyDate 마지막 학습 날짜
 * @returns 오늘 학습 여부
 */
export function isStudiedToday(lastStudyDate: Date | null): boolean {
  if (!lastStudyDate) return false;

  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const lastStudy = new Date(lastStudyDate);
  lastStudy.setHours(0, 0, 0, 0);

  return today.getTime() === lastStudy.getTime();
}

/**
 * 스트릭 계산
 * @param lastStudyDate 마지막 학습 날짜
 * @param currentStreak 현재 스트릭
 * @returns 업데이트된 스트릭 정보
 */
export function calculateStreak(
  lastStudyDate: Date | null,
  currentStreak: number
): {
  newStreak: number;
  streakBroken: boolean;
  streakContinued: boolean;
} {
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  // 첫 학습
  if (!lastStudyDate) {
    return {
      newStreak: 1,
      streakBroken: false,
      streakContinued: false,
    };
  }

  const lastStudy = new Date(lastStudyDate);
  lastStudy.setHours(0, 0, 0, 0);

  // 오늘 이미 학습함
  if (today.getTime() === lastStudy.getTime()) {
    return {
      newStreak: currentStreak,
      streakBroken: false,
      streakContinued: false,
    };
  }

  // 어제 학습함 -> 스트릭 유지
  if (isConsecutiveDay(lastStudy, today)) {
    return {
      newStreak: currentStreak + 1,
      streakBroken: false,
      streakContinued: true,
    };
  }

  // 그 이전에 학습함 -> 스트릭 끊김
  return {
    newStreak: 1,
    streakBroken: true,
    streakContinued: false,
  };
}

/**
 * 스트릭 마일스톤 달성 확인
 * @param streak 현재 스트릭
 * @returns 마일스톤 정보 또는 null
 */
export function checkStreakMilestone(streak: number) {
  const milestones = Object.keys(STREAK_MILESTONES)
    .map(Number)
    .sort((a, b) => b - a); // 내림차순 정렬

  for (const milestone of milestones) {
    if (streak === milestone) {
      return {
        streak: milestone,
        ...STREAK_MILESTONES[milestone as keyof typeof STREAK_MILESTONES],
      };
    }
  }

  return null;
}

/**
 * 스트릭 아이콘 반환
 * @param streak 스트릭 일수
 * @returns 이모지 아이콘
 */
export function getStreakIcon(streak: number): string {
  if (streak >= 100) return '🏆';
  if (streak >= 30) return '💎';
  if (streak >= 7) return '⚡';
  if (streak >= 3) return '🔥';
  return '📅';
}

/**
 * 다음 마일스톤까지 남은 일수
 * @param currentStreak 현재 스트릭
 * @returns 다음 마일스톤과 남은 일수
 */
export function getNextMilestone(currentStreak: number) {
  const milestones = Object.keys(STREAK_MILESTONES)
    .map(Number)
    .sort((a, b) => a - b); // 오름차순 정렬

  for (const milestone of milestones) {
    if (currentStreak < milestone) {
      return {
        milestone,
        daysRemaining: milestone - currentStreak,
        reward: STREAK_MILESTONES[milestone as keyof typeof STREAK_MILESTONES],
      };
    }
  }

  return null; // 모든 마일스톤 달성
}

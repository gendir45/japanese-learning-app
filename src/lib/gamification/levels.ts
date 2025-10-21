// 레벨 시스템
// XP를 기반으로 사용자 레벨을 계산하고 관리합니다

/**
 * 레벨업에 필요한 XP 계산
 * 공식: 100 * (1.5 ^ (level - 1))
 * @param level 목표 레벨
 * @returns 해당 레벨에 필요한 총 XP
 */
export function getXPForLevel(level: number): number {
  if (level <= 1) return 0;
  return Math.floor(100 * Math.pow(1.5, level - 1));
}

/**
 * 특정 레벨까지 필요한 누적 XP 계산
 * @param level 목표 레벨
 * @returns 레벨 1부터 해당 레벨까지의 총 XP
 */
export function getTotalXPForLevel(level: number): number {
  let totalXP = 0;
  for (let i = 2; i <= level; i++) {
    totalXP += getXPForLevel(i);
  }
  return totalXP;
}

/**
 * 현재 XP로 레벨 계산
 * @param totalXP 총 획득 XP
 * @returns 현재 레벨
 */
export function calculateLevel(totalXP: number): number {
  let level = 1;
  let accumulatedXP = 0;

  while (true) {
    const nextLevelXP = getXPForLevel(level + 1);
    if (accumulatedXP + nextLevelXP > totalXP) {
      break;
    }
    accumulatedXP += nextLevelXP;
    level++;
  }

  return level;
}

/**
 * 현재 레벨에서의 진행률 계산
 * @param totalXP 총 획득 XP
 * @returns { level, currentXP, xpForNextLevel, progressPercent }
 */
export function getLevelProgress(totalXP: number) {
  const level = calculateLevel(totalXP);
  const xpForCurrentLevel = getTotalXPForLevel(level);
  const xpForNextLevel = getXPForLevel(level + 1);
  const currentXP = totalXP - xpForCurrentLevel;
  const progressPercent = (currentXP / xpForNextLevel) * 100;

  return {
    level,
    currentXP,
    xpForNextLevel,
    progressPercent: Math.min(100, Math.max(0, progressPercent)),
  };
}

/**
 * 레벨업 여부 확인
 * @param previousXP 이전 XP
 * @param newXP 새로운 XP
 * @returns 레벨업 여부와 새 레벨
 */
export function checkLevelUp(previousXP: number, newXP: number) {
  const previousLevel = calculateLevel(previousXP);
  const newLevel = calculateLevel(newXP);

  return {
    leveledUp: newLevel > previousLevel,
    previousLevel,
    newLevel,
    levelsGained: newLevel - previousLevel,
  };
}

/**
 * 레벨에 따른 타이틀 반환
 * @param level 레벨
 * @returns 타이틀 문자열
 */
export function getLevelTitle(level: number): string {
  if (level >= 50) return '일본어 마스터 🏆';
  if (level >= 40) return '일본어 전문가 💎';
  if (level >= 30) return '일본어 상급자 ⭐';
  if (level >= 20) return '일본어 중급자 🌟';
  if (level >= 10) return '일본어 초급자 ✨';
  if (level >= 5) return '일본어 학습자 📚';
  return '일본어 입문자 🌱';
}

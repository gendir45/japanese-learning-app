/**
 * 타임존 유틸리티
 * 한국 시간대(UTC+9)로 날짜 처리
 */

/**
 * 한국 시간대로 오늘 날짜 문자열 반환 (YYYY-MM-DD 형식)
 */
export function getKoreaToday(): string {
  const now = new Date();
  const koreaTime = new Date(now.getTime() + (9 * 60 * 60 * 1000));
  return koreaTime.toISOString().split('T')[0];
}

/**
 * 한국 시간대로 현재 날짜 객체 반환
 */
export function getKoreaNow(): Date {
  const now = new Date();
  return new Date(now.getTime() + (9 * 60 * 60 * 1000));
}

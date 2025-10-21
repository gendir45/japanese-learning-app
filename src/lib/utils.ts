import { type ClassValue, clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

/**
 * Tailwind CSS 클래스를 조건부로 병합하는 유틸리티 함수
 * clsx로 조건부 클래스를 처리하고, tailwind-merge로 중복을 제거합니다.
 *
 * @example
 * ```tsx
 * cn('px-2 py-1', isActive && 'bg-blue-500', 'hover:bg-blue-600')
 * ```
 */
export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

/**
 * 날짜를 한국어 형식으로 포맷합니다
 *
 * @param date - 포맷할 날짜
 * @returns 포맷된 날짜 문자열 (예: "2025년 10월 20일")
 */
export function formatDate(date: Date): string {
  return new Intl.DateTimeFormat('ko-KR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  }).format(date);
}

/**
 * 날짜를 상대적 시간으로 포맷합니다
 *
 * @param date - 포맷할 날짜
 * @returns 상대적 시간 문자열 (예: "3일 전", "방금 전")
 */
export function formatRelativeTime(date: Date): string {
  const now = new Date();
  const diffInSeconds = Math.floor((now.getTime() - date.getTime()) / 1000);

  if (diffInSeconds < 60) return '방금 전';
  if (diffInSeconds < 3600) return `${Math.floor(diffInSeconds / 60)}분 전`;
  if (diffInSeconds < 86400) return `${Math.floor(diffInSeconds / 3600)}시간 전`;
  if (diffInSeconds < 604800) return `${Math.floor(diffInSeconds / 86400)}일 전`;
  if (diffInSeconds < 2592000) return `${Math.floor(diffInSeconds / 604800)}주 전`;
  if (diffInSeconds < 31536000) return `${Math.floor(diffInSeconds / 2592000)}개월 전`;

  return `${Math.floor(diffInSeconds / 31536000)}년 전`;
}

/**
 * 숫자를 한국어 형식으로 포맷합니다
 *
 * @param num - 포맷할 숫자
 * @returns 포맷된 숫자 문자열 (예: "1,234")
 */
export function formatNumber(num: number): string {
  return new Intl.NumberFormat('ko-KR').format(num);
}

/**
 * 퍼센트를 포맷합니다
 *
 * @param value - 0-1 사이의 값
 * @param decimals - 소수점 자릿수 (기본: 0)
 * @returns 포맷된 퍼센트 문자열 (예: "75%")
 */
export function formatPercent(value: number, decimals: number = 0): string {
  return `${(value * 100).toFixed(decimals)}%`;
}

/**
 * 초를 분:초 형식으로 변환합니다
 *
 * @param seconds - 초
 * @returns 포맷된 시간 문자열 (예: "5:30")
 */
export function formatDuration(seconds: number): string {
  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  return `${mins}:${secs.toString().padStart(2, '0')}`;
}

/**
 * 배열을 무작위로 섞습니다 (Fisher-Yates shuffle)
 *
 * @param array - 섞을 배열
 * @returns 섞인 새 배열
 */
export function shuffle<T>(array: T[]): T[] {
  const newArray = [...array];
  for (let i = newArray.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [newArray[i], newArray[j]] = [newArray[j], newArray[i]];
  }
  return newArray;
}

/**
 * 지연 함수 (async/await 사용)
 *
 * @param ms - 지연 시간 (밀리초)
 */
export function delay(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

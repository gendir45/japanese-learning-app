'use client';

// 스트릭 카운터 컴포넌트
// 연속 학습일 수와 다음 마일스톤을 표시합니다

import { getStreakIcon, getNextMilestone } from '@/lib/gamification/streaks';

interface StreakCounterProps {
  currentStreak: number;
  longestStreak: number;
  className?: string;
}

export default function StreakCounter({
  currentStreak,
  longestStreak,
  className = '',
}: StreakCounterProps) {
  const icon = getStreakIcon(currentStreak);
  const nextMilestone = getNextMilestone(currentStreak);

  return (
    <div className={`bg-gradient-to-br from-orange-50 to-red-50 rounded-xl shadow-md p-6 ${className}`}>
      {/* 현재 스트릭 */}
      <div className="text-center mb-4">
        <div className="text-6xl mb-2">{icon}</div>
        <h3 className="text-3xl font-bold text-gray-900 mb-1">
          {currentStreak}일 연속
        </h3>
        <p className="text-sm text-gray-600">학습 스트릭</p>
      </div>

      {/* 최장 스트릭 */}
      <div className="flex items-center justify-center gap-2 mb-4 text-sm text-gray-600">
        <span>🏆 최장 기록:</span>
        <span className="font-semibold text-gray-900">{longestStreak}일</span>
      </div>

      {/* 다음 마일스톤 */}
      {nextMilestone && (
        <div className="bg-white rounded-lg p-4 border-2 border-orange-200">
          <p className="text-xs text-gray-500 mb-2">다음 마일스톤</p>
          <div className="flex items-center justify-between">
            <div>
              <p className="font-semibold text-gray-900">
                {nextMilestone.milestone}일 달성
              </p>
              <p className="text-xs text-gray-600">
                +{nextMilestone.reward.xp} XP
              </p>
            </div>
            <div className="text-right">
              <p className="text-2xl font-bold text-orange-600">
                {nextMilestone.daysRemaining}
              </p>
              <p className="text-xs text-gray-500">일 남음</p>
            </div>
          </div>
        </div>
      )}

      {/* 모든 마일스톤 달성 */}
      {!nextMilestone && currentStreak >= 100 && (
        <div className="bg-gradient-to-r from-yellow-100 to-orange-100 rounded-lg p-4 text-center">
          <p className="text-lg font-bold text-gray-900">🎉 모든 마일스톤 달성!</p>
          <p className="text-sm text-gray-600">당신은 전설입니다!</p>
        </div>
      )}
    </div>
  );
}

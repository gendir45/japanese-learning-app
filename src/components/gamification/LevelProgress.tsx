'use client';

// 레벨 진행률 표시 컴포넌트
// 현재 레벨, XP, 다음 레벨까지의 진행률을 시각적으로 표시합니다

import { getLevelProgress, getLevelTitle } from '@/lib/gamification/levels';

interface LevelProgressProps {
  totalXP: number;
  className?: string;
}

export default function LevelProgress({ totalXP, className = '' }: LevelProgressProps) {
  const { level, currentXP, xpForNextLevel, progressPercent } = getLevelProgress(totalXP);
  const title = getLevelTitle(level);

  return (
    <div className={`bg-white rounded-xl shadow-md p-6 ${className}`} style={{ border: '2px solid #d1d5db' }}>
      {/* 레벨 헤더 */}
      <div className="flex items-center justify-between mb-4">
        <div>
          <h3 className="text-2xl font-bold text-gray-900">레벨 {level}</h3>
          <p className="text-sm text-gray-600">{title}</p>
        </div>
        <div className="text-right">
          <p className="text-sm text-gray-500">총 XP</p>
          <p className="text-xl font-bold text-blue-600">{totalXP.toLocaleString()}</p>
        </div>
      </div>

      {/* 진행률 바 */}
      <div className="space-y-2">
        <div className="flex justify-between text-sm">
          <span className="text-gray-600">
            {currentXP.toLocaleString()} / {xpForNextLevel.toLocaleString()} XP
          </span>
          <span className="font-semibold text-blue-600">
            {progressPercent.toFixed(1)}%
          </span>
        </div>

        {/* 프로그레스 바 */}
        <div className="relative h-3 bg-gray-200 rounded-full overflow-hidden">
          <div
            className="absolute top-0 left-0 h-full bg-gradient-to-r from-blue-400 to-blue-600 rounded-full transition-all duration-500 ease-out"
            style={{ width: `${progressPercent}%` }}
          />

          {/* 반짝이는 효과 */}
          <div
            className="absolute top-0 left-0 h-full bg-gradient-to-r from-transparent via-white to-transparent opacity-30 animate-shimmer"
            style={{ width: `${progressPercent}%` }}
          />
        </div>

        <p className="text-xs text-gray-500 text-center">
          다음 레벨까지 {(xpForNextLevel - currentXP).toLocaleString()} XP
        </p>
      </div>
    </div>
  );
}

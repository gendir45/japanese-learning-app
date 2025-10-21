'use client';

// 오늘의 학습 통계 컴포넌트
// 오늘 학습한 카드 수, 정답률, 획득 XP 등을 표시합니다

interface TodayStatsProps {
  itemsStudied: number;
  itemsCorrect: number;
  xpEarned: number;
  duration: number; // 초 단위
  accuracy: number; // 퍼센트
  className?: string;
}

export default function TodayStats({
  itemsStudied,
  itemsCorrect,
  xpEarned,
  duration,
  accuracy,
  className = '',
}: TodayStatsProps) {
  // 시간을 분으로 변환
  const minutes = Math.floor(duration / 60);
  const seconds = duration % 60;

  return (
    <div className={`bg-white rounded-xl shadow-md p-6 ${className}`}>
      <h3 className="text-xl font-bold text-gray-900 mb-4">📊 오늘의 학습</h3>

      <div className="grid grid-cols-2 gap-4">
        {/* 학습한 카드 */}
        <div className="bg-blue-50 rounded-lg p-4">
          <p className="text-sm text-gray-600 mb-1">학습한 카드</p>
          <p className="text-3xl font-bold text-blue-600">{itemsStudied}</p>
          <p className="text-xs text-gray-500">개</p>
        </div>

        {/* 정답률 */}
        <div className="bg-green-50 rounded-lg p-4">
          <p className="text-sm text-gray-600 mb-1">정답률</p>
          <p className="text-3xl font-bold text-green-600">{accuracy.toFixed(1)}</p>
          <p className="text-xs text-gray-500">%</p>
        </div>

        {/* 획득 XP */}
        <div className="bg-purple-50 rounded-lg p-4">
          <p className="text-sm text-gray-600 mb-1">획득 XP</p>
          <p className="text-3xl font-bold text-purple-600">{xpEarned}</p>
          <p className="text-xs text-gray-500">경험치</p>
        </div>

        {/* 학습 시간 */}
        <div className="bg-orange-50 rounded-lg p-4">
          <p className="text-sm text-gray-600 mb-1">학습 시간</p>
          <p className="text-3xl font-bold text-orange-600">
            {minutes > 0 ? minutes : '0'}
          </p>
          <p className="text-xs text-gray-500">
            분 {seconds > 0 && `${seconds}초`}
          </p>
        </div>
      </div>

      {/* 격려 메시지 */}
      {itemsStudied > 0 && (
        <div className="mt-4 p-3 bg-gradient-to-r from-blue-50 to-purple-50 rounded-lg">
          <p className="text-sm text-gray-700 text-center">
            {itemsStudied >= 20 ? (
              <span>🎉 대단해요! 오늘 목표를 달성했어요!</span>
            ) : itemsStudied >= 10 ? (
              <span>💪 좋아요! 조금만 더 힘내세요!</span>
            ) : (
              <span>✨ 좋은 시작이에요! 계속 공부해보세요!</span>
            )}
          </p>
        </div>
      )}
    </div>
  );
}

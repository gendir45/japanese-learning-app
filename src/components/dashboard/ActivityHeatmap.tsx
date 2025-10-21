import { cn } from '@/lib/utils';

interface ActivityDay {
  date: string; // YYYY-MM-DD
  count: number; // 학습한 항목 수
}

interface ActivityHeatmapProps {
  days?: ActivityDay[];
  daysToShow?: number;
}

/**
 * 학습 활동 히트맵
 * GitHub 잔디처럼 학습 기록을 시각화
 */
export function ActivityHeatmap({
  days = [],
  daysToShow = 30,
}: ActivityHeatmapProps) {
  // 최근 N일의 날짜 생성
  const today = new Date();
  const recentDays: ActivityDay[] = [];

  for (let i = daysToShow - 1; i >= 0; i--) {
    const date = new Date(today);
    date.setDate(date.getDate() - i);
    const dateStr = date.toISOString().split('T')[0];

    // days 배열에서 해당 날짜 찾기
    const dayData = days.find(d => d.date === dateStr);

    recentDays.push({
      date: dateStr,
      count: dayData?.count || 0,
    });
  }

  // 색상 계산 함수
  const getColor = (count: number) => {
    if (count === 0) return 'bg-gray-100';
    if (count < 5) return 'bg-green-200';
    if (count < 10) return 'bg-green-300';
    if (count < 20) return 'bg-green-400';
    return 'bg-green-500';
  };

  // 날짜 포맷 함수
  const formatDate = (dateStr: string) => {
    const date = new Date(dateStr);
    return `${date.getMonth() + 1}/${date.getDate()}`;
  };

  // 주 단위로 그룹화
  const weeks: ActivityDay[][] = [];
  let currentWeek: ActivityDay[] = [];

  recentDays.forEach((day, index) => {
    currentWeek.push(day);

    // 7일마다 또는 마지막 날이면 주 완성
    if (currentWeek.length === 7 || index === recentDays.length - 1) {
      weeks.push(currentWeek);
      currentWeek = [];
    }
  });

  return (
    <div className="space-y-4">
      {/* 범례 */}
      <div className="flex items-center justify-between text-sm text-gray-600">
        <span>최근 {daysToShow}일 학습 기록</span>
        <div className="flex items-center gap-2">
          <span className="text-xs">적음</span>
          <div className="flex gap-1">
            <div className="w-3 h-3 bg-gray-100 rounded-sm" />
            <div className="w-3 h-3 bg-green-200 rounded-sm" />
            <div className="w-3 h-3 bg-green-300 rounded-sm" />
            <div className="w-3 h-3 bg-green-400 rounded-sm" />
            <div className="w-3 h-3 bg-green-500 rounded-sm" />
          </div>
          <span className="text-xs">많음</span>
        </div>
      </div>

      {/* 히트맵 그리드 */}
      <div className="flex gap-1 overflow-x-auto pb-2">
        {weeks.map((week, weekIndex) => (
          <div key={weekIndex} className="flex flex-col gap-1">
            {week.map((day, dayIndex) => (
              <div
                key={day.date}
                className={cn(
                  'w-3 h-3 rounded-sm transition-all hover:ring-2 hover:ring-blue-400',
                  getColor(day.count)
                )}
                title={`${formatDate(day.date)}: ${day.count}개 학습`}
              />
            ))}
          </div>
        ))}
      </div>

      {/* 통계 */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 pt-2 border-t">
        <StatItem
          label="총 학습일"
          value={recentDays.filter(d => d.count > 0).length}
          suffix="일"
        />
        <StatItem
          label="총 학습 항목"
          value={recentDays.reduce((sum, d) => sum + d.count, 0)}
          suffix="개"
        />
        <StatItem
          label="평균 (일)"
          value={Math.round(
            recentDays.reduce((sum, d) => sum + d.count, 0) / daysToShow
          )}
          suffix="개"
        />
        <StatItem
          label="최대 (일)"
          value={Math.max(...recentDays.map(d => d.count))}
          suffix="개"
        />
      </div>
    </div>
  );
}

function StatItem({
  label,
  value,
  suffix,
}: {
  label: string;
  value: number;
  suffix?: string;
}) {
  return (
    <div className="text-center">
      <p className="text-xs text-gray-500">{label}</p>
      <p className="text-lg font-bold text-gray-900">
        {value}
        {suffix && <span className="text-sm font-normal text-gray-600 ml-0.5">{suffix}</span>}
      </p>
    </div>
  );
}

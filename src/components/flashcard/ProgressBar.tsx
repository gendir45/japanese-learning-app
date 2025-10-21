import { ProgressBarProps } from './types';
import { cn } from '@/lib/utils';

/**
 * 학습 진행률 표시 컴포넌트
 */
export function ProgressBar({ current, total, className }: ProgressBarProps) {
  const percentage = Math.round((current / total) * 100);

  return (
    <div className={cn('w-full', className)}>
      <div className="flex items-center justify-between mb-2">
        <span className="text-sm font-medium text-gray-700">
          {current} / {total} 카드
        </span>
        <span className="text-sm font-medium text-gray-700">
          {percentage}%
        </span>
      </div>
      
      <div className="w-full bg-gray-200 rounded-full h-3 overflow-hidden">
        <div
          className="bg-blue-600 h-full rounded-full transition-all duration-300 ease-out"
          style={{ width: `${percentage}%` }}
          role="progressbar"
          aria-valuenow={current}
          aria-valuemin={0}
          aria-valuemax={total}
          aria-label={`${current}개 중 ${total}개 완료`}
        />
      </div>
    </div>
  );
}

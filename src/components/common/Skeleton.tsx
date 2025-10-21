import { cn } from '@/lib/utils';

interface SkeletonProps {
  className?: string;
  variant?: 'text' | 'circular' | 'rectangular';
  width?: string | number;
  height?: string | number;
  animation?: 'pulse' | 'wave' | 'none';
}

/**
 * 스켈레톤 로딩 컴포넌트
 * 콘텐츠가 로딩 중일 때 표시되는 플레이스홀더
 */
export function Skeleton({
  className,
  variant = 'rectangular',
  width,
  height,
  animation = 'pulse',
}: SkeletonProps) {
  const baseClasses = 'bg-gray-200';

  const variantClasses = {
    text: 'h-4 rounded',
    circular: 'rounded-full',
    rectangular: 'rounded-lg',
  };

  const animationClasses = {
    pulse: 'animate-pulse',
    wave: 'animate-shimmer bg-gradient-to-r from-gray-200 via-gray-100 to-gray-200 bg-[length:200%_100%]',
    none: '',
  };

  const style: React.CSSProperties = {};
  if (width) style.width = typeof width === 'number' ? `${width}px` : width;
  if (height) style.height = typeof height === 'number' ? `${height}px` : height;

  return (
    <div
      className={cn(
        baseClasses,
        variantClasses[variant],
        animationClasses[animation],
        className
      )}
      style={style}
    />
  );
}

/**
 * 카드 스켈레톤
 */
export function CardSkeleton() {
  return (
    <div className="bg-white rounded-xl shadow-sm p-6 space-y-4">
      <Skeleton variant="text" className="w-1/4 h-6" />
      <Skeleton variant="text" className="w-full h-4" />
      <Skeleton variant="text" className="w-3/4 h-4" />
      <div className="flex gap-2 mt-4">
        <Skeleton variant="rectangular" className="w-20 h-10" />
        <Skeleton variant="rectangular" className="w-20 h-10" />
      </div>
    </div>
  );
}

/**
 * 대시보드 통계 카드 스켈레톤
 */
export function StatCardSkeleton() {
  return (
    <div className="bg-white rounded-xl shadow-sm p-6">
      <Skeleton variant="text" className="w-2/3 h-5 mb-4" />
      <Skeleton variant="text" className="w-1/3 h-10 mb-2" />
      <Skeleton variant="text" className="w-full h-4" />
    </div>
  );
}

/**
 * 플래시카드 스켈레톤
 */
export function FlashcardSkeleton() {
  return (
    <div className="max-w-4xl mx-auto space-y-6">
      {/* 진행률 */}
      <div className="bg-white rounded-xl p-4">
        <Skeleton variant="rectangular" className="w-full h-3" />
      </div>

      {/* 플래시카드 */}
      <div className="bg-white rounded-2xl shadow-xl p-12 min-h-[400px] flex flex-col items-center justify-center space-y-6">
        <Skeleton variant="text" className="w-1/4 h-6" />
        <Skeleton variant="text" className="w-1/2 h-16" />
        <Skeleton variant="text" className="w-3/4 h-4" />
        <Skeleton variant="text" className="w-2/3 h-4" />
      </div>

      {/* 힌트 */}
      <div className="text-center">
        <Skeleton variant="text" className="w-1/3 h-4 mx-auto" />
      </div>
    </div>
  );
}

/**
 * 리스트 아이템 스켈레톤
 */
export function ListItemSkeleton() {
  return (
    <div className="flex items-center gap-4 p-4 bg-white rounded-lg shadow-sm">
      <Skeleton variant="circular" width={48} height={48} />
      <div className="flex-1 space-y-2">
        <Skeleton variant="text" className="w-3/4 h-5" />
        <Skeleton variant="text" className="w-1/2 h-4" />
      </div>
      <Skeleton variant="rectangular" width={80} height={32} />
    </div>
  );
}

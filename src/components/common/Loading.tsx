import { HTMLAttributes } from 'react';
import { cn } from '@/lib/utils';

export interface LoadingProps extends HTMLAttributes<HTMLDivElement> {
  size?: 'sm' | 'md' | 'lg';
  text?: string;
  fullScreen?: boolean;
}

/**
 * 공통 Loading 컴포넌트
 *
 * @example
 * ```tsx
 * <Loading size="md" text="로딩 중..." />
 * <Loading fullScreen />
 * ```
 */
export function Loading({
  size = 'md',
  text,
  fullScreen = false,
  className,
  ...props
}: LoadingProps) {
  const sizes = {
    sm: 'h-6 w-6',
    md: 'h-10 w-10',
    lg: 'h-16 w-16',
  };

  const spinner = (
    <div
      className={cn('animate-spin rounded-full border-4 border-gray-200 border-t-blue-600', sizes[size])}
      role="status"
      aria-label="로딩 중"
    >
      <span className="sr-only">로딩 중...</span>
    </div>
  );

  if (fullScreen) {
    return (
      <div
        className="fixed inset-0 z-50 flex items-center justify-center bg-white/80 backdrop-blur-sm"
        {...props}
      >
        <div className="flex flex-col items-center gap-4">
          {spinner}
          {text && (
            <p className="text-sm font-medium text-gray-700">{text}</p>
          )}
        </div>
      </div>
    );
  }

  return (
    <div
      className={cn('flex flex-col items-center justify-center gap-3', className)}
      {...props}
    >
      {spinner}
      {text && (
        <p className="text-sm font-medium text-gray-700">{text}</p>
      )}
    </div>
  );
}

export interface SpinnerProps extends HTMLAttributes<HTMLDivElement> {
  size?: 'sm' | 'md' | 'lg';
}

/**
 * 인라인 스피너 컴포넌트 (텍스트 없이)
 */
export function Spinner({ size = 'md', className, ...props }: SpinnerProps) {
  const sizes = {
    sm: 'h-4 w-4 border-2',
    md: 'h-6 w-6 border-2',
    lg: 'h-8 w-8 border-3',
  };

  return (
    <div
      className={cn(
        'animate-spin rounded-full border-gray-200 border-t-blue-600',
        sizes[size],
        className
      )}
      role="status"
      aria-label="로딩 중"
      {...props}
    >
      <span className="sr-only">로딩 중...</span>
    </div>
  );
}

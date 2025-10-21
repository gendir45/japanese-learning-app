'use client';

import { AnswerButtonsProps, AnswerQuality, ANSWER_LABELS } from './types';
import { Button } from '@/components/common';

/**
 * 답변 평가 버튼 컴포넌트
 * SRS 알고리즘을 위한 4단계 평가
 */
export function AnswerButtons({ onAnswer, disabled = false, showLabels = true }: AnswerButtonsProps) {
  const buttons: Array<{ quality: AnswerQuality; variant: 'danger' | 'secondary' | 'primary' | 'primary'; label: string; key: string }> = [
    { quality: 0, variant: 'danger', label: ANSWER_LABELS[0], key: '1' },
    { quality: 1, variant: 'secondary', label: ANSWER_LABELS[1], key: '2' },
    { quality: 2, variant: 'primary', label: ANSWER_LABELS[2], key: '3' },
    { quality: 3, variant: 'primary', label: ANSWER_LABELS[3], key: '4' },
  ];

  return (
    <div className="w-full max-w-2xl mx-auto">
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
        {buttons.map(({ quality, variant, label, key }) => (
          <Button
            key={quality}
            variant={variant}
            size="lg"
            onClick={() => onAnswer(quality)}
            disabled={disabled}
            className="relative"
          >
            {showLabels && (
              <span className="absolute top-1 right-2 text-xs opacity-70">
                {key}
              </span>
            )}
            {label}
          </Button>
        ))}
      </div>
      
      {showLabels && (
        <p className="text-center text-sm text-gray-500 mt-3">
          키보드: 1-4 또는 Space로 카드 뒤집기
        </p>
      )}
    </div>
  );
}

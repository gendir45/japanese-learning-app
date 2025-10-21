'use client';

import { useEffect } from 'react';
import { AnswerQuality } from '../types';

export interface UseKeyboardShortcutsOptions {
  onFlip: () => void;
  onAnswer: (quality: AnswerQuality) => void;
  onExit: () => void;
  isFlipped: boolean;
  disabled?: boolean;
}

/**
 * 키보드 단축키 훅
 */
export function useKeyboardShortcuts({
  onFlip,
  onAnswer,
  onExit,
  isFlipped,
  disabled = false,
}: UseKeyboardShortcutsOptions) {
  useEffect(() => {
    if (disabled) return;

    function handleKeyDown(e: KeyboardEvent) {
      // Space: 카드 뒤집기
      if (e.key === ' ') {
        e.preventDefault();
        onFlip();
        return;
      }

      // Esc: 종료
      if (e.key === 'Escape') {
        e.preventDefault();
        onExit();
        return;
      }

      // 뒷면일 때만 답변 가능
      if (isFlipped) {
        // 1-4: 답변 평가
        if (e.key >= '1' && e.key <= '4') {
          e.preventDefault();
          const quality = (parseInt(e.key) - 1) as AnswerQuality;
          onAnswer(quality);
          return;
        }
      }
    }

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [onFlip, onAnswer, onExit, isFlipped, disabled]);
}

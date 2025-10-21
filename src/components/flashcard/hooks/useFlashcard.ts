'use client';

import { useState, useCallback } from 'react';

/**
 * 플래시카드 상태 관리 훅 반환 타입
 */
export interface UseFlashcardReturn {
  isFlipped: boolean;
  flip: () => void;
  reset: () => void;
  showBack: () => void;
}

/**
 * 플래시카드 상태 관리 훅
 */
export function useFlashcard(initialFlipped = false): UseFlashcardReturn {
  const [isFlipped, setIsFlipped] = useState(initialFlipped);

  const flip = useCallback(() => {
    setIsFlipped((prev) => !prev);
  }, []);

  const reset = useCallback(() => {
    setIsFlipped(false);
  }, []);

  const showBack = useCallback(() => {
    setIsFlipped(true);
  }, []);

  return {
    isFlipped,
    flip,
    reset,
    showBack,
  };
}

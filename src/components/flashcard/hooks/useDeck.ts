'use client';

import { useState, useCallback } from 'react';
import { AnyLearningItem, AnswerQuality } from '../types';

/**
 * useDeck 반환 타입
 */
export interface UseDeckReturn {
  currentIndex: number;
  currentItem: AnyLearningItem;
  isLastCard: boolean;
  isFirstCard: boolean;
  nextCard: () => void;
  prevCard: () => void;
  recordAnswer: (itemId: string, quality: AnswerQuality) => void;
  answers: Map<string, AnswerQuality>;
  reset: () => void;
  totalItems: number;
}

/**
 * 플래시카드 덱 상태 관리 훅
 */
export function useDeck(items: AnyLearningItem[]): UseDeckReturn {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [answers, setAnswers] = useState<Map<string, AnswerQuality>>(new Map());

  const currentItem = items[currentIndex];
  const isLastCard = currentIndex === items.length - 1;
  const isFirstCard = currentIndex === 0;

  const nextCard = useCallback(() => {
    if (!isLastCard) {
      setCurrentIndex((prev) => prev + 1);
    }
  }, [isLastCard]);

  const prevCard = useCallback(() => {
    if (!isFirstCard) {
      setCurrentIndex((prev) => prev - 1);
    }
  }, [isFirstCard]);

  const recordAnswer = useCallback((itemId: string, quality: AnswerQuality) => {
    setAnswers((prev) => {
      const newAnswers = new Map(prev);
      newAnswers.set(itemId, quality);
      return newAnswers;
    });
  }, []);

  const reset = useCallback(() => {
    setCurrentIndex(0);
    setAnswers(new Map());
  }, []);

  return {
    currentIndex,
    currentItem,
    isLastCard,
    isFirstCard,
    nextCard,
    prevCard,
    recordAnswer,
    answers,
    reset,
    totalItems: items.length,
  };
}

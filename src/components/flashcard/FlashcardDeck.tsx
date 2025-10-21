'use client';

import { FlashcardDeckProps } from './types';
import { Flashcard } from './Flashcard';
import { AnswerButtons } from './AnswerButtons';
import { ProgressBar } from './ProgressBar';
import { useFlashcard } from './hooks/useFlashcard';
import { useDeck } from './hooks/useDeck';
import { useKeyboardShortcuts } from './hooks/useKeyboardShortcuts';
import { Button } from '@/components/common';

/**
 * 플래시카드 덱 컴포넌트
 * 여러 개의 플래시카드를 관리하고 학습 진행을 추적합니다
 */
export function FlashcardDeck({ 
  items, 
  onAnswer, 
  onComplete, 
  onExit 
}: FlashcardDeckProps) {
  const { isFlipped, flip, reset: resetFlip } = useFlashcard();
  const {
    currentIndex,
    currentItem,
    isLastCard,
    nextCard,
    recordAnswer,
    answers,
    totalItems,
  } = useDeck(items);

  // 답변 처리
  const handleAnswer = async (quality: number) => {
    if (!isFlipped || !currentItem) return;

    // 답변 기록
    recordAnswer(currentItem.id, quality as 0 | 1 | 2 | 3);

    // onAnswer가 완료될 때까지 대기
    await onAnswer(currentItem.id, quality as 0 | 1 | 2 | 3);

    // 다음 카드로 이동
    if (isLastCard) {
      // 마지막 카드면 완료 처리
      if (onComplete) {
        // 답변 Map 크기를 전달 (마지막 답변 포함)
        onComplete(answers.size + 1); // +1은 방금 기록한 답변
      }
    } else {
      // 다음 카드로
      nextCard();
      resetFlip();
    }
  };

  // 종료 처리
  const handleExit = () => {
    if (onExit) {
      if (confirm('학습을 종료하시겠습니까?')) {
        onExit();
      }
    }
  };

  // 키보드 단축키
  useKeyboardShortcuts({
    onFlip: flip,
    onAnswer: handleAnswer,
    onExit: handleExit,
    isFlipped,
  });

  if (!currentItem) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <p className="text-xl text-gray-600 dark:text-gray-400">학습할 항목이 없습니다.</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900 py-8 px-4">
      <div className="max-w-4xl mx-auto space-y-6">
        {/* 헤더 */}
        <div className="flex items-center justify-between">
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
            학습하기
          </h1>
          <Button variant="ghost" onClick={handleExit}>
            종료 (Esc)
          </Button>
        </div>

        {/* 진행률 */}
        <ProgressBar 
          current={currentIndex + 1} 
          total={totalItems} 
        />

        {/* 플래시카드 */}
        <Flashcard
          item={currentItem}
          isFlipped={isFlipped}
          onFlip={flip}
        />

        {/* 답변 버튼 (뒷면일 때만) */}
        {isFlipped && (
          <div className="animate-fade-in">
            <AnswerButtons
              onAnswer={handleAnswer}
              disabled={false}
              showLabels={true}
            />
          </div>
        )}

        {/* 힌트 (앞면일 때) */}
        {!isFlipped && (
          <div className="text-center">
            <p className="text-gray-500 text-sm">
              카드를 클릭하거나 Space를 눌러 답을 확인하세요
            </p>
          </div>
        )}
      </div>
    </div>
  );
}

'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { FlashcardDeck, AnyLearningItem, AnswerQuality } from '@/components/flashcard';
import { getStudyItems, recordAnswer, completeStudySession } from '@/lib/actions/study';
import { Button, FlashcardSkeleton } from '@/components/common';

/**
 * 복습하기 페이지
 * 복습 대기 중인 항목만 표시
 */
export default function ReviewPage() {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(true);
  const [items, setItems] = useState<AnyLearningItem[]>([]);
  const [isComplete, setIsComplete] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [sessionStartTime] = useState(Date.now());
  const [answeredCount, setAnsweredCount] = useState(0);
  const [correctCount, setCorrectCount] = useState(0);
  const [newItemsCount, setNewItemsCount] = useState(0);
  const [reviewItemsCount, setReviewItemsCount] = useState(0);
  const [answers, setAnswers] = useState<{ itemId: string; quality: number }[]>([]);

  // 복습 항목 로드
  useEffect(() => {
    async function loadReviewItems() {
      try {
        setIsLoading(true);
        const data = await getStudyItems(20);

        // 복습 항목만 필터링 (이전에 학습한 항목만)
        if (data.reviewItems.length === 0) {
          setError('복습할 항목이 아직 없습니다. 먼저 학습을 진행해주세요!');
          return;
        }

        // 복습 항목 수 저장 (신규 항목은 0)
        setNewItemsCount(0);
        setReviewItemsCount(data.reviewItems.length);

        // API 타입을 플래시카드 타입으로 변환
        const formattedItems: AnyLearningItem[] = data.reviewItems.map(item => ({
          id: item.id,
          type: item.type,
          jlptLevel: item.jlpt_level,
          content: item.content,
          reading: item.reading || undefined,
          meaning: item.meaning,
          exampleSentence: item.example_sentence || undefined,
          exampleReading: item.example_reading || undefined,
          exampleMeaning: item.example_translation || undefined,
        }));

        setItems(formattedItems);
      } catch (err) {
        console.error('복습 항목 로드 실패:', err);
        setError('복습 항목을 불러오는데 실패했습니다.');
      } finally {
        setIsLoading(false);
      }
    }

    loadReviewItems();
  }, []);

  const handleAnswer = async (itemId: string, quality: AnswerQuality) => {
    try {
      // SRS 알고리즘으로 답변 기록
      await recordAnswer({
        itemId,
        quality,
      });

      // 답변 기록 배열에 추가
      setAnswers(prev => [...prev, { itemId, quality }]);

      setAnsweredCount(prev => prev + 1);
      if (quality >= 2) {
        setCorrectCount(prev => prev + 1);
      }
    } catch (err) {
      console.error('답변 기록 실패:', err);
    }
  };

  const handleComplete = async (totalAnswered: number) => {
    try {
      const duration = Math.floor((Date.now() - sessionStartTime) / 1000);

      // FlashcardDeck에서 전달받은 정확한 답변 개수 사용
      const actualItemsCorrect = answers.filter(a => a.quality >= 2).length;

      // 세션 완료 기록
      await completeStudySession({
        itemsStudied: totalAnswered,
        itemsCorrect: actualItemsCorrect,
        newItems: 0, // 복습 페이지에서는 신규 항목 없음
        reviewItems: totalAnswered, // 모두 복습 항목
        duration,
      });

      // 화면 표시용으로 answeredCount 업데이트
      setAnsweredCount(totalAnswered);
      setIsComplete(true);
    } catch (err) {
      console.error('세션 완료 처리 실패:', err);
      setIsComplete(true); // 에러가 나도 완료 화면 표시
    }
  };

  const handleExit = () => {
    router.push('/dashboard');
  };

  // 로딩 중
  if (isLoading) {
    return (
      <div className="min-h-screen bg-gray-50 py-8 px-4">
        <FlashcardSkeleton />
      </div>
    );
  }

  // 에러
  if (error) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center px-4">
        <div className="max-w-md w-full bg-white rounded-2xl shadow-lg p-8 text-center">
          <div className="text-6xl mb-4">📚</div>
          <h1 className="text-2xl font-bold text-gray-900 mb-2">
            {error.includes('없습니다') ? '복습할 항목이 없어요' : '오류 발생'}
          </h1>
          <p className="text-gray-600 mb-6">{error}</p>
          <div className="space-y-3">
            <Button onClick={() => router.push('/learn')} variant="primary" className="w-full">
              새로 학습하기
            </Button>
            <Button onClick={handleExit} variant="secondary" className="w-full">
              대시보드로 돌아가기
            </Button>
          </div>
        </div>
      </div>
    );
  }

  // 완료 화면
  if (isComplete) {
    const accuracy = answeredCount > 0
      ? Math.round((correctCount / answeredCount) * 100)
      : 0;

    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center px-4">
        <div className="max-w-md w-full bg-white rounded-2xl shadow-lg p-8 text-center">
          <div className="text-6xl mb-4">🎉</div>
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            복습 완료!
          </h1>
          <p className="text-gray-600 mb-6">
            {answeredCount}개의 카드를 복습했습니다.
          </p>

          {/* 통계 */}
          <div className="bg-gray-50 rounded-lg p-4 mb-6 space-y-2">
            <div className="flex justify-between text-sm">
              <span className="text-gray-600">복습한 카드</span>
              <span className="font-semibold text-blue-600">{answeredCount}개</span>
            </div>
            <div className="flex justify-between text-sm">
              <span className="text-gray-600">정답률</span>
              <span className="font-semibold text-gray-900">{accuracy}%</span>
            </div>
          </div>

          <div className="space-y-3">
            <Button
              onClick={() => window.location.reload()}
              variant="primary"
              className="w-full"
            >
              계속 학습하기
            </Button>
            <Button
              onClick={handleExit}
              variant="secondary"
              className="w-full"
            >
              대시보드로 돌아가기
            </Button>
          </div>
        </div>
      </div>
    );
  }

  // 플래시카드 복습
  return (
    <FlashcardDeck
      items={items}
      onAnswer={handleAnswer}
      onComplete={handleComplete}
      onExit={handleExit}
    />
  );
}

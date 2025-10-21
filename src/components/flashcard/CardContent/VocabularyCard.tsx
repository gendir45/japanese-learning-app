/**
 * VocabularyCard - 단어 전용 카드
 *
 * 특징:
 * - 읽기(히라가나) 표시
 * - 한국어 뜻
 * - 예문 제공
 */

import { LearningItem } from '../types';

interface VocabularyCardProps {
  item: LearningItem;
  side: 'front' | 'back';
}

export default function VocabularyCard({ item, side }: VocabularyCardProps) {
  if (side === 'front') {
    // 앞면: 일본어 단어 + 카테고리
    return (
      <div className="flex flex-col items-center justify-center w-full h-full space-y-4">
        {/* 카테고리 */}
        {item.category && (
          <div className="px-4 py-2 bg-blue-100 text-blue-700 rounded-full text-sm font-medium">
            {item.category}
          </div>
        )}

        {/* 단어 */}
        <div
          className="text-7xl font-bold text-gray-900"
          lang="ja"
          role="heading"
          aria-level={1}
        >
          {item.content}
        </div>
      </div>
    );
  }

  // 뒷면: 읽기 + 뜻 + 예문
  return (
    <div className="flex flex-col items-center justify-center w-full h-full space-y-6 max-w-xl">
      {/* 단어 */}
      <div className="text-6xl font-bold text-gray-800" lang="ja">
        {item.content}
      </div>

      {/* 읽기 */}
      {item.reading && (
        <div className="text-2xl text-gray-600" lang="ja">
          [{item.reading}]
        </div>
      )}

      {/* 뜻 */}
      <div className="text-4xl font-semibold text-blue-600 text-center">
        {item.meaning}
      </div>

      {/* 구분선 */}
      <div className="w-full border-t border-blue-200 my-4" />

      {/* 예문 */}
      {item.exampleSentence && (
        <div className="w-full p-4 bg-white/60 rounded-lg border border-blue-200">
          <div className="text-sm text-gray-500 mb-2 font-semibold">
            예문
          </div>
          <div className="text-lg text-gray-900 mb-2" lang="ja">
            {item.exampleSentence}
          </div>
          {item.exampleReading && (
            <div className="text-sm text-gray-600 mb-1" lang="ja">
              {item.exampleReading}
            </div>
          )}
          {item.exampleMeaning && (
            <div className="text-base text-gray-700">
              → {item.exampleMeaning}
            </div>
          )}
        </div>
      )}
    </div>
  );
}

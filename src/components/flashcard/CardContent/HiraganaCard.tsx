/**
 * HiraganaCard - 히라가나/가타카나 전용 카드
 *
 * 특징:
 * - 큰 글씨로 문자 표시
 * - 간단한 레이아웃
 * - 읽기 예시
 */

import { LearningItem } from '../types';

interface HiraganaCardProps {
  item: LearningItem;
  side: 'front' | 'back';
}

export default function HiraganaCard({ item, side }: HiraganaCardProps) {
  if (side === 'front') {
    // 앞면: 일본어 문자만 크게 표시
    return (
      <div className="flex flex-col items-center justify-center w-full h-full">
        <div
          className="text-9xl font-bold text-gray-900"
          lang="ja"
          role="img"
          aria-label={`일본어 문자 ${item.content}`}
        >
          {item.content}
        </div>
      </div>
    );
  }

  // 뒷면: 읽기 + 뜻 + 예시
  return (
    <div className="flex flex-col items-center justify-center w-full h-full space-y-6">
      {/* 문자 */}
      <div className="text-8xl font-bold text-gray-800" lang="ja">
        {item.content}
      </div>

      {/* 읽기 */}
      {item.reading && (
        <div className="text-3xl text-gray-600" lang="ja">
          [{item.reading}]
        </div>
      )}

      {/* 뜻 */}
      <div className="text-4xl font-semibold text-blue-600">
        {item.meaning}
      </div>

      {/* 예시 (있는 경우) */}
      {item.exampleSentence && (
        <div className="mt-8 p-4 bg-white/50 rounded-lg border border-blue-200">
          <div className="text-xl text-gray-800 mb-2" lang="ja">
            {item.exampleSentence}
          </div>
          {item.exampleReading && (
            <div className="text-sm text-gray-600 mb-1" lang="ja">
              {item.exampleReading}
            </div>
          )}
          {item.exampleMeaning && (
            <div className="text-base text-gray-700">
              {item.exampleMeaning}
            </div>
          )}
        </div>
      )}
    </div>
  );
}

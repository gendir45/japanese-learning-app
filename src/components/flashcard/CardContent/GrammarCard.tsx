/**
 * GrammarCard - 문법 전용 카드
 *
 * 특징:
 * - 문법 패턴 표시
 * - 설명
 * - 예문 여러 개
 */

import { GrammarItem } from '../types';

interface GrammarCardProps {
  item: GrammarItem;
  side: 'front' | 'back';
}

export default function GrammarCard({ item, side }: GrammarCardProps) {
  if (side === 'front') {
    // 앞면: 문법 패턴
    return (
      <div className="flex flex-col items-center justify-center w-full h-full space-y-4">
        {/* 카테고리 */}
        {item.category && (
          <div className="px-4 py-2 bg-purple-100 text-purple-700 rounded-full text-sm font-medium">
            {item.category}
          </div>
        )}

        {/* 문법 패턴 */}
        <div
          className="text-6xl font-bold text-gray-900 text-center"
          lang="ja"
          role="heading"
          aria-level={1}
        >
          {item.pattern}
        </div>

        {/* 한국어 뜻 */}
        <div className="text-3xl text-gray-600 text-center">
          {item.meaning}
        </div>
      </div>
    );
  }

  // 뒷면: 설명 + 예문
  return (
    <div className="flex flex-col w-full h-full space-y-4 overflow-y-auto max-w-2xl">
      {/* 문법 패턴 */}
      <div className="text-5xl font-bold text-gray-800 text-center" lang="ja">
        {item.pattern}
      </div>

      {/* 설명 */}
      <div className="p-4 bg-purple-50 rounded-lg border border-purple-200">
        <div className="text-sm font-semibold text-purple-700 mb-2">
          설명
        </div>
        <div className="text-base text-gray-800 leading-relaxed">
          {item.explanation}
        </div>
      </div>

      {/* 구분선 */}
      <div className="border-t border-purple-200" />

      {/* 예문 */}
      {item.examples && item.examples.length > 0 && (
        <div className="space-y-3">
          <div className="text-sm font-semibold text-gray-700">
            예문
          </div>
          <div className="space-y-3">
            {item.examples.map((example, idx) => (
              <div
                key={idx}
                className="p-4 bg-white/60 rounded-lg border border-purple-100"
              >
                <div className="text-lg text-gray-900 mb-2" lang="ja">
                  {example.sentence}
                </div>
                <div className="text-sm text-gray-600 mb-1" lang="ja">
                  {example.reading}
                </div>
                <div className="text-base text-gray-700">
                  → {example.meaning}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* 추가 노트 */}
      {item.notes && (
        <div className="p-3 bg-yellow-50 rounded-lg border border-yellow-200">
          <div className="text-sm font-semibold text-yellow-700 mb-1">
            💡 참고
          </div>
          <div className="text-sm text-gray-700">
            {item.notes}
          </div>
        </div>
      )}
    </div>
  );
}

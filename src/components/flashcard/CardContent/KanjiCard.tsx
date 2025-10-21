/**
 * KanjiCard - 한자 전용 카드
 *
 * 특징:
 * - 부수 정보
 * - 획수
 * - 음독/훈독
 * - 사용 예시
 */

import { KanjiItem } from '../types';

interface KanjiCardProps {
  item: KanjiItem;
  side: 'front' | 'back';
}

export default function KanjiCard({ item, side }: KanjiCardProps) {
  if (side === 'front') {
    // 앞면: 한자 + 부수 힌트
    return (
      <div className="flex flex-col items-center justify-center w-full h-full space-y-4">
        {/* 한자 */}
        <div
          className="text-9xl font-bold text-gray-900"
          lang="ja"
          role="img"
          aria-label={`한자 ${item.content}`}
        >
          {item.content}
        </div>

        {/* 부수 힌트 (있는 경우) */}
        {item.radical && (
          <div className="flex items-center gap-2 text-gray-600">
            <span className="text-sm">부수:</span>
            <span className="text-2xl" lang="ja">{item.radical}</span>
            {item.radicalMeaning && (
              <span className="text-sm">({item.radicalMeaning})</span>
            )}
          </div>
        )}
      </div>
    );
  }

  // 뒷면: 상세 정보
  return (
    <div className="flex flex-col w-full h-full space-y-4 overflow-y-auto">
      {/* 한자 + 기본 정보 */}
      <div className="flex items-start gap-6">
        {/* 한자 큰 글씨 */}
        <div className="text-8xl font-bold text-gray-800" lang="ja">
          {item.content}
        </div>

        {/* 기본 정보 */}
        <div className="flex-1 space-y-2">
          {/* 뜻 */}
          <div className="text-3xl font-semibold text-blue-600">
            {item.meaning}
          </div>

          {/* 부수 + 획수 */}
          <div className="flex gap-4 text-sm text-gray-600">
            {item.radical && (
              <div className="flex items-center gap-1">
                <span className="font-medium">부수:</span>
                <span lang="ja">{item.radical}</span>
                {item.radicalMeaning && (
                  <span>({item.radicalMeaning})</span>
                )}
              </div>
            )}
            {item.strokeCount && (
              <div>
                <span className="font-medium">획수:</span> {item.strokeCount}획
              </div>
            )}
          </div>

          {/* 음독 */}
          {item.onyomi && item.onyomi.length > 0 && (
            <div className="text-base">
              <span className="font-medium text-gray-700">음독:</span>{' '}
              <span className="text-lg" lang="ja">
                {item.onyomi.join(', ')}
              </span>
            </div>
          )}

          {/* 훈독 */}
          {item.kunyomi && item.kunyomi.length > 0 && (
            <div className="text-base">
              <span className="font-medium text-gray-700">훈독:</span>{' '}
              <span className="text-lg" lang="ja">
                {item.kunyomi.join(', ')}
              </span>
            </div>
          )}
        </div>
      </div>

      {/* 구분선 */}
      <div className="border-t border-blue-200" />

      {/* 사용 예시 */}
      {item.examples && item.examples.length > 0 && (
        <div className="space-y-3">
          <div className="text-sm font-semibold text-gray-700">
            사용 예시
          </div>
          <div className="space-y-2">
            {item.examples.slice(0, 3).map((example, idx) => (
              <div
                key={idx}
                className="p-3 bg-white/60 rounded-lg border border-blue-100"
              >
                <div className="flex items-baseline gap-2">
                  <span className="text-xl font-medium" lang="ja">
                    {example.word}
                  </span>
                  <span className="text-sm text-gray-600" lang="ja">
                    [{example.reading}]
                  </span>
                </div>
                <div className="text-base text-gray-700 mt-1">
                  {example.meaning}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

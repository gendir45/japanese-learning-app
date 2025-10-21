'use client';

import { FlashcardProps, isKanaItem, isKanjiItem, isGrammarItem } from './types';
import { cn } from '@/lib/utils';

/**
 * 플래시카드 컴포넌트
 * 3D 플립 애니메이션으로 앞면/뒷면을 전환합니다
 */
export function Flashcard({ item, isFlipped, onFlip, className }: FlashcardProps) {
  return (
    <div
      className={cn('perspective-1000 w-full max-w-2xl mx-auto', className)}
      onClick={onFlip}
      role="button"
      tabIndex={0}
      onKeyDown={(e) => {
        if (e.key === ' ' || e.key === 'Enter') {
          e.preventDefault();
          onFlip();
        }
      }}
      aria-label="플래시카드를 클릭하거나 Space를 눌러 뒤집기"
    >
      <div
        className={cn(
          'relative w-full h-[400px] md:h-[500px]',
          'transform-style-preserve-3d transition-transform duration-500 ease-out cursor-pointer',
          isFlipped && 'rotate-y-180'
        )}
      >
        {/* 앞면 */}
        <div
          className={cn(
            'absolute inset-0 backface-hidden',
            'bg-white dark:bg-gray-800 border-2 border-blue-200 dark:border-blue-600 rounded-2xl shadow-lg',
            'flex items-center justify-center p-8'
          )}
        >
          <div className="text-center">
            {/* 후리가나(발음) - 작은 글씨로 위에 표시 */}
            {item.reading && !isFlipped && (
              <p className="text-xl md:text-2xl text-gray-500 dark:text-gray-400 mb-2" lang="ja">
                {item.reading}
              </p>
            )}
            {/* 메인 콘텐츠 (한자 또는 단어) */}
            <p className="text-6xl md:text-8xl font-bold text-gray-900 dark:text-white" lang="ja">
              {item.content}
            </p>
          </div>
        </div>

        {/* 뒷면 */}
        <div
          className={cn(
            'absolute inset-0 backface-hidden rotate-y-180',
            'bg-gradient-to-br from-blue-50 to-purple-50 dark:from-gray-800 dark:to-gray-700 border-2 border-blue-300 dark:border-blue-600 rounded-2xl shadow-lg',
            'flex flex-col items-center justify-center p-8 overflow-y-auto'
          )}
        >
          <FlashcardBack item={item} />
        </div>
      </div>
    </div>
  );
}

/**
 * 플래시카드 뒷면 콘텐츠
 */
function FlashcardBack({ item }: { item: FlashcardProps['item'] }) {
  // 히라가나/가타카나
  if (isKanaItem(item)) {
    return (
      <div className="text-center space-y-6">
        <div>
          <p className="text-5xl md:text-7xl font-bold text-gray-900 dark:text-white mb-2" lang="ja">
            {item.content}
          </p>
          {item.reading && (
            <p className="text-2xl md:text-3xl text-gray-600 dark:text-gray-300">{item.reading}</p>
          )}
        </div>
        <div>
          <p className="text-3xl md:text-4xl font-semibold text-blue-700 dark:text-blue-400">
            {item.meaning}
          </p>
        </div>
      </div>
    );
  }

  // 한자
  if (isKanjiItem(item)) {
    return (
      <div className="w-full space-y-4">
        <div className="text-center">
          <p className="text-6xl md:text-8xl font-bold text-gray-900 dark:text-white mb-2" lang="ja">
            {item.content}
          </p>
          {item.reading && (
            <p className="text-xl md:text-2xl text-gray-600 dark:text-gray-300 mb-2" lang="ja">
              {item.reading}
            </p>
          )}
          <p className="text-2xl md:text-3xl font-semibold text-blue-700 dark:text-blue-400">
            {item.meaning}
          </p>
        </div>

        {(item.onyomi || item.kunyomi || item.radical) && (
          <div className="border-t border-gray-300 dark:border-gray-600 pt-4 space-y-2 text-sm md:text-base">
            {item.radical && (
              <p className="text-gray-700 dark:text-gray-300">
                <span className="font-semibold">부수:</span> {item.radical}
                {item.radicalMeaning && ` (${item.radicalMeaning})`}
              </p>
            )}
            {item.strokeCount && (
              <p className="text-gray-700 dark:text-gray-300">
                <span className="font-semibold">획수:</span> {item.strokeCount}획
              </p>
            )}
            {item.onyomi && item.onyomi.length > 0 && (
              <p className="text-gray-700 dark:text-gray-300">
                <span className="font-semibold">음독:</span> {item.onyomi.join(', ')}
              </p>
            )}
            {item.kunyomi && item.kunyomi.length > 0 && (
              <p className="text-gray-700 dark:text-gray-300">
                <span className="font-semibold">훈독:</span> {item.kunyomi.join(', ')}
              </p>
            )}
          </div>
        )}

        {item.examples && item.examples.length > 0 && (
          <div className="border-t border-gray-300 dark:border-gray-600 pt-4">
            <p className="font-semibold text-gray-800 dark:text-gray-200 mb-2">사용 예시:</p>
            <div className="space-y-1">
              {item.examples.slice(0, 3).map((ex, idx) => (
                <p key={idx} className="text-gray-700 dark:text-gray-300 text-sm md:text-base">
                  <span lang="ja" className="font-medium">{ex.word}</span> ({ex.reading}) - {ex.meaning}
                </p>
              ))}
            </div>
          </div>
        )}
      </div>
    );
  }

  // 문법
  if (isGrammarItem(item)) {
    return (
      <div className="w-full space-y-4">
        <div className="text-center">
          <p className="text-4xl md:text-5xl font-bold text-gray-900 dark:text-white mb-2" lang="ja">
            {item.pattern}
          </p>
          <p className="text-xl md:text-2xl font-semibold text-blue-700 dark:text-blue-400 mb-4">
            {item.meaning}
          </p>
          <p className="text-base md:text-lg text-gray-700 dark:text-gray-300">
            {item.explanation}
          </p>
        </div>

        {item.examples && item.examples.length > 0 && (
          <div className="border-t border-gray-300 dark:border-gray-600 pt-4">
            <p className="font-semibold text-gray-800 dark:text-gray-200 mb-2">예문:</p>
            <div className="space-y-3">
              {item.examples.map((ex, idx) => (
                <div key={idx} className="text-left">
                  <p lang="ja" className="text-lg md:text-xl font-medium text-gray-900 dark:text-white">
                    {ex.sentence}
                  </p>
                  <p className="text-sm md:text-base text-gray-600 dark:text-gray-300">
                    {ex.reading}
                  </p>
                  <p className="text-sm md:text-base text-gray-700 dark:text-gray-300">
                    {ex.meaning}
                  </p>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
    );
  }

  // 일반 단어
  return (
    <div className="text-center space-y-6">
      <div>
        <p className="text-5xl md:text-6xl font-bold text-gray-900 dark:text-white mb-2" lang="ja">
          {item.content}
        </p>
        {item.reading && (
          <p className="text-2xl md:text-3xl text-gray-600 dark:text-gray-300 mb-4" lang="ja">
            {item.reading}
          </p>
        )}
        <p className="text-3xl md:text-4xl font-semibold text-blue-700 dark:text-blue-400">
          {item.meaning}
        </p>
      </div>

      {item.exampleSentence && (
        <div className="border-t border-gray-300 dark:border-gray-600 pt-6">
          <p className="font-semibold text-gray-800 dark:text-gray-200 mb-2">예문:</p>
          <p lang="ja" className="text-xl md:text-2xl font-medium text-gray-900 dark:text-white mb-1">
            {item.exampleSentence}
          </p>
          {item.exampleReading && (
            <p className="text-base md:text-lg text-gray-600 dark:text-gray-300 mb-2">
              {item.exampleReading}
            </p>
          )}
          {item.exampleMeaning && (
            <p className="text-base md:text-lg text-gray-700 dark:text-gray-300">
              {item.exampleMeaning}
            </p>
          )}
        </div>
      )}
    </div>
  );
}

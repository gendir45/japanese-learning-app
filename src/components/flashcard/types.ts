/**
 * 플래시카드 시스템 TypeScript 타입 정의
 */

// ============================================================================
// 학습 항목 타입
// ============================================================================

/**
 * 학습 항목 타입 열거형
 */
export type LearningItemType = 'hiragana' | 'katakana' | 'vocabulary' | 'grammar' | 'kanji';

/**
 * JLPT 레벨 열거형
 */
export type JLPTLevel = 'N5' | 'N4' | 'N3' | 'N2' | 'N1';

/**
 * 학습 항목 기본 인터페이스
 */
export interface LearningItem {
  id: string;
  type: LearningItemType;
  jlptLevel: JLPTLevel;
  content: string;              // 일본어 원문 (히라가나/한자)
  reading?: string;             // 히라가나 읽기 (한자인 경우)
  meaning: string;              // 한국어 뜻
  exampleSentence?: string;     // 예문 (일본어)
  exampleReading?: string;      // 예문 읽기
  exampleMeaning?: string;      // 예문 뜻
  category?: string;            // 카테고리 ('숫자', '시간', '가족' 등)
  orderIndex?: number;          // 학습 순서
}

/**
 * 한자 학습 항목 (확장)
 */
export interface KanjiItem extends LearningItem {
  type: 'kanji';
  radical?: string;             // 부수
  radicalMeaning?: string;      // 부수 뜻
  strokeCount?: number;         // 획수
  onyomi?: string[];            // 음독
  kunyomi?: string[];           // 훈독
  examples?: Array<{            // 사용 예시
    word: string;
    reading: string;
    meaning: string;
  }>;
}

/**
 * 문법 학습 항목 (확장)
 */
export interface GrammarItem extends LearningItem {
  type: 'grammar';
  pattern: string;              // 문법 패턴 (예: "〜ます")
  explanation: string;          // 문법 설명
  examples: Array<{             // 예문 여러 개
    sentence: string;
    reading: string;
    meaning: string;
  }>;
  notes?: string;               // 추가 노트
}

/**
 * 통합 학습 항목 타입
 */
export type AnyLearningItem = LearningItem | KanjiItem | GrammarItem;

// ============================================================================
// SRS (Spaced Repetition System) 타입
// ============================================================================

/**
 * 답변 품질 (0-4 척도)
 * 0 = Again (완전히 틀림)
 * 1 = Hard (어려움)
 * 2 = Good (보통)
 * 3 = Easy (쉬움)
 */
export type AnswerQuality = 0 | 1 | 2 | 3;

/**
 * 답변 버튼 레이블
 */
export const ANSWER_LABELS: Record<AnswerQuality, string> = {
  0: 'Again',
  1: 'Hard',
  2: 'Good',
  3: 'Easy',
} as const;

/**
 * 답변 버튼 색상 (Tailwind 클래스)
 */
export const ANSWER_COLORS: Record<AnswerQuality, string> = {
  0: 'red',    // Again - 빨간색
  1: 'orange', // Hard - 주황색
  2: 'green',  // Good - 초록색
  3: 'blue',   // Easy - 파란색
} as const;

/**
 * 사용자 학습 진도 상태
 */
export type ProgressStatus = 'new' | 'learning' | 'reviewing' | 'mastered';

/**
 * 사용자 학습 진도
 */
export interface UserProgress {
  id: string;
  userId: string;
  itemId: string;

  // 학습 상태
  status: ProgressStatus;

  // SRS 파라미터
  easeFactor: number;           // 난이도 계수 (기본 2.5)
  interval: number;             // 복습 간격 (일 단위)
  repetitions: number;          // 연속 성공 횟수

  // 복습 스케줄
  lastReviewedAt?: Date;
  nextReviewAt?: Date;

  // 통계
  totalReviews: number;
  correctReviews: number;

  createdAt: Date;
  updatedAt: Date;
}

// ============================================================================
// 플래시카드 컴포넌트 Props
// ============================================================================

/**
 * Flashcard 컴포넌트 Props
 */
export interface FlashcardProps {
  item: AnyLearningItem;
  isFlipped: boolean;
  onFlip: () => void;
  showAnswer?: boolean;         // 자동으로 답변 표시 여부
  className?: string;
}

/**
 * FlashcardDeck 컴포넌트 Props
 */
export interface FlashcardDeckProps {
  items: AnyLearningItem[];
  onAnswer: (itemId: string, quality: AnswerQuality) => void;
  onComplete?: (totalAnswered: number) => void;
  onExit?: () => void;
  initialIndex?: number;
}

/**
 * AnswerButtons 컴포넌트 Props
 */
export interface AnswerButtonsProps {
  onAnswer: (quality: AnswerQuality) => void;
  disabled?: boolean;
  showLabels?: boolean;         // 버튼 레이블 표시 여부
}

/**
 * ProgressBar 컴포넌트 Props
 */
export interface ProgressBarProps {
  current: number;
  total: number;
  className?: string;
}

// ============================================================================
// 덱 상태 관리
// ============================================================================

/**
 * 덱 상태
 */
export interface DeckState {
  items: AnyLearningItem[];
  currentIndex: number;
  isFlipped: boolean;
  answers: Map<string, AnswerQuality>;
  startedAt: Date;
}

/**
 * 덱 액션 타입
 */
export type DeckAction =
  | { type: 'FLIP_CARD' }
  | { type: 'NEXT_CARD' }
  | { type: 'PREV_CARD' }
  | { type: 'ANSWER'; itemId: string; quality: AnswerQuality }
  | { type: 'RESET' };

// ============================================================================
// 키보드 단축키
// ============================================================================

/**
 * 키보드 단축키 맵
 */
export const KEYBOARD_SHORTCUTS = {
  FLIP: ' ',              // Space: 카드 뒤집기
  ANSWER_AGAIN: '1',      // 1: Again
  ANSWER_HARD: '2',       // 2: Hard
  ANSWER_GOOD: '3',       // 3: Good
  ANSWER_EASY: '4',       // 4: Easy
  PREV_CARD: 'ArrowLeft', // ←: 이전 카드
  NEXT_CARD: 'ArrowRight',// →: 다음 카드
  EXIT: 'Escape',         // Esc: 학습 종료
} as const;

/**
 * 키보드 단축키 힌트 (UI 표시용)
 */
export const KEYBOARD_HINTS = {
  flip: 'Space: 카드 뒤집기',
  answer: '1-4: 답변 평가',
  navigation: '←/→: 카드 이동',
  exit: 'Esc: 종료',
} as const;

// ============================================================================
// 애니메이션 설정
// ============================================================================

/**
 * 애니메이션 지속 시간 (ms)
 */
export const ANIMATION_DURATION = {
  FLIP: 400,              // 카드 플립
  TRANSITION: 300,        // 카드 전환
  BUTTON_PRESS: 150,      // 버튼 누름
} as const;

/**
 * 플립 애니메이션 CSS 클래스
 */
export const FLIP_CLASSES = {
  container: 'perspective-1000',
  card: 'transform-style-preserve-3d transition-transform duration-400',
  flipped: 'rotate-y-180',
  front: 'backface-hidden',
  back: 'backface-hidden rotate-y-180',
} as const;

// ============================================================================
// 타입 가드
// ============================================================================

/**
 * 한자 항목인지 확인
 */
export function isKanjiItem(item: AnyLearningItem): item is KanjiItem {
  return item.type === 'kanji';
}

/**
 * 문법 항목인지 확인
 */
export function isGrammarItem(item: AnyLearningItem): item is GrammarItem {
  return item.type === 'grammar';
}

/**
 * 히라가나/가타카나 항목인지 확인
 */
export function isKanaItem(item: AnyLearningItem): boolean {
  return item.type === 'hiragana' || item.type === 'katakana';
}

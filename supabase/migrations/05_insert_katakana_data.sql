-- 가타카나 기본 46자 데이터 삽입
-- ア행부터 ワ행까지 순서대로

INSERT INTO learning_items (type, jlpt_level, content, reading, meaning, category, order_index, difficulty_level)
VALUES
  -- ア행 (a-row)
  ('katakana', 'N5', 'ア', 'a', '아', 'basic', 101, 1),
  ('katakana', 'N5', 'イ', 'i', '이', 'basic', 102, 1),
  ('katakana', 'N5', 'ウ', 'u', '우', 'basic', 103, 1),
  ('katakana', 'N5', 'エ', 'e', '에', 'basic', 104, 1),
  ('katakana', 'N5', 'オ', 'o', '오', 'basic', 105, 1),

  -- カ행 (ka-row)
  ('katakana', 'N5', 'カ', 'ka', '카', 'basic', 106, 1),
  ('katakana', 'N5', 'キ', 'ki', '키', 'basic', 107, 1),
  ('katakana', 'N5', 'ク', 'ku', '쿠', 'basic', 108, 1),
  ('katakana', 'N5', 'ケ', 'ke', '케', 'basic', 109, 1),
  ('katakana', 'N5', 'コ', 'ko', '코', 'basic', 110, 1),

  -- サ행 (sa-row)
  ('katakana', 'N5', 'サ', 'sa', '사', 'basic', 111, 1),
  ('katakana', 'N5', 'シ', 'shi', '시', 'basic', 112, 1),
  ('katakana', 'N5', 'ス', 'su', '스', 'basic', 113, 1),
  ('katakana', 'N5', 'セ', 'se', '세', 'basic', 114, 1),
  ('katakana', 'N5', 'ソ', 'so', '소', 'basic', 115, 2),

  -- タ행 (ta-row)
  ('katakana', 'N5', 'タ', 'ta', '타', 'basic', 116, 1),
  ('katakana', 'N5', 'チ', 'chi', '치', 'basic', 117, 1),
  ('katakana', 'N5', 'ツ', 'tsu', '츠', 'basic', 118, 2),
  ('katakana', 'N5', 'テ', 'te', '테', 'basic', 119, 1),
  ('katakana', 'N5', 'ト', 'to', '토', 'basic', 120, 1),

  -- ナ행 (na-row)
  ('katakana', 'N5', 'ナ', 'na', '나', 'basic', 121, 1),
  ('katakana', 'N5', 'ニ', 'ni', '니', 'basic', 122, 1),
  ('katakana', 'N5', 'ヌ', 'nu', '누', 'basic', 123, 2),
  ('katakana', 'N5', 'ネ', 'ne', '네', 'basic', 124, 2),
  ('katakana', 'N5', 'ノ', 'no', '노', 'basic', 125, 1),

  -- ハ행 (ha-row)
  ('katakana', 'N5', 'ハ', 'ha', '하', 'basic', 126, 1),
  ('katakana', 'N5', 'ヒ', 'hi', '히', 'basic', 127, 1),
  ('katakana', 'N5', 'フ', 'fu', '후', 'basic', 128, 2),
  ('katakana', 'N5', 'ヘ', 'he', '헤', 'basic', 129, 1),
  ('katakana', 'N5', 'ホ', 'ho', '호', 'basic', 130, 1),

  -- マ행 (ma-row)
  ('katakana', 'N5', 'マ', 'ma', '마', 'basic', 131, 1),
  ('katakana', 'N5', 'ミ', 'mi', '미', 'basic', 132, 2),
  ('katakana', 'N5', 'ム', 'mu', '무', 'basic', 133, 1),
  ('katakana', 'N5', 'メ', 'me', '메', 'basic', 134, 1),
  ('katakana', 'N5', 'モ', 'mo', '모', 'basic', 135, 1),

  -- ヤ행 (ya-row)
  ('katakana', 'N5', 'ヤ', 'ya', '야', 'basic', 136, 1),
  ('katakana', 'N5', 'ユ', 'yu', '유', 'basic', 137, 1),
  ('katakana', 'N5', 'ヨ', 'yo', '요', 'basic', 138, 1),

  -- ラ행 (ra-row)
  ('katakana', 'N5', 'ラ', 'ra', '라', 'basic', 139, 1),
  ('katakana', 'N5', 'リ', 'ri', '리', 'basic', 140, 1),
  ('katakana', 'N5', 'ル', 'ru', '루', 'basic', 141, 1),
  ('katakana', 'N5', 'レ', 're', '레', 'basic', 142, 1),
  ('katakana', 'N5', 'ロ', 'ro', '로', 'basic', 143, 1),

  -- ワ행 (wa-row)
  ('katakana', 'N5', 'ワ', 'wa', '와', 'basic', 144, 1),
  ('katakana', 'N5', 'ヲ', 'wo', '오 (조사)', 'basic', 145, 2),
  ('katakana', 'N5', 'ン', 'n', '응', 'basic', 146, 1);

-- 데이터 삽입 확인
DO $$
DECLARE
  item_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO item_count FROM learning_items WHERE type = 'katakana';
  RAISE NOTICE '가타카나 데이터 % 개 삽입 완료', item_count;
END $$;

-- 히라가나 기본 46자 데이터 삽입
-- あ행부터 わ행까지 순서대로

INSERT INTO learning_items (type, jlpt_level, content, reading, meaning, category, order_index, difficulty_level)
VALUES
  -- あ행 (a-row)
  ('hiragana', 'N5', 'あ', 'a', '아', 'basic', 1, 1),
  ('hiragana', 'N5', 'い', 'i', '이', 'basic', 2, 1),
  ('hiragana', 'N5', 'う', 'u', '우', 'basic', 3, 1),
  ('hiragana', 'N5', 'え', 'e', '에', 'basic', 4, 1),
  ('hiragana', 'N5', 'お', 'o', '오', 'basic', 5, 1),

  -- か행 (ka-row)
  ('hiragana', 'N5', 'か', 'ka', '카', 'basic', 6, 1),
  ('hiragana', 'N5', 'き', 'ki', '키', 'basic', 7, 1),
  ('hiragana', 'N5', 'く', 'ku', '쿠', 'basic', 8, 1),
  ('hiragana', 'N5', 'け', 'ke', '케', 'basic', 9, 1),
  ('hiragana', 'N5', 'こ', 'ko', '코', 'basic', 10, 1),

  -- さ행 (sa-row)
  ('hiragana', 'N5', 'さ', 'sa', '사', 'basic', 11, 1),
  ('hiragana', 'N5', 'し', 'shi', '시', 'basic', 12, 1),
  ('hiragana', 'N5', 'す', 'su', '스', 'basic', 13, 1),
  ('hiragana', 'N5', 'せ', 'se', '세', 'basic', 14, 1),
  ('hiragana', 'N5', 'そ', 'so', '소', 'basic', 15, 1),

  -- た행 (ta-row)
  ('hiragana', 'N5', 'た', 'ta', '타', 'basic', 16, 1),
  ('hiragana', 'N5', 'ち', 'chi', '치', 'basic', 17, 1),
  ('hiragana', 'N5', 'つ', 'tsu', '츠', 'basic', 18, 2),
  ('hiragana', 'N5', 'て', 'te', '테', 'basic', 19, 1),
  ('hiragana', 'N5', 'と', 'to', '토', 'basic', 20, 1),

  -- な행 (na-row)
  ('hiragana', 'N5', 'な', 'na', '나', 'basic', 21, 1),
  ('hiragana', 'N5', 'に', 'ni', '니', 'basic', 22, 1),
  ('hiragana', 'N5', 'ぬ', 'nu', '누', 'basic', 23, 2),
  ('hiragana', 'N5', 'ね', 'ne', '네', 'basic', 24, 1),
  ('hiragana', 'N5', 'の', 'no', '노', 'basic', 25, 1),

  -- は행 (ha-row)
  ('hiragana', 'N5', 'は', 'ha', '하', 'basic', 26, 1),
  ('hiragana', 'N5', 'ひ', 'hi', '히', 'basic', 27, 1),
  ('hiragana', 'N5', 'ふ', 'fu', '후', 'basic', 28, 2),
  ('hiragana', 'N5', 'へ', 'he', '헤', 'basic', 29, 1),
  ('hiragana', 'N5', 'ほ', 'ho', '호', 'basic', 30, 2),

  -- ま행 (ma-row)
  ('hiragana', 'N5', 'ま', 'ma', '마', 'basic', 31, 1),
  ('hiragana', 'N5', 'み', 'mi', '미', 'basic', 32, 1),
  ('hiragana', 'N5', 'む', 'mu', '무', 'basic', 33, 2),
  ('hiragana', 'N5', 'め', 'me', '메', 'basic', 34, 2),
  ('hiragana', 'N5', 'も', 'mo', '모', 'basic', 35, 1),

  -- や행 (ya-row)
  ('hiragana', 'N5', 'や', 'ya', '야', 'basic', 36, 1),
  ('hiragana', 'N5', 'ゆ', 'yu', '유', 'basic', 37, 1),
  ('hiragana', 'N5', 'よ', 'yo', '요', 'basic', 38, 1),

  -- ら행 (ra-row)
  ('hiragana', 'N5', 'ら', 'ra', '라', 'basic', 39, 1),
  ('hiragana', 'N5', 'り', 'ri', '리', 'basic', 40, 1),
  ('hiragana', 'N5', 'る', 'ru', '루', 'basic', 41, 2),
  ('hiragana', 'N5', 'れ', 're', '레', 'basic', 42, 2),
  ('hiragana', 'N5', 'ろ', 'ro', '로', 'basic', 43, 1),

  -- わ행 (wa-row)
  ('hiragana', 'N5', 'わ', 'wa', '와', 'basic', 44, 2),
  ('hiragana', 'N5', 'を', 'wo', '오 (조사)', 'basic', 45, 2),
  ('hiragana', 'N5', 'ん', 'n', '응', 'basic', 46, 1);

-- 데이터 삽입 확인
DO $$
DECLARE
  item_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO item_count FROM learning_items WHERE type = 'hiragana';
  RAISE NOTICE '히라가나 데이터 % 개 삽입 완료', item_count;
END $$;

-- 학습 항목 테이블 생성
-- 히라가나, 가타카나, 단어, 문법, 한자 등 모든 학습 콘텐츠를 저장

CREATE TABLE IF NOT EXISTS learning_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- 항목 타입 및 레벨
  type TEXT NOT NULL CHECK (type IN ('hiragana', 'katakana', 'vocabulary', 'grammar', 'kanji')),
  jlpt_level TEXT NOT NULL CHECK (jlpt_level IN ('N5', 'N4', 'N3', 'N2', 'N1')),

  -- 학습 내용
  content TEXT NOT NULL, -- 일본어 원문 (예: あ, 犬, 食べる)
  reading TEXT, -- 히라가나 읽기 (예: あ, いぬ, たべる)
  meaning TEXT NOT NULL, -- 한국어 뜻 (예: 아, 개, 먹다)

  -- 추가 정보
  example_sentence TEXT, -- 예문
  example_translation TEXT, -- 예문 번역
  notes TEXT, -- 학습 팁, 주의사항 등

  -- 분류 및 순서
  category TEXT, -- 카테고리 (예: 숫자, 시간, 가족, 동사, 형용사)
  subcategory TEXT, -- 세부 카테고리
  order_index INTEGER, -- 학습 권장 순서

  -- 난이도 (1-5)
  difficulty_level INTEGER CHECK (difficulty_level BETWEEN 1 AND 5),

  -- 타임스탬프
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 인덱스 생성 (검색 성능 향상)
CREATE INDEX idx_learning_items_type ON learning_items(type);
CREATE INDEX idx_learning_items_jlpt_level ON learning_items(jlpt_level);
CREATE INDEX idx_learning_items_category ON learning_items(category);
CREATE INDEX idx_learning_items_type_jlpt ON learning_items(type, jlpt_level);
CREATE INDEX idx_learning_items_order ON learning_items(order_index);

-- 자동 updated_at 업데이트 트리거
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_learning_items_updated_at
  BEFORE UPDATE ON learning_items
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- 코멘트 추가
COMMENT ON TABLE learning_items IS '모든 학습 콘텐츠를 저장하는 마스터 테이블';
COMMENT ON COLUMN learning_items.type IS '항목 타입: hiragana, katakana, vocabulary, grammar, kanji';
COMMENT ON COLUMN learning_items.jlpt_level IS 'JLPT 레벨: N5(초급) ~ N1(고급)';
COMMENT ON COLUMN learning_items.content IS '일본어 원문';
COMMENT ON COLUMN learning_items.reading IS '히라가나 읽기';
COMMENT ON COLUMN learning_items.meaning IS '한국어 뜻';

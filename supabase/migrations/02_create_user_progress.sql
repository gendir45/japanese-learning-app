-- 사용자 학습 진도 테이블 (SRS 알고리즘의 핵심!)
-- 각 사용자가 각 학습 항목을 어떻게 학습하고 있는지 추적

CREATE TABLE IF NOT EXISTS user_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- 사용자 및 학습 항목 연결
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  item_id UUID NOT NULL REFERENCES learning_items(id) ON DELETE CASCADE,

  -- 학습 상태
  status TEXT NOT NULL DEFAULT 'new' CHECK (status IN ('new', 'learning', 'reviewing', 'mastered')),

  -- SRS 알고리즘 파라미터
  ease_factor FLOAT NOT NULL DEFAULT 2.5 CHECK (ease_factor >= 1.3), -- 난이도 계수 (1.3 ~ 무한대)
  interval INTEGER NOT NULL DEFAULT 1 CHECK (interval >= 1), -- 복습 간격 (일 단위)
  repetitions INTEGER NOT NULL DEFAULT 0 CHECK (repetitions >= 0), -- 연속 성공 횟수

  -- 복습 스케줄
  last_reviewed_at TIMESTAMP WITH TIME ZONE, -- 마지막 복습 시간
  next_review_at TIMESTAMP WITH TIME ZONE, -- 다음 복습 예정 시간

  -- 학습 통계
  total_reviews INTEGER NOT NULL DEFAULT 0, -- 총 복습 횟수
  correct_reviews INTEGER NOT NULL DEFAULT 0, -- 정답 횟수
  incorrect_reviews INTEGER NOT NULL DEFAULT 0, -- 오답 횟수

  -- 타임스탬프
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(), -- 첫 학습 시작 시간
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- 제약 조건: 사용자당 학습 항목은 하나만
  UNIQUE(user_id, item_id)
);

-- 인덱스 생성 (복습 쿼리 최적화)
CREATE INDEX idx_user_progress_user_id ON user_progress(user_id);
CREATE INDEX idx_user_progress_item_id ON user_progress(item_id);
CREATE INDEX idx_user_progress_status ON user_progress(status);
CREATE INDEX idx_user_progress_next_review ON user_progress(next_review_at) WHERE next_review_at IS NOT NULL;
CREATE INDEX idx_user_progress_user_status ON user_progress(user_id, status);

-- 복합 인덱스: 오늘 복습할 항목 찾기
CREATE INDEX idx_user_progress_due_reviews ON user_progress(user_id, next_review_at)
  WHERE status IN ('learning', 'reviewing');

-- 자동 updated_at 업데이트
CREATE TRIGGER update_user_progress_updated_at
  BEFORE UPDATE ON user_progress
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- 유용한 뷰: 오늘 복습할 항목
CREATE OR REPLACE VIEW due_reviews AS
SELECT
  up.*,
  li.type,
  li.content,
  li.reading,
  li.meaning,
  li.category
FROM user_progress up
JOIN learning_items li ON up.item_id = li.id
WHERE up.next_review_at IS NOT NULL
  AND up.next_review_at <= NOW()
  AND up.status IN ('learning', 'reviewing')
ORDER BY up.next_review_at ASC;

-- 유용한 뷰: 학습 중인 항목 통계
CREATE OR REPLACE VIEW user_progress_stats AS
SELECT
  user_id,
  COUNT(*) as total_items,
  COUNT(*) FILTER (WHERE status = 'new') as new_items,
  COUNT(*) FILTER (WHERE status = 'learning') as learning_items,
  COUNT(*) FILTER (WHERE status = 'reviewing') as reviewing_items,
  COUNT(*) FILTER (WHERE status = 'mastered') as mastered_items,
  AVG(CASE WHEN total_reviews > 0 THEN correct_reviews::FLOAT / total_reviews ELSE 0 END) as avg_accuracy
FROM user_progress
GROUP BY user_id;

-- 코멘트
COMMENT ON TABLE user_progress IS 'SRS 알고리즘의 핵심 - 사용자별 학습 진도 및 복습 스케줄';
COMMENT ON COLUMN user_progress.ease_factor IS 'SM-2 알고리즘 난이도 계수 (1.3 이상)';
COMMENT ON COLUMN user_progress.interval IS '다음 복습까지 간격 (일 단위)';
COMMENT ON COLUMN user_progress.repetitions IS '연속 성공 횟수 (틀리면 0으로 리셋)';
COMMENT ON COLUMN user_progress.next_review_at IS '다음 복습 예정 시간 (NULL이면 신규 항목)';

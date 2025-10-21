-- 학습 세션 기록 테이블
-- 사용자의 각 학습 세션 통계를 저장 (일일 목표, 스트릭 계산 등에 활용)

CREATE TABLE IF NOT EXISTS study_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- 사용자
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

  -- 세션 정보
  session_date DATE NOT NULL DEFAULT CURRENT_DATE, -- 학습 날짜
  session_start TIMESTAMP WITH TIME ZONE, -- 세션 시작 시간
  session_end TIMESTAMP WITH TIME ZONE, -- 세션 종료 시간
  duration INTEGER, -- 학습 시간 (초 단위)

  -- 학습 통계
  items_studied INTEGER DEFAULT 0, -- 총 학습한 항목 수
  items_correct INTEGER DEFAULT 0, -- 정답 개수
  items_incorrect INTEGER DEFAULT 0, -- 오답 개수

  new_items INTEGER DEFAULT 0, -- 신규 학습 항목 수
  review_items INTEGER DEFAULT 0, -- 복습 항목 수

  -- 타입별 통계 (JSON)
  items_by_type JSONB DEFAULT '{}'::JSONB, -- 타입별 학습 개수 { "hiragana": 10, "vocabulary": 5 }

  -- 게임화 요소
  xp_earned INTEGER DEFAULT 0, -- 이번 세션에서 획득한 XP

  -- 타임스탬프
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 인덱스 생성
CREATE INDEX idx_study_sessions_user_id ON study_sessions(user_id);
CREATE INDEX idx_study_sessions_date ON study_sessions(session_date);
CREATE INDEX idx_study_sessions_user_date ON study_sessions(user_id, session_date DESC);

-- 자동 updated_at 업데이트
CREATE TRIGGER update_study_sessions_updated_at
  BEFORE UPDATE ON study_sessions
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- 유용한 뷰: 일일 학습 통계
CREATE OR REPLACE VIEW daily_study_stats AS
SELECT
  user_id,
  session_date,
  COUNT(*) as session_count,
  SUM(duration) as total_duration,
  SUM(items_studied) as total_items_studied,
  SUM(items_correct) as total_correct,
  SUM(items_incorrect) as total_incorrect,
  SUM(new_items) as total_new_items,
  SUM(review_items) as total_review_items,
  SUM(xp_earned) as total_xp_earned,
  CASE
    WHEN SUM(items_studied) > 0
    THEN ROUND((SUM(items_correct)::NUMERIC / SUM(items_studied)::NUMERIC) * 100, 2)
    ELSE 0
  END as accuracy_percentage
FROM study_sessions
GROUP BY user_id, session_date
ORDER BY user_id, session_date DESC;

-- 유용한 뷰: 주간 학습 통계
CREATE OR REPLACE VIEW weekly_study_stats AS
SELECT
  user_id,
  DATE_TRUNC('week', session_date)::DATE as week_start,
  COUNT(DISTINCT session_date) as days_studied,
  SUM(duration) as total_duration,
  SUM(items_studied) as total_items_studied,
  SUM(xp_earned) as total_xp_earned,
  CASE
    WHEN SUM(items_studied) > 0
    THEN ROUND((SUM(items_correct)::NUMERIC / SUM(items_studied)::NUMERIC) * 100, 2)
    ELSE 0
  END as accuracy_percentage
FROM study_sessions
GROUP BY user_id, DATE_TRUNC('week', session_date)
ORDER BY user_id, week_start DESC;

-- 스트릭 계산 함수 (연속 학습 일수)
CREATE OR REPLACE FUNCTION calculate_user_streak(p_user_id UUID)
RETURNS TABLE(current_streak INTEGER, longest_streak INTEGER) AS $$
DECLARE
  v_dates DATE[];
  v_current_streak INTEGER := 0;
  v_longest_streak INTEGER := 0;
  v_temp_streak INTEGER := 1;
  v_last_date DATE;
  v_date DATE;
BEGIN
  -- 사용자의 모든 학습 날짜를 날짜순으로 가져오기
  SELECT ARRAY_AGG(DISTINCT session_date ORDER BY session_date DESC)
  INTO v_dates
  FROM study_sessions
  WHERE user_id = p_user_id;

  -- 날짜가 없으면 0 반환
  IF v_dates IS NULL OR array_length(v_dates, 1) = 0 THEN
    current_streak := 0;
    longest_streak := 0;
    RETURN NEXT;
    RETURN;
  END IF;

  -- 현재 스트릭 계산 (오늘 또는 어제부터 역순으로)
  v_last_date := CURRENT_DATE;
  FOR i IN 1..array_length(v_dates, 1) LOOP
    v_date := v_dates[i];

    IF v_date = v_last_date OR v_date = v_last_date - 1 THEN
      v_current_streak := v_current_streak + 1;
      v_last_date := v_date;
    ELSE
      EXIT;
    END IF;
  END LOOP;

  -- 최장 스트릭 계산
  v_temp_streak := 1;
  v_longest_streak := 1;
  FOR i IN 1..(array_length(v_dates, 1) - 1) LOOP
    IF v_dates[i] = v_dates[i+1] + 1 THEN
      v_temp_streak := v_temp_streak + 1;
      v_longest_streak := GREATEST(v_longest_streak, v_temp_streak);
    ELSE
      v_temp_streak := 1;
    END IF;
  END LOOP;

  current_streak := v_current_streak;
  longest_streak := v_longest_streak;
  RETURN NEXT;
END;
$$ LANGUAGE plpgsql;

-- 코멘트
COMMENT ON TABLE study_sessions IS '각 학습 세션의 상세 기록 - 스트릭 및 통계 계산에 사용';
COMMENT ON COLUMN study_sessions.duration IS '학습 시간 (초 단위)';
COMMENT ON COLUMN study_sessions.xp_earned IS '해당 세션에서 획득한 경험치';
COMMENT ON FUNCTION calculate_user_streak IS '사용자의 현재 스트릭과 최장 스트릭 계산';

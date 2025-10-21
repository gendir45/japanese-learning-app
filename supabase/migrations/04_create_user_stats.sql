-- 사용자 통계 테이블 (게임화 시스템)
-- 레벨, XP, 스트릭, 누적 통계 등을 저장

CREATE TABLE IF NOT EXISTS user_stats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,

  -- 레벨 시스템
  level INTEGER NOT NULL DEFAULT 1 CHECK (level >= 1),
  total_xp INTEGER NOT NULL DEFAULT 0 CHECK (total_xp >= 0),
  current_level_xp INTEGER NOT NULL DEFAULT 0 CHECK (current_level_xp >= 0), -- 현재 레벨에서의 XP

  -- 스트릭 (연속 학습)
  current_streak INTEGER NOT NULL DEFAULT 0 CHECK (current_streak >= 0),
  longest_streak INTEGER NOT NULL DEFAULT 0 CHECK (longest_streak >= 0),
  last_study_date DATE, -- 마지막 학습 날짜

  -- 누적 통계
  total_items_learned INTEGER NOT NULL DEFAULT 0, -- 학습 시작한 총 항목 수
  total_items_mastered INTEGER NOT NULL DEFAULT 0, -- 마스터한 항목 수
  total_study_time INTEGER NOT NULL DEFAULT 0 CHECK (total_study_time >= 0), -- 총 학습 시간 (초)
  total_sessions INTEGER NOT NULL DEFAULT 0 CHECK (total_sessions >= 0), -- 총 세션 수

  -- 타입별 마스터 개수 (JSON)
  mastered_by_type JSONB DEFAULT '{
    "hiragana": 0,
    "katakana": 0,
    "vocabulary": 0,
    "grammar": 0,
    "kanji": 0
  }'::JSONB,

  -- JLPT 레벨별 진도
  jlpt_progress JSONB DEFAULT '{
    "N5": {"total": 0, "mastered": 0},
    "N4": {"total": 0, "mastered": 0},
    "N3": {"total": 0, "mastered": 0},
    "N2": {"total": 0, "mastered": 0},
    "N1": {"total": 0, "mastered": 0}
  }'::JSONB,

  -- 타임스탬프
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 인덱스
CREATE INDEX idx_user_stats_user_id ON user_stats(user_id);
CREATE INDEX idx_user_stats_level ON user_stats(level DESC);

-- 자동 updated_at 업데이트
CREATE TRIGGER update_user_stats_updated_at
  BEFORE UPDATE ON user_stats
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- 레벨 계산 함수
CREATE OR REPLACE FUNCTION calculate_level_from_xp(xp INTEGER)
RETURNS INTEGER AS $$
DECLARE
  v_level INTEGER := 1;
  v_required_xp INTEGER := 100;
  v_remaining_xp INTEGER := xp;
BEGIN
  WHILE v_remaining_xp >= v_required_xp LOOP
    v_remaining_xp := v_remaining_xp - v_required_xp;
    v_level := v_level + 1;
    v_required_xp := FLOOR(100 * POWER(1.5, v_level - 1));
  END LOOP;

  RETURN v_level;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- 레벨에 필요한 총 XP 계산 함수
CREATE OR REPLACE FUNCTION calculate_xp_for_level(target_level INTEGER)
RETURNS INTEGER AS $$
DECLARE
  v_total_xp INTEGER := 0;
  v_level INTEGER := 1;
BEGIN
  WHILE v_level < target_level LOOP
    v_total_xp := v_total_xp + FLOOR(100 * POWER(1.5, v_level - 1));
    v_level := v_level + 1;
  END LOOP;

  RETURN v_total_xp;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- 다음 레벨까지 필요한 XP 계산 함수
CREATE OR REPLACE FUNCTION xp_needed_for_next_level(current_xp INTEGER)
RETURNS INTEGER AS $$
DECLARE
  v_current_level INTEGER;
  v_next_level_xp INTEGER;
BEGIN
  v_current_level := calculate_level_from_xp(current_xp);
  v_next_level_xp := calculate_xp_for_level(v_current_level + 1);

  RETURN v_next_level_xp - current_xp;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- XP 추가 및 레벨업 처리 함수
CREATE OR REPLACE FUNCTION add_user_xp(p_user_id UUID, p_xp_amount INTEGER)
RETURNS TABLE(
  new_level INTEGER,
  new_total_xp INTEGER,
  leveled_up BOOLEAN,
  xp_to_next_level INTEGER
) AS $$
DECLARE
  v_old_level INTEGER;
  v_new_level INTEGER;
  v_new_total_xp INTEGER;
  v_current_level_xp INTEGER;
  v_leveled_up BOOLEAN := FALSE;
BEGIN
  -- 현재 레벨 가져오기
  SELECT level, total_xp INTO v_old_level, v_new_total_xp
  FROM user_stats
  WHERE user_id = p_user_id;

  -- user_stats 레코드가 없으면 생성
  IF NOT FOUND THEN
    INSERT INTO user_stats (user_id, level, total_xp, current_level_xp)
    VALUES (p_user_id, 1, 0, 0);
    v_old_level := 1;
    v_new_total_xp := 0;
  END IF;

  -- XP 추가
  v_new_total_xp := v_new_total_xp + p_xp_amount;

  -- 새 레벨 계산
  v_new_level := calculate_level_from_xp(v_new_total_xp);

  -- 레벨업 여부 확인
  IF v_new_level > v_old_level THEN
    v_leveled_up := TRUE;
  END IF;

  -- 현재 레벨 XP 계산
  v_current_level_xp := v_new_total_xp - calculate_xp_for_level(v_new_level);

  -- 업데이트
  UPDATE user_stats
  SET
    level = v_new_level,
    total_xp = v_new_total_xp,
    current_level_xp = v_current_level_xp,
    updated_at = NOW()
  WHERE user_id = p_user_id;

  -- 결과 반환
  new_level := v_new_level;
  new_total_xp := v_new_total_xp;
  leveled_up := v_leveled_up;
  xp_to_next_level := xp_needed_for_next_level(v_new_total_xp);

  RETURN NEXT;
END;
$$ LANGUAGE plpgsql;

-- 스트릭 업데이트 함수
CREATE OR REPLACE FUNCTION update_user_streak(p_user_id UUID, p_study_date DATE DEFAULT CURRENT_DATE)
RETURNS TABLE(
  new_current_streak INTEGER,
  new_longest_streak INTEGER,
  streak_broken BOOLEAN
) AS $$
DECLARE
  v_last_study_date DATE;
  v_current_streak INTEGER;
  v_longest_streak INTEGER;
  v_streak_broken BOOLEAN := FALSE;
BEGIN
  -- 현재 스트릭 정보 가져오기
  SELECT last_study_date, current_streak, longest_streak
  INTO v_last_study_date, v_current_streak, v_longest_streak
  FROM user_stats
  WHERE user_id = p_user_id;

  -- user_stats 없으면 생성
  IF NOT FOUND THEN
    INSERT INTO user_stats (user_id, current_streak, longest_streak, last_study_date)
    VALUES (p_user_id, 1, 1, p_study_date);

    new_current_streak := 1;
    new_longest_streak := 1;
    streak_broken := FALSE;
    RETURN NEXT;
    RETURN;
  END IF;

  -- 같은 날이면 변경 없음
  IF v_last_study_date = p_study_date THEN
    new_current_streak := v_current_streak;
    new_longest_streak := v_longest_streak;
    streak_broken := FALSE;
  -- 연속된 날이면 스트릭 증가
  ELSIF v_last_study_date = p_study_date - 1 THEN
    v_current_streak := v_current_streak + 1;
    v_longest_streak := GREATEST(v_longest_streak, v_current_streak);

    UPDATE user_stats
    SET
      current_streak = v_current_streak,
      longest_streak = v_longest_streak,
      last_study_date = p_study_date,
      updated_at = NOW()
    WHERE user_id = p_user_id;

    new_current_streak := v_current_streak;
    new_longest_streak := v_longest_streak;
    streak_broken := FALSE;
  -- 스트릭이 끊김
  ELSE
    UPDATE user_stats
    SET
      current_streak = 1,
      last_study_date = p_study_date,
      updated_at = NOW()
    WHERE user_id = p_user_id;

    new_current_streak := 1;
    new_longest_streak := v_longest_streak;
    streak_broken := TRUE;
  END IF;

  RETURN NEXT;
END;
$$ LANGUAGE plpgsql;

-- 코멘트
COMMENT ON TABLE user_stats IS '사용자 게임화 통계 - 레벨, XP, 스트릭, 누적 기록';
COMMENT ON COLUMN user_stats.total_xp IS '획득한 총 경험치';
COMMENT ON COLUMN user_stats.current_level_xp IS '현재 레벨에서 획득한 XP';
COMMENT ON COLUMN user_stats.current_streak IS '현재 연속 학습 일수';
COMMENT ON COLUMN user_stats.longest_streak IS '역대 최장 연속 학습 일수';
COMMENT ON FUNCTION add_user_xp IS 'XP 추가 및 자동 레벨업 처리';
COMMENT ON FUNCTION update_user_streak IS '스트릭 업데이트 (연속 학습 일수 추적)';

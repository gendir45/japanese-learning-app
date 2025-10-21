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
-- 사용자 배지 테이블
-- 획득한 배지를 기록

CREATE TABLE IF NOT EXISTS user_badges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

  -- 배지 정보
  badge_id TEXT NOT NULL, -- 배지 고유 ID (예: 'hiragana_master', '7_day_streak')
  badge_category TEXT, -- 카테고리 (예: 'progress', 'streak', 'achievement', 'hidden')

  -- 획득 정보
  earned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- 배지 메타데이터 (JSON)
  metadata JSONB, -- 배지 획득 당시의 추가 정보

  -- 제약: 같은 배지는 한 번만 획득
  UNIQUE(user_id, badge_id)
);

-- 인덱스
CREATE INDEX idx_user_badges_user_id ON user_badges(user_id);
CREATE INDEX idx_user_badges_badge_id ON user_badges(badge_id);
CREATE INDEX idx_user_badges_category ON user_badges(badge_category);
CREATE INDEX idx_user_badges_earned_at ON user_badges(earned_at DESC);

-- 배지 정의 테이블 (마스터 데이터)
CREATE TABLE IF NOT EXISTS badge_definitions (
  badge_id TEXT PRIMARY KEY,

  -- 배지 정보
  name_ko TEXT NOT NULL, -- 한국어 이름
  name_ja TEXT, -- 일본어 이름 (선택)
  description TEXT NOT NULL, -- 설명
  icon TEXT, -- 아이콘 이모지 또는 URL

  -- 분류
  category TEXT NOT NULL, -- 'progress', 'streak', 'achievement', 'hidden'
  rarity TEXT CHECK (rarity IN ('common', 'rare', 'epic', 'legendary')), -- 희소성

  -- 획득 조건 (JSON)
  criteria JSONB NOT NULL,
  -- 예시:
  -- { "type": "items_mastered", "target": "hiragana", "count": 46 }
  -- { "type": "streak", "days": 7 }
  -- { "type": "accuracy", "percentage": 95, "min_reviews": 100 }

  -- XP 보상
  xp_reward INTEGER DEFAULT 0,

  -- 정렬 순서
  display_order INTEGER,

  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 배지 정의 인덱스
CREATE INDEX idx_badge_definitions_category ON badge_definitions(category);
CREATE INDEX idx_badge_definitions_rarity ON badge_definitions(rarity);

-- 기본 배지 데이터 삽입
INSERT INTO badge_definitions (badge_id, name_ko, description, icon, category, rarity, criteria, xp_reward, display_order) VALUES

-- 진도 배지
('hiragana_master', '히라가나 정복자', '히라가나 46자를 모두 마스터했습니다', '🈁', 'progress', 'common',
 '{"type": "items_mastered", "item_type": "hiragana", "count": 46}'::JSONB, 100, 1),

('katakana_master', '가타카나 마스터', '가타카나 46자를 모두 마스터했습니다', '🈂', 'progress', 'common',
 '{"type": "items_mastered", "item_type": "katakana", "count": 46}'::JSONB, 100, 2),

('n5_vocab_collector_100', 'N5 단어 컬렉터 (100)', 'N5 단어 100개를 학습했습니다', '📚', 'progress', 'common',
 '{"type": "items_mastered", "item_type": "vocabulary", "jlpt_level": "N5", "count": 100}'::JSONB, 50, 3),

('n5_vocab_collector_300', 'N5 단어 컬렉터 (300)', 'N5 단어 300개를 학습했습니다', '📖', 'progress', 'rare',
 '{"type": "items_mastered", "item_type": "vocabulary", "jlpt_level": "N5", "count": 300}'::JSONB, 150, 4),

('n5_vocab_master', 'N5 단어 마스터', 'N5 단어 800개를 모두 마스터했습니다', '🎓', 'progress', 'epic',
 '{"type": "items_mastered", "item_type": "vocabulary", "jlpt_level": "N5", "count": 800}'::JSONB, 500, 5),

('kanji_beginner', '한자 입문자', '첫 10개 한자를 학습했습니다', '㊗️', 'progress', 'common',
 '{"type": "items_mastered", "item_type": "kanji", "count": 10}'::JSONB, 50, 6),

-- 스트릭 배지
('streak_3', '불꽃 🔥', '3일 연속 학습했습니다', '🔥', 'streak', 'common',
 '{"type": "streak", "days": 3}'::JSONB, 50, 10),

('streak_7', '일주일 전사', '7일 연속 학습했습니다', '⚡', 'streak', 'rare',
 '{"type": "streak", "days": 7}'::JSONB, 150, 11),

('streak_30', '월간 마스터', '30일 연속 학습했습니다', '💎', 'streak', 'epic',
 '{"type": "streak", "days": 30}'::JSONB, 1000, 12),

('streak_100', '레전드 학습자', '100일 연속 학습했습니다', '🏆', 'streak', 'legendary',
 '{"type": "streak", "days": 100}'::JSONB, 5000, 13),

-- 성취 배지
('perfectionist', '완벽주의자', '정답률 95% 이상으로 100문제를 풀었습니다', '⭐', 'achievement', 'rare',
 '{"type": "accuracy", "percentage": 95, "min_reviews": 100}'::JSONB, 200, 20),

('speed_runner', '스피드러너', '1분 안에 20문제를 풀었습니다', '⏱️', 'achievement', 'rare',
 '{"type": "speed", "questions": 20, "time_seconds": 60}'::JSONB, 150, 21),

('early_bird', '얼리버드', '오전 6시 전에 학습했습니다', '🌅', 'achievement', 'common',
 '{"type": "time_of_day", "before_hour": 6}'::JSONB, 50, 22),

('night_owl', '올빼미', '밤 12시 이후에 학습했습니다', '🌙', 'achievement', 'common',
 '{"type": "time_of_day", "after_hour": 24}'::JSONB, 50, 23),

-- 숨겨진 배지
('lucky_777', '행운의 숫자', '777번째 카드를 학습했습니다', '🎰', 'hidden', 'epic',
 '{"type": "total_items_studied", "count": 777}'::JSONB, 777, 30),

('comeback_kid', '부활자', '30일 중단 후 다시 학습을 시작했습니다', '💪', 'hidden', 'rare',
 '{"type": "comeback", "break_days": 30}'::JSONB, 200, 31),

('perfect_week', '완벽한 주', '7일 연속 100% 정답률을 기록했습니다', '✨', 'hidden', 'legendary',
 '{"type": "perfect_week", "days": 7, "accuracy": 100}'::JSONB, 1000, 32)

ON CONFLICT (badge_id) DO NOTHING;

-- 배지 확인 및 자동 부여 함수
CREATE OR REPLACE FUNCTION check_and_award_badges(p_user_id UUID)
RETURNS TABLE(
  badge_id TEXT,
  badge_name TEXT,
  is_new BOOLEAN
) AS $$
DECLARE
  v_badge RECORD;
  v_user_stats RECORD;
  v_already_has BOOLEAN;
  v_should_award BOOLEAN;
BEGIN
  -- 사용자 통계 가져오기
  SELECT * INTO v_user_stats
  FROM user_stats
  WHERE user_id = p_user_id;

  -- 모든 배지 정의 순회
  FOR v_badge IN SELECT * FROM badge_definitions ORDER BY display_order LOOP
    -- 이미 가지고 있는지 확인
    SELECT EXISTS(
      SELECT 1 FROM user_badges
      WHERE user_id = p_user_id AND user_badges.badge_id = v_badge.badge_id
    ) INTO v_already_has;

    -- 이미 있으면 스킵
    IF v_already_has THEN
      CONTINUE;
    END IF;

    -- 배지 획득 조건 확인 (간단한 케이스만 구현)
    v_should_award := FALSE;

    -- 스트릭 배지
    IF v_badge.criteria->>'type' = 'streak' THEN
      IF v_user_stats.current_streak >= (v_badge.criteria->>'days')::INTEGER THEN
        v_should_award := TRUE;
      END IF;
    END IF;

    -- 배지 부여
    IF v_should_award THEN
      INSERT INTO user_badges (user_id, badge_id, badge_category)
      VALUES (p_user_id, v_badge.badge_id, v_badge.category);

      -- XP 보상
      IF v_badge.xp_reward > 0 THEN
        PERFORM add_user_xp(p_user_id, v_badge.xp_reward);
      END IF;

      -- 결과 반환
      badge_id := v_badge.badge_id;
      badge_name := v_badge.name_ko;
      is_new := TRUE;
      RETURN NEXT;
    END IF;
  END LOOP;

  RETURN;
END;
$$ LANGUAGE plpgsql;

-- 코멘트
COMMENT ON TABLE user_badges IS '사용자가 획득한 배지 기록';
COMMENT ON TABLE badge_definitions IS '배지 마스터 데이터 - 모든 배지의 정의와 조건';
COMMENT ON COLUMN badge_definitions.criteria IS '배지 획득 조건 (JSON 형식)';
COMMENT ON FUNCTION check_and_award_badges IS '배지 획득 조건 확인 및 자동 부여';
-- Row Level Security (RLS) 정책 설정
-- 사용자별 데이터 접근 제어

-- 1. learning_items: 모든 사용자가 읽기 가능 (공개 학습 콘텐츠)
ALTER TABLE learning_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "learning_items는 모두 읽기 가능"
  ON learning_items
  FOR SELECT
  TO authenticated
  USING (true);

-- 관리자만 learning_items 수정 가능 (나중에 관리자 역할 추가 시)
CREATE POLICY "관리자만 learning_items 수정 가능"
  ON learning_items
  FOR ALL
  TO authenticated
  USING (
    auth.uid() IN (
      SELECT id FROM auth.users WHERE email LIKE '%@admin.com'
    )
  );

-- 2. user_progress: 본인 데이터만 접근 가능
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "user_progress는 본인만 조회 가능"
  ON user_progress
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "user_progress는 본인만 삽입 가능"
  ON user_progress
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_progress는 본인만 수정 가능"
  ON user_progress
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_progress는 본인만 삭제 가능"
  ON user_progress
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- 3. study_sessions: 본인 데이터만 접근 가능
ALTER TABLE study_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "study_sessions는 본인만 조회 가능"
  ON study_sessions
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "study_sessions는 본인만 삽입 가능"
  ON study_sessions
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "study_sessions는 본인만 수정 가능"
  ON study_sessions
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "study_sessions는 본인만 삭제 가능"
  ON study_sessions
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- 4. user_stats: 본인 데이터만 접근 가능
ALTER TABLE user_stats ENABLE ROW LEVEL SECURITY;

CREATE POLICY "user_stats는 본인만 조회 가능"
  ON user_stats
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "user_stats는 본인만 삽입 가능"
  ON user_stats
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_stats는 본인만 수정 가능"
  ON user_stats
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_stats는 본인만 삭제 가능"
  ON user_stats
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- 5. user_badges: 본인 데이터만 접근 가능
ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;

CREATE POLICY "user_badges는 본인만 조회 가능"
  ON user_badges
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "user_badges는 본인만 삽입 가능"
  ON user_badges
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_badges는 본인만 삭제 가능"
  ON user_badges
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- 6. badge_definitions: 모든 사용자가 읽기 가능 (배지 정보는 공개)
ALTER TABLE badge_definitions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "badge_definitions는 모두 읽기 가능"
  ON badge_definitions
  FOR SELECT
  TO authenticated
  USING (true);

-- 관리자만 badge_definitions 수정 가능
CREATE POLICY "관리자만 badge_definitions 수정 가능"
  ON badge_definitions
  FOR ALL
  TO authenticated
  USING (
    auth.uid() IN (
      SELECT id FROM auth.users WHERE email LIKE '%@admin.com'
    )
  );

-- 뷰에 대한 권한 부여
GRANT SELECT ON due_reviews TO authenticated;
GRANT SELECT ON user_progress_stats TO authenticated;
GRANT SELECT ON daily_study_stats TO authenticated;
GRANT SELECT ON weekly_study_stats TO authenticated;

-- 함수에 대한 권한 부여
GRANT EXECUTE ON FUNCTION calculate_level_from_xp TO authenticated;
GRANT EXECUTE ON FUNCTION calculate_xp_for_level TO authenticated;
GRANT EXECUTE ON FUNCTION xp_needed_for_next_level TO authenticated;
GRANT EXECUTE ON FUNCTION add_user_xp TO authenticated;
GRANT EXECUTE ON FUNCTION update_user_streak TO authenticated;
GRANT EXECUTE ON FUNCTION calculate_user_streak TO authenticated;
GRANT EXECUTE ON FUNCTION check_and_award_badges TO authenticated;

-- 코멘트
COMMENT ON POLICY "user_progress는 본인만 조회 가능" ON user_progress IS 'RLS: 사용자는 자신의 학습 진도만 볼 수 있음';
COMMENT ON POLICY "learning_items는 모두 읽기 가능" ON learning_items IS 'RLS: 학습 콘텐츠는 모든 인증된 사용자가 볼 수 있음';

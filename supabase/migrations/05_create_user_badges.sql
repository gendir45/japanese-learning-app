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

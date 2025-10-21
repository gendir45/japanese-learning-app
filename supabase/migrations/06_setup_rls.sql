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

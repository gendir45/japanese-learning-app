-- Row Level Security (RLS) 정책 설정
-- 사용자는 자신의 데이터만 조회/수정 가능

-- ============================================================================
-- user_progress 테이블 RLS
-- ============================================================================

ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;

-- 사용자는 자신의 진도만 조회 가능
CREATE POLICY "Users can view own progress"
  ON user_progress FOR SELECT
  USING (auth.uid() = user_id);

-- 사용자는 자신의 진도만 수정 가능
CREATE POLICY "Users can update own progress"
  ON user_progress FOR UPDATE
  USING (auth.uid() = user_id);

-- 사용자는 자신의 진도만 삽입 가능
CREATE POLICY "Users can insert own progress"
  ON user_progress FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- 사용자는 자신의 진도만 삭제 가능
CREATE POLICY "Users can delete own progress"
  ON user_progress FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================================================
-- study_sessions 테이블 RLS
-- ============================================================================

ALTER TABLE study_sessions ENABLE ROW LEVEL SECURITY;

-- 사용자는 자신의 세션만 조회 가능
CREATE POLICY "Users can view own sessions"
  ON study_sessions FOR SELECT
  USING (auth.uid() = user_id);

-- 사용자는 자신의 세션만 삽입 가능
CREATE POLICY "Users can insert own sessions"
  ON study_sessions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- user_stats 테이블 RLS
-- ============================================================================

ALTER TABLE user_stats ENABLE ROW LEVEL SECURITY;

-- 사용자는 자신의 통계만 조회 가능
CREATE POLICY "Users can view own stats"
  ON user_stats FOR SELECT
  USING (auth.uid() = user_id);

-- 사용자는 자신의 통계만 수정 가능
CREATE POLICY "Users can update own stats"
  ON user_stats FOR UPDATE
  USING (auth.uid() = user_id);

-- 사용자는 자신의 통계만 삽입 가능
CREATE POLICY "Users can insert own stats"
  ON user_stats FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- user_badges 테이블 RLS
-- ============================================================================

ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;

-- 사용자는 자신의 배지만 조회 가능
CREATE POLICY "Users can view own badges"
  ON user_badges FOR SELECT
  USING (auth.uid() = user_id);

-- 사용자는 자신의 배지만 삽입 가능 (시스템에서 자동 부여)
CREATE POLICY "Users can insert own badges"
  ON user_badges FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- learning_items 테이블 RLS
-- ============================================================================

ALTER TABLE learning_items ENABLE ROW LEVEL SECURITY;

-- 모든 인증된 사용자가 학습 항목을 조회 가능 (읽기 전용)
CREATE POLICY "Authenticated users can view learning items"
  ON learning_items FOR SELECT
  TO authenticated
  USING (true);

-- ============================================================================
-- badge_definitions 테이블 RLS
-- ============================================================================

ALTER TABLE badge_definitions ENABLE ROW LEVEL SECURITY;

-- 모든 인증된 사용자가 배지 정의를 조회 가능 (읽기 전용)
CREATE POLICY "Authenticated users can view badge definitions"
  ON badge_definitions FOR SELECT
  TO authenticated
  USING (true);

-- ============================================================================
-- 코멘트
-- ============================================================================

COMMENT ON POLICY "Users can view own progress" ON user_progress IS 
  '사용자는 자신의 학습 진도만 조회할 수 있습니다';

COMMENT ON POLICY "Authenticated users can view learning items" ON learning_items IS 
  '인증된 모든 사용자가 학습 콘텐츠를 조회할 수 있습니다 (읽기 전용)';

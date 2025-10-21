-- ease_factor NULL 값 수정 스크립트
-- NULL 값을 기본값 2.5로 업데이트

-- 1. 현재 NULL 값 개수 확인
SELECT 'Before fix:' as status, COUNT(*) as null_count
FROM user_progress
WHERE ease_factor IS NULL;

-- 2. NULL 값을 기본값으로 업데이트
UPDATE user_progress
SET ease_factor = 2.5
WHERE ease_factor IS NULL;

-- 3. 수정 후 확인 (0이어야 함)
SELECT 'After fix:' as status, COUNT(*) as null_count
FROM user_progress
WHERE ease_factor IS NULL;

-- 4. 전체 레코드 확인
SELECT 'Total records:' as status, COUNT(*) as total_count
FROM user_progress;

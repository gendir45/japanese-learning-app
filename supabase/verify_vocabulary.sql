-- N5 Vocabulary 데이터 검증 쿼리
-- Supabase Dashboard > SQL Editor에서 실행하세요

-- ============================================
-- 1. 전체 N5 단어 수 확인
-- ============================================
SELECT COUNT(*) as total_n5_words
FROM learning_items
WHERE type = 'vocabulary' AND jlpt_level = 'N5';

-- 예상 결과: 700-800개 (201-300 범위 제외 시 700개)


-- ============================================
-- 2. 배치별 단어 수 확인
-- ============================================
SELECT
  CASE
    WHEN order_index BETWEEN 1 AND 100 THEN 'Batch 1 (1-100): 숫자, 인사, 대명사, 기본 명사/동사'
    WHEN order_index BETWEEN 101 AND 200 THEN 'Batch 2 (101-200): 시간, 가족, 색상, 방향, 음식, 교통'
    WHEN order_index BETWEEN 201 AND 300 THEN 'Batch 3 (201-300): ❌ 미생성'
    WHEN order_index BETWEEN 301 AND 400 THEN 'Batch 4 (301-400): 날씨/자연, 신체, 의류, 활동, 형용사'
    WHEN order_index BETWEEN 401 AND 500 THEN 'Batch 5 (401-500): 형용사, 부사, 동작 동사, 장소'
    WHEN order_index BETWEEN 501 AND 600 THEN 'Batch 6 (501-600): 감정 형용사, 상태 동사, 의문사'
    WHEN order_index BETWEEN 601 AND 700 THEN 'Batch 7 (601-700): 학교, 일상생활, 날씨'
    WHEN order_index BETWEEN 701 AND 800 THEN 'Batch 8 (701-800): 관계, 추상 명사, 조수사'
    ELSE 'Other'
  END as batch,
  COUNT(*) as count,
  CASE
    WHEN COUNT(*) = 100 THEN '✅ 완료'
    WHEN COUNT(*) = 0 THEN '❌ 없음'
    ELSE '⚠️  불완전'
  END as status
FROM learning_items
WHERE type = 'vocabulary' AND jlpt_level = 'N5'
GROUP BY batch
ORDER BY MIN(order_index);

-- 예상 결과:
-- Batch 1 (1-100): 100개 ✅
-- Batch 2 (101-200): 100개 ✅
-- Batch 3 (201-300): 0개 ❌
-- Batch 4 (301-400): 100개 ✅
-- Batch 5 (401-500): 100개 ✅
-- Batch 6 (501-600): 100개 ✅
-- Batch 7 (601-700): 100개 ✅
-- Batch 8 (701-800): 100개 ✅


-- ============================================
-- 3. 카테고리별 단어 수 확인
-- ============================================
SELECT
  category,
  COUNT(*) as count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
FROM learning_items
WHERE type = 'vocabulary' AND jlpt_level = 'N5'
GROUP BY category
ORDER BY count DESC;


-- ============================================
-- 4. 세부 카테고리별 단어 수 확인
-- ============================================
SELECT
  category,
  subcategory,
  COUNT(*) as count
FROM learning_items
WHERE type = 'vocabulary' AND jlpt_level = 'N5'
GROUP BY category, subcategory
ORDER BY category, count DESC;


-- ============================================
-- 5. order_index 중복 확인
-- ============================================
SELECT
  order_index,
  COUNT(*) as duplicate_count
FROM learning_items
WHERE type = 'vocabulary' AND jlpt_level = 'N5'
GROUP BY order_index
HAVING COUNT(*) > 1
ORDER BY order_index;

-- 예상 결과: 0개 (중복 없어야 함)


-- ============================================
-- 6. order_index 누락 범위 확인
-- ============================================
WITH RECURSIVE numbers AS (
  SELECT 1 as num
  UNION ALL
  SELECT num + 1
  FROM numbers
  WHERE num < 800
)
SELECT
  num as missing_order_index
FROM numbers
WHERE num NOT IN (
  SELECT order_index
  FROM learning_items
  WHERE type = 'vocabulary' AND jlpt_level = 'N5'
)
ORDER BY num;

-- 예상 결과: 201-300 범위 (100개)


-- ============================================
-- 7. example_reading 컬럼 누락 확인
-- ============================================
SELECT
  order_index,
  content,
  example_sentence,
  example_reading
FROM learning_items
WHERE type = 'vocabulary'
  AND jlpt_level = 'N5'
  AND (example_reading IS NULL OR example_reading = '')
ORDER BY order_index;

-- 예상 결과: 0개 (모두 example_reading이 있어야 함)


-- ============================================
-- 8. 각 배치의 첫 5개 단어 샘플 확인
-- ============================================
SELECT
  order_index,
  content,
  reading,
  meaning,
  category,
  subcategory
FROM learning_items
WHERE type = 'vocabulary' AND jlpt_level = 'N5'
  AND order_index IN (1, 2, 3, 4, 5, 101, 102, 103, 104, 105, 301, 302, 303, 304, 305)
ORDER BY order_index;


-- ============================================
-- 9. 난이도별 분포 확인
-- ============================================
SELECT
  difficulty_level,
  COUNT(*) as count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
FROM learning_items
WHERE type = 'vocabulary' AND jlpt_level = 'N5'
GROUP BY difficulty_level
ORDER BY difficulty_level;


-- ============================================
-- 10. 최근 삽입된 데이터 확인 (상위 10개)
-- ============================================
SELECT
  order_index,
  content,
  reading,
  meaning,
  created_at
FROM learning_items
WHERE type = 'vocabulary' AND jlpt_level = 'N5'
ORDER BY created_at DESC
LIMIT 10;

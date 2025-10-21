-- 현재 데이터베이스 상태 확인

-- 1. 전체 N5 단어 수
SELECT COUNT(*) as total_n5_words
FROM learning_items
WHERE type = 'vocabulary' AND jlpt_level = 'N5';

-- 2. 배치별 상세 확인
SELECT
  CASE
    WHEN order_index BETWEEN 1 AND 100 THEN 'Batch 1 (1-100)'
    WHEN order_index BETWEEN 101 AND 200 THEN 'Batch 2 (101-200)'
    WHEN order_index BETWEEN 201 AND 300 THEN 'Batch 3 (201-300)'
    WHEN order_index BETWEEN 301 AND 400 THEN 'Batch 4 (301-400)'
    WHEN order_index BETWEEN 401 AND 500 THEN 'Batch 5 (401-500)'
    WHEN order_index BETWEEN 501 AND 600 THEN 'Batch 6 (501-600)'
    WHEN order_index BETWEEN 601 AND 700 THEN 'Batch 7 (601-700)'
    WHEN order_index BETWEEN 701 AND 800 THEN 'Batch 8 (701-800)'
    WHEN order_index BETWEEN 801 AND 900 THEN 'Batch 9 (801-900)'
    WHEN order_index BETWEEN 901 AND 1000 THEN 'Batch 10 (901-1000)'
    ELSE 'Other'
  END as batch,
  COUNT(*) as count,
  MIN(order_index) as first_index,
  MAX(order_index) as last_index
FROM learning_items
WHERE type = 'vocabulary' AND jlpt_level = 'N5'
GROUP BY batch
ORDER BY MIN(order_index);

-- 3. order_index 중복 확인
SELECT
  order_index,
  COUNT(*) as duplicate_count,
  STRING_AGG(content, ', ') as words
FROM learning_items
WHERE type = 'vocabulary' AND jlpt_level = 'N5'
GROUP BY order_index
HAVING COUNT(*) > 1
ORDER BY order_index
LIMIT 20;

-- 4. 각 배치 샘플 확인 (첫 3개씩)
WITH ranked_items AS (
  SELECT
    order_index,
    content,
    reading,
    meaning,
    category,
    ROW_NUMBER() OVER (
      PARTITION BY FLOOR((order_index - 1) / 100)
      ORDER BY order_index
    ) as rn
  FROM learning_items
  WHERE type = 'vocabulary' AND jlpt_level = 'N5'
)
SELECT * FROM ranked_items
WHERE rn <= 3
ORDER BY order_index;

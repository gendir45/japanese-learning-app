-- 학습 항목 확인
SELECT COUNT(*) as learning_items_count FROM learning_items;

-- 첫 5개 항목 확인
SELECT id, type, content, meaning
FROM learning_items
ORDER BY order_index
LIMIT 5;

-- Add example_reading column to learning_items table
-- This column stores the hiragana reading of example sentences

ALTER TABLE learning_items
ADD COLUMN IF NOT EXISTS example_reading TEXT;

COMMENT ON COLUMN learning_items.example_reading IS '예문의 히라가나 읽기';

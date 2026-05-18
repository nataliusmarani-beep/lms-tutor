-- Add bilingual text columns to quiz tables
ALTER TABLE quiz_questions ADD COLUMN IF NOT EXISTS question_text_id TEXT;
ALTER TABLE quiz_options    ADD COLUMN IF NOT EXISTS option_text_id   TEXT;

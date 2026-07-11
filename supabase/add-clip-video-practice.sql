-- ============================================================
-- add-clip-video-practice.sql
-- Turn each checklist "clip" into a watch + practice unit.
-- Adds a video and a written practice task to every clip.
-- Run in Supabase SQL Editor. Safe to re-run.
-- ============================================================

-- Video shown for the clip (YouTube watch/embed URL)
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS video_url TEXT;

-- Short "now try this in Excel" practice task (bilingual)
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS practice_task    TEXT;
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS practice_task_id TEXT;

-- ============================================================
-- remove-excel-shorts-course.sql
-- Removes the standalone "Microsoft Excel Essentials — Short Clips"
-- course and everything under it.
--
-- Run this ONLY if you previously seeded excel-shorts-course.sql and
-- now want the "resources only" version (excel-clips-resources.sql)
-- instead. Safe to run if the course was never seeded (does nothing).
--
-- Several tables reference course_modules(id) WITHOUT ON DELETE CASCADE
-- (module_checklist_items, learning_sessions, checklist_completions,
-- assignments), so those rows are cleared first before the course is
-- deleted. module_resources and the quiz tables cascade automatically.
--
-- Run in the Supabase SQL Editor.
-- ============================================================

DO $$
DECLARE
  v_course_id UUID;
BEGIN
  SELECT id INTO v_course_id FROM courses
   WHERE title = 'Microsoft Excel Essentials — Short Clips'
   LIMIT 1;

  IF v_course_id IS NULL THEN
    RAISE NOTICE 'Standalone Excel short-clips course not found — nothing to remove.';
    RETURN;
  END IF;

  -- Clear non-cascading references to this course's modules
  DELETE FROM checklist_completions
   WHERE course_module_id IN (SELECT id FROM course_modules WHERE course_id = v_course_id);

  DELETE FROM learning_sessions
   WHERE course_module_id IN (SELECT id FROM course_modules WHERE course_id = v_course_id);

  DELETE FROM assignments
   WHERE course_module_id IN (SELECT id FROM course_modules WHERE course_id = v_course_id);

  DELETE FROM module_checklist_items
   WHERE course_module_id IN (SELECT id FROM course_modules WHERE course_id = v_course_id);

  -- Delete the course; course_modules -> module_resources / module_quizzes
  -- (and quiz_questions/options/attempts) cascade from here.
  DELETE FROM courses WHERE id = v_course_id;

  RAISE NOTICE 'Removed standalone Excel short-clips course and its modules.';
END $$;

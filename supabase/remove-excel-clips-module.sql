-- ============================================================
-- remove-excel-clips-module.sql
-- Removes the "Excel Clips" module (and its 120 videos) that was added
-- to "Microsoft Digital Skills for University Prep" by mistake.
--
-- The clips belong to "Microsoft Excel Essentials — Short Clips", the
-- course students are actually enrolled in — see excel-clips-to-resources.sql.
-- The Digital Skills course keeps its own 8 weekly modules and their
-- original resources; only the Excel Clips module goes.
--
-- Safe to re-run (does nothing if already removed).
-- Run in the Supabase SQL Editor.
-- ============================================================

DO $$
DECLARE
  v_mod_id UUID;
BEGIN
  SELECT m.id INTO v_mod_id
    FROM course_modules m
    JOIN courses c ON c.id = m.course_id
   WHERE m.title = 'Excel Clips'
     AND c.title = 'Microsoft Digital Skills for University Prep'
   LIMIT 1;

  IF v_mod_id IS NULL THEN
    RAISE NOTICE 'Excel Clips module not found — nothing to remove.';
    RETURN;
  END IF;

  -- Clear the references that do NOT cascade from course_modules
  DELETE FROM checklist_completions   WHERE course_module_id = v_mod_id;
  DELETE FROM learning_sessions       WHERE course_module_id = v_mod_id;
  DELETE FROM assignments             WHERE course_module_id = v_mod_id;
  DELETE FROM module_checklist_items  WHERE course_module_id = v_mod_id;

  -- module_resources and module_quizzes cascade from the module
  DELETE FROM course_modules WHERE id = v_mod_id;

  RAISE NOTICE 'Removed the misplaced Excel Clips module and its videos.';
END $$;

-- Verify: expect ONE row (the Short Clips course) holding all the clip videos
SELECT c.title,
       count(DISTINCT m.id) AS modules,
       count(DISTINCT r.id) FILTER (WHERE r.url LIKE '%youtube.com/%') AS youtube_videos
  FROM courses c
  LEFT JOIN course_modules m   ON m.course_id = c.id
  LEFT JOIN module_resources r ON r.course_module_id = m.id
 GROUP BY c.title
 ORDER BY c.title;

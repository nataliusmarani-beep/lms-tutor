-- ============================================================
-- delete-standalone-excel-course.sql
-- Consolidation cleanup: permanently delete the standalone
-- "Microsoft Excel Essentials — Short Clips" course now that the Excel
-- clips live in "Microsoft Digital Skills for University Prep"
-- (see excel-clips-in-digital-skills.sql).
--
-- DESTRUCTIVE. This removes the course, its 9 modules, 120 videos, tutor
-- checklist items and quizzes, AND every student's enrolment + progress in
-- it (course_enrollments cascades on course delete). Only run this AFTER
-- excel-clips-in-digital-skills.sql has succeeded and you have confirmed
-- the videos show under the Digital Skills Excel module.
--
-- Several tables reference course_modules(id) WITHOUT ON DELETE CASCADE
-- (checklist_completions, learning_sessions, assignments,
-- module_checklist_items), so those rows are cleared first.
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
    RAISE NOTICE 'Standalone Excel course not found — already removed.';
    RETURN;
  END IF;

  DELETE FROM checklist_completions
   WHERE course_module_id IN (SELECT id FROM course_modules WHERE course_id = v_course_id);
  DELETE FROM learning_sessions
   WHERE course_module_id IN (SELECT id FROM course_modules WHERE course_id = v_course_id);
  DELETE FROM assignments
   WHERE course_module_id IN (SELECT id FROM course_modules WHERE course_id = v_course_id);
  DELETE FROM module_checklist_items
   WHERE course_module_id IN (SELECT id FROM course_modules WHERE course_id = v_course_id);

  -- Deleting the course cascades: course_modules -> module_resources /
  -- module_quizzes (-> quiz_questions/options/attempts), and course_enrollments.
  DELETE FROM courses WHERE id = v_course_id;

  RAISE NOTICE 'Deleted the standalone Excel Short Clips course.';
END $$;

-- Verify: expect ONE row left — "Microsoft Digital Skills for University Prep".
SELECT c.title,
       count(DISTINCT m.id) AS modules,
       count(DISTINCT r.id) FILTER (WHERE r.url LIKE '%youtube.com/%') AS youtube_videos,
       count(DISTINCT e.student_id) AS students_enrolled
  FROM courses c
  LEFT JOIN course_modules m     ON m.course_id = c.id
  LEFT JOIN module_resources r   ON r.course_module_id = m.id
  LEFT JOIN course_enrollments e ON e.course_id = c.id
 GROUP BY c.title
 ORDER BY c.title;

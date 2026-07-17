-- ============================================================
-- excel-clips-no-week.sql
-- The "Excel Clips" module is a reference library of 120 videos,
-- not a 9th week of coursework — but it was seeded as week 9 of an
-- 8-week course. Clear its week number.
--
-- Effects in the app:
--   * the "Week 9" / "Minggu 9" badge disappears (every week badge is
--     rendered behind a `{mod.week_number && ...}` guard)
--   * the course header's week count goes back to 8 (maxWeek ignores NULL)
--   * ordering is unaffected — modules are ordered by sort_order, so the
--     library stays at the end of the course
--
-- Safe to re-run. Run in the Supabase SQL Editor.
-- ============================================================

UPDATE course_modules
   SET week_number = NULL
 WHERE title = 'Excel Clips'
   AND course_id = (
     SELECT id FROM courses
      WHERE title = 'Microsoft Digital Skills for University Prep'
      LIMIT 1
   );

-- Verify: expect week_number = NULL, sort_order = 9, videos = 120
SELECT m.title,
       m.week_number,
       m.sort_order,
       count(r.id) AS videos
  FROM course_modules m
  LEFT JOIN module_resources r
         ON r.course_module_id = m.id AND r.url LIKE '%youtube.com/%'
 WHERE m.title = 'Excel Clips'
 GROUP BY m.title, m.week_number, m.sort_order;

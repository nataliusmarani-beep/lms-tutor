-- ============================================================
-- powerpoint-lesson-clip-videos.sql
-- Fills the "Video coming soon" placeholders in the Lesson Clips section
-- of the PowerPoint module (Module 5, "Microsoft PowerPoint – Dynamic
-- Presentations") in "Microsoft Digital Skills for University Prep".
--
-- Lesson Clips are the module's STUDENT CHECKLIST ITEMS, rendered by
-- ChecklistSection with an embedded video (video_url) and a bilingual
-- practice task. This sets an English tutorial video + EN/ID practice task
-- on each of the 5 items. Every video was oEmbed-verified as embeddable.
--
-- (Separate from the 📎 Materi resources added by
-- powerpoint-clips-resources.sql — this fills the checklist-item videos.)
--
-- Idempotent: plain UPDATEs, safe to re-run. Run in the Supabase SQL Editor.
-- ============================================================

-- Ensure the clip columns exist (added earlier for the Excel clips)
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS video_url        TEXT;
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS practice_task    TEXT;
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS practice_task_id TEXT;

DO $$
DECLARE
  v_mod_id UUID;
BEGIN
  SELECT m.id INTO v_mod_id
    FROM course_modules m
    JOIN courses c ON c.id = m.course_id
   WHERE c.title = 'Microsoft Digital Skills for University Prep'
     AND m.title LIKE 'Microsoft PowerPoint%'
   LIMIT 1;

  IF v_mod_id IS NULL THEN
    RAISE EXCEPTION 'PowerPoint module not found — nothing changed.';
  END IF;

  -- 1) Applied a consistent theme and layout to a presentation
  UPDATE module_checklist_items SET
    video_url        = 'https://www.youtube.com/watch?v=UH7Gzjd3rGA',
    practice_task    = 'Apply a theme, try a colour variant, and give your slides a consistent layout.',
    practice_task_id = 'Terapkan sebuah tema, coba varian warna, dan gunakan layout yang konsisten di semua slide.'
  WHERE course_module_id = v_mod_id AND item_key = 'ms_5_s_1';

  -- 2) Added slide transitions and animations appropriately
  UPDATE module_checklist_items SET
    video_url        = 'https://www.youtube.com/watch?v=jNxxU0tpHlQ',
    practice_task    = 'Add a transition to all slides, then give a title one entrance animation.',
    practice_task_id = 'Tambahkan transisi ke semua slide, lalu beri judul satu animasi masuk.'
  WHERE course_module_id = v_mod_id AND item_key = 'ms_5_s_2';

  -- 3) Inserted an image and a chart into a slide
  UPDATE module_checklist_items SET
    video_url        = 'https://www.youtube.com/watch?v=DMBjDPrcWF0',
    practice_task    = 'Insert a picture and a column chart onto one slide, then resize them neatly.',
    practice_task_id = 'Sisipkan sebuah gambar dan grafik kolom ke dalam satu slide, lalu rapikan ukurannya.'
  WHERE course_module_id = v_mod_id AND item_key = 'ms_5_s_3';

  -- 4) Practised presenting using Slide Show view
  UPDATE module_checklist_items SET
    video_url        = 'https://www.youtube.com/watch?v=X0gH_N2X8cQ',
    practice_task    = 'Start the slide show in Presenter View and use the timer and next-slide preview.',
    practice_task_id = 'Jalankan slide show dengan Presenter View dan gunakan timer serta pratinjau slide berikutnya.'
  WHERE course_module_id = v_mod_id AND item_key = 'ms_5_s_4';

  -- 5) Exported the presentation as a PDF
  UPDATE module_checklist_items SET
    video_url        = 'https://www.youtube.com/watch?v=fg2JvYheg74',
    practice_task    = 'Export your finished presentation as a PDF, then open it to check the slides.',
    practice_task_id = 'Ekspor presentasimu yang sudah jadi sebagai PDF, lalu buka untuk memeriksa slide-nya.'
  WHERE course_module_id = v_mod_id AND item_key = 'ms_5_s_5';

  RAISE NOTICE 'Set videos + practice tasks on the 5 PowerPoint lesson clips.';
END $$;

-- Verify: expect 5 rows, each with a youtube video_url and a practice task.
SELECT i.item_key, i.label,
       (i.video_url IS NOT NULL)     AS has_video,
       (i.practice_task IS NOT NULL) AS has_task
  FROM module_checklist_items i
  JOIN course_modules m ON m.id = i.course_module_id
 WHERE m.title LIKE 'Microsoft PowerPoint%'
   AND i.item_type = 'student'
 ORDER BY i.sort_order;

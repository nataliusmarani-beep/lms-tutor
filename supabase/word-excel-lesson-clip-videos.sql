-- ============================================================
-- word-excel-lesson-clip-videos.sql
-- Fills the Lesson Clips ("Video coming soon") in the Word (Module 3) and
-- Excel (Module 4) modules of "Microsoft Digital Skills for University Prep"
-- with an English + a Bahasa Indonesia video and a bilingual practice task
-- on each student checklist item. Mirrors powerpoint-lesson-clip-videos.sql.
-- ChecklistSection shows the ID video (video_url_id) when viewing in
-- Indonesian, else the English one. All videos oEmbed-verified.
-- Idempotent UPDATEs. Run in the Supabase SQL Editor.
-- ============================================================

ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS video_url        TEXT;
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS video_url_id     TEXT;
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS practice_task    TEXT;
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS practice_task_id TEXT;

DO $$
DECLARE v_mod_id UUID;
BEGIN
  -- ── Module 3 · Microsoft Word ──────────────────────────────
  SELECT m.id INTO v_mod_id FROM course_modules m JOIN courses c ON c.id=m.course_id
   WHERE c.title = 'Microsoft Digital Skills for University Prep' AND m.title LIKE 'Microsoft Word%' LIMIT 1;
  IF v_mod_id IS NULL THEN RAISE EXCEPTION 'Word module not found in Digital Skills course'; END IF;
  UPDATE module_checklist_items SET
    video_url = 'https://www.youtube.com/watch?v=tKbXkiKSD6o', video_url_id = 'https://www.youtube.com/watch?v=Nz0Gh57rd4A',
    practice_task = 'Apply Heading 1 to your title and Heading 2 to two subheadings.', practice_task_id = 'Terapkan Heading 1 pada judul dan Heading 2 pada dua subjudul.'
  WHERE course_module_id = v_mod_id AND item_key = 'ms_3_s_1';
  UPDATE module_checklist_items SET
    video_url = 'https://www.youtube.com/watch?v=pf8xv4PqnRs', video_url_id = 'https://www.youtube.com/watch?v=1ENNOeCYUAA',
    practice_task = 'Run Spelling & Grammar check and fix the flagged mistakes.', practice_task_id = 'Jalankan pemeriksaan Ejaan & Tata Bahasa dan perbaiki kesalahan yang ditandai.'
  WHERE course_module_id = v_mod_id AND item_key = 'ms_3_s_2';
  UPDATE module_checklist_items SET
    video_url = 'https://www.youtube.com/watch?v=4QQnh9pkvv0', video_url_id = 'https://www.youtube.com/watch?v=58_8ySNJ2cA',
    practice_task = 'Turn on Track Changes, edit a sentence, then accept the change.', practice_task_id = 'Aktifkan Track Changes, edit satu kalimat, lalu terima perubahannya.'
  WHERE course_module_id = v_mod_id AND item_key = 'ms_3_s_3';
  UPDATE module_checklist_items SET
    video_url = 'https://www.youtube.com/watch?v=_gklpjgaVSo', video_url_id = 'https://www.youtube.com/watch?v=Exywv-qetZ0',
    practice_task = 'Create a new document from a Word template.', practice_task_id = 'Buat dokumen baru dari sebuah template Word.'
  WHERE course_module_id = v_mod_id AND item_key = 'ms_3_s_4';
  UPDATE module_checklist_items SET
    video_url = 'https://www.youtube.com/watch?v=P9uWUz-e1V0', video_url_id = 'https://www.youtube.com/watch?v=5R35dR22Hgc',
    practice_task = 'Export your document as a PDF and open it to check.', practice_task_id = 'Ekspor dokumenmu sebagai PDF dan buka untuk memeriksanya.'
  WHERE course_module_id = v_mod_id AND item_key = 'ms_3_s_5';

  -- ── Module 4 · Microsoft Excel ─────────────────────────────
  SELECT m.id INTO v_mod_id FROM course_modules m JOIN courses c ON c.id=m.course_id
   WHERE c.title = 'Microsoft Digital Skills for University Prep' AND m.title LIKE 'Microsoft Excel%' LIMIT 1;
  IF v_mod_id IS NULL THEN RAISE EXCEPTION 'Excel module not found in Digital Skills course'; END IF;
  UPDATE module_checklist_items SET
    video_url = 'https://www.youtube.com/watch?v=MFSvwFUirEM', video_url_id = 'https://www.youtube.com/watch?v=ctMaR7yG-Rs',
    practice_task = 'Type a small table of data and format the header row (bold, fill colour).', practice_task_id = 'Ketik tabel data kecil dan format baris judulnya (tebal, warna latar).'
  WHERE course_module_id = v_mod_id AND item_key = 'ms_4_s_1';
  UPDATE module_checklist_items SET
    video_url = 'https://www.youtube.com/watch?v=oSa7pP5um_s', video_url_id = 'https://www.youtube.com/watch?v=v8w5vWheSoM',
    practice_task = 'Use SUM to total a column, AVERAGE for the mean, and COUNT for how many.', practice_task_id = 'Pakai SUM untuk menjumlahkan kolom, AVERAGE untuk rata-rata, dan COUNT untuk menghitung jumlah.'
  WHERE course_module_id = v_mod_id AND item_key = 'ms_4_s_2';
  UPDATE module_checklist_items SET
    video_url = 'https://www.youtube.com/watch?v=64DSXejsYbo', video_url_id = 'https://www.youtube.com/watch?v=FdzvFJ6Dc0U',
    practice_task = 'Select a data range and create a column chart from it.', practice_task_id = 'Pilih rentang data dan buat grafik kolom darinya.'
  WHERE course_module_id = v_mod_id AND item_key = 'ms_4_s_3';
  UPDATE module_checklist_items SET
    video_url = 'https://www.youtube.com/watch?v=YkaYOSduu40', video_url_id = 'https://www.youtube.com/watch?v=PSHpJRewxPY',
    practice_task = 'Sort your data A-Z, then filter to show only one category.', practice_task_id = 'Urutkan datamu A-Z, lalu filter untuk menampilkan satu kategori saja.'
  WHERE course_module_id = v_mod_id AND item_key = 'ms_4_s_4';
  UPDATE module_checklist_items SET
    video_url = 'https://www.youtube.com/watch?v=ryrz6UVvOwM', video_url_id = 'https://www.youtube.com/watch?v=yF_tnM7BJTg',
    practice_task = 'Add borders, a fill colour, and a currency/number format to your cells.', practice_task_id = 'Tambahkan border, warna latar, dan format mata uang/angka pada sel-mu.'
  WHERE course_module_id = v_mod_id AND item_key = 'ms_4_s_5';

  RAISE NOTICE 'Set EN+ID videos on the Word and Excel lesson clips.';
END $$;

-- Verify: expect 10 rows, each with EN video, ID video, and a task.
SELECT m.title AS module, i.item_key,
       (i.video_url IS NOT NULL)    AS en, (i.video_url_id IS NOT NULL) AS id,
       (i.practice_task IS NOT NULL) AS task
  FROM module_checklist_items i JOIN course_modules m ON m.id=i.course_module_id
 WHERE m.course_id=(SELECT id FROM courses WHERE title='Microsoft Digital Skills for University Prep')
   AND (m.title LIKE 'Microsoft Word%' OR m.title LIKE 'Microsoft Excel%')
   AND i.item_type='student'
 ORDER BY m.title, i.sort_order;

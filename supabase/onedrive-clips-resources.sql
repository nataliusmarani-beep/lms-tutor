-- ============================================================
-- onedrive-clips-resources.sql
-- 15 OneDrive & cloud-storage topics as WATCHABLE RESOURCES on the
-- existing "OneDrive & Cloud Storage" module (Week 6) inside
-- "Microsoft Digital Skills for University Prep" — same setup as the
-- Word / Excel / PowerPoint clips (one course).
--
-- Per topic, two videos are added under Materi/Resources:
--   * an English tutorial      (sort_order 2k-1)
--   * a Bahasa Indonesia one   (sort_order 2k, title prefixed "ID · ")
-- Titles grouped "Group · Topic" across 3 groups (Cloud Basics,
-- Sync & Access, Sharing & Managing Files). Each description is that
-- topic's practice task in the matching language.
--
-- Every video was oEmbed-checked (embeddable) and language-confirmed from
-- its canonical title/channel. OneDrive had unusually heavy YouTube title
-- localisation, so every pick was validated against its canonical title.
--
-- Resources only: the module keeps its own checklist items and quiz.
-- Idempotent: re-running replaces only the clip videos this file added
-- (matched by title prefix), leaving the module's original resources alone.
-- Run in the Supabase SQL Editor.
-- ============================================================

DO $$
DECLARE
  v_mod_id UUID;
BEGIN
  SELECT m.id INTO v_mod_id
    FROM course_modules m
    JOIN courses c ON c.id = m.course_id
   WHERE c.title = 'Microsoft Digital Skills for University Prep'
     AND m.title LIKE 'OneDrive%'
   LIMIT 1;

  IF v_mod_id IS NULL THEN
    RAISE EXCEPTION 'OneDrive module not found in the Digital Skills course — nothing changed.';
  END IF;

  DELETE FROM module_resources
   WHERE course_module_id = v_mod_id
     AND (title LIKE 'Cloud Basics · %' OR title LIKE 'Sync & Access · %' OR title LIKE 'Sharing & Managing Files · %' OR title LIKE 'ID · %');

  INSERT INTO module_resources
    (course_module_id, resource_type, title, url, description, sort_order) VALUES
    (v_mod_id, 'video', 'Cloud Basics · What is OneDrive & cloud storage', 'https://www.youtube.com/watch?v=kc4JvqGEM-M', 'In your own words, explain what OneDrive is and one benefit of keeping files in the cloud.', 1),
    (v_mod_id, 'video', 'ID · Dasar Cloud · Apa itu OneDrive & cloud storage', 'https://www.youtube.com/watch?v=O7jeP76ESj8', 'Dengan kata-katamu sendiri, jelaskan apa itu OneDrive dan satu manfaat menyimpan file di cloud.', 2),
    (v_mod_id, 'video', 'Cloud Basics · Signing in to OneDrive', 'https://www.youtube.com/watch?v=YQRTZku2glc', 'Sign in to OneDrive with your Microsoft account on onedrive.com.', 3),
    (v_mod_id, 'video', 'ID · Dasar Cloud · Masuk (login) ke OneDrive', 'https://www.youtube.com/watch?v=QKTzPGR4htw', 'Masuk ke OneDrive dengan akun Microsoft-mu di onedrive.com.', 4),
    (v_mod_id, 'video', 'Cloud Basics · Uploading files and folders', 'https://www.youtube.com/watch?v=grXApvc8isU', 'Upload one file and one whole folder to OneDrive.', 5),
    (v_mod_id, 'video', 'ID · Dasar Cloud · Mengunggah file dan folder', 'https://www.youtube.com/watch?v=GfKU5mYD4bQ', 'Unggah satu file dan satu folder utuh ke OneDrive.', 6),
    (v_mod_id, 'video', 'Cloud Basics · Downloading files', 'https://www.youtube.com/watch?v=BpkcId4Umhg', 'Download a file from OneDrive back to your computer.', 7),
    (v_mod_id, 'video', 'ID · Dasar Cloud · Mengunduh file', 'https://www.youtube.com/watch?v=udNyUfDq1nk', 'Unduh sebuah file dari OneDrive kembali ke komputermu.', 8),
    (v_mod_id, 'video', 'Cloud Basics · Creating folders and organising files', 'https://www.youtube.com/watch?v=Olu7hk_AWV8', 'Create two folders and move three files into them to stay organised.', 9),
    (v_mod_id, 'video', 'ID · Dasar Cloud · Membuat folder dan merapikan file', 'https://www.youtube.com/watch?v=03VztnMG0wg', 'Buat dua folder dan pindahkan tiga file ke dalamnya agar rapi.', 10),
    (v_mod_id, 'video', 'Sync & Access · Setting up OneDrive sync on your PC', 'https://www.youtube.com/watch?v=wZlGiqYmrkI', 'Install or turn on OneDrive on a PC and let one folder sync.', 11),
    (v_mod_id, 'video', 'ID · Sinkronisasi & Akses · Mengatur sinkronisasi OneDrive di PC', 'https://www.youtube.com/watch?v=ebl1tQYO3U8', 'Pasang atau aktifkan OneDrive di PC dan biarkan satu folder tersinkron.', 12),
    (v_mod_id, 'video', 'Sync & Access · OneDrive on the web (any browser)', 'https://www.youtube.com/watch?v=MkJPG-1QrmE', 'Open onedrive.com in a browser and find a file you uploaded earlier.', 13),
    (v_mod_id, 'video', 'ID · Sinkronisasi & Akses · OneDrive di web (browser apa saja)', 'https://www.youtube.com/watch?v=gO9CIipcQFk', 'Buka onedrive.com di browser dan temukan file yang tadi kamu unggah.', 14),
    (v_mod_id, 'video', 'Sync & Access · Using the OneDrive mobile app', 'https://www.youtube.com/watch?v=vfzAFQ54DIU', 'Open the OneDrive app on a phone and view your files.', 15),
    (v_mod_id, 'video', 'ID · Sinkronisasi & Akses · Menggunakan aplikasi OneDrive di HP', 'https://www.youtube.com/watch?v=q1owHjNHFO8', 'Buka aplikasi OneDrive di HP dan lihat file-mu.', 16),
    (v_mod_id, 'video', 'Sync & Access · Auto-backup of Desktop, Documents & Photos', 'https://www.youtube.com/watch?v=DtduNsOXVlw', 'Turn on backup so your Desktop, Documents and Photos save to OneDrive.', 17),
    (v_mod_id, 'video', 'ID · Sinkronisasi & Akses · Backup otomatis Desktop, Dokumen & Foto', 'https://www.youtube.com/watch?v=XYyVGpRsmYo', 'Aktifkan backup agar Desktop, Dokumen, dan Foto tersimpan ke OneDrive.', 18),
    (v_mod_id, 'video', 'Sharing & Managing Files · Sharing a file or folder', 'https://www.youtube.com/watch?v=KmzWo8n0oec', 'Share one file or folder with a classmate.', 19),
    (v_mod_id, 'video', 'ID · Berbagi & Mengelola File · Berbagi file atau folder', 'https://www.youtube.com/watch?v=z-b4FS7Vl08', 'Bagikan satu file atau folder ke temanmu.', 20),
    (v_mod_id, 'video', 'Sharing & Managing Files · Sharing links and permissions', 'https://www.youtube.com/watch?v=RErtkfQ8Zpg', 'Change a shared link to view-only, then to edit.', 21),
    (v_mod_id, 'video', 'ID · Berbagi & Mengelola File · Tautan berbagi dan izin akses', 'https://www.youtube.com/watch?v=7baEBWcnwJk', 'Ubah tautan berbagi menjadi hanya-lihat, lalu menjadi bisa-edit.', 22),
    (v_mod_id, 'video', 'Sharing & Managing Files · Co-authoring in real time', 'https://www.youtube.com/watch?v=7goYd-B1_sM', 'Open a shared document and edit it at the same time as a classmate.', 23),
    (v_mod_id, 'video', 'ID · Berbagi & Mengelola File · Menyunting bersama secara real-time', 'https://www.youtube.com/watch?v=TYbAPEk496g', 'Buka dokumen bersama dan sunting bersamaan dengan temanmu.', 24),
    (v_mod_id, 'video', 'Sharing & Managing Files · Version history (restore older versions)', 'https://www.youtube.com/watch?v=fEm6PNT1opA', 'Open a file''s Version History and restore an earlier version.', 25),
    (v_mod_id, 'video', 'ID · Berbagi & Mengelola File · Riwayat versi (memulihkan versi lama)', 'https://www.youtube.com/watch?v=P3elP0wHPyU', 'Buka Riwayat Versi sebuah file dan pulihkan versi sebelumnya.', 26),
    (v_mod_id, 'video', 'Sharing & Managing Files · Recycle Bin (recover deleted files)', 'https://www.youtube.com/watch?v=vlYCp02txK4', 'Delete a file, then recover it from the OneDrive Recycle Bin.', 27),
    (v_mod_id, 'video', 'ID · Berbagi & Mengelola File · Recycle Bin (memulihkan file terhapus)', 'https://www.youtube.com/watch?v=mh_iMcl_bdg', 'Hapus sebuah file, lalu pulihkan dari Recycle Bin OneDrive.', 28),
    (v_mod_id, 'video', 'Sharing & Managing Files · Managing your storage space', 'https://www.youtube.com/watch?v=XzHozNuYnkA', 'Check how much OneDrive storage you have used and free up some space.', 29),
    (v_mod_id, 'video', 'ID · Berbagi & Mengelola File · Mengelola ruang penyimpanan', 'https://www.youtube.com/watch?v=kPkuVNQSGek', 'Periksa berapa banyak penyimpanan OneDrive yang terpakai dan kosongkan sebagian.', 30);

  RAISE NOTICE 'OneDrive clips added: 15 topics, 30 videos (EN + ID).';
END $$;

-- Verify: expect clip_videos = 30 on the OneDrive module; checklist + quiz intact.
SELECT m.title,
       count(DISTINCT r.id) FILTER (WHERE r.url LIKE '%youtube.com/%') AS youtube_videos,
       count(DISTINCT i.id) AS checklist_items,
       count(DISTINCT q.id) AS quizzes
  FROM course_modules m
  LEFT JOIN module_resources r       ON r.course_module_id = m.id
  LEFT JOIN module_checklist_items i ON i.course_module_id = m.id
  LEFT JOIN module_quizzes q         ON q.course_module_id = m.id
 WHERE m.title LIKE 'OneDrive%'
   AND m.course_id = (SELECT id FROM courses WHERE title = 'Microsoft Digital Skills for University Prep')
 GROUP BY m.title;

-- ============================================================
-- powerpoint-clips-resources.sql
-- 30 PowerPoint short-clip topics as WATCHABLE RESOURCES on the existing
-- "Microsoft PowerPoint – Dynamic Presentations" module inside
-- "Microsoft Digital Skills for University Prep".
--
-- Per topic, two videos are added under Materi/Resources:
--   * an English tutorial      (sort_order 2k-1)
--   * a Bahasa Indonesia one   (sort_order 2k, title prefixed "ID · ")
-- Each description is that topic's practice task in the matching language.
--
-- Every video was checked against the YouTube oEmbed endpoint: embeddable,
-- and its canonical title/channel confirms the language (YouTube localises
-- titles in search results, so search text alone is not trustworthy).
--
-- Nothing here is graded: these are resources, not checklist items, so the
-- module's progress and quiz are untouched.
--
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
     AND m.title LIKE 'Microsoft PowerPoint%'
   LIMIT 1;

  IF v_mod_id IS NULL THEN
    RAISE EXCEPTION 'PowerPoint module not found in the Digital Skills course — nothing changed.';
  END IF;

  -- Refresh only the clip videos added by this file
  DELETE FROM module_resources
   WHERE course_module_id = v_mod_id
     AND (title LIKE 'Slides & Text · %' OR title LIKE 'Design · %' OR title LIKE 'Visuals · %' OR title LIKE 'Animation · %' OR title LIKE 'Delivery · %' OR title LIKE 'ID · %');

  INSERT INTO module_resources
    (course_module_id, resource_type, title, url, description, sort_order) VALUES
    (v_mod_id, 'video', 'Slides & Text · PowerPoint interface tour (ribbon, slide pane, notes)', 'https://www.youtube.com/watch?v=PdUG2o7ocgk', 'Open a blank presentation and point out the ribbon, the slide pane, and the notes pane.', 1),
    (v_mod_id, 'video', 'ID · Slide & Teks · Tur antarmuka PowerPoint (ribbon, panel slide, catatan)', 'https://www.youtube.com/watch?v=jgG4oQCdl2w', 'Buka presentasi kosong dan tunjukkan ribbon, panel slide, dan panel catatan.', 2),
    (v_mod_id, 'video', 'Slides & Text · Creating slides and choosing layouts', 'https://www.youtube.com/watch?v=oKgXeNbKyF4', 'Add three new slides and give each one a different layout (Title, Title & Content, Blank).', 3),
    (v_mod_id, 'video', 'ID · Slide & Teks · Membuat slide dan memilih layout', 'https://www.youtube.com/watch?v=vzom_kNG3To', 'Tambahkan tiga slide baru dan beri masing-masing layout berbeda (Title, Title & Content, Blank).', 4),
    (v_mod_id, 'video', 'Slides & Text · Adding and formatting text', 'https://www.youtube.com/watch?v=lzJrj8XRqNM', 'Add a text box, type a heading, then change its font, size, and colour.', 5),
    (v_mod_id, 'video', 'ID · Slide & Teks · Menambahkan dan memformat teks', 'https://www.youtube.com/watch?v=u4ku-XCR9ec', 'Tambahkan kotak teks, ketik sebuah judul, lalu ubah font, ukuran, dan warnanya.', 6),
    (v_mod_id, 'video', 'Slides & Text · Bullet lists and indent levels', 'https://www.youtube.com/watch?v=fhLlISfmGqA', 'Write a 4-point list, then use Tab to demote two of them to a second level.', 7),
    (v_mod_id, 'video', 'ID · Slide & Teks · Daftar poin dan tingkat indentasi', 'https://www.youtube.com/watch?v=tMeE-GDrFNE', 'Tulis daftar 4 poin, lalu pakai Tab untuk menurunkan dua di antaranya ke level kedua.', 8),
    (v_mod_id, 'video', 'Slides & Text · Reordering, duplicating and deleting slides', 'https://www.youtube.com/watch?v=Kf-9mWnOx6Y', 'Duplicate a slide, drag it to the end, then delete one you do not need.', 9),
    (v_mod_id, 'video', 'ID · Slide & Teks · Mengurutkan, menggandakan, dan menghapus slide', 'https://www.youtube.com/watch?v=zrB5Ij6I-Hg', 'Gandakan sebuah slide, seret ke posisi terakhir, lalu hapus slide yang tidak diperlukan.', 10),
    (v_mod_id, 'video', 'Slides & Text · Organising a deck with sections', 'https://www.youtube.com/watch?v=7o9gigXvIlo', 'Split your slides into two sections and give each section a name.', 11),
    (v_mod_id, 'video', 'ID · Slide & Teks · Merapikan presentasi dengan section', 'https://www.youtube.com/watch?v=FPCtDAtaJXE', 'Bagi slide-mu menjadi dua section dan beri nama masing-masing section.', 12),
    (v_mod_id, 'video', 'Design · Themes and variants', 'https://www.youtube.com/watch?v=UH7Gzjd3rGA', 'Apply a theme to your deck, then try a different colour variant of it.', 13),
    (v_mod_id, 'video', 'ID · Desain · Tema dan varian', 'https://www.youtube.com/watch?v=rMAFRobkb_U', 'Terapkan sebuah tema ke presentasimu, lalu coba varian warna yang berbeda.', 14),
    (v_mod_id, 'video', 'Design · Slide Master basics', 'https://www.youtube.com/watch?v=QiVSIvB1xis', 'Open Slide Master and change the title font once — check that every slide updates.', 15),
    (v_mod_id, 'video', 'ID · Desain · Dasar Slide Master', 'https://www.youtube.com/watch?v=HB-xyEgYyoA', 'Buka Slide Master dan ubah font judul sekali — periksa semua slide ikut berubah.', 16),
    (v_mod_id, 'video', 'Design · Theme colours and fonts', 'https://www.youtube.com/watch?v=7Z1xdPb3-qw', 'Change the theme''s font and colour set, and see how the whole deck follows.', 17),
    (v_mod_id, 'video', 'ID · Desain · Warna dan font tema', 'https://www.youtube.com/watch?v=4L7gV0nQEpQ', 'Ubah set font dan warna tema, lalu lihat bagaimana seluruh presentasi mengikuti.', 18),
    (v_mod_id, 'video', 'Design · Slide backgrounds', 'https://www.youtube.com/watch?v=1-GbcMG6uh4', 'Give one slide a solid colour background and another a picture background.', 19),
    (v_mod_id, 'video', 'ID · Desain · Latar belakang slide', 'https://www.youtube.com/watch?v=zEq_j5LO_nI', 'Beri satu slide latar warna solid dan slide lain latar berupa gambar.', 20),
    (v_mod_id, 'video', 'Design · Align, distribute and smart guides', 'https://www.youtube.com/watch?v=6F6qR5hyI6E', 'Place three shapes, then align them to the top and distribute them evenly.', 21),
    (v_mod_id, 'video', 'ID · Desain · Rata, distribusi, dan garis bantu', 'https://www.youtube.com/watch?v=KRxHPwz0WbE', 'Letakkan tiga bentuk, lalu ratakan ke atas dan distribusikan jaraknya merata.', 22),
    (v_mod_id, 'video', 'Design · Slide numbers, headers and footers', 'https://www.youtube.com/watch?v=zw_9m2Mqckw', 'Turn on slide numbers and add a footer with your name to every slide.', 23),
    (v_mod_id, 'video', 'ID · Desain · Nomor slide, header dan footer', 'https://www.youtube.com/watch?v=biucj-O2dY0', 'Aktifkan nomor slide dan tambahkan footer berisi namamu di semua slide.', 24),
    (v_mod_id, 'video', 'Visuals · Inserting and cropping pictures', 'https://www.youtube.com/watch?v=8GQCQiPlfJ0', 'Insert a photo, crop it to a square, then crop it to a shape.', 25),
    (v_mod_id, 'video', 'ID · Visual · Menyisipkan dan memotong gambar', 'https://www.youtube.com/watch?v=susNjwgC9kI', 'Sisipkan foto, potong menjadi persegi, lalu potong mengikuti sebuah bentuk.', 26),
    (v_mod_id, 'video', 'Visuals · Removing an image background', 'https://www.youtube.com/watch?v=f2mtp3SEWEg', 'Insert a photo of a person or object and remove its background.', 27),
    (v_mod_id, 'video', 'ID · Visual · Menghapus latar gambar', 'https://www.youtube.com/watch?v=pLuhy0shbeA', 'Sisipkan foto orang atau benda lalu hapus latar belakangnya.', 28),
    (v_mod_id, 'video', 'Visuals · Icons and SmartArt', 'https://www.youtube.com/watch?v=ZQK5O_Xe1kY', 'Turn a 3-point bullet list into a SmartArt graphic, then add an icon.', 29),
    (v_mod_id, 'video', 'ID · Visual · Ikon dan SmartArt', 'https://www.youtube.com/watch?v=WCbxVXlIijE', 'Ubah daftar 3 poin menjadi grafik SmartArt, lalu tambahkan sebuah ikon.', 30),
    (v_mod_id, 'video', 'Visuals · Shapes and Merge Shapes', 'https://www.youtube.com/watch?v=yKhF5vhcksk', 'Overlap two shapes and try Union, Subtract, and Intersect on them.', 31),
    (v_mod_id, 'video', 'ID · Visual · Bentuk dan Merge Shapes', 'https://www.youtube.com/watch?v=Hyjw8dNazLM', 'Tumpuk dua bentuk lalu coba Union, Subtract, dan Intersect.', 32),
    (v_mod_id, 'video', 'Visuals · Charts in PowerPoint', 'https://www.youtube.com/watch?v=DMBjDPrcWF0', 'Insert a column chart and edit its data to show three months of sales.', 33),
    (v_mod_id, 'video', 'ID · Visual · Grafik di PowerPoint', 'https://www.youtube.com/watch?v=26JqD-uDluU', 'Sisipkan grafik kolom dan ubah datanya untuk menampilkan penjualan tiga bulan.', 34),
    (v_mod_id, 'video', 'Visuals · Tables in PowerPoint', 'https://www.youtube.com/watch?v=PnlpjsEMikM', 'Insert a 3x4 table and apply a table style to it.', 35),
    (v_mod_id, 'video', 'ID · Visual · Tabel di PowerPoint', 'https://www.youtube.com/watch?v=XJ3bQrhGtD0', 'Sisipkan tabel 3x4 dan terapkan satu table style padanya.', 36),
    (v_mod_id, 'video', 'Animation · Slide transitions', 'https://www.youtube.com/watch?v=jNxxU0tpHlQ', 'Apply a transition to one slide, then apply it to all slides.', 37),
    (v_mod_id, 'video', 'ID · Animasi · Transisi slide', 'https://www.youtube.com/watch?v=kMCFzUVYAqM', 'Terapkan transisi pada satu slide, lalu terapkan ke semua slide.', 38),
    (v_mod_id, 'video', 'Animation · Entrance and exit animations', 'https://www.youtube.com/watch?v=fd-0_MbUsjg', 'Give a title an entrance animation and an image an exit animation.', 39),
    (v_mod_id, 'video', 'ID · Animasi · Animasi masuk dan keluar', 'https://www.youtube.com/watch?v=lcwNFeafSp4', 'Beri judul animasi masuk dan beri gambar animasi keluar.', 40),
    (v_mod_id, 'video', 'Animation · The Animation Pane and timing', 'https://www.youtube.com/watch?v=DAiE41g5DWs', 'Open the Animation Pane, reorder two animations, then set one to start After Previous.', 41),
    (v_mod_id, 'video', 'ID · Animasi · Panel animasi dan pengaturan waktu', 'https://www.youtube.com/watch?v=yHNE7IDamDk', 'Buka Animation Pane, ubah urutan dua animasi, lalu atur satu menjadi After Previous.', 42),
    (v_mod_id, 'video', 'Animation · Morph transition', 'https://www.youtube.com/watch?v=7u5mQ6rfows', 'Duplicate a slide, move and resize one shape, then apply Morph between them.', 43),
    (v_mod_id, 'video', 'ID · Animasi · Transisi Morph', 'https://www.youtube.com/watch?v=Q_NNjGWCbRI', 'Gandakan slide, pindahkan dan ubah ukuran satu bentuk, lalu terapkan Morph di antaranya.', 44),
    (v_mod_id, 'video', 'Animation · Motion paths', 'https://www.youtube.com/watch?v=724rFztvZsY', 'Make a shape travel across the slide using a motion path animation.', 45),
    (v_mod_id, 'video', 'ID · Animasi · Jalur gerak (motion path)', 'https://www.youtube.com/watch?v=4uMQm9gHkb8', 'Buat sebuah bentuk bergerak melintasi slide memakai animasi motion path.', 46),
    (v_mod_id, 'video', 'Animation · Video and audio on slides', 'https://www.youtube.com/watch?v=UJBCanWJD0k', 'Insert a short video and set it to start automatically.', 47),
    (v_mod_id, 'video', 'ID · Animasi · Video dan audio di slide', 'https://www.youtube.com/watch?v=lM-oIBjIqo4', 'Sisipkan video pendek dan atur agar mulai otomatis.', 48),
    (v_mod_id, 'video', 'Delivery · Presenter View', 'https://www.youtube.com/watch?v=X0gH_N2X8cQ', 'Start a slide show in Presenter View and find the timer and next-slide preview.', 49),
    (v_mod_id, 'video', 'ID · Presentasi · Tampilan Presenter', 'https://www.youtube.com/watch?v=084fXezLy2Y', 'Jalankan slide show dengan Presenter View dan temukan timer serta pratinjau slide berikutnya.', 50),
    (v_mod_id, 'video', 'Delivery · Speaker notes', 'https://www.youtube.com/watch?v=MIcWwXuIwuU', 'Write speaker notes on three slides and read them in Presenter View.', 51),
    (v_mod_id, 'video', 'ID · Presentasi · Catatan pembicara', 'https://www.youtube.com/watch?v=qfdSM-Cev90', 'Tulis catatan pembicara di tiga slide dan baca lewat Presenter View.', 52),
    (v_mod_id, 'video', 'Delivery · Rehearse timings', 'https://www.youtube.com/watch?v=wjrgHhqO44U', 'Use Rehearse Timings to practise your deck and record how long each slide takes.', 53),
    (v_mod_id, 'video', 'ID · Presentasi · Melatih durasi (Rehearse Timings)', 'https://www.youtube.com/watch?v=v6XaaXr4qaY', 'Pakai Rehearse Timings untuk berlatih dan merekam durasi tiap slide.', 54),
    (v_mod_id, 'video', 'Delivery · Exporting to PDF', 'https://www.youtube.com/watch?v=fg2JvYheg74', 'Export your deck as a PDF and open it to check the slides look right.', 55),
    (v_mod_id, 'video', 'ID · Presentasi · Ekspor ke PDF', 'https://www.youtube.com/watch?v=Igrt_tmJubA', 'Ekspor presentasimu jadi PDF dan buka untuk memastikan slide tampil benar.', 56),
    (v_mod_id, 'video', 'Delivery · Exporting as a video', 'https://www.youtube.com/watch?v=86MZnQYzPYA', 'Export your presentation as an MP4 video and play it back.', 57),
    (v_mod_id, 'video', 'ID · Presentasi · Ekspor menjadi video', 'https://www.youtube.com/watch?v=JH8rL5RAF6k', 'Ekspor presentasimu menjadi video MP4 lalu putar hasilnya.', 58),
    (v_mod_id, 'video', 'Delivery · Printing handouts', 'https://www.youtube.com/watch?v=Itj0ZM93f14', 'Use Print to make a handout with 4 slides per page (printing to PDF is fine).', 59),
    (v_mod_id, 'video', 'ID · Presentasi · Mencetak handout', 'https://www.youtube.com/watch?v=k0IqM7cYud0', 'Pakai Print untuk membuat handout 4 slide per halaman (cetak ke PDF juga boleh).', 60);

  RAISE NOTICE 'PowerPoint clips added: 30 topics, 60 videos (EN + ID).';
END $$;

-- Verify: expect clip_videos = 60 on the PowerPoint module,
-- with its checklist items and quiz untouched.
SELECT m.title,
       count(DISTINCT r.id) FILTER (
         WHERE r.url LIKE '%youtube.com/%' AND (r.title LIKE 'ID · %' OR r.title LIKE '%·%')
       ) AS clip_videos,
       count(DISTINCT i.id) AS checklist_items,
       count(DISTINCT q.id) AS quizzes
  FROM course_modules m
  LEFT JOIN module_resources r       ON r.course_module_id = m.id
  LEFT JOIN module_checklist_items i ON i.course_module_id = m.id
  LEFT JOIN module_quizzes q         ON q.course_module_id = m.id
 WHERE m.title LIKE 'Microsoft PowerPoint%'
 GROUP BY m.title;

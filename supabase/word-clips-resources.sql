-- ============================================================
-- word-clips-resources.sql
-- 30 Microsoft Word short-clip topics as WATCHABLE RESOURCES on the
-- existing "Microsoft Word – Professional Documents" module inside
-- "Microsoft Digital Skills for University Prep" — same setup as the
-- Excel and PowerPoint clips (one course).
--
-- Per topic, two videos are added under Materi/Resources:
--   * an English tutorial      (sort_order 2k-1)
--   * a Bahasa Indonesia one   (sort_order 2k, title prefixed "ID · ")
-- Titles grouped "Group · Topic" across 5 groups (Documents & Text,
-- Formatting Text, Page Layout, Visuals & Tables, References & Review).
-- Each description is that topic's practice task in the matching language.
--
-- Every video was oEmbed-checked (embeddable) and language-confirmed from
-- its canonical title/channel (YouTube localises search titles, which
-- disguised many EN videos as ID and vice-versa).
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
     AND m.title LIKE 'Microsoft Word%'
   LIMIT 1;

  IF v_mod_id IS NULL THEN
    RAISE EXCEPTION 'Word module not found in the Digital Skills course — nothing changed.';
  END IF;

  DELETE FROM module_resources
   WHERE course_module_id = v_mod_id
     AND (title LIKE 'Documents & Text · %' OR title LIKE 'Formatting Text · %' OR title LIKE 'Page Layout · %' OR title LIKE 'Visuals & Tables · %' OR title LIKE 'References & Review · %' OR title LIKE 'ID · %');

  INSERT INTO module_resources
    (course_module_id, resource_type, title, url, description, sort_order) VALUES
    (v_mod_id, 'video', 'Documents & Text · Word interface tour (ribbon, ruler, status bar)', 'https://www.youtube.com/watch?v=Y4hN2khT-Tc', 'Open a blank document and point out the ribbon tabs, the ruler, and the status bar.', 1),
    (v_mod_id, 'video', 'ID · Dokumen & Teks · Tur antarmuka Word (ribbon, penggaris, status bar)', 'https://www.youtube.com/watch?v=CgI0uMJwwrg', 'Buka dokumen kosong dan tunjukkan tab ribbon, penggaris, dan status bar.', 2),
    (v_mod_id, 'video', 'Documents & Text · Creating, saving and opening documents (.docx, PDF)', 'https://www.youtube.com/watch?v=PafCMUVH_OA', 'Type a sentence, save the file as .docx, then save a copy as PDF.', 3),
    (v_mod_id, 'video', 'ID · Dokumen & Teks · Membuat, menyimpan, dan membuka dokumen (.docx, PDF)', 'https://www.youtube.com/watch?v=Z6UQpCzhcoU', 'Ketik satu kalimat, simpan file sebagai .docx, lalu simpan salinan sebagai PDF.', 4),
    (v_mod_id, 'video', 'Documents & Text · Selecting and editing text', 'https://www.youtube.com/watch?v=5_HdVz_lWjI', 'Select a word by double-click, a sentence, then the whole document with Ctrl+A, and retype one word.', 5),
    (v_mod_id, 'video', 'ID · Dokumen & Teks · Memilih dan mengedit teks', 'https://www.youtube.com/watch?v=xWnDr5gF240', 'Pilih satu kata dengan klik ganda, satu kalimat, lalu seluruh dokumen dengan Ctrl+A, dan ketik ulang satu kata.', 6),
    (v_mod_id, 'video', 'Documents & Text · Cut, copy, paste and Format Painter', 'https://www.youtube.com/watch?v=_euO2Sfph0Y', 'Format one sentence (bold, coloured), then copy that look to another sentence with Format Painter.', 7),
    (v_mod_id, 'video', 'ID · Dokumen & Teks · Potong, salin, tempel, dan Format Painter', 'https://www.youtube.com/watch?v=oPf_Z5dJKd4', 'Format satu kalimat (tebal, berwarna), lalu salin tampilannya ke kalimat lain dengan Format Painter.', 8),
    (v_mod_id, 'video', 'Documents & Text · Find & Replace', 'https://www.youtube.com/watch?v=8ZSlu4DWJ5k', 'Use Find & Replace to change every occurrence of a word in your document.', 9),
    (v_mod_id, 'video', 'ID · Dokumen & Teks · Cari & Ganti', 'https://www.youtube.com/watch?v=ucxPbWlx04Y', 'Pakai Cari & Ganti untuk mengubah semua kemunculan sebuah kata di dokumenmu.', 10),
    (v_mod_id, 'video', 'Documents & Text · Undo, Redo and AutoCorrect', 'https://www.youtube.com/watch?v=19rgCLqJxrk', 'Type a few lines, undo three actions with Ctrl+Z, then redo them with Ctrl+Y.', 11),
    (v_mod_id, 'video', 'ID · Dokumen & Teks · Undo, Redo, dan AutoCorrect', 'https://www.youtube.com/watch?v=upiyL1WL4WI', 'Ketik beberapa baris, batalkan tiga tindakan dengan Ctrl+Z, lalu ulangi dengan Ctrl+Y.', 12),
    (v_mod_id, 'video', 'Formatting Text · Fonts: bold, italic, size and colour', 'https://www.youtube.com/watch?v=rRqWw9_IYwk', 'Make a heading bold size 16 in blue, and one word italic.', 13),
    (v_mod_id, 'video', 'ID · Memformat Teks · Font: tebal, miring, ukuran, dan warna', 'https://www.youtube.com/watch?v=AZJXKHD2FoM', 'Buat judul tebal ukuran 16 warna biru, dan satu kata miring.', 14),
    (v_mod_id, 'video', 'Formatting Text · Paragraph alignment and line spacing', 'https://www.youtube.com/watch?v=mXWvKHWe2Co', 'Centre a title, justify a paragraph, and set line spacing to 1.5.', 15),
    (v_mod_id, 'video', 'ID · Memformat Teks · Perataan paragraf dan spasi baris', 'https://www.youtube.com/watch?v=jg8rElCGl-E', 'Ratakan tengah judul, ratakan penuh satu paragraf, dan atur spasi baris 1,5.', 16),
    (v_mod_id, 'video', 'Formatting Text · Bulleted and numbered lists', 'https://www.youtube.com/watch?v=_w_IeEempwQ', 'Turn five lines into a bulleted list, then change it to a numbered list.', 17),
    (v_mod_id, 'video', 'ID · Memformat Teks · Daftar berpoin dan bernomor', 'https://www.youtube.com/watch?v=CHLP1cEUf6w', 'Ubah lima baris menjadi daftar berpoin, lalu ubah menjadi daftar bernomor.', 18),
    (v_mod_id, 'video', 'Formatting Text · Indents and tab stops', 'https://www.youtube.com/watch?v=_iFZZp29qaY', 'Add a first-line indent to a paragraph and set a tab stop using the ruler.', 19),
    (v_mod_id, 'video', 'ID · Memformat Teks · Indentasi dan tab', 'https://www.youtube.com/watch?v=UzdFQeIkmsU', 'Tambahkan indentasi baris pertama pada paragraf dan atur tab lewat penggaris.', 20),
    (v_mod_id, 'video', 'Formatting Text · Borders and shading', 'https://www.youtube.com/watch?v=2cyVMBv-rwA', 'Put a border around one paragraph and add light shading behind it.', 21),
    (v_mod_id, 'video', 'ID · Memformat Teks · Bingkai dan arsiran', 'https://www.youtube.com/watch?v=StN_tJpA2gA', 'Beri bingkai di sekitar satu paragraf dan tambahkan arsiran tipis di belakangnya.', 22),
    (v_mod_id, 'video', 'Formatting Text · Heading styles (Heading 1, Heading 2)', 'https://www.youtube.com/watch?v=tKbXkiKSD6o', 'Apply Heading 1 to your title and Heading 2 to two subtitles.', 23),
    (v_mod_id, 'video', 'ID · Memformat Teks · Gaya judul (Heading 1, Heading 2)', 'https://www.youtube.com/watch?v=Nz0Gh57rd4A', 'Terapkan Heading 1 pada judul dan Heading 2 pada dua subjudul.', 24),
    (v_mod_id, 'video', 'Page Layout · Margins and page orientation', 'https://www.youtube.com/watch?v=Z_8k1sS9USE', 'Change the margins to Narrow and switch the page to Landscape, then back.', 25),
    (v_mod_id, 'video', 'ID · Tata Letak Halaman · Margin dan orientasi halaman', 'https://www.youtube.com/watch?v=xAd50aXlUfU', 'Ubah margin menjadi Narrow dan ubah halaman ke Landscape, lalu kembalikan.', 26),
    (v_mod_id, 'video', 'Page Layout · Columns (newspaper style)', 'https://www.youtube.com/watch?v=-lnDFyptQV4', 'Split a block of text into two newspaper-style columns.', 27),
    (v_mod_id, 'video', 'ID · Tata Letak Halaman · Kolom (gaya koran)', 'https://www.youtube.com/watch?v=lPmVvJ7574Q', 'Bagi satu blok teks menjadi dua kolom bergaya koran.', 28),
    (v_mod_id, 'video', 'Page Layout · Page breaks and section breaks', 'https://www.youtube.com/watch?v=_KSDGDRNHpY', 'Insert a page break to start a new page, then a section break.', 29),
    (v_mod_id, 'video', 'ID · Tata Letak Halaman · Page break dan section break', 'https://www.youtube.com/watch?v=1gGSs-2IT6g', 'Sisipkan page break untuk memulai halaman baru, lalu section break.', 30),
    (v_mod_id, 'video', 'Page Layout · Headers and footers', 'https://www.youtube.com/watch?v=rYuibkDyNYs', 'Add a header with the document title and a footer with your name.', 31),
    (v_mod_id, 'video', 'ID · Tata Letak Halaman · Header dan footer', 'https://www.youtube.com/watch?v=5ONFj9cTIwk', 'Tambahkan header berisi judul dokumen dan footer berisi namamu.', 32),
    (v_mod_id, 'video', 'Page Layout · Page numbers', 'https://www.youtube.com/watch?v=5r0c7Lx2CaQ', 'Add automatic page numbers at the bottom of every page.', 33),
    (v_mod_id, 'video', 'ID · Tata Letak Halaman · Nomor halaman', 'https://www.youtube.com/watch?v=IPQ0G0wi5cc', 'Tambahkan nomor halaman otomatis di bagian bawah setiap halaman.', 34),
    (v_mod_id, 'video', 'Page Layout · Watermark and page colour', 'https://www.youtube.com/watch?v=wmA90kaP1ks', 'Add a "DRAFT" watermark to the document.', 35),
    (v_mod_id, 'video', 'ID · Tata Letak Halaman · Watermark dan warna halaman', 'https://www.youtube.com/watch?v=te1SRPxuFQk', 'Tambahkan watermark "DRAFT" ke dokumen.', 36),
    (v_mod_id, 'video', 'Visuals & Tables · Inserting pictures and text wrapping', 'https://www.youtube.com/watch?v=jh9IQuu8J_s', 'Insert a picture and set text wrapping to Square so text flows around it.', 37),
    (v_mod_id, 'video', 'ID · Visual & Tabel · Menyisipkan gambar dan wrap text', 'https://www.youtube.com/watch?v=fvLIifWWbdU', 'Sisipkan gambar dan atur wrap text ke Square agar teks mengalir mengelilinginya.', 38),
    (v_mod_id, 'video', 'Visuals & Tables · Shapes and icons', 'https://www.youtube.com/watch?v=RMlYOi_iqyw', 'Insert a rectangle and an icon, then move and resize them.', 39),
    (v_mod_id, 'video', 'ID · Visual & Tabel · Bentuk dan ikon', 'https://www.youtube.com/watch?v=EE5OB0ptxZA', 'Sisipkan persegi panjang dan sebuah ikon, lalu pindahkan dan ubah ukurannya.', 40),
    (v_mod_id, 'video', 'Visuals & Tables · SmartArt', 'https://www.youtube.com/watch?v=Hna1uJN1-qY', 'Create a SmartArt list or org chart with three items.', 41),
    (v_mod_id, 'video', 'ID · Visual & Tabel · SmartArt', 'https://www.youtube.com/watch?v=fKZYOHCqFGQ', 'Buat SmartArt daftar atau bagan organisasi dengan tiga item.', 42),
    (v_mod_id, 'video', 'Visuals & Tables · Inserting and formatting tables', 'https://www.youtube.com/watch?v=CZx8RA0x3Js', 'Insert a 3x4 table, type headings in the first row, and apply a table style.', 43),
    (v_mod_id, 'video', 'ID · Visual & Tabel · Menyisipkan dan memformat tabel', 'https://www.youtube.com/watch?v=uMAfeWxvhJ0', 'Sisipkan tabel 3x4, ketik judul di baris pertama, dan terapkan table style.', 44),
    (v_mod_id, 'video', 'Visuals & Tables · Charts in Word', 'https://www.youtube.com/watch?v=3G_dixHPaMQ', 'Insert a column chart and edit its data to show three values.', 45),
    (v_mod_id, 'video', 'ID · Visual & Tabel · Grafik di Word', 'https://www.youtube.com/watch?v=1M4Sq7nuGZM', 'Sisipkan grafik kolom dan ubah datanya untuk menampilkan tiga nilai.', 46),
    (v_mod_id, 'video', 'Visuals & Tables · Text boxes and WordArt', 'https://www.youtube.com/watch?v=Gu_ElhTtPpc', 'Add a text box and turn a title into WordArt.', 47),
    (v_mod_id, 'video', 'ID · Visual & Tabel · Kotak teks dan WordArt', 'https://www.youtube.com/watch?v=vd41eaTw2JE', 'Tambahkan kotak teks dan ubah sebuah judul menjadi WordArt.', 48),
    (v_mod_id, 'video', 'References & Review · Table of contents (automatic)', 'https://www.youtube.com/watch?v=45s9VKQ6wEI', 'Using your Heading styles, insert an automatic table of contents.', 49),
    (v_mod_id, 'video', 'ID · Referensi & Tinjauan · Daftar isi otomatis', 'https://www.youtube.com/watch?v=Uv66MmSWNmY', 'Dengan gaya Heading-mu, sisipkan daftar isi otomatis.', 50),
    (v_mod_id, 'video', 'References & Review · Footnotes and endnotes', 'https://www.youtube.com/watch?v=DGfbbCsZi6Q', 'Add a footnote to one sentence explaining a term.', 51),
    (v_mod_id, 'video', 'ID · Referensi & Tinjauan · Catatan kaki dan catatan akhir', 'https://www.youtube.com/watch?v=k4HWSS8CZBo', 'Tambahkan catatan kaki pada satu kalimat untuk menjelaskan sebuah istilah.', 52),
    (v_mod_id, 'video', 'References & Review · Citations and bibliography', 'https://www.youtube.com/watch?v=r4srwwHGWzg', 'Add one source, insert a citation, then generate a bibliography.', 53),
    (v_mod_id, 'video', 'ID · Referensi & Tinjauan · Sitasi dan daftar pustaka', 'https://www.youtube.com/watch?v=xypzKvsK-1I', 'Tambahkan satu sumber, sisipkan sitasi, lalu buat daftar pustaka.', 54),
    (v_mod_id, 'video', 'References & Review · Spelling & grammar check', 'https://www.youtube.com/watch?v=pf8xv4PqnRs', 'Run Spelling & Grammar check and fix the flagged mistakes.', 55),
    (v_mod_id, 'video', 'ID · Referensi & Tinjauan · Periksa ejaan & tata bahasa', 'https://www.youtube.com/watch?v=1ENNOeCYUAA', 'Jalankan pemeriksaan Ejaan & Tata Bahasa dan perbaiki kesalahan yang ditandai.', 56),
    (v_mod_id, 'video', 'References & Review · Track Changes and comments', 'https://www.youtube.com/watch?v=4QQnh9pkvv0', 'Turn on Track Changes, edit a sentence, add a comment, then accept the change.', 57),
    (v_mod_id, 'video', 'ID · Referensi & Tinjauan · Track Changes dan komentar', 'https://www.youtube.com/watch?v=58_8ySNJ2cA', 'Aktifkan Track Changes, edit satu kalimat, tambahkan komentar, lalu terima perubahannya.', 58),
    (v_mod_id, 'video', 'References & Review · Mail Merge', 'https://www.youtube.com/watch?v=mFqCvTOpOL0', 'Use Mail Merge with a short list to make personalised letters.', 59),
    (v_mod_id, 'video', 'ID · Referensi & Tinjauan · Mail Merge', 'https://www.youtube.com/watch?v=0tkDYDBC5nw', 'Pakai Mail Merge dengan daftar singkat untuk membuat surat yang dipersonalisasi.', 60);

  RAISE NOTICE 'Word clips added: 30 topics, 60 videos (EN + ID).';
END $$;

-- Verify: expect clip_videos = 60 on the Word module; checklist + quiz intact.
SELECT m.title,
       count(DISTINCT r.id) FILTER (WHERE r.url LIKE '%youtube.com/%') AS youtube_videos,
       count(DISTINCT i.id) AS checklist_items,
       count(DISTINCT q.id) AS quizzes
  FROM course_modules m
  LEFT JOIN module_resources r       ON r.course_module_id = m.id
  LEFT JOIN module_checklist_items i ON i.course_module_id = m.id
  LEFT JOIN module_quizzes q         ON q.course_module_id = m.id
 WHERE m.title LIKE 'Microsoft Word%'
   AND m.course_id = (SELECT id FROM courses WHERE title = 'Microsoft Digital Skills for University Prep')
 GROUP BY m.title;

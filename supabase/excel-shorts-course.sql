-- ============================================================
-- excel-shorts-course.sql
-- "Microsoft Excel Essentials — Short Clips" course
-- 9 weekly modules · 60 short clips as student checklist items
-- Bilingual (EN + Indonesian _id columns) · Quiz per module
-- with single-choice questions + one Homework Upload question.
--
-- Run in Supabase SQL Editor. Safe to re-run (guarded).
-- ============================================================

-- Allow all question types used by the app (older schema only allowed 3)
ALTER TABLE quiz_questions DROP CONSTRAINT IF EXISTS quiz_questions_question_type_check;
ALTER TABLE quiz_questions ADD CONSTRAINT quiz_questions_question_type_check
  CHECK (question_type IN ('single_choice','multiple_choice','fill_blank','homework_upload','yes_no'));

-- Bilingual columns for quizzes (older schema only had them on questions/options)
ALTER TABLE module_quizzes ADD COLUMN IF NOT EXISTS title_id       TEXT;
ALTER TABLE module_quizzes ADD COLUMN IF NOT EXISTS description_id TEXT;

-- New course modules do not use the legacy integer module id
ALTER TABLE module_checklist_items ALTER COLUMN module_id DROP NOT NULL;

DO $$
DECLARE
  v_course_id UUID;
  v_mod_id    UUID;
  v_quiz_id   UUID;
  v_q_id      UUID;
BEGIN

  -- Guard: skip if course already exists
  IF EXISTS (SELECT 1 FROM courses WHERE title = 'Microsoft Excel Essentials — Short Clips') THEN
    RETURN;
  END IF;

  -- ============================================================
  -- COURSE
  -- ============================================================
  v_course_id := gen_random_uuid();
  INSERT INTO courses (id, title, title_id, description, description_id, icon, created_at)
  VALUES (
    v_course_id,
    'Microsoft Excel Essentials — Short Clips',
    'Dasar-Dasar Microsoft Excel — Klip Singkat',
    'A 9-week Excel course built from 60 short tutorial clips (about 60 seconds each). Each week: watch the clips, practice in your own workbook, take the quiz, and upload your practice file.',
    'Kursus Excel 9 minggu yang terdiri dari 60 klip tutorial singkat (sekitar 60 detik per klip). Setiap minggu: tonton klip, berlatih di workbook sendiri, kerjakan kuis, lalu unggah file latihanmu.',
    '📊',
    NOW()
  );

  -- ============================================================
  -- WEEK 1 — Getting Started with Excel
  -- ============================================================
  v_mod_id := gen_random_uuid();
  INSERT INTO course_modules (id, course_id, title, title_id, focus, focus_id, icon, week_number, sort_order)
  VALUES (
    v_mod_id, v_course_id,
    'Getting Started with Excel', 'Mengenal Excel',
    'Interface, entering data, navigation, sheets',
    'Antarmuka, memasukkan data, navigasi, lembar kerja',
    '🚀', 1, 1
  );

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, label_id, sort_order) VALUES
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w1_s1', 'Watched & practiced: Excel interface tour (ribbon, cells, name box, formula bar)', 'Menonton & berlatih: Tur antarmuka Excel (ribbon, sel, name box, formula bar)', 1),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w1_s2', 'Watched & practiced: Entering and editing data (Enter, Tab, F2)', 'Menonton & berlatih: Memasukkan dan mengedit data (Enter, Tab, F2)', 2),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w1_s3', 'Watched & practiced: Selecting cells, rows, columns, and ranges', 'Menonton & berlatih: Memilih sel, baris, kolom, dan rentang', 3),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w1_s4', 'Watched & practiced: Copy, cut, paste, and Paste Special (values only)', 'Menonton & berlatih: Salin, potong, tempel, dan Paste Special (hanya nilai)', 4),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w1_s5', 'Watched & practiced: AutoFill and Flash Fill', 'Menonton & berlatih: AutoFill dan Flash Fill', 5),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w1_s6', 'Watched & practiced: Undo/Redo and saving (.xlsx vs .csv)', 'Menonton & berlatih: Undo/Redo dan menyimpan (.xlsx vs .csv)', 6),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w1_s7', 'Watched & practiced: Freeze Panes', 'Menonton & berlatih: Freeze Panes (membekukan judul)', 7),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w1_s8', 'Watched & practiced: Inserting/deleting rows and columns, resizing', 'Menonton & berlatih: Menyisipkan/menghapus baris dan kolom, mengubah ukuran', 8),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w1_s9', 'Watched & practiced: Working with multiple sheets', 'Menonton & berlatih: Bekerja dengan banyak sheet', 9);

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, label_id, sort_order) VALUES
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w1_t1', 'Demonstrated this week''s clips and answered questions', 'Mendemonstrasikan klip minggu ini dan menjawab pertanyaan', 1),
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w1_t2', 'Reviewed the student''s practice workbook', 'Meninjau workbook latihan siswa', 2),
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w1_t3', 'Graded the homework upload and gave feedback', 'Menilai unggahan tugas dan memberi umpan balik', 3);

  v_quiz_id := gen_random_uuid();
  INSERT INTO module_quizzes (id, course_module_id, title, title_id, description, description_id, sort_order)
  VALUES (v_quiz_id, v_mod_id,
    'Week 1 Quiz — Getting Started', 'Kuis Minggu 1 — Mengenal Excel',
    'Answer the questions, then upload your practice workbook.',
    'Jawab pertanyaannya, lalu unggah workbook latihanmu.', 1);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'A cell shows ##### — what does it mean?',
    'Sebuah sel menampilkan ##### — apa artinya?', 1);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'The formula is broken', 'Rumusnya rusak', false, 1),
    (gen_random_uuid(), v_q_id, 'The column is too narrow for the number', 'Kolom terlalu sempit untuk angkanya', true, 2),
    (gen_random_uuid(), v_q_id, 'The data was deleted', 'Datanya terhapus', false, 3),
    (gen_random_uuid(), v_q_id, 'Excel has an error', 'Excel mengalami error', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'Which key moves to the next cell on the RIGHT while entering data?',
    'Tombol mana yang berpindah ke sel di sebelah KANAN saat memasukkan data?', 2);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Enter', 'Enter', false, 1),
    (gen_random_uuid(), v_q_id, 'Tab', 'Tab', true, 2),
    (gen_random_uuid(), v_q_id, 'Esc', 'Esc', false, 3),
    (gen_random_uuid(), v_q_id, 'F2', 'F2', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'You want to paste only the RESULT of a formula, not the formula itself. What do you use?',
    'Kamu ingin menempel hanya HASIL dari sebuah rumus, bukan rumusnya. Apa yang kamu gunakan?', 3);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Ctrl+V (normal paste)', 'Ctrl+V (tempel biasa)', false, 1),
    (gen_random_uuid(), v_q_id, 'Paste Special → Values', 'Paste Special → Values', true, 2),
    (gen_random_uuid(), v_q_id, 'Format Painter', 'Format Painter', false, 3),
    (gen_random_uuid(), v_q_id, 'Flash Fill', 'Flash Fill', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'homework_upload',
    'Homework: create a workbook with 3 named, color-coded sheets (PAUD / SD / SMP), a frozen header row, and 10 inventory items on the first sheet. Upload your .xlsx file.',
    'Tugas: buat workbook dengan 3 sheet yang diberi nama dan warna (PAUD / SD / SMP), baris judul yang dibekukan (Freeze Panes), dan 10 barang inventaris di sheet pertama. Unggah file .xlsx kamu.', 4);

  -- ============================================================
  -- WEEK 2 — Formatting Like a Pro
  -- ============================================================
  v_mod_id := gen_random_uuid();
  INSERT INTO course_modules (id, course_id, title, title_id, focus, focus_id, icon, week_number, sort_order)
  VALUES (
    v_mod_id, v_course_id,
    'Formatting Like a Pro', 'Memformat Seperti Profesional',
    'Number formats, colors, tables, conditional formatting',
    'Format angka, warna, tabel, format bersyarat',
    '🎨', 2, 2
  );

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, label_id, sort_order) VALUES
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w2_s1', 'Watched & practiced: Number formats (currency Rp, percentage, dates)', 'Menonton & berlatih: Format angka (mata uang Rp, persentase, tanggal)', 1),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w2_s2', 'Watched & practiced: Cell formatting (bold, borders, fill, wrap text)', 'Menonton & berlatih: Format sel (tebal, garis, warna, wrap text)', 2),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w2_s3', 'Watched & practiced: Merge & Center vs Center Across Selection', 'Menonton & berlatih: Merge & Center vs Center Across Selection', 3),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w2_s4', 'Watched & practiced: Format Painter', 'Menonton & berlatih: Format Painter', 4),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w2_s5', 'Watched & practiced: Conditional Formatting (highlight low stock)', 'Menonton & berlatih: Format bersyarat (menyorot stok menipis)', 5),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w2_s6', 'Watched & practiced: Format as Table', 'Menonton & berlatih: Format sebagai Tabel', 6),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w2_s7', 'Watched & practiced: Cell styles and themes', 'Menonton & berlatih: Gaya sel dan tema', 7);

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, label_id, sort_order) VALUES
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w2_t1', 'Demonstrated this week''s clips and answered questions', 'Mendemonstrasikan klip minggu ini dan menjawab pertanyaan', 1),
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w2_t2', 'Reviewed the student''s practice workbook', 'Meninjau workbook latihan siswa', 2),
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w2_t3', 'Graded the homework upload and gave feedback', 'Menilai unggahan tugas dan memberi umpan balik', 3);

  v_quiz_id := gen_random_uuid();
  INSERT INTO module_quizzes (id, course_module_id, title, title_id, description, description_id, sort_order)
  VALUES (v_quiz_id, v_mod_id,
    'Week 2 Quiz — Formatting', 'Kuis Minggu 2 — Memformat',
    'Answer the questions, then upload your practice workbook.',
    'Jawab pertanyaannya, lalu unggah workbook latihanmu.', 1);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'Which feature automatically colors cells when stock drops below a limit?',
    'Fitur mana yang otomatis mewarnai sel saat stok turun di bawah batas?', 1);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Format Painter', 'Format Painter', false, 1),
    (gen_random_uuid(), v_q_id, 'Conditional Formatting', 'Format Bersyarat (Conditional Formatting)', true, 2),
    (gen_random_uuid(), v_q_id, 'Merge & Center', 'Merge & Center', false, 3),
    (gen_random_uuid(), v_q_id, 'Cell Styles', 'Gaya Sel', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'What does the Format Painter do?',
    'Apa fungsi Format Painter?', 2);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Copies cell values', 'Menyalin nilai sel', false, 1),
    (gen_random_uuid(), v_q_id, 'Copies formatting from one cell to another', 'Menyalin format dari satu sel ke sel lain', true, 2),
    (gen_random_uuid(), v_q_id, 'Draws borders', 'Menggambar garis tepi', false, 3),
    (gen_random_uuid(), v_q_id, 'Changes the font color only', 'Hanya mengubah warna huruf', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'Which number format is best for prices in Rupiah?',
    'Format angka mana yang paling tepat untuk harga dalam Rupiah?', 3);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'General', 'General', false, 1),
    (gen_random_uuid(), v_q_id, 'Currency', 'Mata Uang (Currency)', true, 2),
    (gen_random_uuid(), v_q_id, 'Percentage', 'Persentase', false, 3),
    (gen_random_uuid(), v_q_id, 'Text', 'Teks', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'homework_upload',
    'Homework: format an inventory sheet with currency format for prices, borders and a colored header row, and conditional formatting that highlights quantities below 5 in red. Upload your .xlsx file.',
    'Tugas: format lembar inventaris dengan format mata uang untuk harga, garis tepi dan baris judul berwarna, serta format bersyarat yang menyorot jumlah di bawah 5 dengan warna merah. Unggah file .xlsx kamu.', 4);

  -- ============================================================
  -- WEEK 3 — Your First Formulas
  -- ============================================================
  v_mod_id := gen_random_uuid();
  INSERT INTO course_modules (id, course_id, title, title_id, focus, focus_id, icon, week_number, sort_order)
  VALUES (
    v_mod_id, v_course_id,
    'Your First Formulas', 'Rumus Pertamamu',
    'SUM, AVERAGE, COUNT, cell references',
    'SUM, AVERAGE, COUNT, referensi sel',
    '🧮', 3, 3
  );

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, label_id, sort_order) VALUES
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w3_s1', 'Watched & practiced: Your first formula (=, cell references, + − * /)', 'Menonton & berlatih: Rumus pertamamu (=, referensi sel, + − * /)', 1),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w3_s2', 'Watched & practiced: SUM and AutoSum', 'Menonton & berlatih: SUM dan AutoSum', 2),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w3_s3', 'Watched & practiced: AVERAGE, MIN, MAX', 'Menonton & berlatih: AVERAGE, MIN, MAX', 3),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w3_s4', 'Watched & practiced: COUNT vs COUNTA vs COUNTBLANK', 'Menonton & berlatih: COUNT vs COUNTA vs COUNTBLANK', 4),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w3_s5', 'Watched & practiced: Relative vs absolute references ($A$1)', 'Menonton & berlatih: Referensi relatif vs absolut ($A$1)', 5),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w3_s6', 'Watched & practiced: Copying formulas down a column', 'Menonton & berlatih: Menyalin rumus ke bawah kolom', 6);

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, label_id, sort_order) VALUES
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w3_t1', 'Demonstrated this week''s clips and answered questions', 'Mendemonstrasikan klip minggu ini dan menjawab pertanyaan', 1),
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w3_t2', 'Reviewed the student''s practice workbook', 'Meninjau workbook latihan siswa', 2),
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w3_t3', 'Graded the homework upload and gave feedback', 'Menilai unggahan tugas dan memberi umpan balik', 3);

  v_quiz_id := gen_random_uuid();
  INSERT INTO module_quizzes (id, course_module_id, title, title_id, description, description_id, sort_order)
  VALUES (v_quiz_id, v_mod_id,
    'Week 3 Quiz — First Formulas', 'Kuis Minggu 3 — Rumus Pertama',
    'Answer the questions, then upload your practice workbook.',
    'Jawab pertanyaannya, lalu unggah workbook latihanmu.', 1);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'Which formula adds up all values from A1 to A10?',
    'Rumus mana yang menjumlahkan semua nilai dari A1 sampai A10?', 1);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, '=SUM(A1:A10)', '=SUM(A1:A10)', true, 1),
    (gen_random_uuid(), v_q_id, '=ADD(A1:A10)', '=ADD(A1:A10)', false, 2),
    (gen_random_uuid(), v_q_id, '=TOTAL(A1-A10)', '=TOTAL(A1-A10)', false, 3),
    (gen_random_uuid(), v_q_id, '=A1+A10', '=A1+A10', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'What kind of reference is $A$1?',
    'Referensi jenis apakah $A$1?', 2);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Relative reference', 'Referensi relatif', false, 1),
    (gen_random_uuid(), v_q_id, 'Absolute reference', 'Referensi absolut', true, 2),
    (gen_random_uuid(), v_q_id, 'Circular reference', 'Referensi melingkar', false, 3),
    (gen_random_uuid(), v_q_id, 'Broken reference', 'Referensi rusak', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'COUNTA counts…',
    'COUNTA menghitung…', 3);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Only numbers', 'Hanya angka', false, 1),
    (gen_random_uuid(), v_q_id, 'All non-empty cells', 'Semua sel yang tidak kosong', true, 2),
    (gen_random_uuid(), v_q_id, 'Only empty cells', 'Hanya sel kosong', false, 3),
    (gen_random_uuid(), v_q_id, 'Only text', 'Hanya teks', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'homework_upload',
    'Homework: build a simple monthly budget with SUM for the total, plus AVERAGE, MIN and MAX of your expenses. Use at least one absolute reference. Upload your .xlsx file.',
    'Tugas: buat anggaran bulanan sederhana dengan SUM untuk total, ditambah AVERAGE, MIN dan MAX dari pengeluaranmu. Gunakan minimal satu referensi absolut. Unggah file .xlsx kamu.', 4);

  -- ============================================================
  -- WEEK 4 — Smart Decisions with Logic
  -- ============================================================
  v_mod_id := gen_random_uuid();
  INSERT INTO course_modules (id, course_id, title, title_id, focus, focus_id, icon, week_number, sort_order)
  VALUES (
    v_mod_id, v_course_id,
    'Smart Decisions with Logic', 'Keputusan Cerdas dengan Logika',
    'IF, COUNTIF, SUMIF, multiple conditions',
    'IF, COUNTIF, SUMIF, kondisi ganda',
    '🧠', 4, 4
  );

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, label_id, sort_order) VALUES
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w4_s1', 'Watched & practiced: IF (pass/fail decisions)', 'Menonton & berlatih: IF (keputusan lulus/gagal)', 1),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w4_s2', 'Watched & practiced: Nested IF and IFS (grading A/B/C/D)', 'Menonton & berlatih: IF bertingkat dan IFS (penilaian A/B/C/D)', 2),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w4_s3', 'Watched & practiced: AND / OR inside IF', 'Menonton & berlatih: AND / OR di dalam IF', 3),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w4_s4', 'Watched & practiced: COUNTIF / COUNTIFS', 'Menonton & berlatih: COUNTIF / COUNTIFS', 4),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w4_s5', 'Watched & practiced: SUMIF / SUMIFS', 'Menonton & berlatih: SUMIF / SUMIFS', 5),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w4_s6', 'Watched & practiced: AVERAGEIF', 'Menonton & berlatih: AVERAGEIF', 6);

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, label_id, sort_order) VALUES
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w4_t1', 'Demonstrated this week''s clips and answered questions', 'Mendemonstrasikan klip minggu ini dan menjawab pertanyaan', 1),
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w4_t2', 'Reviewed the student''s practice workbook', 'Meninjau workbook latihan siswa', 2),
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w4_t3', 'Graded the homework upload and gave feedback', 'Menilai unggahan tugas dan memberi umpan balik', 3);

  v_quiz_id := gen_random_uuid();
  INSERT INTO module_quizzes (id, course_module_id, title, title_id, description, description_id, sort_order)
  VALUES (v_quiz_id, v_mod_id,
    'Week 4 Quiz — Logic Functions', 'Kuis Minggu 4 — Fungsi Logika',
    'Answer the questions, then upload your practice workbook.',
    'Jawab pertanyaannya, lalu unggah workbook latihanmu.', 1);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'What does =IF(A1>=75,"Pass","Fail") return when A1 is 80?',
    'Apa hasil =IF(A1>=75,"Pass","Fail") jika A1 bernilai 80?', 1);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Pass', 'Pass', true, 1),
    (gen_random_uuid(), v_q_id, 'Fail', 'Fail', false, 2),
    (gen_random_uuid(), v_q_id, '80', '80', false, 3),
    (gen_random_uuid(), v_q_id, 'TRUE', 'TRUE', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'Which function counts how many items belong to the category "Stationery"?',
    'Fungsi mana yang menghitung berapa banyak barang dalam kategori "Stationery"?', 2);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'COUNT', 'COUNT', false, 1),
    (gen_random_uuid(), v_q_id, 'COUNTIF', 'COUNTIF', true, 2),
    (gen_random_uuid(), v_q_id, 'SUM', 'SUM', false, 3),
    (gen_random_uuid(), v_q_id, 'IF', 'IF', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'To total quantities ONLY for the PAUD location, which function fits best?',
    'Untuk menjumlahkan jumlah barang HANYA untuk lokasi PAUD, fungsi mana yang paling tepat?', 3);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'SUM', 'SUM', false, 1),
    (gen_random_uuid(), v_q_id, 'SUMIF', 'SUMIF', true, 2),
    (gen_random_uuid(), v_q_id, 'AVERAGE', 'AVERAGE', false, 3),
    (gen_random_uuid(), v_q_id, 'MAX', 'MAX', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'homework_upload',
    'Homework: build a grade sheet for 10 students with an IF pass/fail column, and a summary using COUNTIF (how many passed) and AVERAGEIF. Upload your .xlsx file.',
    'Tugas: buat lembar nilai untuk 10 siswa dengan kolom lulus/gagal memakai IF, dan ringkasan memakai COUNTIF (berapa yang lulus) serta AVERAGEIF. Unggah file .xlsx kamu.', 4);

  -- ============================================================
  -- WEEK 5 — Finding Data with Lookups
  -- ============================================================
  v_mod_id := gen_random_uuid();
  INSERT INTO course_modules (id, course_id, title, title_id, focus, focus_id, icon, week_number, sort_order)
  VALUES (
    v_mod_id, v_course_id,
    'Finding Data with Lookups', 'Mencari Data dengan Lookup',
    'VLOOKUP, XLOOKUP, INDEX+MATCH, IFERROR',
    'VLOOKUP, XLOOKUP, INDEX+MATCH, IFERROR',
    '🔍', 5, 5
  );

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, label_id, sort_order) VALUES
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w5_s1', 'Watched & practiced: VLOOKUP (find a price from a master list)', 'Menonton & berlatih: VLOOKUP (mencari harga dari daftar induk)', 1),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w5_s2', 'Watched & practiced: XLOOKUP (the modern replacement)', 'Menonton & berlatih: XLOOKUP (pengganti modern)', 2),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w5_s3', 'Watched & practiced: INDEX + MATCH', 'Menonton & berlatih: INDEX + MATCH', 3),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w5_s4', 'Watched & practiced: IFERROR (clean up #N/A)', 'Menonton & berlatih: IFERROR (merapikan #N/A)', 4);

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, label_id, sort_order) VALUES
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w5_t1', 'Demonstrated this week''s clips and answered questions', 'Mendemonstrasikan klip minggu ini dan menjawab pertanyaan', 1),
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w5_t2', 'Reviewed the student''s practice workbook', 'Meninjau workbook latihan siswa', 2),
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w5_t3', 'Graded the homework upload and gave feedback', 'Menilai unggahan tugas dan memberi umpan balik', 3);

  v_quiz_id := gen_random_uuid();
  INSERT INTO module_quizzes (id, course_module_id, title, title_id, description, description_id, sort_order)
  VALUES (v_quiz_id, v_mod_id,
    'Week 5 Quiz — Lookups', 'Kuis Minggu 5 — Lookup',
    'Answer the questions, then upload your practice workbook.',
    'Jawab pertanyaannya, lalu unggah workbook latihanmu.', 1);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'XLOOKUP is the modern replacement for which function?',
    'XLOOKUP adalah pengganti modern untuk fungsi apa?', 1);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'SUMIF', 'SUMIF', false, 1),
    (gen_random_uuid(), v_q_id, 'VLOOKUP', 'VLOOKUP', true, 2),
    (gen_random_uuid(), v_q_id, 'COUNTIF', 'COUNTIF', false, 3),
    (gen_random_uuid(), v_q_id, 'TEXTJOIN', 'TEXTJOIN', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'In VLOOKUP, what does FALSE in the last argument mean?',
    'Dalam VLOOKUP, apa arti FALSE pada argumen terakhir?', 2);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Approximate match', 'Pencocokan perkiraan', false, 1),
    (gen_random_uuid(), v_q_id, 'Exact match', 'Pencocokan persis', true, 2),
    (gen_random_uuid(), v_q_id, 'Search backwards', 'Mencari mundur', false, 3),
    (gen_random_uuid(), v_q_id, 'Ignore errors', 'Mengabaikan error', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'What is IFERROR used for?',
    'Untuk apa IFERROR digunakan?', 3);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'To hide columns', 'Untuk menyembunyikan kolom', false, 1),
    (gen_random_uuid(), v_q_id, 'To show a friendly message instead of #N/A errors', 'Untuk menampilkan pesan ramah alih-alih error #N/A', true, 2),
    (gen_random_uuid(), v_q_id, 'To delete wrong data', 'Untuk menghapus data yang salah', false, 3),
    (gen_random_uuid(), v_q_id, 'To check spelling', 'Untuk memeriksa ejaan', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'homework_upload',
    'Homework: create a workbook with a master price list on Sheet1 and an order form on Sheet2 that uses XLOOKUP (or VLOOKUP) wrapped in IFERROR to fetch prices. Upload your .xlsx file.',
    'Tugas: buat workbook dengan daftar harga induk di Sheet1 dan formulir pesanan di Sheet2 yang memakai XLOOKUP (atau VLOOKUP) dibungkus IFERROR untuk mengambil harga. Unggah file .xlsx kamu.', 4);

  -- ============================================================
  -- WEEK 6 — Text & Dates Mastery
  -- ============================================================
  v_mod_id := gen_random_uuid();
  INSERT INTO course_modules (id, course_id, title, title_id, focus, focus_id, icon, week_number, sort_order)
  VALUES (
    v_mod_id, v_course_id,
    'Text & Dates Mastery', 'Menguasai Teks & Tanggal',
    'Combining text, extracting, cleaning, date math',
    'Menggabung teks, ekstraksi, membersihkan data, hitung tanggal',
    '📝', 6, 6
  );

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, label_id, sort_order) VALUES
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w6_s1', 'Watched & practiced: CONCAT / TEXTJOIN and & (combine names)', 'Menonton & berlatih: CONCAT / TEXTJOIN dan & (menggabung nama)', 1),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w6_s2', 'Watched & practiced: LEFT, RIGHT, MID (extract codes)', 'Menonton & berlatih: LEFT, RIGHT, MID (mengekstrak kode)', 2),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w6_s3', 'Watched & practiced: UPPER, LOWER, PROPER', 'Menonton & berlatih: UPPER, LOWER, PROPER', 3),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w6_s4', 'Watched & practiced: TRIM and CLEAN', 'Menonton & berlatih: TRIM dan CLEAN', 4),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w6_s5', 'Watched & practiced: TEXT function (format inside text)', 'Menonton & berlatih: Fungsi TEXT (format di dalam teks)', 5),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w6_s6', 'Watched & practiced: TODAY and NOW', 'Menonton & berlatih: TODAY dan NOW', 6),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w6_s7', 'Watched & practiced: DATEDIF and date math', 'Menonton & berlatih: DATEDIF dan perhitungan tanggal', 7),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w6_s8', 'Watched & practiced: WEEKDAY, MONTH, YEAR', 'Menonton & berlatih: WEEKDAY, MONTH, YEAR', 8);

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, label_id, sort_order) VALUES
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w6_t1', 'Demonstrated this week''s clips and answered questions', 'Mendemonstrasikan klip minggu ini dan menjawab pertanyaan', 1),
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w6_t2', 'Reviewed the student''s practice workbook', 'Meninjau workbook latihan siswa', 2),
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w6_t3', 'Graded the homework upload and gave feedback', 'Menilai unggahan tugas dan memberi umpan balik', 3);

  v_quiz_id := gen_random_uuid();
  INSERT INTO module_quizzes (id, course_module_id, title, title_id, description, description_id, sort_order)
  VALUES (v_quiz_id, v_mod_id,
    'Week 6 Quiz — Text & Dates', 'Kuis Minggu 6 — Teks & Tanggal',
    'Answer the questions, then upload your practice workbook.',
    'Jawab pertanyaannya, lalu unggah workbook latihanmu.', 1);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'Which formula joins a first name (A2) and last name (B2) with a space?',
    'Rumus mana yang menggabungkan nama depan (A2) dan nama belakang (B2) dengan spasi?', 1);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, '=A2&" "&B2', '=A2&" "&B2', true, 1),
    (gen_random_uuid(), v_q_id, '=A2+B2', '=A2+B2', false, 2),
    (gen_random_uuid(), v_q_id, '=JOIN(A2,B2)', '=JOIN(A2,B2)', false, 3),
    (gen_random_uuid(), v_q_id, '=A2-B2', '=A2-B2', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'What does TRIM remove?',
    'Apa yang dihapus oleh TRIM?', 2);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Extra spaces', 'Spasi berlebih', true, 1),
    (gen_random_uuid(), v_q_id, 'Numbers', 'Angka', false, 2),
    (gen_random_uuid(), v_q_id, 'Capital letters', 'Huruf kapital', false, 3),
    (gen_random_uuid(), v_q_id, 'Formulas', 'Rumus', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'What does =TODAY() return?',
    'Apa hasil dari =TODAY()?', 3);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'The current date, updating automatically', 'Tanggal hari ini, diperbarui otomatis', true, 1),
    (gen_random_uuid(), v_q_id, 'A fixed date that never changes', 'Tanggal tetap yang tidak pernah berubah', false, 2),
    (gen_random_uuid(), v_q_id, 'The current time only', 'Hanya waktu saat ini', false, 3),
    (gen_random_uuid(), v_q_id, 'The day of the week as text', 'Nama hari dalam teks', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'homework_upload',
    'Homework: clean a messy name list using TRIM and PROPER, combine names into one column, and calculate each person''s age from their birthdate. Upload your .xlsx file.',
    'Tugas: bersihkan daftar nama yang berantakan memakai TRIM dan PROPER, gabungkan nama menjadi satu kolom, dan hitung umur setiap orang dari tanggal lahirnya. Unggah file .xlsx kamu.', 4);

  -- ============================================================
  -- WEEK 7 — Managing Real Data
  -- ============================================================
  v_mod_id := gen_random_uuid();
  INSERT INTO course_modules (id, course_id, title, title_id, focus, focus_id, icon, week_number, sort_order)
  VALUES (
    v_mod_id, v_course_id,
    'Managing Real Data', 'Mengelola Data Nyata',
    'Sort, filter, validation, duplicates, dropdowns',
    'Urutkan, filter, validasi, duplikat, dropdown',
    '🗂️', 7, 7
  );

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, label_id, sort_order) VALUES
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w7_s1', 'Watched & practiced: Sort (A-Z, multi-level)', 'Menonton & berlatih: Mengurutkan (A-Z, bertingkat)', 1),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w7_s2', 'Watched & practiced: Filter', 'Menonton & berlatih: Filter', 2),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w7_s3', 'Watched & practiced: Remove Duplicates', 'Menonton & berlatih: Menghapus Duplikat', 3),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w7_s4', 'Watched & practiced: Data Validation (dropdown lists)', 'Menonton & berlatih: Validasi Data (daftar dropdown)', 4),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w7_s5', 'Watched & practiced: Text to Columns', 'Menonton & berlatih: Text to Columns', 5),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w7_s6', 'Watched & practiced: Find & Replace', 'Menonton & berlatih: Find & Replace', 6),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w7_s7', 'Watched & practiced: Grouping and outlining', 'Menonton & berlatih: Pengelompokan baris/kolom', 7);

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, label_id, sort_order) VALUES
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w7_t1', 'Demonstrated this week''s clips and answered questions', 'Mendemonstrasikan klip minggu ini dan menjawab pertanyaan', 1),
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w7_t2', 'Reviewed the student''s practice workbook', 'Meninjau workbook latihan siswa', 2),
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w7_t3', 'Graded the homework upload and gave feedback', 'Menilai unggahan tugas dan memberi umpan balik', 3);

  v_quiz_id := gen_random_uuid();
  INSERT INTO module_quizzes (id, course_module_id, title, title_id, description, description_id, sort_order)
  VALUES (v_quiz_id, v_mod_id,
    'Week 7 Quiz — Data Management', 'Kuis Minggu 7 — Mengelola Data',
    'Answer the questions, then upload your practice workbook.',
    'Jawab pertanyaannya, lalu unggah workbook latihanmu.', 1);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'Which feature creates a dropdown list inside a cell?',
    'Fitur mana yang membuat daftar dropdown di dalam sel?', 1);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Data Validation', 'Validasi Data (Data Validation)', true, 1),
    (gen_random_uuid(), v_q_id, 'Conditional Formatting', 'Format Bersyarat', false, 2),
    (gen_random_uuid(), v_q_id, 'Filter', 'Filter', false, 3),
    (gen_random_uuid(), v_q_id, 'Merge & Center', 'Merge & Center', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'To show ONLY the rows where location is "PAUD", you use…',
    'Untuk menampilkan HANYA baris dengan lokasi "PAUD", kamu menggunakan…', 2);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Sort', 'Sort', false, 1),
    (gen_random_uuid(), v_q_id, 'Filter', 'Filter', true, 2),
    (gen_random_uuid(), v_q_id, 'Freeze Panes', 'Freeze Panes', false, 3),
    (gen_random_uuid(), v_q_id, 'Format Painter', 'Format Painter', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'Remove Duplicates is found on which ribbon tab?',
    'Remove Duplicates ada di tab ribbon yang mana?', 3);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Home', 'Home', false, 1),
    (gen_random_uuid(), v_q_id, 'Data', 'Data', true, 2),
    (gen_random_uuid(), v_q_id, 'Insert', 'Insert', false, 3),
    (gen_random_uuid(), v_q_id, 'View', 'View', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'homework_upload',
    'Homework: build an inventory list with dropdown categories (Data Validation), sorted by name, filtered view saved, and duplicates removed. Upload your .xlsx file.',
    'Tugas: buat daftar inventaris dengan kategori dropdown (Validasi Data), diurutkan berdasarkan nama, tampilan filter tersimpan, dan duplikat dihapus. Unggah file .xlsx kamu.', 4);

  -- ============================================================
  -- WEEK 8 — Charts & PivotTables
  -- ============================================================
  v_mod_id := gen_random_uuid();
  INSERT INTO course_modules (id, course_id, title, title_id, focus, focus_id, icon, week_number, sort_order)
  VALUES (
    v_mod_id, v_course_id,
    'Charts & PivotTables', 'Grafik & PivotTable',
    'Charts, sparklines, PivotTables, reports',
    'Grafik, sparkline, PivotTable, laporan',
    '📈', 8, 8
  );

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, label_id, sort_order) VALUES
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w8_s1', 'Watched & practiced: Creating your first chart', 'Menonton & berlatih: Membuat grafik pertamamu', 1),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w8_s2', 'Watched & practiced: Choosing the right chart type', 'Menonton & berlatih: Memilih jenis grafik yang tepat', 2),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w8_s3', 'Watched & practiced: Formatting charts', 'Menonton & berlatih: Memformat grafik', 3),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w8_s4', 'Watched & practiced: Sparklines', 'Menonton & berlatih: Sparklines', 4),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w8_s5', 'Watched & practiced: PivotTables part 1 (summarize data)', 'Menonton & berlatih: PivotTable bagian 1 (meringkas data)', 5),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w8_s6', 'Watched & practiced: PivotTables part 2 (grouping, slicers)', 'Menonton & berlatih: PivotTable bagian 2 (pengelompokan, slicer)', 6),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w8_s7', 'Watched & practiced: PivotCharts', 'Menonton & berlatih: PivotChart', 7);

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, label_id, sort_order) VALUES
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w8_t1', 'Demonstrated this week''s clips and answered questions', 'Mendemonstrasikan klip minggu ini dan menjawab pertanyaan', 1),
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w8_t2', 'Reviewed the student''s practice workbook', 'Meninjau workbook latihan siswa', 2),
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w8_t3', 'Graded the homework upload and gave feedback', 'Menilai unggahan tugas dan memberi umpan balik', 3);

  v_quiz_id := gen_random_uuid();
  INSERT INTO module_quizzes (id, course_module_id, title, title_id, description, description_id, sort_order)
  VALUES (v_quiz_id, v_mod_id,
    'Week 8 Quiz — Charts & PivotTables', 'Kuis Minggu 8 — Grafik & PivotTable',
    'Answer the questions, then upload your practice workbook.',
    'Jawab pertanyaannya, lalu unggah workbook latihanmu.', 1);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'Which chart type is best for showing a trend over 12 months?',
    'Jenis grafik mana yang paling baik untuk menunjukkan tren selama 12 bulan?', 1);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Pie chart', 'Grafik lingkaran (pie)', false, 1),
    (gen_random_uuid(), v_q_id, 'Line chart', 'Grafik garis (line)', true, 2),
    (gen_random_uuid(), v_q_id, 'Doughnut chart', 'Grafik donat', false, 3),
    (gen_random_uuid(), v_q_id, 'Scatter chart', 'Grafik sebar (scatter)', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'What is a PivotTable mainly used for?',
    'Apa kegunaan utama PivotTable?', 2);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Summarizing large amounts of data quickly', 'Meringkas data dalam jumlah besar dengan cepat', true, 1),
    (gen_random_uuid(), v_q_id, 'Drawing pictures', 'Menggambar', false, 2),
    (gen_random_uuid(), v_q_id, 'Checking spelling', 'Memeriksa ejaan', false, 3),
    (gen_random_uuid(), v_q_id, 'Protecting the workbook', 'Melindungi workbook', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'What does a slicer do?',
    'Apa fungsi slicer?', 3);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Adds clickable filter buttons to a PivotTable', 'Menambahkan tombol filter yang bisa diklik pada PivotTable', true, 1),
    (gen_random_uuid(), v_q_id, 'Splits text into columns', 'Memisahkan teks menjadi kolom', false, 2),
    (gen_random_uuid(), v_q_id, 'Deletes rows', 'Menghapus baris', false, 3),
    (gen_random_uuid(), v_q_id, 'Merges cells', 'Menggabungkan sel', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'homework_upload',
    'Homework: from a sales/inventory dataset, build one PivotTable with a slicer and one chart with a title and labels, arranged as a mini dashboard. Upload your .xlsx file.',
    'Tugas: dari kumpulan data penjualan/inventaris, buat satu PivotTable dengan slicer dan satu grafik dengan judul serta label, disusun sebagai dasbor mini. Unggah file .xlsx kamu.', 4);

  -- ============================================================
  -- WEEK 9 — Output & Protection
  -- ============================================================
  v_mod_id := gen_random_uuid();
  INSERT INTO course_modules (id, course_id, title, title_id, focus, focus_id, icon, week_number, sort_order)
  VALUES (
    v_mod_id, v_course_id,
    'Output & Protection', 'Cetak & Proteksi',
    'Shortcuts, printing, protecting, PDF export',
    'Pintasan, mencetak, proteksi, ekspor PDF',
    '🖨️', 9, 9
  );

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, label_id, sort_order) VALUES
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w9_s1', 'Watched & practiced: Top 10 keyboard shortcuts', 'Menonton & berlatih: 10 pintasan keyboard teratas', 1),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w9_s2', 'Watched & practiced: Print setup (print area, fit to page)', 'Menonton & berlatih: Pengaturan cetak (area cetak, muat satu halaman)', 2),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w9_s3', 'Watched & practiced: Page headers/footers and page numbers', 'Menonton & berlatih: Header/footer dan nomor halaman', 3),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w9_s4', 'Watched & practiced: Protecting sheets and locking cells', 'Menonton & berlatih: Proteksi sheet dan mengunci sel', 4),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w9_s5', 'Watched & practiced: Comments and notes', 'Menonton & berlatih: Komentar dan catatan', 5),
    (gen_random_uuid(), v_mod_id, 'student', 'xl_w9_s6', 'Watched & practiced: Exporting to PDF and sharing', 'Menonton & berlatih: Ekspor ke PDF dan berbagi', 6);

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, label_id, sort_order) VALUES
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w9_t1', 'Demonstrated this week''s clips and answered questions', 'Mendemonstrasikan klip minggu ini dan menjawab pertanyaan', 1),
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w9_t2', 'Reviewed the student''s practice workbook', 'Meninjau workbook latihan siswa', 2),
    (gen_random_uuid(), v_mod_id, 'teacher', 'xl_w9_t3', 'Graded the final portfolio and gave feedback', 'Menilai portofolio akhir dan memberi umpan balik', 3);

  v_quiz_id := gen_random_uuid();
  INSERT INTO module_quizzes (id, course_module_id, title, title_id, description, description_id, sort_order)
  VALUES (v_quiz_id, v_mod_id,
    'Week 9 Quiz — Output & Protection', 'Kuis Minggu 9 — Cetak & Proteksi',
    'Answer the questions, then upload your final portfolio workbook.',
    'Jawab pertanyaannya, lalu unggah workbook portofolio akhirmu.', 1);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'Which shortcut saves your workbook?',
    'Pintasan mana yang menyimpan workbook-mu?', 1);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Ctrl+S', 'Ctrl+S', true, 1),
    (gen_random_uuid(), v_q_id, 'Ctrl+P', 'Ctrl+P', false, 2),
    (gen_random_uuid(), v_q_id, 'Ctrl+Z', 'Ctrl+Z', false, 3),
    (gen_random_uuid(), v_q_id, 'Ctrl+C', 'Ctrl+C', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'To repeat the header row on every printed page, you use…',
    'Untuk mengulang baris judul di setiap halaman cetak, kamu menggunakan…', 2);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Page Layout → Print Titles', 'Page Layout → Print Titles', true, 1),
    (gen_random_uuid(), v_q_id, 'Freeze Panes', 'Freeze Panes', false, 2),
    (gen_random_uuid(), v_q_id, 'Merge & Center', 'Merge & Center', false, 3),
    (gen_random_uuid(), v_q_id, 'Copy & Paste', 'Salin & Tempel', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'single_choice',
    'What does protecting a sheet prevent?',
    'Apa yang dicegah oleh proteksi sheet?', 3);
  INSERT INTO quiz_options (id, question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Editing of locked cells', 'Pengeditan sel yang terkunci', true, 1),
    (gen_random_uuid(), v_q_id, 'Opening the file', 'Membuka file', false, 2),
    (gen_random_uuid(), v_q_id, 'Printing the sheet', 'Mencetak sheet', false, 3),
    (gen_random_uuid(), v_q_id, 'Saving the file', 'Menyimpan file', false, 4);

  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_q_id, v_quiz_id, 'homework_upload',
    'Final portfolio: combine your best work from the course into one workbook — a formatted data sheet, a formulas sheet, a lookup sheet, and a dashboard — with a protected summary sheet and print-ready layout. Upload your .xlsx file.',
    'Portofolio akhir: gabungkan karya terbaikmu dari kursus ini menjadi satu workbook — sheet data yang terformat, sheet rumus, sheet lookup, dan dasbor — dengan sheet ringkasan yang terproteksi dan tata letak siap cetak. Unggah file .xlsx kamu.', 4);

  -- ============================================================
  -- Enrol all existing students
  -- ============================================================
  INSERT INTO course_enrollments (course_id, student_id)
  SELECT v_course_id, id FROM profiles WHERE role = 'student'
  ON CONFLICT (course_id, student_id) DO NOTHING;

END $$;

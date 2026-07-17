-- ============================================================
-- excel-clips-to-resources.sql
-- Turn the Excel short-clips into WATCHABLE RESOURCES inside the course
-- students are actually enrolled in: "Microsoft Excel Essentials — Short Clips".
--
-- Per weekly module, the week's clips are added under Materi/Resources as:
--   * the English tutorial video   (sort_order 2k-1)
--   * a Bahasa Indonesia video     (sort_order 2k, title prefixed "ID · ")
-- Descriptions carry that clip's practice task in the matching language.
--
-- The 60 clip CHECKLIST items are then removed, so watching a clip no longer
-- scores toward the progress bar. The 27 tutor checklist items are kept.
--
-- Idempotent: re-running refreshes the videos and re-removes the clip items.
-- Run in the Supabase SQL Editor.
-- ============================================================

DO $$
DECLARE
  v_course_id UUID;
  v_mod_id    UUID;
BEGIN
  SELECT id INTO v_course_id FROM courses
   WHERE title = 'Microsoft Excel Essentials — Short Clips' LIMIT 1;
  IF v_course_id IS NULL THEN
    RAISE EXCEPTION 'Course "Microsoft Excel Essentials — Short Clips" not found — nothing changed.';
  END IF;


  -- ── WEEK 1 ─────────────────────────────────────────────
  SELECT id INTO v_mod_id FROM course_modules
   WHERE course_id = v_course_id AND week_number = 1 LIMIT 1;
  IF v_mod_id IS NULL THEN
    RAISE EXCEPTION 'Week 1 module not found in the Short Clips course.';
  END IF;

  DELETE FROM module_resources
   WHERE course_module_id = v_mod_id AND url LIKE '%youtube.com/%';

  INSERT INTO module_resources
    (course_module_id, resource_type, title, url, description, sort_order) VALUES
    (v_mod_id, 'video', 'Excel interface tour (ribbon, cells, name box, formula bar)', 'https://www.youtube.com/watch?v=SOvI2_dL02Q', 'Open a blank workbook and point out the ribbon, a cell, the Name Box, and the formula bar. Type your name in cell A1.', 1),
    (v_mod_id, 'video', 'ID · Tur antarmuka Excel (ribbon, sel, name box, formula bar)', 'https://www.youtube.com/watch?v=UJCkKUTNNAE', 'Buka workbook kosong dan tunjukkan ribbon, sebuah sel, Name Box, dan formula bar. Ketik namamu di sel A1.', 2),
    (v_mod_id, 'video', 'Entering and editing data (Enter, Tab, F2)', 'https://www.youtube.com/watch?v=MFSvwFUirEM', 'Type 5 item names down column A using Enter and Tab, then edit one cell with F2.', 3),
    (v_mod_id, 'video', 'ID · Memasukkan dan mengedit data (Enter, Tab, F2)', 'https://www.youtube.com/watch?v=ctMaR7yG-Rs', 'Ketik 5 nama barang ke bawah di kolom A memakai Enter dan Tab, lalu edit satu sel dengan F2.', 4),
    (v_mod_id, 'video', 'Selecting cells, rows, columns, and ranges', 'https://www.youtube.com/watch?v=_tnbn96yxIc', 'Select column A, then row 1, then the range A1:C5 by clicking and dragging.', 5),
    (v_mod_id, 'video', 'ID · Memilih sel, baris, kolom, dan rentang', 'https://www.youtube.com/watch?v=CSu-0IArgAk', 'Pilih kolom A, lalu baris 1, lalu rentang A1:C5 dengan klik dan seret.', 6),
    (v_mod_id, 'video', 'Copy, cut, paste, and Paste Special (values only)', 'https://www.youtube.com/watch?v=Y5CKUd-Q3i4', 'Copy A1:A5, then use Paste Special -> Values to paste only the values into C1.', 7),
    (v_mod_id, 'video', 'ID · Salin, potong, tempel, dan Paste Special (hanya nilai)', 'https://www.youtube.com/watch?v=QrMxhbBkwNc', 'Salin A1:A5, lalu pakai Paste Special -> Values untuk menempel hanya nilainya ke C1.', 8),
    (v_mod_id, 'video', 'AutoFill and Flash Fill', 'https://www.youtube.com/watch?v=jOeiKZz7Y5Q', 'Type 1 and 2 and drag the fill handle to make 1-10, then use Flash Fill to split first names from a full-name column.', 9),
    (v_mod_id, 'video', 'ID · AutoFill dan Flash Fill', 'https://www.youtube.com/watch?v=jZO2aOXr8Vg', 'Ketik 1 dan 2 lalu seret fill handle membuat 1-10, kemudian pakai Flash Fill untuk memisahkan nama depan dari kolom nama lengkap.', 10),
    (v_mod_id, 'video', 'Undo/Redo and saving (.xlsx vs .csv)', 'https://www.youtube.com/watch?v=O1Z7WjdyHbY', 'Delete a row, press Ctrl+Z to undo, then save the file once as .xlsx and once as .csv.', 11),
    (v_mod_id, 'video', 'ID · Undo/Redo dan menyimpan (.xlsx vs .csv)', 'https://www.youtube.com/watch?v=Mkefp55GdcA', 'Hapus satu baris, tekan Ctrl+Z untuk membatalkan, lalu simpan file sekali sebagai .xlsx dan sekali sebagai .csv.', 12),
    (v_mod_id, 'video', 'Freeze Panes', 'https://www.youtube.com/watch?v=wjGzYpdIcxY', 'Add a header row, then use View -> Freeze Panes -> Freeze Top Row and scroll to test it.', 13),
    (v_mod_id, 'video', 'ID · Freeze Panes (membekukan judul)', 'https://www.youtube.com/watch?v=Q45aYUCjLP8', 'Tambahkan baris judul, lalu pakai View -> Freeze Panes -> Freeze Top Row dan gulir untuk mengujinya.', 14),
    (v_mod_id, 'video', 'Inserting/deleting rows and columns, resizing', 'https://www.youtube.com/watch?v=_JjqaMmDlig', 'Insert a new row above row 2, delete column B, and widen column A.', 15),
    (v_mod_id, 'video', 'ID · Menyisipkan/menghapus baris dan kolom, mengubah ukuran', 'https://www.youtube.com/watch?v=a-3lWaL2uHk', 'Sisipkan baris baru di atas baris 2, hapus kolom B, dan lebarkan kolom A.', 16),
    (v_mod_id, 'video', 'Working with multiple sheets', 'https://www.youtube.com/watch?v=qRShQc-v3LI', 'Rename Sheet1 to ''Stock'', add a second sheet named ''Prices'', and give the tabs different colors.', 17),
    (v_mod_id, 'video', 'ID · Bekerja dengan banyak sheet', 'https://www.youtube.com/watch?v=92w4EU8Sqbw', 'Ganti nama Sheet1 menjadi ''Stok'', tambahkan sheet kedua bernama ''Harga'', dan beri warna berbeda pada tab.', 18);

  -- ── WEEK 2 ─────────────────────────────────────────────
  SELECT id INTO v_mod_id FROM course_modules
   WHERE course_id = v_course_id AND week_number = 2 LIMIT 1;
  IF v_mod_id IS NULL THEN
    RAISE EXCEPTION 'Week 2 module not found in the Short Clips course.';
  END IF;

  DELETE FROM module_resources
   WHERE course_module_id = v_mod_id AND url LIKE '%youtube.com/%';

  INSERT INTO module_resources
    (course_module_id, resource_type, title, url, description, sort_order) VALUES
    (v_mod_id, 'video', 'Number formats (currency Rp, percentage, dates)', 'https://www.youtube.com/watch?v=sKv2DOwk6-A', 'Format one column as Currency (Rp), one as Percentage, and one as Date.', 1),
    (v_mod_id, 'video', 'ID · Format angka (mata uang Rp, persentase, tanggal)', 'https://www.youtube.com/watch?v=06sRaogKIPU', 'Format satu kolom sebagai Mata Uang (Rp), satu sebagai Persentase, dan satu sebagai Tanggal.', 2),
    (v_mod_id, 'video', 'Cell formatting (bold, borders, fill, wrap text)', 'https://www.youtube.com/watch?v=ryrz6UVvOwM', 'Make the header row bold, add borders around A1:C5, and turn on Wrap Text.', 3),
    (v_mod_id, 'video', 'ID · Format sel (tebal, garis, warna, wrap text)', 'https://www.youtube.com/watch?v=yF_tnM7BJTg', 'Buat baris judul menjadi tebal, tambahkan garis tepi di A1:C5, dan aktifkan Wrap Text.', 4),
    (v_mod_id, 'video', 'Merge & Center vs Center Across Selection', 'https://www.youtube.com/watch?v=2PkEfxayYrs', 'Use Merge & Center on a title across A1:C1, then redo it with Center Across Selection instead.', 5),
    (v_mod_id, 'video', 'ID · Merge & Center vs Center Across Selection', 'https://www.youtube.com/watch?v=g_ZV9vGibes', 'Pakai Merge & Center pada judul di A1:C1, lalu ulangi memakai Center Across Selection.', 6),
    (v_mod_id, 'video', 'Format Painter', 'https://www.youtube.com/watch?v=pKQf06bLs28', 'Format one cell nicely, then use Format Painter to copy that look onto 5 other cells.', 7),
    (v_mod_id, 'video', 'ID · Format Painter', 'https://www.youtube.com/watch?v=hoK59cUsR_A', 'Format satu sel dengan rapi, lalu pakai Format Painter untuk menyalin tampilannya ke 5 sel lain.', 8),
    (v_mod_id, 'video', 'Conditional Formatting (highlight low stock)', 'https://www.youtube.com/watch?v=DXbUjlR9URA', 'Add a Highlight Cells rule so any stock value below 10 turns red.', 9),
    (v_mod_id, 'video', 'ID · Format bersyarat (menyorot stok menipis)', 'https://www.youtube.com/watch?v=1E9DORLGizA', 'Tambahkan aturan Highlight Cells agar nilai stok di bawah 10 berubah menjadi merah.', 10),
    (v_mod_id, 'video', 'Format as Table', 'https://www.youtube.com/watch?v=M07df44RXOM', 'Select your data and apply Format as Table, then try the filter arrows in the header.', 11),
    (v_mod_id, 'video', 'ID · Format sebagai Tabel', 'https://www.youtube.com/watch?v=4cr6Vo1PNDc', 'Pilih datamu dan terapkan Format as Table, lalu coba panah filter di barisan judul.', 12),
    (v_mod_id, 'video', 'Cell styles and themes', 'https://www.youtube.com/watch?v=Stnq9DNwGME', 'Apply a built-in Cell Style to your header, then change the workbook Theme.', 13),
    (v_mod_id, 'video', 'ID · Gaya sel dan tema', 'https://www.youtube.com/watch?v=shaXE0fAf6o', 'Terapkan Cell Style bawaan pada judulmu, lalu ubah Theme workbook.', 14);

  -- ── WEEK 3 ─────────────────────────────────────────────
  SELECT id INTO v_mod_id FROM course_modules
   WHERE course_id = v_course_id AND week_number = 3 LIMIT 1;
  IF v_mod_id IS NULL THEN
    RAISE EXCEPTION 'Week 3 module not found in the Short Clips course.';
  END IF;

  DELETE FROM module_resources
   WHERE course_module_id = v_mod_id AND url LIKE '%youtube.com/%';

  INSERT INTO module_resources
    (course_module_id, resource_type, title, url, description, sort_order) VALUES
    (v_mod_id, 'video', 'Your first formula (=, cell references, + − * /)', 'https://www.youtube.com/watch?v=S3fhooS5Oik', 'In C2 type =A2+B2, then try the same with - , * and / on your own numbers.', 1),
    (v_mod_id, 'video', 'ID · Rumus pertamamu (=, referensi sel, + − * /)', 'https://www.youtube.com/watch?v=Mj-H3HEogsw', 'Di C2 ketik =A2+B2, lalu coba hal serupa dengan - , * dan / pada angkamu sendiri.', 2),
    (v_mod_id, 'video', 'SUM and AutoSum', 'https://www.youtube.com/watch?v=oSa7pP5um_s', 'Use =SUM() to total a column of quantities, then do it again with the AutoSum button.', 3),
    (v_mod_id, 'video', 'ID · SUM dan AutoSum', 'https://www.youtube.com/watch?v=v8w5vWheSoM', 'Pakai =SUM() untuk menjumlahkan kolom kuantitas, lalu ulangi dengan tombol AutoSum.', 4),
    (v_mod_id, 'video', 'AVERAGE, MIN, MAX', 'https://www.youtube.com/watch?v=k3MHxObhD_0', 'Add AVERAGE, MIN, and MAX below a column of prices.', 5),
    (v_mod_id, 'video', 'ID · AVERAGE, MIN, MAX', 'https://www.youtube.com/watch?v=FDmXCngGTOY', 'Tambahkan AVERAGE, MIN, dan MAX di bawah kolom harga.', 6),
    (v_mod_id, 'video', 'COUNT vs COUNTA vs COUNTBLANK', 'https://www.youtube.com/watch?v=K7qO3PBCCgM', 'Use COUNT, COUNTA, and COUNTBLANK on a column that has some blank cells.', 7),
    (v_mod_id, 'video', 'ID · COUNT vs COUNTA vs COUNTBLANK', 'https://www.youtube.com/watch?v=yJURU4Ac-Ew', 'Pakai COUNT, COUNTA, dan COUNTBLANK pada kolom yang punya beberapa sel kosong.', 8),
    (v_mod_id, 'video', 'Relative vs absolute references ($A$1)', 'https://www.youtube.com/watch?v=DIkBBIo0thw', 'Write a formula using $A$1 and copy it down to see the reference stay fixed.', 9),
    (v_mod_id, 'video', 'ID · Referensi relatif vs absolut ($A$1)', 'https://www.youtube.com/watch?v=9-40DwzfbnY', 'Tulis rumus memakai $A$1 dan salin ke bawah untuk melihat referensinya tetap terkunci.', 10),
    (v_mod_id, 'video', 'Copying formulas down a column', 'https://www.youtube.com/watch?v=PVhuI4pJ6es', 'Write one formula in D2, then double-click the fill handle to copy it down the whole column.', 11),
    (v_mod_id, 'video', 'ID · Menyalin rumus ke bawah kolom', 'https://www.youtube.com/watch?v=CyRH0_0Lg54', 'Tulis satu rumus di D2, lalu klik dua kali fill handle untuk menyalinnya ke seluruh kolom.', 12);

  -- ── WEEK 4 ─────────────────────────────────────────────
  SELECT id INTO v_mod_id FROM course_modules
   WHERE course_id = v_course_id AND week_number = 4 LIMIT 1;
  IF v_mod_id IS NULL THEN
    RAISE EXCEPTION 'Week 4 module not found in the Short Clips course.';
  END IF;

  DELETE FROM module_resources
   WHERE course_module_id = v_mod_id AND url LIKE '%youtube.com/%';

  INSERT INTO module_resources
    (course_module_id, resource_type, title, url, description, sort_order) VALUES
    (v_mod_id, 'video', 'IF (pass/fail decisions)', 'https://www.youtube.com/watch?v=jIYD7wiWDU4', 'Write =IF(A2>=60,"Pass","Fail") for a list of scores.', 1),
    (v_mod_id, 'video', 'ID · IF (keputusan lulus/gagal)', 'https://www.youtube.com/watch?v=xd7KLdprOI8', 'Tulis =IF(A2>=60;"Lulus";"Gagal") untuk daftar nilai.', 2),
    (v_mod_id, 'video', 'Nested IF and IFS (grading A/B/C/D)', 'https://www.youtube.com/watch?v=5vzcDWuB6Ys', 'Grade a list of scores into A/B/C/D using IFS (or nested IF).', 3),
    (v_mod_id, 'video', 'ID · IF bertingkat dan IFS (penilaian A/B/C/D)', 'https://www.youtube.com/watch?v=51ZBVkFl4sg', 'Beri nilai huruf A/B/C/D pada daftar skor memakai IFS (atau IF bersarang).', 4),
    (v_mod_id, 'video', 'AND / OR inside IF', 'https://www.youtube.com/watch?v=5vHT16cEOPc', 'Write an IF that passes only when score>=60 AND attendance>=80 using AND().', 5),
    (v_mod_id, 'video', 'ID · AND / OR di dalam IF', 'https://www.youtube.com/watch?v=ZhACHy0s_14', 'Tulis IF yang lulus hanya jika nilai>=60 DAN kehadiran>=80 memakai AND().', 6),
    (v_mod_id, 'video', 'COUNTIF / COUNTIFS', 'https://www.youtube.com/watch?v=ut4hez1MJ3s', 'Count how many items are ''Low'' with COUNTIF, then add a second condition using COUNTIFS.', 7),
    (v_mod_id, 'video', 'ID · COUNTIF / COUNTIFS', 'https://www.youtube.com/watch?v=z79QDAJ3rtk', 'Hitung berapa barang berstatus ''Rendah'' dengan COUNTIF, lalu tambah kondisi kedua memakai COUNTIFS.', 8),
    (v_mod_id, 'video', 'SUMIF / SUMIFS', 'https://www.youtube.com/watch?v=dI8w0utjUc0', 'Total the quantity for one category with SUMIF, then use two conditions with SUMIFS.', 9),
    (v_mod_id, 'video', 'ID · SUMIF / SUMIFS', 'https://www.youtube.com/watch?v=oBAkApf6V0A', 'Jumlahkan kuantitas untuk satu kategori dengan SUMIF, lalu pakai dua kondisi dengan SUMIFS.', 10),
    (v_mod_id, 'video', 'AVERAGEIF', 'https://www.youtube.com/watch?v=bCX-qAz2Cqk', 'Find the average price of items in one category using AVERAGEIF.', 11),
    (v_mod_id, 'video', 'ID · AVERAGEIF', 'https://www.youtube.com/watch?v=eoJrBXQwI0k', 'Cari harga rata-rata barang pada satu kategori memakai AVERAGEIF.', 12);

  -- ── WEEK 5 ─────────────────────────────────────────────
  SELECT id INTO v_mod_id FROM course_modules
   WHERE course_id = v_course_id AND week_number = 5 LIMIT 1;
  IF v_mod_id IS NULL THEN
    RAISE EXCEPTION 'Week 5 module not found in the Short Clips course.';
  END IF;

  DELETE FROM module_resources
   WHERE course_module_id = v_mod_id AND url LIKE '%youtube.com/%';

  INSERT INTO module_resources
    (course_module_id, resource_type, title, url, description, sort_order) VALUES
    (v_mod_id, 'video', 'VLOOKUP (find a price from a master list)', 'https://www.youtube.com/watch?v=xIynD1gFOLo', 'Build a small price list and use VLOOKUP to pull a price by item code.', 1),
    (v_mod_id, 'video', 'ID · VLOOKUP (mencari harga dari daftar induk)', 'https://www.youtube.com/watch?v=7JXWn9c68PM', 'Buat daftar harga kecil dan pakai VLOOKUP untuk mengambil harga berdasarkan kode barang.', 2),
    (v_mod_id, 'video', 'XLOOKUP (the modern replacement)', 'https://www.youtube.com/watch?v=y5H6Yi3V4cw', 'Redo the same lookup with XLOOKUP.', 3),
    (v_mod_id, 'video', 'ID · XLOOKUP (pengganti modern)', 'https://www.youtube.com/watch?v=eMryM48_-L8', 'Ulangi pencarian yang sama dengan XLOOKUP.', 4),
    (v_mod_id, 'video', 'INDEX + MATCH', 'https://www.youtube.com/watch?v=6JhbY8Mku1A', 'Look up a value using INDEX and MATCH together.', 5),
    (v_mod_id, 'video', 'ID · INDEX + MATCH', 'https://www.youtube.com/watch?v=TbiTs6sV7zE', 'Cari sebuah nilai memakai INDEX dan MATCH bersama-sama.', 6),
    (v_mod_id, 'video', 'IFERROR (clean up #N/A)', 'https://www.youtube.com/watch?v=xEjLwqYjKFk', 'Wrap your lookup in IFERROR so #N/A shows "Not found" instead.', 7),
    (v_mod_id, 'video', 'ID · IFERROR (merapikan #N/A)', 'https://www.youtube.com/watch?v=3jb0L8JfvZ0', 'Bungkus pencarianmu dengan IFERROR agar #N/A menampilkan "Tidak ditemukan".', 8);

  -- ── WEEK 6 ─────────────────────────────────────────────
  SELECT id INTO v_mod_id FROM course_modules
   WHERE course_id = v_course_id AND week_number = 6 LIMIT 1;
  IF v_mod_id IS NULL THEN
    RAISE EXCEPTION 'Week 6 module not found in the Short Clips course.';
  END IF;

  DELETE FROM module_resources
   WHERE course_module_id = v_mod_id AND url LIKE '%youtube.com/%';

  INSERT INTO module_resources
    (course_module_id, resource_type, title, url, description, sort_order) VALUES
    (v_mod_id, 'video', 'CONCAT / TEXTJOIN and & (combine names)', 'https://www.youtube.com/watch?v=77NAWZwi0CI', 'Combine first and last name into one cell using & , then again using TEXTJOIN.', 1),
    (v_mod_id, 'video', 'ID · CONCAT / TEXTJOIN dan & (menggabung nama)', 'https://www.youtube.com/watch?v=oXI3_8VeXSE', 'Gabungkan nama depan dan belakang ke satu sel memakai & , lalu ulangi dengan TEXTJOIN.', 2),
    (v_mod_id, 'video', 'LEFT, RIGHT, MID (extract codes)', 'https://www.youtube.com/watch?v=PbWRI7ANjsE', 'Extract the first 3 letters of a code with LEFT and the middle part with MID.', 3),
    (v_mod_id, 'video', 'ID · LEFT, RIGHT, MID (mengekstrak kode)', 'https://www.youtube.com/watch?v=rgb1VrHoHqE', 'Ambil 3 huruf pertama sebuah kode dengan LEFT dan bagian tengahnya dengan MID.', 4),
    (v_mod_id, 'video', 'UPPER, LOWER, PROPER', 'https://www.youtube.com/watch?v=PkuhtMDkGUI', 'Convert a name column to UPPER, LOWER, and PROPER case.', 5),
    (v_mod_id, 'video', 'ID · UPPER, LOWER, PROPER', 'https://www.youtube.com/watch?v=E1OoThT5vCg', 'Ubah kolom nama menjadi huruf UPPER, LOWER, dan PROPER.', 6),
    (v_mod_id, 'video', 'TRIM and CLEAN', 'https://www.youtube.com/watch?v=6xD59AgxUi8', 'Use TRIM to remove extra spaces from a messy text column.', 7),
    (v_mod_id, 'video', 'ID · TRIM dan CLEAN', 'https://www.youtube.com/watch?v=DJR8PCDwAkA', 'Pakai TRIM untuk menghapus spasi berlebih dari kolom teks yang berantakan.', 8),
    (v_mod_id, 'video', 'TEXT function (format inside text)', 'https://www.youtube.com/watch?v=lpux4m0jsdk', 'Use TEXT to show a number as "Rp #,##0" inside a sentence.', 9),
    (v_mod_id, 'video', 'ID · Fungsi TEXT (format di dalam teks)', 'https://www.youtube.com/watch?v=E6jMy7JSYXE', 'Pakai TEXT untuk menampilkan angka sebagai "Rp #.##0" di dalam kalimat.', 10),
    (v_mod_id, 'video', 'TODAY and NOW', 'https://www.youtube.com/watch?v=HUstL5T5L4s', 'Put =TODAY() in one cell and =NOW() in another.', 11),
    (v_mod_id, 'video', 'ID · TODAY dan NOW', 'https://www.youtube.com/watch?v=fsP3R4_sw-s', 'Letakkan =TODAY() di satu sel dan =NOW() di sel lain.', 12),
    (v_mod_id, 'video', 'DATEDIF and date math', 'https://www.youtube.com/watch?v=uXItl_HQR5Q', 'Use DATEDIF to find the number of days between two dates.', 13),
    (v_mod_id, 'video', 'ID · DATEDIF dan perhitungan tanggal', 'https://www.youtube.com/watch?v=2M4XCoZ2VRk', 'Pakai DATEDIF untuk menghitung jumlah hari antara dua tanggal.', 14),
    (v_mod_id, 'video', 'WEEKDAY, MONTH, YEAR', 'https://www.youtube.com/watch?v=ajCHNzO774w', 'Pull the weekday, month, and year out of a date using WEEKDAY, MONTH, and YEAR.', 15),
    (v_mod_id, 'video', 'ID · WEEKDAY, MONTH, YEAR', 'https://www.youtube.com/watch?v=p1hDJVHXsNE', 'Ambil hari, bulan, dan tahun dari sebuah tanggal memakai WEEKDAY, MONTH, dan YEAR.', 16);

  -- ── WEEK 7 ─────────────────────────────────────────────
  SELECT id INTO v_mod_id FROM course_modules
   WHERE course_id = v_course_id AND week_number = 7 LIMIT 1;
  IF v_mod_id IS NULL THEN
    RAISE EXCEPTION 'Week 7 module not found in the Short Clips course.';
  END IF;

  DELETE FROM module_resources
   WHERE course_module_id = v_mod_id AND url LIKE '%youtube.com/%';

  INSERT INTO module_resources
    (course_module_id, resource_type, title, url, description, sort_order) VALUES
    (v_mod_id, 'video', 'Sort (A-Z, multi-level)', 'https://www.youtube.com/watch?v=YkaYOSduu40', 'Sort your table by category, then add a second level to also sort by quantity.', 1),
    (v_mod_id, 'video', 'ID · Mengurutkan (A-Z, bertingkat)', 'https://www.youtube.com/watch?v=PSHpJRewxPY', 'Urutkan tabelmu berdasarkan kategori, lalu tambah level kedua agar juga terurut berdasarkan kuantitas.', 2),
    (v_mod_id, 'video', 'Filter', 'https://www.youtube.com/watch?v=4i1DH6EwIIE', 'Turn on Filter and show only the items in one category.', 3),
    (v_mod_id, 'video', 'ID · Filter', 'https://www.youtube.com/watch?v=1xmb4t-3o54', 'Aktifkan Filter dan tampilkan hanya barang dalam satu kategori.', 4),
    (v_mod_id, 'video', 'Remove Duplicates', 'https://www.youtube.com/watch?v=7hJstN44pTE', 'Add a duplicate row, then use Remove Duplicates to clean it up.', 5),
    (v_mod_id, 'video', 'ID · Menghapus Duplikat', 'https://www.youtube.com/watch?v=MAUl6YsMbUU', 'Tambahkan satu baris duplikat, lalu pakai Remove Duplicates untuk membersihkannya.', 6),
    (v_mod_id, 'video', 'Data Validation (dropdown lists)', 'https://www.youtube.com/watch?v=uQd92e6ilBQ', 'Add a dropdown list of categories to a column using Data Validation.', 7),
    (v_mod_id, 'video', 'ID · Validasi Data (daftar dropdown)', 'https://www.youtube.com/watch?v=olGoOdAB_bM', 'Tambahkan daftar dropdown kategori ke sebuah kolom memakai Data Validation.', 8),
    (v_mod_id, 'video', 'Text to Columns', 'https://www.youtube.com/watch?v=QyZ6IMkln2U', 'Split a ''Name Code'' column into two columns using Text to Columns.', 9),
    (v_mod_id, 'video', 'ID · Text to Columns', 'https://www.youtube.com/watch?v=ClQHIVx4peo', 'Pisahkan kolom ''Nama Kode'' menjadi dua kolom memakai Text to Columns.', 10),
    (v_mod_id, 'video', 'Find & Replace', 'https://www.youtube.com/watch?v=4hiVLC7vgf0', 'Use Find & Replace to change every ''pcs'' to ''units''.', 11),
    (v_mod_id, 'video', 'ID · Find & Replace', 'https://www.youtube.com/watch?v=1bZSEq9YkV0', 'Pakai Find & Replace untuk mengubah setiap ''pcs'' menjadi ''unit''.', 12),
    (v_mod_id, 'video', 'Grouping and outlining', 'https://www.youtube.com/watch?v=0S2ZHyxd2NI', 'Group a set of rows so you can collapse and expand them.', 13),
    (v_mod_id, 'video', 'ID · Pengelompokan baris/kolom', 'https://www.youtube.com/watch?v=50-pFvmgWp8', 'Kelompokkan sekumpulan baris agar bisa kamu ciutkan dan bentangkan.', 14);

  -- ── WEEK 8 ─────────────────────────────────────────────
  SELECT id INTO v_mod_id FROM course_modules
   WHERE course_id = v_course_id AND week_number = 8 LIMIT 1;
  IF v_mod_id IS NULL THEN
    RAISE EXCEPTION 'Week 8 module not found in the Short Clips course.';
  END IF;

  DELETE FROM module_resources
   WHERE course_module_id = v_mod_id AND url LIKE '%youtube.com/%';

  INSERT INTO module_resources
    (course_module_id, resource_type, title, url, description, sort_order) VALUES
    (v_mod_id, 'video', 'Creating your first chart', 'https://www.youtube.com/watch?v=64DSXejsYbo', 'Select a small table and insert a column chart.', 1),
    (v_mod_id, 'video', 'ID · Membuat grafik pertamamu', 'https://www.youtube.com/watch?v=FdzvFJ6Dc0U', 'Pilih tabel kecil dan sisipkan grafik kolom.', 2),
    (v_mod_id, 'video', 'Choosing the right chart type', 'https://www.youtube.com/watch?v=IHffvF4Vrm8', 'Show the same data as a bar, line, and pie chart, then pick the clearest one.', 3),
    (v_mod_id, 'video', 'ID · Memilih jenis grafik yang tepat', 'https://www.youtube.com/watch?v=o3afb6BDhvg', 'Tampilkan data yang sama sebagai grafik batang, garis, dan lingkaran, lalu pilih yang paling jelas.', 4),
    (v_mod_id, 'video', 'Formatting charts', 'https://www.youtube.com/watch?v=ZeZ94yEa6xI', 'Add a chart title and data labels, then change the chart colors.', 5),
    (v_mod_id, 'video', 'ID · Memformat grafik', 'https://www.youtube.com/watch?v=1-BhbQm2dCA', 'Tambahkan judul grafik dan label data, lalu ubah warna grafik.', 6),
    (v_mod_id, 'video', 'Sparklines', 'https://www.youtube.com/watch?v=xCDcrC0a6Zo', 'Add a line sparkline next to each row of monthly numbers.', 7),
    (v_mod_id, 'video', 'ID · Sparklines', 'https://www.youtube.com/watch?v=JzFEvTTRxNI', 'Tambahkan sparkline garis di samping setiap baris angka bulanan.', 8),
    (v_mod_id, 'video', 'PivotTables part 1 (summarize data)', 'https://www.youtube.com/watch?v=dvbLrwD2SpA', 'Create a PivotTable that sums quantity by category.', 9),
    (v_mod_id, 'video', 'ID · PivotTable bagian 1 (meringkas data)', 'https://www.youtube.com/watch?v=OoN5KjqzD2I', 'Buat PivotTable yang menjumlahkan kuantitas berdasarkan kategori.', 10),
    (v_mod_id, 'video', 'PivotTables part 2 (grouping, slicers)', 'https://www.youtube.com/watch?v=mW4QWFW1oO8', 'Group your PivotTable and add a Slicer to filter it.', 11),
    (v_mod_id, 'video', 'ID · PivotTable bagian 2 (pengelompokan, slicer)', 'https://www.youtube.com/watch?v=pHFzHSLEOXk', 'Kelompokkan PivotTable-mu dan tambahkan Slicer untuk memfilternya.', 12),
    (v_mod_id, 'video', 'PivotCharts', 'https://www.youtube.com/watch?v=7IbW_DF89Ws', 'Add a PivotChart to your PivotTable.', 13),
    (v_mod_id, 'video', 'ID · PivotChart', 'https://www.youtube.com/watch?v=7kZu5pqnR-k', 'Tambahkan PivotChart ke PivotTable-mu.', 14);

  -- ── WEEK 9 ─────────────────────────────────────────────
  SELECT id INTO v_mod_id FROM course_modules
   WHERE course_id = v_course_id AND week_number = 9 LIMIT 1;
  IF v_mod_id IS NULL THEN
    RAISE EXCEPTION 'Week 9 module not found in the Short Clips course.';
  END IF;

  DELETE FROM module_resources
   WHERE course_module_id = v_mod_id AND url LIKE '%youtube.com/%';

  INSERT INTO module_resources
    (course_module_id, resource_type, title, url, description, sort_order) VALUES
    (v_mod_id, 'video', 'Top 10 keyboard shortcuts', 'https://www.youtube.com/watch?v=2edm5xqn-8I', 'Practice Ctrl+C, Ctrl+V, Ctrl+Z, Ctrl+S and a few more shortcuts on your workbook.', 1),
    (v_mod_id, 'video', 'ID · 10 pintasan keyboard teratas', 'https://www.youtube.com/watch?v=qKWb7jinyhA', 'Latih Ctrl+C, Ctrl+V, Ctrl+Z, Ctrl+S dan beberapa pintasan lain di workbook-mu.', 2),
    (v_mod_id, 'video', 'Print setup (print area, fit to page)', 'https://www.youtube.com/watch?v=Mrt4v0ysA8w', 'Set a Print Area, then use ''Fit to 1 page wide'' in Print settings.', 3),
    (v_mod_id, 'video', 'ID · Pengaturan cetak (area cetak, muat satu halaman)', 'https://www.youtube.com/watch?v=y5N2AjwEVp4', 'Atur Print Area, lalu pakai ''Fit to 1 page wide'' di pengaturan Print.', 4),
    (v_mod_id, 'video', 'Page headers/footers and page numbers', 'https://www.youtube.com/watch?v=1uFzJfiP-ZI', 'Add a header with the sheet title and a footer with page numbers.', 5),
    (v_mod_id, 'video', 'ID · Header/footer dan nomor halaman', 'https://www.youtube.com/watch?v=LA3I1FZppJo', 'Tambahkan header berisi judul sheet dan footer berisi nomor halaman.', 6),
    (v_mod_id, 'video', 'Protecting sheets and locking cells', 'https://www.youtube.com/watch?v=wrOE8fheMR0', 'Lock your formula cells and protect the sheet, leaving the input cells editable.', 7),
    (v_mod_id, 'video', 'ID · Proteksi sheet dan mengunci sel', 'https://www.youtube.com/watch?v=I-OrXo9OOAM', 'Kunci sel rumusmu dan proteksi sheet, biarkan sel input tetap bisa diisi.', 8),
    (v_mod_id, 'video', 'Comments and notes', 'https://www.youtube.com/watch?v=aY-p0oySZa0', 'Add a comment to one cell and a note to another.', 9),
    (v_mod_id, 'video', 'ID · Komentar dan catatan', 'https://www.youtube.com/watch?v=upPdxHt8Nkg', 'Tambahkan comment pada satu sel dan note pada sel lain.', 10),
    (v_mod_id, 'video', 'Exporting to PDF and sharing', 'https://www.youtube.com/watch?v=iuoQyIZW0tA', 'Save or export your finished workbook as a PDF.', 11),
    (v_mod_id, 'video', 'ID · Ekspor ke PDF dan berbagi', 'https://www.youtube.com/watch?v=Ms4lTSlNzhQ', 'Simpan atau ekspor workbook selesaimu sebagai PDF.', 12);

  -- ── Clips become material, not graded tasks ───────────────
  -- Drop any completions first (checklist_completions has no FK to items),
  -- then the 60 clip checklist items. Tutor items (xl_wN_tN) are untouched.
  DELETE FROM checklist_completions
   WHERE item_key ~ '^xl_w[0-9]+_s[0-9]+$';

  DELETE FROM module_checklist_items
   WHERE item_key ~ '^xl_w[0-9]+_s[0-9]+$'
     AND course_module_id IN (SELECT id FROM course_modules WHERE course_id = v_course_id);

  RAISE NOTICE 'Excel clips are now resources; clip checklist items removed.';
END $$;

-- Verify: expect 9 rows, each with videos = 2x that week's clip count,
-- student_items = 0, tutor_items = 3
SELECT m.week_number,
       m.title,
       count(DISTINCT r.id) FILTER (WHERE r.url LIKE '%youtube.com/%') AS videos,
       count(DISTINCT i.id) FILTER (WHERE i.item_type = 'student')     AS student_items,
       count(DISTINCT i.id) FILTER (WHERE i.item_type = 'teacher')     AS tutor_items
  FROM course_modules m
  LEFT JOIN module_resources r       ON r.course_module_id = m.id
  LEFT JOIN module_checklist_items i ON i.course_module_id = m.id
 WHERE m.course_id = (SELECT id FROM courses WHERE title = 'Microsoft Excel Essentials — Short Clips')
 GROUP BY m.week_number, m.title
 ORDER BY m.week_number;

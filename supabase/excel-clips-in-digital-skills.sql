-- ============================================================
-- excel-clips-in-digital-skills.sql
-- Consolidation: move the Excel short-clips into the SAME course that now
-- holds the PowerPoint clips — "Microsoft Digital Skills for University Prep"
-- — as watchable resources on its existing
-- "Microsoft Excel – Data & Spreadsheets" module. Mirrors the PowerPoint setup.
--
-- Per topic, two videos are added under Materi/Resources:
--   * an English tutorial      (sort_order 2k-1)
--   * a Bahasa Indonesia one   (sort_order 2k, title prefixed "ID · ")
-- Titles are grouped "Theme · Topic" across the 9 original weekly themes.
-- Each description is that topic's practice task in the matching language.
--
-- All 120 videos were oEmbed-verified (embeddable) and language-confirmed
-- from their canonical titles. Resources only: the module keeps its own
-- checklist items and quiz, which are untouched.
--
-- Pair with delete-standalone-excel-course.sql to end up with ONE course.
-- Idempotent: re-running refreshes only the clip videos this file adds
-- (matched by the theme/ID title prefixes); the module's original video is
-- left alone. Run in the Supabase SQL Editor.
-- ============================================================

DO $$
DECLARE
  v_mod_id UUID;
BEGIN
  SELECT m.id INTO v_mod_id
    FROM course_modules m
    JOIN courses c ON c.id = m.course_id
   WHERE c.title = 'Microsoft Digital Skills for University Prep'
     AND m.title LIKE 'Microsoft Excel%'
   LIMIT 1;

  IF v_mod_id IS NULL THEN
    RAISE EXCEPTION 'Excel module not found in the Digital Skills course — nothing changed.';
  END IF;

  DELETE FROM module_resources
   WHERE course_module_id = v_mod_id
     AND (title LIKE 'Getting Started with Excel · %' OR title LIKE 'Formatting Like a Pro · %' OR title LIKE 'Your First Formulas · %' OR title LIKE 'Smart Decisions with Logic · %' OR title LIKE 'Finding Data with Lookups · %' OR title LIKE 'Text & Dates Mastery · %' OR title LIKE 'Managing Real Data · %' OR title LIKE 'Charts & PivotTables · %' OR title LIKE 'Output & Protection · %' OR title LIKE 'ID · %');

  INSERT INTO module_resources
    (course_module_id, resource_type, title, url, description, sort_order) VALUES
    (v_mod_id, 'video', 'Getting Started with Excel · Excel interface tour (ribbon, cells, name box, formula bar)', 'https://www.youtube.com/watch?v=SOvI2_dL02Q', 'Open a blank workbook and point out the ribbon, a cell, the Name Box, and the formula bar. Type your name in cell A1.', 1),
    (v_mod_id, 'video', 'ID · Mengenal Excel · Tur antarmuka Excel (ribbon, sel, name box, formula bar)', 'https://www.youtube.com/watch?v=UJCkKUTNNAE', 'Buka workbook kosong dan tunjukkan ribbon, sebuah sel, Name Box, dan formula bar. Ketik namamu di sel A1.', 2),
    (v_mod_id, 'video', 'Getting Started with Excel · Entering and editing data (Enter, Tab, F2)', 'https://www.youtube.com/watch?v=MFSvwFUirEM', 'Type 5 item names down column A using Enter and Tab, then edit one cell with F2.', 3),
    (v_mod_id, 'video', 'ID · Mengenal Excel · Memasukkan dan mengedit data (Enter, Tab, F2)', 'https://www.youtube.com/watch?v=ctMaR7yG-Rs', 'Ketik 5 nama barang ke bawah di kolom A memakai Enter dan Tab, lalu edit satu sel dengan F2.', 4),
    (v_mod_id, 'video', 'Getting Started with Excel · Selecting cells, rows, columns, and ranges', 'https://www.youtube.com/watch?v=_tnbn96yxIc', 'Select column A, then row 1, then the range A1:C5 by clicking and dragging.', 5),
    (v_mod_id, 'video', 'ID · Mengenal Excel · Memilih sel, baris, kolom, dan rentang', 'https://www.youtube.com/watch?v=CSu-0IArgAk', 'Pilih kolom A, lalu baris 1, lalu rentang A1:C5 dengan klik dan seret.', 6),
    (v_mod_id, 'video', 'Getting Started with Excel · Copy, cut, paste, and Paste Special (values only)', 'https://www.youtube.com/watch?v=Y5CKUd-Q3i4', 'Copy A1:A5, then use Paste Special -> Values to paste only the values into C1.', 7),
    (v_mod_id, 'video', 'ID · Mengenal Excel · Salin, potong, tempel, dan Paste Special (hanya nilai)', 'https://www.youtube.com/watch?v=QrMxhbBkwNc', 'Salin A1:A5, lalu pakai Paste Special -> Values untuk menempel hanya nilainya ke C1.', 8),
    (v_mod_id, 'video', 'Getting Started with Excel · AutoFill and Flash Fill', 'https://www.youtube.com/watch?v=jOeiKZz7Y5Q', 'Type 1 and 2 and drag the fill handle to make 1-10, then use Flash Fill to split first names from a full-name column.', 9),
    (v_mod_id, 'video', 'ID · Mengenal Excel · AutoFill dan Flash Fill', 'https://www.youtube.com/watch?v=jZO2aOXr8Vg', 'Ketik 1 dan 2 lalu seret fill handle membuat 1-10, kemudian pakai Flash Fill untuk memisahkan nama depan dari kolom nama lengkap.', 10),
    (v_mod_id, 'video', 'Getting Started with Excel · Undo/Redo and saving (.xlsx vs .csv)', 'https://www.youtube.com/watch?v=O1Z7WjdyHbY', 'Delete a row, press Ctrl+Z to undo, then save the file once as .xlsx and once as .csv.', 11),
    (v_mod_id, 'video', 'ID · Mengenal Excel · Undo/Redo dan menyimpan (.xlsx vs .csv)', 'https://www.youtube.com/watch?v=Mkefp55GdcA', 'Hapus satu baris, tekan Ctrl+Z untuk membatalkan, lalu simpan file sekali sebagai .xlsx dan sekali sebagai .csv.', 12),
    (v_mod_id, 'video', 'Getting Started with Excel · Freeze Panes', 'https://www.youtube.com/watch?v=wjGzYpdIcxY', 'Add a header row, then use View -> Freeze Panes -> Freeze Top Row and scroll to test it.', 13),
    (v_mod_id, 'video', 'ID · Mengenal Excel · Freeze Panes (membekukan judul)', 'https://www.youtube.com/watch?v=Q45aYUCjLP8', 'Tambahkan baris judul, lalu pakai View -> Freeze Panes -> Freeze Top Row dan gulir untuk mengujinya.', 14),
    (v_mod_id, 'video', 'Getting Started with Excel · Inserting/deleting rows and columns, resizing', 'https://www.youtube.com/watch?v=_JjqaMmDlig', 'Insert a new row above row 2, delete column B, and widen column A.', 15),
    (v_mod_id, 'video', 'ID · Mengenal Excel · Menyisipkan/menghapus baris dan kolom, mengubah ukuran', 'https://www.youtube.com/watch?v=a-3lWaL2uHk', 'Sisipkan baris baru di atas baris 2, hapus kolom B, dan lebarkan kolom A.', 16),
    (v_mod_id, 'video', 'Getting Started with Excel · Working with multiple sheets', 'https://www.youtube.com/watch?v=qRShQc-v3LI', 'Rename Sheet1 to ''Stock'', add a second sheet named ''Prices'', and give the tabs different colors.', 17),
    (v_mod_id, 'video', 'ID · Mengenal Excel · Bekerja dengan banyak sheet', 'https://www.youtube.com/watch?v=92w4EU8Sqbw', 'Ganti nama Sheet1 menjadi ''Stok'', tambahkan sheet kedua bernama ''Harga'', dan beri warna berbeda pada tab.', 18),
    (v_mod_id, 'video', 'Formatting Like a Pro · Number formats (currency Rp, percentage, dates)', 'https://www.youtube.com/watch?v=sKv2DOwk6-A', 'Format one column as Currency (Rp), one as Percentage, and one as Date.', 19),
    (v_mod_id, 'video', 'ID · Memformat Seperti Profesional · Format angka (mata uang Rp, persentase, tanggal)', 'https://www.youtube.com/watch?v=06sRaogKIPU', 'Format satu kolom sebagai Mata Uang (Rp), satu sebagai Persentase, dan satu sebagai Tanggal.', 20),
    (v_mod_id, 'video', 'Formatting Like a Pro · Cell formatting (bold, borders, fill, wrap text)', 'https://www.youtube.com/watch?v=ryrz6UVvOwM', 'Make the header row bold, add borders around A1:C5, and turn on Wrap Text.', 21),
    (v_mod_id, 'video', 'ID · Memformat Seperti Profesional · Format sel (tebal, garis, warna, wrap text)', 'https://www.youtube.com/watch?v=yF_tnM7BJTg', 'Buat baris judul menjadi tebal, tambahkan garis tepi di A1:C5, dan aktifkan Wrap Text.', 22),
    (v_mod_id, 'video', 'Formatting Like a Pro · Merge & Center vs Center Across Selection', 'https://www.youtube.com/watch?v=2PkEfxayYrs', 'Use Merge & Center on a title across A1:C1, then redo it with Center Across Selection instead.', 23),
    (v_mod_id, 'video', 'ID · Memformat Seperti Profesional · Merge & Center vs Center Across Selection', 'https://www.youtube.com/watch?v=g_ZV9vGibes', 'Pakai Merge & Center pada judul di A1:C1, lalu ulangi memakai Center Across Selection.', 24),
    (v_mod_id, 'video', 'Formatting Like a Pro · Format Painter', 'https://www.youtube.com/watch?v=pKQf06bLs28', 'Format one cell nicely, then use Format Painter to copy that look onto 5 other cells.', 25),
    (v_mod_id, 'video', 'ID · Memformat Seperti Profesional · Format Painter', 'https://www.youtube.com/watch?v=hoK59cUsR_A', 'Format satu sel dengan rapi, lalu pakai Format Painter untuk menyalin tampilannya ke 5 sel lain.', 26),
    (v_mod_id, 'video', 'Formatting Like a Pro · Conditional Formatting (highlight low stock)', 'https://www.youtube.com/watch?v=DXbUjlR9URA', 'Add a Highlight Cells rule so any stock value below 10 turns red.', 27),
    (v_mod_id, 'video', 'ID · Memformat Seperti Profesional · Format bersyarat (menyorot stok menipis)', 'https://www.youtube.com/watch?v=1E9DORLGizA', 'Tambahkan aturan Highlight Cells agar nilai stok di bawah 10 berubah menjadi merah.', 28),
    (v_mod_id, 'video', 'Formatting Like a Pro · Format as Table', 'https://www.youtube.com/watch?v=M07df44RXOM', 'Select your data and apply Format as Table, then try the filter arrows in the header.', 29),
    (v_mod_id, 'video', 'ID · Memformat Seperti Profesional · Format sebagai Tabel', 'https://www.youtube.com/watch?v=4cr6Vo1PNDc', 'Pilih datamu dan terapkan Format as Table, lalu coba panah filter di barisan judul.', 30),
    (v_mod_id, 'video', 'Formatting Like a Pro · Cell styles and themes', 'https://www.youtube.com/watch?v=Stnq9DNwGME', 'Apply a built-in Cell Style to your header, then change the workbook Theme.', 31),
    (v_mod_id, 'video', 'ID · Memformat Seperti Profesional · Gaya sel dan tema', 'https://www.youtube.com/watch?v=shaXE0fAf6o', 'Terapkan Cell Style bawaan pada judulmu, lalu ubah Theme workbook.', 32),
    (v_mod_id, 'video', 'Your First Formulas · Your first formula (=, cell references, + − * /)', 'https://www.youtube.com/watch?v=S3fhooS5Oik', 'In C2 type =A2+B2, then try the same with - , * and / on your own numbers.', 33),
    (v_mod_id, 'video', 'ID · Rumus Pertamamu · Rumus pertamamu (=, referensi sel, + − * /)', 'https://www.youtube.com/watch?v=Mj-H3HEogsw', 'Di C2 ketik =A2+B2, lalu coba hal serupa dengan - , * dan / pada angkamu sendiri.', 34),
    (v_mod_id, 'video', 'Your First Formulas · SUM and AutoSum', 'https://www.youtube.com/watch?v=oSa7pP5um_s', 'Use =SUM() to total a column of quantities, then do it again with the AutoSum button.', 35),
    (v_mod_id, 'video', 'ID · Rumus Pertamamu · SUM dan AutoSum', 'https://www.youtube.com/watch?v=v8w5vWheSoM', 'Pakai =SUM() untuk menjumlahkan kolom kuantitas, lalu ulangi dengan tombol AutoSum.', 36),
    (v_mod_id, 'video', 'Your First Formulas · AVERAGE, MIN, MAX', 'https://www.youtube.com/watch?v=k3MHxObhD_0', 'Add AVERAGE, MIN, and MAX below a column of prices.', 37),
    (v_mod_id, 'video', 'ID · Rumus Pertamamu · AVERAGE, MIN, MAX', 'https://www.youtube.com/watch?v=FDmXCngGTOY', 'Tambahkan AVERAGE, MIN, dan MAX di bawah kolom harga.', 38),
    (v_mod_id, 'video', 'Your First Formulas · COUNT vs COUNTA vs COUNTBLANK', 'https://www.youtube.com/watch?v=K7qO3PBCCgM', 'Use COUNT, COUNTA, and COUNTBLANK on a column that has some blank cells.', 39),
    (v_mod_id, 'video', 'ID · Rumus Pertamamu · COUNT vs COUNTA vs COUNTBLANK', 'https://www.youtube.com/watch?v=yJURU4Ac-Ew', 'Pakai COUNT, COUNTA, dan COUNTBLANK pada kolom yang punya beberapa sel kosong.', 40),
    (v_mod_id, 'video', 'Your First Formulas · Relative vs absolute references ($A$1)', 'https://www.youtube.com/watch?v=DIkBBIo0thw', 'Write a formula using $A$1 and copy it down to see the reference stay fixed.', 41),
    (v_mod_id, 'video', 'ID · Rumus Pertamamu · Referensi relatif vs absolut ($A$1)', 'https://www.youtube.com/watch?v=9-40DwzfbnY', 'Tulis rumus memakai $A$1 dan salin ke bawah untuk melihat referensinya tetap terkunci.', 42),
    (v_mod_id, 'video', 'Your First Formulas · Copying formulas down a column', 'https://www.youtube.com/watch?v=PVhuI4pJ6es', 'Write one formula in D2, then double-click the fill handle to copy it down the whole column.', 43),
    (v_mod_id, 'video', 'ID · Rumus Pertamamu · Menyalin rumus ke bawah kolom', 'https://www.youtube.com/watch?v=CyRH0_0Lg54', 'Tulis satu rumus di D2, lalu klik dua kali fill handle untuk menyalinnya ke seluruh kolom.', 44),
    (v_mod_id, 'video', 'Smart Decisions with Logic · IF (pass/fail decisions)', 'https://www.youtube.com/watch?v=jIYD7wiWDU4', 'Write =IF(A2>=60,"Pass","Fail") for a list of scores.', 45),
    (v_mod_id, 'video', 'ID · Keputusan Cerdas dengan Logika · IF (keputusan lulus/gagal)', 'https://www.youtube.com/watch?v=xd7KLdprOI8', 'Tulis =IF(A2>=60;"Lulus";"Gagal") untuk daftar nilai.', 46),
    (v_mod_id, 'video', 'Smart Decisions with Logic · Nested IF and IFS (grading A/B/C/D)', 'https://www.youtube.com/watch?v=5vzcDWuB6Ys', 'Grade a list of scores into A/B/C/D using IFS (or nested IF).', 47),
    (v_mod_id, 'video', 'ID · Keputusan Cerdas dengan Logika · IF bertingkat dan IFS (penilaian A/B/C/D)', 'https://www.youtube.com/watch?v=51ZBVkFl4sg', 'Beri nilai huruf A/B/C/D pada daftar skor memakai IFS (atau IF bersarang).', 48),
    (v_mod_id, 'video', 'Smart Decisions with Logic · AND / OR inside IF', 'https://www.youtube.com/watch?v=5vHT16cEOPc', 'Write an IF that passes only when score>=60 AND attendance>=80 using AND().', 49),
    (v_mod_id, 'video', 'ID · Keputusan Cerdas dengan Logika · AND / OR di dalam IF', 'https://www.youtube.com/watch?v=ZhACHy0s_14', 'Tulis IF yang lulus hanya jika nilai>=60 DAN kehadiran>=80 memakai AND().', 50),
    (v_mod_id, 'video', 'Smart Decisions with Logic · COUNTIF / COUNTIFS', 'https://www.youtube.com/watch?v=ut4hez1MJ3s', 'Count how many items are ''Low'' with COUNTIF, then add a second condition using COUNTIFS.', 51),
    (v_mod_id, 'video', 'ID · Keputusan Cerdas dengan Logika · COUNTIF / COUNTIFS', 'https://www.youtube.com/watch?v=z79QDAJ3rtk', 'Hitung berapa barang berstatus ''Rendah'' dengan COUNTIF, lalu tambah kondisi kedua memakai COUNTIFS.', 52),
    (v_mod_id, 'video', 'Smart Decisions with Logic · SUMIF / SUMIFS', 'https://www.youtube.com/watch?v=dI8w0utjUc0', 'Total the quantity for one category with SUMIF, then use two conditions with SUMIFS.', 53),
    (v_mod_id, 'video', 'ID · Keputusan Cerdas dengan Logika · SUMIF / SUMIFS', 'https://www.youtube.com/watch?v=oBAkApf6V0A', 'Jumlahkan kuantitas untuk satu kategori dengan SUMIF, lalu pakai dua kondisi dengan SUMIFS.', 54),
    (v_mod_id, 'video', 'Smart Decisions with Logic · AVERAGEIF', 'https://www.youtube.com/watch?v=bCX-qAz2Cqk', 'Find the average price of items in one category using AVERAGEIF.', 55),
    (v_mod_id, 'video', 'ID · Keputusan Cerdas dengan Logika · AVERAGEIF', 'https://www.youtube.com/watch?v=eoJrBXQwI0k', 'Cari harga rata-rata barang pada satu kategori memakai AVERAGEIF.', 56),
    (v_mod_id, 'video', 'Finding Data with Lookups · VLOOKUP (find a price from a master list)', 'https://www.youtube.com/watch?v=xIynD1gFOLo', 'Build a small price list and use VLOOKUP to pull a price by item code.', 57),
    (v_mod_id, 'video', 'ID · Mencari Data dengan Lookup · VLOOKUP (mencari harga dari daftar induk)', 'https://www.youtube.com/watch?v=7JXWn9c68PM', 'Buat daftar harga kecil dan pakai VLOOKUP untuk mengambil harga berdasarkan kode barang.', 58),
    (v_mod_id, 'video', 'Finding Data with Lookups · XLOOKUP (the modern replacement)', 'https://www.youtube.com/watch?v=y5H6Yi3V4cw', 'Redo the same lookup with XLOOKUP.', 59),
    (v_mod_id, 'video', 'ID · Mencari Data dengan Lookup · XLOOKUP (pengganti modern)', 'https://www.youtube.com/watch?v=eMryM48_-L8', 'Ulangi pencarian yang sama dengan XLOOKUP.', 60),
    (v_mod_id, 'video', 'Finding Data with Lookups · INDEX + MATCH', 'https://www.youtube.com/watch?v=6JhbY8Mku1A', 'Look up a value using INDEX and MATCH together.', 61),
    (v_mod_id, 'video', 'ID · Mencari Data dengan Lookup · INDEX + MATCH', 'https://www.youtube.com/watch?v=TbiTs6sV7zE', 'Cari sebuah nilai memakai INDEX dan MATCH bersama-sama.', 62),
    (v_mod_id, 'video', 'Finding Data with Lookups · IFERROR (clean up #N/A)', 'https://www.youtube.com/watch?v=xEjLwqYjKFk', 'Wrap your lookup in IFERROR so #N/A shows "Not found" instead.', 63),
    (v_mod_id, 'video', 'ID · Mencari Data dengan Lookup · IFERROR (merapikan #N/A)', 'https://www.youtube.com/watch?v=3jb0L8JfvZ0', 'Bungkus pencarianmu dengan IFERROR agar #N/A menampilkan "Tidak ditemukan".', 64),
    (v_mod_id, 'video', 'Text & Dates Mastery · CONCAT / TEXTJOIN and & (combine names)', 'https://www.youtube.com/watch?v=77NAWZwi0CI', 'Combine first and last name into one cell using & , then again using TEXTJOIN.', 65),
    (v_mod_id, 'video', 'ID · Menguasai Teks & Tanggal · CONCAT / TEXTJOIN dan & (menggabung nama)', 'https://www.youtube.com/watch?v=oXI3_8VeXSE', 'Gabungkan nama depan dan belakang ke satu sel memakai & , lalu ulangi dengan TEXTJOIN.', 66),
    (v_mod_id, 'video', 'Text & Dates Mastery · LEFT, RIGHT, MID (extract codes)', 'https://www.youtube.com/watch?v=PbWRI7ANjsE', 'Extract the first 3 letters of a code with LEFT and the middle part with MID.', 67),
    (v_mod_id, 'video', 'ID · Menguasai Teks & Tanggal · LEFT, RIGHT, MID (mengekstrak kode)', 'https://www.youtube.com/watch?v=rgb1VrHoHqE', 'Ambil 3 huruf pertama sebuah kode dengan LEFT dan bagian tengahnya dengan MID.', 68),
    (v_mod_id, 'video', 'Text & Dates Mastery · UPPER, LOWER, PROPER', 'https://www.youtube.com/watch?v=PkuhtMDkGUI', 'Convert a name column to UPPER, LOWER, and PROPER case.', 69),
    (v_mod_id, 'video', 'ID · Menguasai Teks & Tanggal · UPPER, LOWER, PROPER', 'https://www.youtube.com/watch?v=E1OoThT5vCg', 'Ubah kolom nama menjadi huruf UPPER, LOWER, dan PROPER.', 70),
    (v_mod_id, 'video', 'Text & Dates Mastery · TRIM and CLEAN', 'https://www.youtube.com/watch?v=6xD59AgxUi8', 'Use TRIM to remove extra spaces from a messy text column.', 71),
    (v_mod_id, 'video', 'ID · Menguasai Teks & Tanggal · TRIM dan CLEAN', 'https://www.youtube.com/watch?v=DJR8PCDwAkA', 'Pakai TRIM untuk menghapus spasi berlebih dari kolom teks yang berantakan.', 72),
    (v_mod_id, 'video', 'Text & Dates Mastery · TEXT function (format inside text)', 'https://www.youtube.com/watch?v=lpux4m0jsdk', 'Use TEXT to show a number as "Rp #,##0" inside a sentence.', 73),
    (v_mod_id, 'video', 'ID · Menguasai Teks & Tanggal · Fungsi TEXT (format di dalam teks)', 'https://www.youtube.com/watch?v=E6jMy7JSYXE', 'Pakai TEXT untuk menampilkan angka sebagai "Rp #.##0" di dalam kalimat.', 74),
    (v_mod_id, 'video', 'Text & Dates Mastery · TODAY and NOW', 'https://www.youtube.com/watch?v=HUstL5T5L4s', 'Put =TODAY() in one cell and =NOW() in another.', 75),
    (v_mod_id, 'video', 'ID · Menguasai Teks & Tanggal · TODAY dan NOW', 'https://www.youtube.com/watch?v=fsP3R4_sw-s', 'Letakkan =TODAY() di satu sel dan =NOW() di sel lain.', 76),
    (v_mod_id, 'video', 'Text & Dates Mastery · DATEDIF and date math', 'https://www.youtube.com/watch?v=uXItl_HQR5Q', 'Use DATEDIF to find the number of days between two dates.', 77),
    (v_mod_id, 'video', 'ID · Menguasai Teks & Tanggal · DATEDIF dan perhitungan tanggal', 'https://www.youtube.com/watch?v=2M4XCoZ2VRk', 'Pakai DATEDIF untuk menghitung jumlah hari antara dua tanggal.', 78),
    (v_mod_id, 'video', 'Text & Dates Mastery · WEEKDAY, MONTH, YEAR', 'https://www.youtube.com/watch?v=ajCHNzO774w', 'Pull the weekday, month, and year out of a date using WEEKDAY, MONTH, and YEAR.', 79),
    (v_mod_id, 'video', 'ID · Menguasai Teks & Tanggal · WEEKDAY, MONTH, YEAR', 'https://www.youtube.com/watch?v=p1hDJVHXsNE', 'Ambil hari, bulan, dan tahun dari sebuah tanggal memakai WEEKDAY, MONTH, dan YEAR.', 80),
    (v_mod_id, 'video', 'Managing Real Data · Sort (A-Z, multi-level)', 'https://www.youtube.com/watch?v=YkaYOSduu40', 'Sort your table by category, then add a second level to also sort by quantity.', 81),
    (v_mod_id, 'video', 'ID · Mengelola Data Nyata · Mengurutkan (A-Z, bertingkat)', 'https://www.youtube.com/watch?v=PSHpJRewxPY', 'Urutkan tabelmu berdasarkan kategori, lalu tambah level kedua agar juga terurut berdasarkan kuantitas.', 82),
    (v_mod_id, 'video', 'Managing Real Data · Filter', 'https://www.youtube.com/watch?v=4i1DH6EwIIE', 'Turn on Filter and show only the items in one category.', 83),
    (v_mod_id, 'video', 'ID · Mengelola Data Nyata · Filter', 'https://www.youtube.com/watch?v=1xmb4t-3o54', 'Aktifkan Filter dan tampilkan hanya barang dalam satu kategori.', 84),
    (v_mod_id, 'video', 'Managing Real Data · Remove Duplicates', 'https://www.youtube.com/watch?v=7hJstN44pTE', 'Add a duplicate row, then use Remove Duplicates to clean it up.', 85),
    (v_mod_id, 'video', 'ID · Mengelola Data Nyata · Menghapus Duplikat', 'https://www.youtube.com/watch?v=MAUl6YsMbUU', 'Tambahkan satu baris duplikat, lalu pakai Remove Duplicates untuk membersihkannya.', 86),
    (v_mod_id, 'video', 'Managing Real Data · Data Validation (dropdown lists)', 'https://www.youtube.com/watch?v=uQd92e6ilBQ', 'Add a dropdown list of categories to a column using Data Validation.', 87),
    (v_mod_id, 'video', 'ID · Mengelola Data Nyata · Validasi Data (daftar dropdown)', 'https://www.youtube.com/watch?v=olGoOdAB_bM', 'Tambahkan daftar dropdown kategori ke sebuah kolom memakai Data Validation.', 88),
    (v_mod_id, 'video', 'Managing Real Data · Text to Columns', 'https://www.youtube.com/watch?v=QyZ6IMkln2U', 'Split a ''Name Code'' column into two columns using Text to Columns.', 89),
    (v_mod_id, 'video', 'ID · Mengelola Data Nyata · Text to Columns', 'https://www.youtube.com/watch?v=ClQHIVx4peo', 'Pisahkan kolom ''Nama Kode'' menjadi dua kolom memakai Text to Columns.', 90),
    (v_mod_id, 'video', 'Managing Real Data · Find & Replace', 'https://www.youtube.com/watch?v=4hiVLC7vgf0', 'Use Find & Replace to change every ''pcs'' to ''units''.', 91),
    (v_mod_id, 'video', 'ID · Mengelola Data Nyata · Find & Replace', 'https://www.youtube.com/watch?v=1bZSEq9YkV0', 'Pakai Find & Replace untuk mengubah setiap ''pcs'' menjadi ''unit''.', 92),
    (v_mod_id, 'video', 'Managing Real Data · Grouping and outlining', 'https://www.youtube.com/watch?v=0S2ZHyxd2NI', 'Group a set of rows so you can collapse and expand them.', 93),
    (v_mod_id, 'video', 'ID · Mengelola Data Nyata · Pengelompokan baris/kolom', 'https://www.youtube.com/watch?v=50-pFvmgWp8', 'Kelompokkan sekumpulan baris agar bisa kamu ciutkan dan bentangkan.', 94),
    (v_mod_id, 'video', 'Charts & PivotTables · Creating your first chart', 'https://www.youtube.com/watch?v=64DSXejsYbo', 'Select a small table and insert a column chart.', 95),
    (v_mod_id, 'video', 'ID · Grafik & PivotTable · Membuat grafik pertamamu', 'https://www.youtube.com/watch?v=FdzvFJ6Dc0U', 'Pilih tabel kecil dan sisipkan grafik kolom.', 96),
    (v_mod_id, 'video', 'Charts & PivotTables · Choosing the right chart type', 'https://www.youtube.com/watch?v=IHffvF4Vrm8', 'Show the same data as a bar, line, and pie chart, then pick the clearest one.', 97),
    (v_mod_id, 'video', 'ID · Grafik & PivotTable · Memilih jenis grafik yang tepat', 'https://www.youtube.com/watch?v=o3afb6BDhvg', 'Tampilkan data yang sama sebagai grafik batang, garis, dan lingkaran, lalu pilih yang paling jelas.', 98),
    (v_mod_id, 'video', 'Charts & PivotTables · Formatting charts', 'https://www.youtube.com/watch?v=ZeZ94yEa6xI', 'Add a chart title and data labels, then change the chart colors.', 99),
    (v_mod_id, 'video', 'ID · Grafik & PivotTable · Memformat grafik', 'https://www.youtube.com/watch?v=1-BhbQm2dCA', 'Tambahkan judul grafik dan label data, lalu ubah warna grafik.', 100),
    (v_mod_id, 'video', 'Charts & PivotTables · Sparklines', 'https://www.youtube.com/watch?v=xCDcrC0a6Zo', 'Add a line sparkline next to each row of monthly numbers.', 101),
    (v_mod_id, 'video', 'ID · Grafik & PivotTable · Sparklines', 'https://www.youtube.com/watch?v=JzFEvTTRxNI', 'Tambahkan sparkline garis di samping setiap baris angka bulanan.', 102),
    (v_mod_id, 'video', 'Charts & PivotTables · PivotTables part 1 (summarize data)', 'https://www.youtube.com/watch?v=dvbLrwD2SpA', 'Create a PivotTable that sums quantity by category.', 103),
    (v_mod_id, 'video', 'ID · Grafik & PivotTable · PivotTable bagian 1 (meringkas data)', 'https://www.youtube.com/watch?v=OoN5KjqzD2I', 'Buat PivotTable yang menjumlahkan kuantitas berdasarkan kategori.', 104),
    (v_mod_id, 'video', 'Charts & PivotTables · PivotTables part 2 (grouping, slicers)', 'https://www.youtube.com/watch?v=mW4QWFW1oO8', 'Group your PivotTable and add a Slicer to filter it.', 105),
    (v_mod_id, 'video', 'ID · Grafik & PivotTable · PivotTable bagian 2 (pengelompokan, slicer)', 'https://www.youtube.com/watch?v=pHFzHSLEOXk', 'Kelompokkan PivotTable-mu dan tambahkan Slicer untuk memfilternya.', 106),
    (v_mod_id, 'video', 'Charts & PivotTables · PivotCharts', 'https://www.youtube.com/watch?v=7IbW_DF89Ws', 'Add a PivotChart to your PivotTable.', 107),
    (v_mod_id, 'video', 'ID · Grafik & PivotTable · PivotChart', 'https://www.youtube.com/watch?v=7kZu5pqnR-k', 'Tambahkan PivotChart ke PivotTable-mu.', 108),
    (v_mod_id, 'video', 'Output & Protection · Top 10 keyboard shortcuts', 'https://www.youtube.com/watch?v=2edm5xqn-8I', 'Practice Ctrl+C, Ctrl+V, Ctrl+Z, Ctrl+S and a few more shortcuts on your workbook.', 109),
    (v_mod_id, 'video', 'ID · Cetak & Proteksi · 10 pintasan keyboard teratas', 'https://www.youtube.com/watch?v=qKWb7jinyhA', 'Latih Ctrl+C, Ctrl+V, Ctrl+Z, Ctrl+S dan beberapa pintasan lain di workbook-mu.', 110),
    (v_mod_id, 'video', 'Output & Protection · Print setup (print area, fit to page)', 'https://www.youtube.com/watch?v=Mrt4v0ysA8w', 'Set a Print Area, then use ''Fit to 1 page wide'' in Print settings.', 111),
    (v_mod_id, 'video', 'ID · Cetak & Proteksi · Pengaturan cetak (area cetak, muat satu halaman)', 'https://www.youtube.com/watch?v=y5N2AjwEVp4', 'Atur Print Area, lalu pakai ''Fit to 1 page wide'' di pengaturan Print.', 112),
    (v_mod_id, 'video', 'Output & Protection · Page headers/footers and page numbers', 'https://www.youtube.com/watch?v=1uFzJfiP-ZI', 'Add a header with the sheet title and a footer with page numbers.', 113),
    (v_mod_id, 'video', 'ID · Cetak & Proteksi · Header/footer dan nomor halaman', 'https://www.youtube.com/watch?v=LA3I1FZppJo', 'Tambahkan header berisi judul sheet dan footer berisi nomor halaman.', 114),
    (v_mod_id, 'video', 'Output & Protection · Protecting sheets and locking cells', 'https://www.youtube.com/watch?v=wrOE8fheMR0', 'Lock your formula cells and protect the sheet, leaving the input cells editable.', 115),
    (v_mod_id, 'video', 'ID · Cetak & Proteksi · Proteksi sheet dan mengunci sel', 'https://www.youtube.com/watch?v=I-OrXo9OOAM', 'Kunci sel rumusmu dan proteksi sheet, biarkan sel input tetap bisa diisi.', 116),
    (v_mod_id, 'video', 'Output & Protection · Comments and notes', 'https://www.youtube.com/watch?v=aY-p0oySZa0', 'Add a comment to one cell and a note to another.', 117),
    (v_mod_id, 'video', 'ID · Cetak & Proteksi · Komentar dan catatan', 'https://www.youtube.com/watch?v=upPdxHt8Nkg', 'Tambahkan comment pada satu sel dan note pada sel lain.', 118),
    (v_mod_id, 'video', 'Output & Protection · Exporting to PDF and sharing', 'https://www.youtube.com/watch?v=iuoQyIZW0tA', 'Save or export your finished workbook as a PDF.', 119),
    (v_mod_id, 'video', 'ID · Cetak & Proteksi · Ekspor ke PDF dan berbagi', 'https://www.youtube.com/watch?v=Ms4lTSlNzhQ', 'Simpan atau ekspor workbook selesaimu sebagai PDF.', 120);

  RAISE NOTICE 'Excel clips added to Digital Skills: 60 topics, 120 videos (EN + ID).';
END $$;

-- Verify: expect clip_videos = 120 on the Excel module; checklist + quiz intact.
SELECT m.title,
       count(DISTINCT r.id) FILTER (WHERE r.url LIKE '%youtube.com/%') AS youtube_videos,
       count(DISTINCT i.id) AS checklist_items,
       count(DISTINCT q.id) AS quizzes
  FROM course_modules m
  LEFT JOIN module_resources r       ON r.course_module_id = m.id
  LEFT JOIN module_checklist_items i ON i.course_module_id = m.id
  LEFT JOIN module_quizzes q         ON q.course_module_id = m.id
 WHERE m.title LIKE 'Microsoft Excel%'
   AND m.course_id = (SELECT id FROM courses WHERE title = 'Microsoft Digital Skills for University Prep')
 GROUP BY m.title;

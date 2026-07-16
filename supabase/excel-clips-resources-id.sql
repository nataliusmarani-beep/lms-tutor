-- ============================================================
-- excel-clips-resources-id.sql — 60 Excel clips as BAHASA INDONESIA video resources (added alongside the English ones)
-- Idempotent: re-running refreshes only THIS language's clip videos.
-- Run in the Supabase SQL Editor.  Host course default:
-- "Microsoft Digital Skills for University Prep" > module "Excel Clips".
-- ============================================================

DO $$
DECLARE
  v_course_id UUID;
  v_mod_id    UUID;
BEGIN
  SELECT id INTO v_course_id FROM courses
   WHERE title = 'Microsoft Digital Skills for University Prep' LIMIT 1;
  IF v_course_id IS NULL THEN
    RAISE NOTICE 'Host course not found — nothing seeded.'; RETURN;
  END IF;

  SELECT id INTO v_mod_id FROM course_modules
   WHERE course_id = v_course_id AND title = 'Excel Clips' LIMIT 1;
  IF v_mod_id IS NULL THEN
    v_mod_id := gen_random_uuid();
    INSERT INTO course_modules
      (id, course_id, title, title_id, focus, focus_id, icon, week_number, sort_order)
    VALUES
      (v_mod_id, v_course_id, 'Excel Clips', 'Klip Excel',
       '60 short Excel tutorial clips to watch and practice',
       '60 klip tutorial Excel singkat untuk ditonton dan dipraktikkan',
       '📊',
       (SELECT COALESCE(MAX(week_number), 0) + 1 FROM course_modules WHERE course_id = v_course_id),
       (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM course_modules WHERE course_id = v_course_id));
  END IF;

  -- Refresh only this language's clip videos (scoped by title marker)
  DELETE FROM module_resources
   WHERE course_module_id = v_mod_id
     AND resource_type = 'video'
     AND title LIKE 'ID · %';

  INSERT INTO module_resources
    (course_module_id, resource_type, title, url, description, sort_order)
  VALUES
    (v_mod_id, 'video', 'ID · W1 · Tur antarmuka Excel (ribbon, sel, name box, formula bar)', 'https://www.youtube.com/watch?v=UJCkKUTNNAE', 'Buka workbook kosong dan tunjukkan ribbon, sebuah sel, Name Box, dan formula bar. Ketik namamu di sel A1.', 2),
    (v_mod_id, 'video', 'ID · W1 · Memasukkan dan mengedit data (Enter, Tab, F2)', 'https://www.youtube.com/watch?v=ctMaR7yG-Rs', 'Ketik 5 nama barang ke bawah di kolom A memakai Enter dan Tab, lalu edit satu sel dengan F2.', 4),
    (v_mod_id, 'video', 'ID · W1 · Memilih sel, baris, kolom, dan rentang', 'https://www.youtube.com/watch?v=CSu-0IArgAk', 'Pilih kolom A, lalu baris 1, lalu rentang A1:C5 dengan klik dan seret.', 6),
    (v_mod_id, 'video', 'ID · W1 · Salin, potong, tempel, dan Paste Special (hanya nilai)', 'https://www.youtube.com/watch?v=QrMxhbBkwNc', 'Salin A1:A5, lalu pakai Paste Special -> Values untuk menempel hanya nilainya ke C1.', 8),
    (v_mod_id, 'video', 'ID · W1 · AutoFill dan Flash Fill', 'https://www.youtube.com/watch?v=jZO2aOXr8Vg', 'Ketik 1 dan 2 lalu seret fill handle membuat 1-10, kemudian pakai Flash Fill untuk memisahkan nama depan dari kolom nama lengkap.', 10),
    (v_mod_id, 'video', 'ID · W1 · Undo/Redo dan menyimpan (.xlsx vs .csv)', 'https://www.youtube.com/watch?v=Mkefp55GdcA', 'Hapus satu baris, tekan Ctrl+Z untuk membatalkan, lalu simpan file sekali sebagai .xlsx dan sekali sebagai .csv.', 12),
    (v_mod_id, 'video', 'ID · W1 · Freeze Panes (membekukan judul)', 'https://www.youtube.com/watch?v=Q45aYUCjLP8', 'Tambahkan baris judul, lalu pakai View -> Freeze Panes -> Freeze Top Row dan gulir untuk mengujinya.', 14),
    (v_mod_id, 'video', 'ID · W1 · Menyisipkan/menghapus baris dan kolom, mengubah ukuran', 'https://www.youtube.com/watch?v=a-3lWaL2uHk', 'Sisipkan baris baru di atas baris 2, hapus kolom B, dan lebarkan kolom A.', 16),
    (v_mod_id, 'video', 'ID · W1 · Bekerja dengan banyak sheet', 'https://www.youtube.com/watch?v=92w4EU8Sqbw', 'Ganti nama Sheet1 menjadi ''Stok'', tambahkan sheet kedua bernama ''Harga'', dan beri warna berbeda pada tab.', 18),
    (v_mod_id, 'video', 'ID · W2 · Format angka (mata uang Rp, persentase, tanggal)', 'https://www.youtube.com/watch?v=06sRaogKIPU', 'Format satu kolom sebagai Mata Uang (Rp), satu sebagai Persentase, dan satu sebagai Tanggal.', 20),
    (v_mod_id, 'video', 'ID · W2 · Format sel (tebal, garis, warna, wrap text)', 'https://www.youtube.com/watch?v=yF_tnM7BJTg', 'Buat baris judul menjadi tebal, tambahkan garis tepi di A1:C5, dan aktifkan Wrap Text.', 22),
    (v_mod_id, 'video', 'ID · W2 · Merge & Center vs Center Across Selection', 'https://www.youtube.com/watch?v=g_ZV9vGibes', 'Pakai Merge & Center pada judul di A1:C1, lalu ulangi memakai Center Across Selection.', 24),
    (v_mod_id, 'video', 'ID · W2 · Format Painter', 'https://www.youtube.com/watch?v=hoK59cUsR_A', 'Format satu sel dengan rapi, lalu pakai Format Painter untuk menyalin tampilannya ke 5 sel lain.', 26),
    (v_mod_id, 'video', 'ID · W2 · Format bersyarat (menyorot stok menipis)', 'https://www.youtube.com/watch?v=1E9DORLGizA', 'Tambahkan aturan Highlight Cells agar nilai stok di bawah 10 berubah menjadi merah.', 28),
    (v_mod_id, 'video', 'ID · W2 · Format sebagai Tabel', 'https://www.youtube.com/watch?v=4cr6Vo1PNDc', 'Pilih datamu dan terapkan Format as Table, lalu coba panah filter di barisan judul.', 30),
    (v_mod_id, 'video', 'ID · W2 · Gaya sel dan tema', 'https://www.youtube.com/watch?v=shaXE0fAf6o', 'Terapkan Cell Style bawaan pada judulmu, lalu ubah Theme workbook.', 32),
    (v_mod_id, 'video', 'ID · W3 · Rumus pertamamu (=, referensi sel, + − * /)', 'https://www.youtube.com/watch?v=Mj-H3HEogsw', 'Di C2 ketik =A2+B2, lalu coba hal serupa dengan - , * dan / pada angkamu sendiri.', 34),
    (v_mod_id, 'video', 'ID · W3 · SUM dan AutoSum', 'https://www.youtube.com/watch?v=v8w5vWheSoM', 'Pakai =SUM() untuk menjumlahkan kolom kuantitas, lalu ulangi dengan tombol AutoSum.', 36),
    (v_mod_id, 'video', 'ID · W3 · AVERAGE, MIN, MAX', 'https://www.youtube.com/watch?v=FDmXCngGTOY', 'Tambahkan AVERAGE, MIN, dan MAX di bawah kolom harga.', 38),
    (v_mod_id, 'video', 'ID · W3 · COUNT vs COUNTA vs COUNTBLANK', 'https://www.youtube.com/watch?v=yJURU4Ac-Ew', 'Pakai COUNT, COUNTA, dan COUNTBLANK pada kolom yang punya beberapa sel kosong.', 40),
    (v_mod_id, 'video', 'ID · W3 · Referensi relatif vs absolut ($A$1)', 'https://www.youtube.com/watch?v=9-40DwzfbnY', 'Tulis rumus memakai $A$1 dan salin ke bawah untuk melihat referensinya tetap terkunci.', 42),
    (v_mod_id, 'video', 'ID · W3 · Menyalin rumus ke bawah kolom', 'https://www.youtube.com/watch?v=CyRH0_0Lg54', 'Tulis satu rumus di D2, lalu klik dua kali fill handle untuk menyalinnya ke seluruh kolom.', 44),
    (v_mod_id, 'video', 'ID · W4 · IF (keputusan lulus/gagal)', 'https://www.youtube.com/watch?v=xd7KLdprOI8', 'Tulis =IF(A2>=60;"Lulus";"Gagal") untuk daftar nilai.', 46),
    (v_mod_id, 'video', 'ID · W4 · IF bertingkat dan IFS (penilaian A/B/C/D)', 'https://www.youtube.com/watch?v=51ZBVkFl4sg', 'Beri nilai huruf A/B/C/D pada daftar skor memakai IFS (atau IF bersarang).', 48),
    (v_mod_id, 'video', 'ID · W4 · AND / OR di dalam IF', 'https://www.youtube.com/watch?v=ZhACHy0s_14', 'Tulis IF yang lulus hanya jika nilai>=60 DAN kehadiran>=80 memakai AND().', 50),
    (v_mod_id, 'video', 'ID · W4 · COUNTIF / COUNTIFS', 'https://www.youtube.com/watch?v=z79QDAJ3rtk', 'Hitung berapa barang berstatus ''Rendah'' dengan COUNTIF, lalu tambah kondisi kedua memakai COUNTIFS.', 52),
    (v_mod_id, 'video', 'ID · W4 · SUMIF / SUMIFS', 'https://www.youtube.com/watch?v=oBAkApf6V0A', 'Jumlahkan kuantitas untuk satu kategori dengan SUMIF, lalu pakai dua kondisi dengan SUMIFS.', 54),
    (v_mod_id, 'video', 'ID · W4 · AVERAGEIF', 'https://www.youtube.com/watch?v=eoJrBXQwI0k', 'Cari harga rata-rata barang pada satu kategori memakai AVERAGEIF.', 56),
    (v_mod_id, 'video', 'ID · W5 · VLOOKUP (mencari harga dari daftar induk)', 'https://www.youtube.com/watch?v=7JXWn9c68PM', 'Buat daftar harga kecil dan pakai VLOOKUP untuk mengambil harga berdasarkan kode barang.', 58),
    (v_mod_id, 'video', 'ID · W5 · XLOOKUP (pengganti modern)', 'https://www.youtube.com/watch?v=eMryM48_-L8', 'Ulangi pencarian yang sama dengan XLOOKUP.', 60),
    (v_mod_id, 'video', 'ID · W5 · INDEX + MATCH', 'https://www.youtube.com/watch?v=TbiTs6sV7zE', 'Cari sebuah nilai memakai INDEX dan MATCH bersama-sama.', 62),
    (v_mod_id, 'video', 'ID · W5 · IFERROR (merapikan #N/A)', 'https://www.youtube.com/watch?v=3jb0L8JfvZ0', 'Bungkus pencarianmu dengan IFERROR agar #N/A menampilkan "Tidak ditemukan".', 64),
    (v_mod_id, 'video', 'ID · W6 · CONCAT / TEXTJOIN dan & (menggabung nama)', 'https://www.youtube.com/watch?v=oXI3_8VeXSE', 'Gabungkan nama depan dan belakang ke satu sel memakai & , lalu ulangi dengan TEXTJOIN.', 66),
    (v_mod_id, 'video', 'ID · W6 · LEFT, RIGHT, MID (mengekstrak kode)', 'https://www.youtube.com/watch?v=rgb1VrHoHqE', 'Ambil 3 huruf pertama sebuah kode dengan LEFT dan bagian tengahnya dengan MID.', 68),
    (v_mod_id, 'video', 'ID · W6 · UPPER, LOWER, PROPER', 'https://www.youtube.com/watch?v=E1OoThT5vCg', 'Ubah kolom nama menjadi huruf UPPER, LOWER, dan PROPER.', 70),
    (v_mod_id, 'video', 'ID · W6 · TRIM dan CLEAN', 'https://www.youtube.com/watch?v=DJR8PCDwAkA', 'Pakai TRIM untuk menghapus spasi berlebih dari kolom teks yang berantakan.', 72),
    (v_mod_id, 'video', 'ID · W6 · Fungsi TEXT (format di dalam teks)', 'https://www.youtube.com/watch?v=E6jMy7JSYXE', 'Pakai TEXT untuk menampilkan angka sebagai "Rp #.##0" di dalam kalimat.', 74),
    (v_mod_id, 'video', 'ID · W6 · TODAY dan NOW', 'https://www.youtube.com/watch?v=fsP3R4_sw-s', 'Letakkan =TODAY() di satu sel dan =NOW() di sel lain.', 76),
    (v_mod_id, 'video', 'ID · W6 · DATEDIF dan perhitungan tanggal', 'https://www.youtube.com/watch?v=2M4XCoZ2VRk', 'Pakai DATEDIF untuk menghitung jumlah hari antara dua tanggal.', 78),
    (v_mod_id, 'video', 'ID · W6 · WEEKDAY, MONTH, YEAR', 'https://www.youtube.com/watch?v=p1hDJVHXsNE', 'Ambil hari, bulan, dan tahun dari sebuah tanggal memakai WEEKDAY, MONTH, dan YEAR.', 80),
    (v_mod_id, 'video', 'ID · W7 · Mengurutkan (A-Z, bertingkat)', 'https://www.youtube.com/watch?v=PSHpJRewxPY', 'Urutkan tabelmu berdasarkan kategori, lalu tambah level kedua agar juga terurut berdasarkan kuantitas.', 82),
    (v_mod_id, 'video', 'ID · W7 · Filter', 'https://www.youtube.com/watch?v=1xmb4t-3o54', 'Aktifkan Filter dan tampilkan hanya barang dalam satu kategori.', 84),
    (v_mod_id, 'video', 'ID · W7 · Menghapus Duplikat', 'https://www.youtube.com/watch?v=MAUl6YsMbUU', 'Tambahkan satu baris duplikat, lalu pakai Remove Duplicates untuk membersihkannya.', 86),
    (v_mod_id, 'video', 'ID · W7 · Validasi Data (daftar dropdown)', 'https://www.youtube.com/watch?v=olGoOdAB_bM', 'Tambahkan daftar dropdown kategori ke sebuah kolom memakai Data Validation.', 88),
    (v_mod_id, 'video', 'ID · W7 · Text to Columns', 'https://www.youtube.com/watch?v=ClQHIVx4peo', 'Pisahkan kolom ''Nama Kode'' menjadi dua kolom memakai Text to Columns.', 90),
    (v_mod_id, 'video', 'ID · W7 · Find & Replace', 'https://www.youtube.com/watch?v=1bZSEq9YkV0', 'Pakai Find & Replace untuk mengubah setiap ''pcs'' menjadi ''unit''.', 92),
    (v_mod_id, 'video', 'ID · W7 · Pengelompokan baris/kolom', 'https://www.youtube.com/watch?v=50-pFvmgWp8', 'Kelompokkan sekumpulan baris agar bisa kamu ciutkan dan bentangkan.', 94),
    (v_mod_id, 'video', 'ID · W8 · Membuat grafik pertamamu', 'https://www.youtube.com/watch?v=FdzvFJ6Dc0U', 'Pilih tabel kecil dan sisipkan grafik kolom.', 96),
    (v_mod_id, 'video', 'ID · W8 · Memilih jenis grafik yang tepat', 'https://www.youtube.com/watch?v=o3afb6BDhvg', 'Tampilkan data yang sama sebagai grafik batang, garis, dan lingkaran, lalu pilih yang paling jelas.', 98),
    (v_mod_id, 'video', 'ID · W8 · Memformat grafik', 'https://www.youtube.com/watch?v=1-BhbQm2dCA', 'Tambahkan judul grafik dan label data, lalu ubah warna grafik.', 100),
    (v_mod_id, 'video', 'ID · W8 · Sparklines', 'https://www.youtube.com/watch?v=JzFEvTTRxNI', 'Tambahkan sparkline garis di samping setiap baris angka bulanan.', 102),
    (v_mod_id, 'video', 'ID · W8 · PivotTable bagian 1 (meringkas data)', 'https://www.youtube.com/watch?v=OoN5KjqzD2I', 'Buat PivotTable yang menjumlahkan kuantitas berdasarkan kategori.', 104),
    (v_mod_id, 'video', 'ID · W8 · PivotTable bagian 2 (pengelompokan, slicer)', 'https://www.youtube.com/watch?v=pHFzHSLEOXk', 'Kelompokkan PivotTable-mu dan tambahkan Slicer untuk memfilternya.', 106),
    (v_mod_id, 'video', 'ID · W8 · PivotChart', 'https://www.youtube.com/watch?v=7kZu5pqnR-k', 'Tambahkan PivotChart ke PivotTable-mu.', 108),
    (v_mod_id, 'video', 'ID · W9 · 10 pintasan keyboard teratas', 'https://www.youtube.com/watch?v=qKWb7jinyhA', 'Latih Ctrl+C, Ctrl+V, Ctrl+Z, Ctrl+S dan beberapa pintasan lain di workbook-mu.', 110),
    (v_mod_id, 'video', 'ID · W9 · Pengaturan cetak (area cetak, muat satu halaman)', 'https://www.youtube.com/watch?v=y5N2AjwEVp4', 'Atur Print Area, lalu pakai ''Fit to 1 page wide'' di pengaturan Print.', 112),
    (v_mod_id, 'video', 'ID · W9 · Header/footer dan nomor halaman', 'https://www.youtube.com/watch?v=LA3I1FZppJo', 'Tambahkan header berisi judul sheet dan footer berisi nomor halaman.', 114),
    (v_mod_id, 'video', 'ID · W9 · Proteksi sheet dan mengunci sel', 'https://www.youtube.com/watch?v=I-OrXo9OOAM', 'Kunci sel rumusmu dan proteksi sheet, biarkan sel input tetap bisa diisi.', 116),
    (v_mod_id, 'video', 'ID · W9 · Komentar dan catatan', 'https://www.youtube.com/watch?v=upPdxHt8Nkg', 'Tambahkan comment pada satu sel dan note pada sel lain.', 118),
    (v_mod_id, 'video', 'ID · W9 · Ekspor ke PDF dan berbagi', 'https://www.youtube.com/watch?v=Ms4lTSlNzhQ', 'Simpan atau ekspor workbook selesaimu sebagai PDF.', 120);

END $$;

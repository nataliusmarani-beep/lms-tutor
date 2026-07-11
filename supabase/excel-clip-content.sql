-- ============================================================
-- excel-clip-content.sql
-- Sets a verified YouTube video + a bilingual practice task on
-- each of the 60 Excel course clips (matched by item_key).
-- Requires: add-clip-video-practice.sql (adds the columns) first.
-- Run in Supabase SQL Editor. Safe to re-run (idempotent UPDATEs).
-- ============================================================

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=SOvI2_dL02Q',
  practice_task = 'Open a blank workbook and point out the ribbon, a cell, the Name Box, and the formula bar. Type your name in cell A1.',
  practice_task_id = 'Buka workbook kosong dan tunjukkan ribbon, sebuah sel, Name Box, dan formula bar. Ketik namamu di sel A1.'
WHERE item_key = 'xl_w1_s1';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=MFSvwFUirEM',
  practice_task = 'Type 5 item names down column A using Enter and Tab, then edit one cell with F2.',
  practice_task_id = 'Ketik 5 nama barang ke bawah di kolom A memakai Enter dan Tab, lalu edit satu sel dengan F2.'
WHERE item_key = 'xl_w1_s2';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=_tnbn96yxIc',
  practice_task = 'Select column A, then row 1, then the range A1:C5 by clicking and dragging.',
  practice_task_id = 'Pilih kolom A, lalu baris 1, lalu rentang A1:C5 dengan klik dan seret.'
WHERE item_key = 'xl_w1_s3';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=Y5CKUd-Q3i4',
  practice_task = 'Copy A1:A5, then use Paste Special -> Values to paste only the values into C1.',
  practice_task_id = 'Salin A1:A5, lalu pakai Paste Special -> Values untuk menempel hanya nilainya ke C1.'
WHERE item_key = 'xl_w1_s4';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=jOeiKZz7Y5Q',
  practice_task = 'Type 1 and 2 and drag the fill handle to make 1-10, then use Flash Fill to split first names from a full-name column.',
  practice_task_id = 'Ketik 1 dan 2 lalu seret fill handle membuat 1-10, kemudian pakai Flash Fill untuk memisahkan nama depan dari kolom nama lengkap.'
WHERE item_key = 'xl_w1_s5';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=O1Z7WjdyHbY',
  practice_task = 'Delete a row, press Ctrl+Z to undo, then save the file once as .xlsx and once as .csv.',
  practice_task_id = 'Hapus satu baris, tekan Ctrl+Z untuk membatalkan, lalu simpan file sekali sebagai .xlsx dan sekali sebagai .csv.'
WHERE item_key = 'xl_w1_s6';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=wjGzYpdIcxY',
  practice_task = 'Add a header row, then use View -> Freeze Panes -> Freeze Top Row and scroll to test it.',
  practice_task_id = 'Tambahkan baris judul, lalu pakai View -> Freeze Panes -> Freeze Top Row dan gulir untuk mengujinya.'
WHERE item_key = 'xl_w1_s7';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=_JjqaMmDlig',
  practice_task = 'Insert a new row above row 2, delete column B, and widen column A.',
  practice_task_id = 'Sisipkan baris baru di atas baris 2, hapus kolom B, dan lebarkan kolom A.'
WHERE item_key = 'xl_w1_s8';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=qRShQc-v3LI',
  practice_task = 'Rename Sheet1 to ''Stock'', add a second sheet named ''Prices'', and give the tabs different colors.',
  practice_task_id = 'Ganti nama Sheet1 menjadi ''Stok'', tambahkan sheet kedua bernama ''Harga'', dan beri warna berbeda pada tab.'
WHERE item_key = 'xl_w1_s9';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=sKv2DOwk6-A',
  practice_task = 'Format one column as Currency (Rp), one as Percentage, and one as Date.',
  practice_task_id = 'Format satu kolom sebagai Mata Uang (Rp), satu sebagai Persentase, dan satu sebagai Tanggal.'
WHERE item_key = 'xl_w2_s1';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=ryrz6UVvOwM',
  practice_task = 'Make the header row bold, add borders around A1:C5, and turn on Wrap Text.',
  practice_task_id = 'Buat baris judul menjadi tebal, tambahkan garis tepi di A1:C5, dan aktifkan Wrap Text.'
WHERE item_key = 'xl_w2_s2';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=2PkEfxayYrs',
  practice_task = 'Use Merge & Center on a title across A1:C1, then redo it with Center Across Selection instead.',
  practice_task_id = 'Pakai Merge & Center pada judul di A1:C1, lalu ulangi memakai Center Across Selection.'
WHERE item_key = 'xl_w2_s3';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=pKQf06bLs28',
  practice_task = 'Format one cell nicely, then use Format Painter to copy that look onto 5 other cells.',
  practice_task_id = 'Format satu sel dengan rapi, lalu pakai Format Painter untuk menyalin tampilannya ke 5 sel lain.'
WHERE item_key = 'xl_w2_s4';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=DXbUjlR9URA',
  practice_task = 'Add a Highlight Cells rule so any stock value below 10 turns red.',
  practice_task_id = 'Tambahkan aturan Highlight Cells agar nilai stok di bawah 10 berubah menjadi merah.'
WHERE item_key = 'xl_w2_s5';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=M07df44RXOM',
  practice_task = 'Select your data and apply Format as Table, then try the filter arrows in the header.',
  practice_task_id = 'Pilih datamu dan terapkan Format as Table, lalu coba panah filter di barisan judul.'
WHERE item_key = 'xl_w2_s6';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=Stnq9DNwGME',
  practice_task = 'Apply a built-in Cell Style to your header, then change the workbook Theme.',
  practice_task_id = 'Terapkan Cell Style bawaan pada judulmu, lalu ubah Theme workbook.'
WHERE item_key = 'xl_w2_s7';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=S3fhooS5Oik',
  practice_task = 'In C2 type =A2+B2, then try the same with - , * and / on your own numbers.',
  practice_task_id = 'Di C2 ketik =A2+B2, lalu coba hal serupa dengan - , * dan / pada angkamu sendiri.'
WHERE item_key = 'xl_w3_s1';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=oSa7pP5um_s',
  practice_task = 'Use =SUM() to total a column of quantities, then do it again with the AutoSum button.',
  practice_task_id = 'Pakai =SUM() untuk menjumlahkan kolom kuantitas, lalu ulangi dengan tombol AutoSum.'
WHERE item_key = 'xl_w3_s2';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=k3MHxObhD_0',
  practice_task = 'Add AVERAGE, MIN, and MAX below a column of prices.',
  practice_task_id = 'Tambahkan AVERAGE, MIN, dan MAX di bawah kolom harga.'
WHERE item_key = 'xl_w3_s3';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=K7qO3PBCCgM',
  practice_task = 'Use COUNT, COUNTA, and COUNTBLANK on a column that has some blank cells.',
  practice_task_id = 'Pakai COUNT, COUNTA, dan COUNTBLANK pada kolom yang punya beberapa sel kosong.'
WHERE item_key = 'xl_w3_s4';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=DIkBBIo0thw',
  practice_task = 'Write a formula using $A$1 and copy it down to see the reference stay fixed.',
  practice_task_id = 'Tulis rumus memakai $A$1 dan salin ke bawah untuk melihat referensinya tetap terkunci.'
WHERE item_key = 'xl_w3_s5';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=PVhuI4pJ6es',
  practice_task = 'Write one formula in D2, then double-click the fill handle to copy it down the whole column.',
  practice_task_id = 'Tulis satu rumus di D2, lalu klik dua kali fill handle untuk menyalinnya ke seluruh kolom.'
WHERE item_key = 'xl_w3_s6';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=jIYD7wiWDU4',
  practice_task = 'Write =IF(A2>=60,"Pass","Fail") for a list of scores.',
  practice_task_id = 'Tulis =IF(A2>=60;"Lulus";"Gagal") untuk daftar nilai.'
WHERE item_key = 'xl_w4_s1';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=5vzcDWuB6Ys',
  practice_task = 'Grade a list of scores into A/B/C/D using IFS (or nested IF).',
  practice_task_id = 'Beri nilai huruf A/B/C/D pada daftar skor memakai IFS (atau IF bersarang).'
WHERE item_key = 'xl_w4_s2';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=5vHT16cEOPc',
  practice_task = 'Write an IF that passes only when score>=60 AND attendance>=80 using AND().',
  practice_task_id = 'Tulis IF yang lulus hanya jika nilai>=60 DAN kehadiran>=80 memakai AND().'
WHERE item_key = 'xl_w4_s3';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=ut4hez1MJ3s',
  practice_task = 'Count how many items are ''Low'' with COUNTIF, then add a second condition using COUNTIFS.',
  practice_task_id = 'Hitung berapa barang berstatus ''Rendah'' dengan COUNTIF, lalu tambah kondisi kedua memakai COUNTIFS.'
WHERE item_key = 'xl_w4_s4';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=dI8w0utjUc0',
  practice_task = 'Total the quantity for one category with SUMIF, then use two conditions with SUMIFS.',
  practice_task_id = 'Jumlahkan kuantitas untuk satu kategori dengan SUMIF, lalu pakai dua kondisi dengan SUMIFS.'
WHERE item_key = 'xl_w4_s5';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=bCX-qAz2Cqk',
  practice_task = 'Find the average price of items in one category using AVERAGEIF.',
  practice_task_id = 'Cari harga rata-rata barang pada satu kategori memakai AVERAGEIF.'
WHERE item_key = 'xl_w4_s6';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=xIynD1gFOLo',
  practice_task = 'Build a small price list and use VLOOKUP to pull a price by item code.',
  practice_task_id = 'Buat daftar harga kecil dan pakai VLOOKUP untuk mengambil harga berdasarkan kode barang.'
WHERE item_key = 'xl_w5_s1';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=y5H6Yi3V4cw',
  practice_task = 'Redo the same lookup with XLOOKUP.',
  practice_task_id = 'Ulangi pencarian yang sama dengan XLOOKUP.'
WHERE item_key = 'xl_w5_s2';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=6JhbY8Mku1A',
  practice_task = 'Look up a value using INDEX and MATCH together.',
  practice_task_id = 'Cari sebuah nilai memakai INDEX dan MATCH bersama-sama.'
WHERE item_key = 'xl_w5_s3';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=xEjLwqYjKFk',
  practice_task = 'Wrap your lookup in IFERROR so #N/A shows "Not found" instead.',
  practice_task_id = 'Bungkus pencarianmu dengan IFERROR agar #N/A menampilkan "Tidak ditemukan".'
WHERE item_key = 'xl_w5_s4';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=77NAWZwi0CI',
  practice_task = 'Combine first and last name into one cell using & , then again using TEXTJOIN.',
  practice_task_id = 'Gabungkan nama depan dan belakang ke satu sel memakai & , lalu ulangi dengan TEXTJOIN.'
WHERE item_key = 'xl_w6_s1';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=PbWRI7ANjsE',
  practice_task = 'Extract the first 3 letters of a code with LEFT and the middle part with MID.',
  practice_task_id = 'Ambil 3 huruf pertama sebuah kode dengan LEFT dan bagian tengahnya dengan MID.'
WHERE item_key = 'xl_w6_s2';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=PkuhtMDkGUI',
  practice_task = 'Convert a name column to UPPER, LOWER, and PROPER case.',
  practice_task_id = 'Ubah kolom nama menjadi huruf UPPER, LOWER, dan PROPER.'
WHERE item_key = 'xl_w6_s3';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=6xD59AgxUi8',
  practice_task = 'Use TRIM to remove extra spaces from a messy text column.',
  practice_task_id = 'Pakai TRIM untuk menghapus spasi berlebih dari kolom teks yang berantakan.'
WHERE item_key = 'xl_w6_s4';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=lpux4m0jsdk',
  practice_task = 'Use TEXT to show a number as "Rp #,##0" inside a sentence.',
  practice_task_id = 'Pakai TEXT untuk menampilkan angka sebagai "Rp #.##0" di dalam kalimat.'
WHERE item_key = 'xl_w6_s5';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=HUstL5T5L4s',
  practice_task = 'Put =TODAY() in one cell and =NOW() in another.',
  practice_task_id = 'Letakkan =TODAY() di satu sel dan =NOW() di sel lain.'
WHERE item_key = 'xl_w6_s6';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=uXItl_HQR5Q',
  practice_task = 'Use DATEDIF to find the number of days between two dates.',
  practice_task_id = 'Pakai DATEDIF untuk menghitung jumlah hari antara dua tanggal.'
WHERE item_key = 'xl_w6_s7';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=ajCHNzO774w',
  practice_task = 'Pull the weekday, month, and year out of a date using WEEKDAY, MONTH, and YEAR.',
  practice_task_id = 'Ambil hari, bulan, dan tahun dari sebuah tanggal memakai WEEKDAY, MONTH, dan YEAR.'
WHERE item_key = 'xl_w6_s8';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=YkaYOSduu40',
  practice_task = 'Sort your table by category, then add a second level to also sort by quantity.',
  practice_task_id = 'Urutkan tabelmu berdasarkan kategori, lalu tambah level kedua agar juga terurut berdasarkan kuantitas.'
WHERE item_key = 'xl_w7_s1';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=4i1DH6EwIIE',
  practice_task = 'Turn on Filter and show only the items in one category.',
  practice_task_id = 'Aktifkan Filter dan tampilkan hanya barang dalam satu kategori.'
WHERE item_key = 'xl_w7_s2';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=7hJstN44pTE',
  practice_task = 'Add a duplicate row, then use Remove Duplicates to clean it up.',
  practice_task_id = 'Tambahkan satu baris duplikat, lalu pakai Remove Duplicates untuk membersihkannya.'
WHERE item_key = 'xl_w7_s3';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=uQd92e6ilBQ',
  practice_task = 'Add a dropdown list of categories to a column using Data Validation.',
  practice_task_id = 'Tambahkan daftar dropdown kategori ke sebuah kolom memakai Data Validation.'
WHERE item_key = 'xl_w7_s4';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=QyZ6IMkln2U',
  practice_task = 'Split a ''Name Code'' column into two columns using Text to Columns.',
  practice_task_id = 'Pisahkan kolom ''Nama Kode'' menjadi dua kolom memakai Text to Columns.'
WHERE item_key = 'xl_w7_s5';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=4hiVLC7vgf0',
  practice_task = 'Use Find & Replace to change every ''pcs'' to ''units''.',
  practice_task_id = 'Pakai Find & Replace untuk mengubah setiap ''pcs'' menjadi ''unit''.'
WHERE item_key = 'xl_w7_s6';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=0S2ZHyxd2NI',
  practice_task = 'Group a set of rows so you can collapse and expand them.',
  practice_task_id = 'Kelompokkan sekumpulan baris agar bisa kamu ciutkan dan bentangkan.'
WHERE item_key = 'xl_w7_s7';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=64DSXejsYbo',
  practice_task = 'Select a small table and insert a column chart.',
  practice_task_id = 'Pilih tabel kecil dan sisipkan grafik kolom.'
WHERE item_key = 'xl_w8_s1';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=IHffvF4Vrm8',
  practice_task = 'Show the same data as a bar, line, and pie chart, then pick the clearest one.',
  practice_task_id = 'Tampilkan data yang sama sebagai grafik batang, garis, dan lingkaran, lalu pilih yang paling jelas.'
WHERE item_key = 'xl_w8_s2';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=ZeZ94yEa6xI',
  practice_task = 'Add a chart title and data labels, then change the chart colors.',
  practice_task_id = 'Tambahkan judul grafik dan label data, lalu ubah warna grafik.'
WHERE item_key = 'xl_w8_s3';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=xCDcrC0a6Zo',
  practice_task = 'Add a line sparkline next to each row of monthly numbers.',
  practice_task_id = 'Tambahkan sparkline garis di samping setiap baris angka bulanan.'
WHERE item_key = 'xl_w8_s4';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=dvbLrwD2SpA',
  practice_task = 'Create a PivotTable that sums quantity by category.',
  practice_task_id = 'Buat PivotTable yang menjumlahkan kuantitas berdasarkan kategori.'
WHERE item_key = 'xl_w8_s5';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=mW4QWFW1oO8',
  practice_task = 'Group your PivotTable and add a Slicer to filter it.',
  practice_task_id = 'Kelompokkan PivotTable-mu dan tambahkan Slicer untuk memfilternya.'
WHERE item_key = 'xl_w8_s6';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=7IbW_DF89Ws',
  practice_task = 'Add a PivotChart to your PivotTable.',
  practice_task_id = 'Tambahkan PivotChart ke PivotTable-mu.'
WHERE item_key = 'xl_w8_s7';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=2edm5xqn-8I',
  practice_task = 'Practice Ctrl+C, Ctrl+V, Ctrl+Z, Ctrl+S and a few more shortcuts on your workbook.',
  practice_task_id = 'Latih Ctrl+C, Ctrl+V, Ctrl+Z, Ctrl+S dan beberapa pintasan lain di workbook-mu.'
WHERE item_key = 'xl_w9_s1';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=Mrt4v0ysA8w',
  practice_task = 'Set a Print Area, then use ''Fit to 1 page wide'' in Print settings.',
  practice_task_id = 'Atur Print Area, lalu pakai ''Fit to 1 page wide'' di pengaturan Print.'
WHERE item_key = 'xl_w9_s2';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=1uFzJfiP-ZI',
  practice_task = 'Add a header with the sheet title and a footer with page numbers.',
  practice_task_id = 'Tambahkan header berisi judul sheet dan footer berisi nomor halaman.'
WHERE item_key = 'xl_w9_s3';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=wrOE8fheMR0',
  practice_task = 'Lock your formula cells and protect the sheet, leaving the input cells editable.',
  practice_task_id = 'Kunci sel rumusmu dan proteksi sheet, biarkan sel input tetap bisa diisi.'
WHERE item_key = 'xl_w9_s4';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=aY-p0oySZa0',
  practice_task = 'Add a comment to one cell and a note to another.',
  practice_task_id = 'Tambahkan comment pada satu sel dan note pada sel lain.'
WHERE item_key = 'xl_w9_s5';

UPDATE module_checklist_items SET
  video_url = 'https://www.youtube.com/watch?v=iuoQyIZW0tA',
  practice_task = 'Save or export your finished workbook as a PDF.',
  practice_task_id = 'Simpan atau ekspor workbook selesaimu sebagai PDF.'
WHERE item_key = 'xl_w9_s6';

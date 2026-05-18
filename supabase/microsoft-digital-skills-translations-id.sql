-- ============================================================
-- Indonesian (_id) translations for:
-- "Microsoft Digital Skills for University Prep"
-- ============================================================
-- Matches rows by English text / item_key — no hardcoded UUIDs.
-- ============================================================

DO $$
BEGIN

  -- ============================================================
  -- COURSE
  -- ============================================================
  UPDATE courses
  SET
    title_id       = 'Keterampilan Digital Microsoft untuk Persiapan Universitas',
    description_id = 'Program 8 minggu yang membekali mahasiswa baru dengan keterampilan digital Microsoft yang esensial — mulai dari manajemen file dan keamanan siber hingga Word, Excel, PowerPoint, OneDrive, Forms, dan Teams — membangun fondasi produktivitas yang dibutuhkan untuk sukses akademik.'
  WHERE title = 'Microsoft Digital Skills for University Prep';

  -- ============================================================
  -- MODULE 1 — Computer Survival Skills & File Management
  -- ============================================================
  UPDATE course_modules
  SET
    title_id = 'Keterampilan Dasar Komputer & Manajemen File',
    focus_id = 'Pintasan keyboard, organisasi file/folder, cetak & PDF, kunci layar'
  WHERE title     = 'Computer Survival Skills & File Management'
    AND course_id = (SELECT id FROM courses WHERE title = 'Microsoft Digital Skills for University Prep');

  -- ============================================================
  -- MODULE 2 — Internet Safety, Email & Security Awareness
  -- ============================================================
  UPDATE course_modules
  SET
    title_id = 'Keamanan Internet, Email & Kesadaran Keamanan Digital',
    focus_id = 'Keamanan kata sandi, identifikasi phishing, browsing aman, etika email'
  WHERE title     = 'Internet Safety, Email & Security Awareness'
    AND course_id = (SELECT id FROM courses WHERE title = 'Microsoft Digital Skills for University Prep');

  -- ============================================================
  -- MODULE 3 — Microsoft Word – Professional Documents
  -- ============================================================
  UPDATE course_modules
  SET
    title_id = 'Microsoft Word – Dokumen Profesional',
    focus_id = 'Pemformatan, gaya, templat, pemeriksaan ejaan, lacak perubahan, ekspor PDF'
  WHERE title     = 'Microsoft Word – Professional Documents'
    AND course_id = (SELECT id FROM courses WHERE title = 'Microsoft Digital Skills for University Prep');

  -- ============================================================
  -- MODULE 4 — Microsoft Excel – Data & Spreadsheets
  -- ============================================================
  UPDATE course_modules
  SET
    title_id = 'Microsoft Excel – Data & Lembar Kerja',
    focus_id = 'Entri data, rumus SUM/AVERAGE/COUNT, grafik, pemformatan sel, pengurutan/filter'
  WHERE title     = 'Microsoft Excel – Data & Spreadsheets'
    AND course_id = (SELECT id FROM courses WHERE title = 'Microsoft Digital Skills for University Prep');

  -- ============================================================
  -- MODULE 5 — Microsoft PowerPoint – Dynamic Presentations
  -- ============================================================
  UPDATE course_modules
  SET
    title_id = 'Microsoft PowerPoint – Presentasi Dinamis',
    focus_id = 'Tata letak slide, tema, transisi, menyisipkan gambar/grafik, tips presentasi, ekspor'
  WHERE title     = 'Microsoft PowerPoint – Dynamic Presentations'
    AND course_id = (SELECT id FROM courses WHERE title = 'Microsoft Digital Skills for University Prep');

  -- ============================================================
  -- MODULE 6 — OneDrive & Cloud Storage
  -- ============================================================
  UPDATE course_modules
  SET
    title_id = 'OneDrive & Penyimpanan Cloud',
    focus_id = 'Unggah/unduh, berbagi folder, penulisan bersama, riwayat versi, sinkronisasi desktop'
  WHERE title     = 'OneDrive & Cloud Storage'
    AND course_id = (SELECT id FROM courses WHERE title = 'Microsoft Digital Skills for University Prep');

  -- ============================================================
  -- MODULE 7 — Microsoft Forms & Digital Assessment
  -- ============================================================
  UPDATE course_modules
  SET
    title_id = 'Microsoft Forms & Penilaian Digital',
    focus_id = 'Membuat formulir/kuis, jenis pertanyaan, berbagi, melihat respons, percabangan'
  WHERE title     = 'Microsoft Forms & Digital Assessment'
    AND course_id = (SELECT id FROM courses WHERE title = 'Microsoft Digital Skills for University Prep');

  -- ============================================================
  -- MODULE 8 — Digital Workflow & Microsoft Teams
  -- ============================================================
  UPDATE course_modules
  SET
    title_id = 'Alur Kerja Digital & Microsoft Teams',
    focus_id = 'Saluran/obrolan Teams, berbagi file di Teams, menjadwalkan rapat, tugas, tips produktivitas'
  WHERE title     = 'Digital Workflow & Microsoft Teams'
    AND course_id = (SELECT id FROM courses WHERE title = 'Microsoft Digital Skills for University Prep');

  -- ============================================================
  -- CHECKLIST ITEMS — Module 1 (Student)
  -- ============================================================
  UPDATE module_checklist_items SET label_id = 'Mengorganisasi file ke dalam struktur folder semester'            WHERE item_key = 'ms_1_s_1';
  UPDATE module_checklist_items SET label_id = 'Menggunakan pintasan keyboard (Ctrl+C, Ctrl+V, Ctrl+Z, Alt+Tab)' WHERE item_key = 'ms_1_s_2';
  UPDATE module_checklist_items SET label_id = 'Mencetak dokumen dan menyimpan sebagai PDF'                       WHERE item_key = 'ms_1_s_3';
  UPDATE module_checklist_items SET label_id = 'Mengunci layar komputer saat meninggalkan meja'                   WHERE item_key = 'ms_1_s_4';
  UPDATE module_checklist_items SET label_id = 'Membuat folder baru dan mengganti nama file dengan benar'         WHERE item_key = 'ms_1_s_5';

  -- ============================================================
  -- CHECKLIST ITEMS — Module 1 (Teacher)
  -- ============================================================
  UPDATE module_checklist_items SET label_id = 'Menyampaikan slide demo pintasan keyboard'            WHERE item_key = 'ms_1_t_1';
  UPDATE module_checklist_items SET label_id = 'Mendemonstrasikan organisasi file/folder di layar'    WHERE item_key = 'ms_1_t_2';
  UPDATE module_checklist_items SET label_id = 'Mendemonstrasikan Cetak dan Cetak ke PDF'             WHERE item_key = 'ms_1_t_3';
  UPDATE module_checklist_items SET label_id = 'Menjelaskan kunci layar dan dasar keamanan perangkat' WHERE item_key = 'ms_1_t_4';
  UPDATE module_checklist_items SET label_id = 'Memeriksa struktur folder siswa'                      WHERE item_key = 'ms_1_t_5';

  -- ============================================================
  -- CHECKLIST ITEMS — Module 2 (Student)
  -- ============================================================
  UPDATE module_checklist_items SET label_id = 'Membuat kata sandi kuat menggunakan frasa sandi'                WHERE item_key = 'ms_2_s_1';
  UPDATE module_checklist_items SET label_id = 'Mengidentifikasi 3 tanda bahaya dalam contoh email phishing'    WHERE item_key = 'ms_2_s_2';
  UPDATE module_checklist_items SET label_id = 'Mengaktifkan autentikasi dua faktor pada satu akun'             WHERE item_key = 'ms_2_s_3';
  UPDATE module_checklist_items SET label_id = 'Berlatih menulis email profesional'                             WHERE item_key = 'ms_2_s_4';
  UPDATE module_checklist_items SET label_id = 'Mempelajari cara melaporkan email spam/phishing'                WHERE item_key = 'ms_2_s_5';

  -- ============================================================
  -- CHECKLIST ITEMS — Module 2 (Teacher)
  -- ============================================================
  UPDATE module_checklist_items SET label_id = 'Menyajikan studi kasus email phishing'               WHERE item_key = 'ms_2_t_1';
  UPDATE module_checklist_items SET label_id = 'Mendemonstrasikan kata sandi kuat vs lemah'           WHERE item_key = 'ms_2_t_2';
  UPDATE module_checklist_items SET label_id = 'Memandu langkah-langkah pengaturan 2FA'               WHERE item_key = 'ms_2_t_3';
  UPDATE module_checklist_items SET label_id = 'Menampilkan hal yang boleh dan tidak dalam etika email' WHERE item_key = 'ms_2_t_4';
  UPDATE module_checklist_items SET label_id = 'Meninjau latihan identifikasi phishing siswa'         WHERE item_key = 'ms_2_t_5';

  -- ============================================================
  -- CHECKLIST ITEMS — Module 3 (Student)
  -- ============================================================
  UPDATE module_checklist_items SET label_id = 'Menerapkan gaya Judul (Heading 1, Heading 2) pada dokumen'      WHERE item_key = 'ms_3_s_1';
  UPDATE module_checklist_items SET label_id = 'Menggunakan pemeriksaan ejaan dan tata bahasa untuk mengoreksi dokumen' WHERE item_key = 'ms_3_s_2';
  UPDATE module_checklist_items SET label_id = 'Mengaktifkan Lacak Perubahan dan menerima/menolak revisi'        WHERE item_key = 'ms_3_s_3';
  UPDATE module_checklist_items SET label_id = 'Membuat dokumen dari templat Microsoft Word'                     WHERE item_key = 'ms_3_s_4';
  UPDATE module_checklist_items SET label_id = 'Mengekspor dokumen Word sebagai file PDF'                        WHERE item_key = 'ms_3_s_5';

  -- ============================================================
  -- CHECKLIST ITEMS — Module 3 (Teacher)
  -- ============================================================
  UPDATE module_checklist_items SET label_id = 'Mendemonstrasikan penerapan Gaya dan Tema di Word'              WHERE item_key = 'ms_3_t_1';
  UPDATE module_checklist_items SET label_id = 'Menunjukkan cara menjalankan pemeriksaan Ejaan & Tata Bahasa'   WHERE item_key = 'ms_3_t_2';
  UPDATE module_checklist_items SET label_id = 'Memandu alur kerja Lacak Perubahan dan Komentar'                WHERE item_key = 'ms_3_t_3';
  UPDATE module_checklist_items SET label_id = 'Membimbing siswa memilih dan mengisi templat'                   WHERE item_key = 'ms_3_t_4';
  UPDATE module_checklist_items SET label_id = 'Meninjau PDF yang diekspor untuk konsistensi pemformatan'       WHERE item_key = 'ms_3_t_5';

  -- ============================================================
  -- CHECKLIST ITEMS — Module 4 (Student)
  -- ============================================================
  UPDATE module_checklist_items SET label_id = 'Memasukkan dan memformat data dalam lembar kerja Excel'  WHERE item_key = 'ms_4_s_1';
  UPDATE module_checklist_items SET label_id = 'Menggunakan rumus SUM, AVERAGE, dan COUNT dengan benar'  WHERE item_key = 'ms_4_s_2';
  UPDATE module_checklist_items SET label_id = 'Membuat grafik dari rentang data'                        WHERE item_key = 'ms_4_s_3';
  UPDATE module_checklist_items SET label_id = 'Menerapkan pengurutan dan filter pada kumpulan data'     WHERE item_key = 'ms_4_s_4';
  UPDATE module_checklist_items SET label_id = 'Memformat sel dengan batas, warna, dan format angka'     WHERE item_key = 'ms_4_s_5';

  -- ============================================================
  -- CHECKLIST ITEMS — Module 4 (Teacher)
  -- ============================================================
  UPDATE module_checklist_items SET label_id = 'Mendemonstrasikan entri data dasar dan referensi sel'     WHERE item_key = 'ms_4_t_1';
  UPDATE module_checklist_items SET label_id = 'Memandu sintaks rumus SUM, AVERAGE, dan COUNT'            WHERE item_key = 'ms_4_t_2';
  UPDATE module_checklist_items SET label_id = 'Menunjukkan cara membuat dan menyesuaikan grafik'         WHERE item_key = 'ms_4_t_3';
  UPDATE module_checklist_items SET label_id = 'Menjelaskan pengurutan dan filter kumpulan data'          WHERE item_key = 'ms_4_t_4';
  UPDATE module_checklist_items SET label_id = 'Meninjau lembar kerja siswa untuk akurasi rumus'          WHERE item_key = 'ms_4_t_5';

  -- ============================================================
  -- CHECKLIST ITEMS — Module 5 (Student)
  -- ============================================================
  UPDATE module_checklist_items SET label_id = 'Menerapkan tema dan tata letak yang konsisten pada presentasi' WHERE item_key = 'ms_5_s_1';
  UPDATE module_checklist_items SET label_id = 'Menambahkan transisi slide dan animasi dengan tepat'            WHERE item_key = 'ms_5_s_2';
  UPDATE module_checklist_items SET label_id = 'Menyisipkan gambar dan grafik ke dalam slide'                   WHERE item_key = 'ms_5_s_3';
  UPDATE module_checklist_items SET label_id = 'Berlatih presentasi menggunakan tampilan Slide Show'            WHERE item_key = 'ms_5_s_4';
  UPDATE module_checklist_items SET label_id = 'Mengekspor presentasi sebagai PDF'                             WHERE item_key = 'ms_5_s_5';

  -- ============================================================
  -- CHECKLIST ITEMS — Module 5 (Teacher)
  -- ============================================================
  UPDATE module_checklist_items SET label_id = 'Mendemonstrasikan tata letak slide dan tema Desain'            WHERE item_key = 'ms_5_t_1';
  UPDATE module_checklist_items SET label_id = 'Menunjukkan cara menambahkan dan menyesuaikan transisi'        WHERE item_key = 'ms_5_t_2';
  UPDATE module_checklist_items SET label_id = 'Membimbing siswa menyisipkan gambar dan grafik'                WHERE item_key = 'ms_5_t_3';
  UPDATE module_checklist_items SET label_id = 'Melatih penyampaian presentasi dan penggunaan Tampilan Presenter' WHERE item_key = 'ms_5_t_4';
  UPDATE module_checklist_items SET label_id = 'Meninjau presentasi siswa untuk kejelasan dan desain'          WHERE item_key = 'ms_5_t_5';

  -- ============================================================
  -- CHECKLIST ITEMS — Module 6 (Student)
  -- ============================================================
  UPDATE module_checklist_items SET label_id = 'Mengunggah file ke OneDrive dan mengunduhnya di perangkat lain'        WHERE item_key = 'ms_6_s_1';
  UPDATE module_checklist_items SET label_id = 'Berbagi folder OneDrive dengan teman sekelas dengan izin lihat saja'   WHERE item_key = 'ms_6_s_2';
  UPDATE module_checklist_items SET label_id = 'Menulis bersama dokumen Word secara bersamaan dengan pengguna lain'    WHERE item_key = 'ms_6_s_3';
  UPDATE module_checklist_items SET label_id = 'Memulihkan versi sebelumnya dari file menggunakan Riwayat Versi'       WHERE item_key = 'ms_6_s_4';
  UPDATE module_checklist_items SET label_id = 'Menyiapkan sinkronisasi OneDrive di desktop/laptop'                    WHERE item_key = 'ms_6_s_5';

  -- ============================================================
  -- CHECKLIST ITEMS — Module 6 (Teacher)
  -- ============================================================
  UPDATE module_checklist_items SET label_id = 'Mendemonstrasikan mengunggah dan mengunduh file di OneDrive'          WHERE item_key = 'ms_6_t_1';
  UPDATE module_checklist_items SET label_id = 'Menunjukkan cara berbagi folder dengan tingkat izin yang berbeda'     WHERE item_key = 'ms_6_t_2';
  UPDATE module_checklist_items SET label_id = 'Mendemonstrasikan penulisan bersama secara real-time dalam dokumen bersama' WHERE item_key = 'ms_6_t_3';
  UPDATE module_checklist_items SET label_id = 'Memandu akses dan pemulihan Riwayat Versi'                            WHERE item_key = 'ms_6_t_4';
  UPDATE module_checklist_items SET label_id = 'Membimbing siswa melalui pengaturan sinkronisasi desktop OneDrive'    WHERE item_key = 'ms_6_t_5';

  -- ============================================================
  -- CHECKLIST ITEMS — Module 7 (Student)
  -- ============================================================
  UPDATE module_checklist_items SET label_id = 'Membuat Microsoft Form dengan setidaknya 4 jenis pertanyaan berbeda' WHERE item_key = 'ms_7_s_1';
  UPDATE module_checklist_items SET label_id = 'Menambahkan logika percabangan pada pertanyaan formulir'              WHERE item_key = 'ms_7_s_2';
  UPDATE module_checklist_items SET label_id = 'Berbagi formulir melalui tautan dan mengumpulkan respons'             WHERE item_key = 'ms_7_s_3';
  UPDATE module_checklist_items SET label_id = 'Melihat dan menganalisis tab Ringkasan Respons'                       WHERE item_key = 'ms_7_s_4';
  UPDATE module_checklist_items SET label_id = 'Mengekspor respons formulir ke Excel untuk analisis lebih lanjut'    WHERE item_key = 'ms_7_s_5';

  -- ============================================================
  -- CHECKLIST ITEMS — Module 7 (Teacher)
  -- ============================================================
  UPDATE module_checklist_items SET label_id = 'Mendemonstrasikan pembuatan formulir baru dari awal'                       WHERE item_key = 'ms_7_t_1';
  UPDATE module_checklist_items SET label_id = 'Menunjukkan cara menambahkan berbagai jenis pertanyaan termasuk rating dan Likert' WHERE item_key = 'ms_7_t_2';
  UPDATE module_checklist_items SET label_id = 'Menjelaskan logika percabangan/kondisional dalam formulir'                WHERE item_key = 'ms_7_t_3';
  UPDATE module_checklist_items SET label_id = 'Memandu opsi berbagi (tautan, kode QR, sematkan)'                         WHERE item_key = 'ms_7_t_4';
  UPDATE module_checklist_items SET label_id = 'Mendemonstrasikan dasbor Respons dan ekspor ke Excel'                     WHERE item_key = 'ms_7_t_5';

  -- ============================================================
  -- CHECKLIST ITEMS — Module 8 (Student)
  -- ============================================================
  UPDATE module_checklist_items SET label_id = 'Menavigasi saluran Teams dan memposting pesan di saluran yang tepat'       WHERE item_key = 'ms_8_s_1';
  UPDATE module_checklist_items SET label_id = 'Berbagi file langsung dalam percakapan saluran Teams'                      WHERE item_key = 'ms_8_s_2';
  UPDATE module_checklist_items SET label_id = 'Menjadwalkan rapat Teams dan menambahkan teman sekelas sebagai tamu'       WHERE item_key = 'ms_8_s_3';
  UPDATE module_checklist_items SET label_id = 'Mengumpulkan tugas melalui tab Tugas Teams'                                WHERE item_key = 'ms_8_s_4';
  UPDATE module_checklist_items SET label_id = 'Menerapkan tips produktivitas pribadi (mis. Jangan Ganggu, obrolan disematkan, pintasan keyboard)' WHERE item_key = 'ms_8_s_5';

  -- ============================================================
  -- CHECKLIST ITEMS — Module 8 (Teacher)
  -- ============================================================
  UPDATE module_checklist_items SET label_id = 'Mendemonstrasikan antarmuka Teams: Tim, Saluran, Obrolan, umpan Aktivitas' WHERE item_key = 'ms_8_t_1';
  UPDATE module_checklist_items SET label_id = 'Menunjukkan berbagi file dan pengeditan bersama dalam saluran Teams'       WHERE item_key = 'ms_8_t_2';
  UPDATE module_checklist_items SET label_id = 'Memandu penjadwalan dan bergabung ke rapat Teams'                          WHERE item_key = 'ms_8_t_3';
  UPDATE module_checklist_items SET label_id = 'Mendemonstrasikan pembuatan dan pengelolaan Tugas di Teams'                WHERE item_key = 'ms_8_t_4';
  UPDATE module_checklist_items SET label_id = 'Berbagi tips produktivitas: notifikasi, status, pintasan keyboard'         WHERE item_key = 'ms_8_t_5';

END $$;

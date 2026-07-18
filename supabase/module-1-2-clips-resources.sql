-- ============================================================
-- module-1-2-clips-resources.sql
-- Adds EN + ID video resources (Materi) to Module 1 "Computer Survival
-- Skills & File Management" and Module 2 "Internet Safety, Email &
-- Security Awareness" of the Digital Skills course. Same pattern as the
-- Word/Excel/PowerPoint/OneDrive resource files. All videos oEmbed-verified
-- and language-confirmed. Idempotent (delete-by-prefix). Run in SQL Editor.
-- ============================================================
DO $$
DECLARE v_mod UUID;
BEGIN
  -- Module 1
  SELECT m.id INTO v_mod FROM course_modules m JOIN courses c ON c.id=m.course_id
   WHERE c.title='Microsoft Digital Skills for University Prep' AND m.title LIKE 'Computer Survival%' LIMIT 1;
  IF v_mod IS NULL THEN RAISE EXCEPTION 'module not found'; END IF;
  DELETE FROM module_resources WHERE course_module_id=v_mod AND (title LIKE 'Files & Folders · %' OR title LIKE 'Everyday Skills · %' OR title LIKE 'ID · %');
  INSERT INTO module_resources (course_module_id, resource_type, title, url, description, sort_order) VALUES
    (v_mod, 'video', 'Files & Folders · File and folder basics', 'https://www.youtube.com/watch?v=hUW5MEKDtMM', 'Point out the difference between a file and a folder on your computer.', 1),
    (v_mod, 'video', 'ID · File & Folder · Dasar file dan folder', 'https://www.youtube.com/watch?v=7D1XFiCBgHo', 'Tunjukkan perbedaan antara file dan folder di komputermu.', 2),
    (v_mod, 'video', 'Files & Folders · Create, rename and delete folders', 'https://www.youtube.com/watch?v=TYyo3d50yc0', 'Create a new folder, rename it, then delete it.', 3),
    (v_mod, 'video', 'ID · File & Folder · Membuat, ganti nama, dan hapus folder', 'https://www.youtube.com/watch?v=ejM9-Cmbknw', 'Buat folder baru, ganti namanya, lalu hapus.', 4),
    (v_mod, 'video', 'Files & Folders · Organise files into folders', 'https://www.youtube.com/watch?v=bKjRKZxr-KY', 'Make a Semester folder with a subfolder per subject and move files in.', 5),
    (v_mod, 'video', 'ID · File & Folder · Merapikan file ke dalam folder', 'https://www.youtube.com/watch?v=YeaBHkzW0PA', 'Buat folder Semester dengan subfolder tiap mata pelajaran dan pindahkan file ke dalamnya.', 6),
    (v_mod, 'video', 'Files & Folders · Copy, move and paste files', 'https://www.youtube.com/watch?v=0xA1nFEiTd0', 'Copy a file to another folder, then move a different one.', 7),
    (v_mod, 'video', 'ID · File & Folder · Menyalin, memindahkan, dan menempel file', 'https://www.youtube.com/watch?v=ZvZzafa0LW4', 'Salin sebuah file ke folder lain, lalu pindahkan file lain.', 8),
    (v_mod, 'video', 'Files & Folders · Keyboard shortcuts (Ctrl+C/V/Z, Alt+Tab)', 'https://www.youtube.com/watch?v=uBANd9aVb3Y', 'Practise Ctrl+C, Ctrl+V, Ctrl+Z and Alt+Tab.', 9),
    (v_mod, 'video', 'ID · File & Folder · Pintasan keyboard (Ctrl+C/V/Z, Alt+Tab)', 'https://www.youtube.com/watch?v=mslkVwk5lRU', 'Latih Ctrl+C, Ctrl+V, Ctrl+Z, dan Alt+Tab.', 10),
    (v_mod, 'video', 'Files & Folders · Search for files', 'https://www.youtube.com/watch?v=GtGVItw89NM', 'Use the search box to find a file by its name.', 11),
    (v_mod, 'video', 'ID · File & Folder · Mencari file', 'https://www.youtube.com/watch?v=nkR7AuDSI5M', 'Pakai kotak pencarian untuk menemukan file berdasarkan namanya.', 12),
    (v_mod, 'video', 'Everyday Skills · Print a document', 'https://www.youtube.com/watch?v=VqPyEGkTDsg', 'Print a document (or use Print Preview) from your computer.', 13),
    (v_mod, 'video', 'ID · Keterampilan Sehari-hari · Mencetak dokumen', 'https://www.youtube.com/watch?v=jrcIqe6jUMs', 'Cetak sebuah dokumen (atau pakai Print Preview) dari komputermu.', 14),
    (v_mod, 'video', 'Everyday Skills · Save or print to PDF', 'https://www.youtube.com/watch?v=P9uWUz-e1V0', 'Save or print a document as a PDF and open it to check.', 15),
    (v_mod, 'video', 'ID · Keterampilan Sehari-hari · Menyimpan atau mencetak ke PDF', 'https://www.youtube.com/watch?v=5R35dR22Hgc', 'Simpan atau cetak dokumen sebagai PDF lalu buka untuk memeriksanya.', 16),
    (v_mod, 'video', 'Everyday Skills · Zip and unzip files', 'https://www.youtube.com/watch?v=c7x-Q3AQEgw', 'Put two files into a ZIP folder, then extract them.', 17),
    (v_mod, 'video', 'ID · Keterampilan Sehari-hari · Zip dan ekstrak file', 'https://www.youtube.com/watch?v=v8BBPk31RD4', 'Masukkan dua file ke folder ZIP, lalu ekstrak kembali.', 18),
    (v_mod, 'video', 'Everyday Skills · Lock your screen (Win+L)', 'https://www.youtube.com/watch?v=BbqoACLRbTI', 'Lock your screen with Windows+L, then unlock it.', 19),
    (v_mod, 'video', 'ID · Keterampilan Sehari-hari · Mengunci layar (Win+L)', 'https://www.youtube.com/watch?v=NjQ-Mdl0t7w', 'Kunci layar dengan Windows+L, lalu buka kembali.', 20);

  -- Module 2
  SELECT m.id INTO v_mod FROM course_modules m JOIN courses c ON c.id=m.course_id
   WHERE c.title='Microsoft Digital Skills for University Prep' AND m.title LIKE 'Internet Safety%' LIMIT 1;
  IF v_mod IS NULL THEN RAISE EXCEPTION 'module not found'; END IF;
  DELETE FROM module_resources WHERE course_module_id=v_mod AND (title LIKE 'Staying Safe · %' OR title LIKE 'Email Skills · %' OR title LIKE 'ID · %');
  INSERT INTO module_resources (course_module_id, resource_type, title, url, description, sort_order) VALUES
    (v_mod, 'video', 'Staying Safe · Creating a strong password', 'https://www.youtube.com/watch?v=ph7AF2GWSCo', 'Create a strong password using letters, numbers and symbols.', 1),
    (v_mod, 'video', 'ID · Tetap Aman · Membuat kata sandi yang kuat', 'https://www.youtube.com/watch?v=y4BEAQKPyBU', 'Buat kata sandi kuat memakai huruf, angka, dan simbol.', 2),
    (v_mod, 'video', 'Staying Safe · Two-factor authentication (2FA)', 'https://www.youtube.com/watch?v=eVnf3x5w4rA', 'Turn on two-factor authentication (2FA) on one account.', 3),
    (v_mod, 'video', 'ID · Tetap Aman · Autentikasi dua faktor (2FA)', 'https://www.youtube.com/watch?v=jbxHYdEPz9c', 'Aktifkan autentikasi dua faktor (2FA) di satu akun.', 4),
    (v_mod, 'video', 'Staying Safe · Recognising phishing emails', 'https://www.youtube.com/watch?v=0IzgWhnuH0M', 'List three red flags that show an email is phishing.', 5),
    (v_mod, 'video', 'ID · Tetap Aman · Mengenali email phishing', 'https://www.youtube.com/watch?v=_99iuQo6h7w', 'Sebutkan tiga ciri yang menandakan sebuah email adalah phishing.', 6),
    (v_mod, 'video', 'Staying Safe · Spotting fake sites and scams', 'https://www.youtube.com/watch?v=b0rZZXH1t3c', 'Check a website address (https, spelling) before trusting it.', 7),
    (v_mod, 'video', 'ID · Tetap Aman · Mengenali situs palsu dan penipuan', 'https://www.youtube.com/watch?v=6uJGJ31UgBs', 'Periksa alamat situs (https, ejaan) sebelum mempercayainya.', 8),
    (v_mod, 'video', 'Staying Safe · Avoiding malware and online threats', 'https://www.youtube.com/watch?v=7vhXRC8Tp04', 'Name two ways to avoid malware and online scams.', 9),
    (v_mod, 'video', 'ID · Tetap Aman · Menghindari malware dan ancaman online', 'https://www.youtube.com/watch?v=kVEWChw6UCI', 'Sebutkan dua cara menghindari malware dan penipuan online.', 10),
    (v_mod, 'video', 'Staying Safe · Social media privacy settings', 'https://www.youtube.com/watch?v=qwh9SFNLQCA', 'Review and tighten the privacy settings on one social media account.', 11),
    (v_mod, 'video', 'ID · Tetap Aman · Pengaturan privasi media sosial', 'https://www.youtube.com/watch?v=fVE9WGNxunY', 'Tinjau dan perketat pengaturan privasi di satu akun media sosial.', 12),
    (v_mod, 'video', 'Email Skills · Writing a professional email', 'https://www.youtube.com/watch?v=GeuZV2eGDpY', 'Write a short, polite email with a clear subject line.', 13),
    (v_mod, 'video', 'ID · Keterampilan Email · Menulis email profesional', 'https://www.youtube.com/watch?v=GvgSKRVMqbw', 'Tulis email singkat yang sopan dengan subjek yang jelas.', 14),
    (v_mod, 'video', 'Email Skills · Email etiquette: To, Cc, Bcc', 'https://www.youtube.com/watch?v=zKPcqAHJDqc', 'Explain when to use To, Cc, and Bcc.', 15),
    (v_mod, 'video', 'ID · Keterampilan Email · Etika email: To, Cc, Bcc', 'https://www.youtube.com/watch?v=cyj-IxTxJyE', 'Jelaskan kapan memakai To, Cc, dan Bcc.', 16),
    (v_mod, 'video', 'Email Skills · Attaching files to an email', 'https://www.youtube.com/watch?v=NGu6MOEDNeI', 'Send yourself an email with a file attached.', 17),
    (v_mod, 'video', 'ID · Keterampilan Email · Melampirkan file ke email', 'https://www.youtube.com/watch?v=-smPbWzD4VM', 'Kirim email ke dirimu sendiri dengan sebuah file terlampir.', 18),
    (v_mod, 'video', 'Email Skills · Reporting spam and phishing', 'https://www.youtube.com/watch?v=Ss-Xf5FqetM', 'Report a spam or phishing email using the report button.', 19),
    (v_mod, 'video', 'ID · Keterampilan Email · Melaporkan spam dan phishing', 'https://www.youtube.com/watch?v=s5oIAbAd1r4', 'Laporkan email spam atau phishing memakai tombol lapor.', 20);
  RAISE NOTICE 'Added Module 1 & 2 video resources.';
END $$;

-- ============================================================
-- fill-lesson-clips-module-1-2.sql
-- Fills every still-empty lesson clip (video_url IS NULL) in Module 1 and
-- Module 2 of the Digital Skills course by matching each clip's label to the
-- best topic, setting that topic's EN + ID video and bilingual practice task.
-- Covers the seed items AND any custom clips added in the app. All videos
-- oEmbed-verified. Idempotent. Run in the Supabase SQL Editor.
-- ============================================================
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS video_url        TEXT;
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS video_url_id     TEXT;
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS practice_task    TEXT;
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS practice_task_id TEXT;
DO $$
DECLARE v_mod UUID;
BEGIN
  -- Module 1 · Computer Survival Skills & File Management
  SELECT m.id INTO v_mod FROM course_modules m JOIN courses c ON c.id=m.course_id
   WHERE c.title='Microsoft Digital Skills for University Prep' AND m.title LIKE 'Computer Survival%' LIMIT 1;
  IF v_mod IS NULL THEN RAISE EXCEPTION 'module not found'; END IF;
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=bKjRKZxr-KY', video_url_id='https://www.youtube.com/watch?v=YeaBHkzW0PA', practice_task='Make a Semester folder with a subfolder per subject and move files in.', practice_task_id='Buat folder Semester dengan subfolder tiap mata pelajaran dan pindahkan file ke dalamnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%folder structure%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=bKjRKZxr-KY', video_url_id='https://www.youtube.com/watch?v=YeaBHkzW0PA', practice_task='Make a Semester folder with a subfolder per subject and move files in.', practice_task_id='Buat folder Semester dengan subfolder tiap mata pelajaran dan pindahkan file ke dalamnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%organi%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=bKjRKZxr-KY', video_url_id='https://www.youtube.com/watch?v=YeaBHkzW0PA', practice_task='Make a Semester folder with a subfolder per subject and move files in.', practice_task_id='Buat folder Semester dengan subfolder tiap mata pelajaran dan pindahkan file ke dalamnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%semester%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=bKjRKZxr-KY', video_url_id='https://www.youtube.com/watch?v=YeaBHkzW0PA', practice_task='Make a Semester folder with a subfolder per subject and move files in.', practice_task_id='Buat folder Semester dengan subfolder tiap mata pelajaran dan pindahkan file ke dalamnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%merapikan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=TYyo3d50yc0', video_url_id='https://www.youtube.com/watch?v=ejM9-Cmbknw', practice_task='Create a new folder, rename it, then delete it.', practice_task_id='Buat folder baru, ganti namanya, lalu hapus.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%renamed%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=TYyo3d50yc0', video_url_id='https://www.youtube.com/watch?v=ejM9-Cmbknw', practice_task='Create a new folder, rename it, then delete it.', practice_task_id='Buat folder baru, ganti namanya, lalu hapus.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%rename%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=TYyo3d50yc0', video_url_id='https://www.youtube.com/watch?v=ejM9-Cmbknw', practice_task='Create a new folder, rename it, then delete it.', practice_task_id='Buat folder baru, ganti namanya, lalu hapus.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%delete%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=TYyo3d50yc0', video_url_id='https://www.youtube.com/watch?v=ejM9-Cmbknw', practice_task='Create a new folder, rename it, then delete it.', practice_task_id='Buat folder baru, ganti namanya, lalu hapus.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%create a new folder%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=TYyo3d50yc0', video_url_id='https://www.youtube.com/watch?v=ejM9-Cmbknw', practice_task='Create a new folder, rename it, then delete it.', practice_task_id='Buat folder baru, ganti namanya, lalu hapus.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%new folder%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=TYyo3d50yc0', video_url_id='https://www.youtube.com/watch?v=ejM9-Cmbknw', practice_task='Create a new folder, rename it, then delete it.', practice_task_id='Buat folder baru, ganti namanya, lalu hapus.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%membuat folder%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=TYyo3d50yc0', video_url_id='https://www.youtube.com/watch?v=ejM9-Cmbknw', practice_task='Create a new folder, rename it, then delete it.', practice_task_id='Buat folder baru, ganti namanya, lalu hapus.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%ganti nama%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=TYyo3d50yc0', video_url_id='https://www.youtube.com/watch?v=ejM9-Cmbknw', practice_task='Create a new folder, rename it, then delete it.', practice_task_id='Buat folder baru, ganti namanya, lalu hapus.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%hapus folder%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=0xA1nFEiTd0', video_url_id='https://www.youtube.com/watch?v=ZvZzafa0LW4', practice_task='Copy a file to another folder, then move a different one.', practice_task_id='Salin sebuah file ke folder lain, lalu pindahkan file lain.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%copy%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=0xA1nFEiTd0', video_url_id='https://www.youtube.com/watch?v=ZvZzafa0LW4', practice_task='Copy a file to another folder, then move a different one.', practice_task_id='Salin sebuah file ke folder lain, lalu pindahkan file lain.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%cut%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=0xA1nFEiTd0', video_url_id='https://www.youtube.com/watch?v=ZvZzafa0LW4', practice_task='Copy a file to another folder, then move a different one.', practice_task_id='Salin sebuah file ke folder lain, lalu pindahkan file lain.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%move%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=0xA1nFEiTd0', video_url_id='https://www.youtube.com/watch?v=ZvZzafa0LW4', practice_task='Copy a file to another folder, then move a different one.', practice_task_id='Salin sebuah file ke folder lain, lalu pindahkan file lain.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%paste%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=0xA1nFEiTd0', video_url_id='https://www.youtube.com/watch?v=ZvZzafa0LW4', practice_task='Copy a file to another folder, then move a different one.', practice_task_id='Salin sebuah file ke folder lain, lalu pindahkan file lain.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%salin%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=0xA1nFEiTd0', video_url_id='https://www.youtube.com/watch?v=ZvZzafa0LW4', practice_task='Copy a file to another folder, then move a different one.', practice_task_id='Salin sebuah file ke folder lain, lalu pindahkan file lain.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%pindah%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=0xA1nFEiTd0', video_url_id='https://www.youtube.com/watch?v=ZvZzafa0LW4', practice_task='Copy a file to another folder, then move a different one.', practice_task_id='Salin sebuah file ke folder lain, lalu pindahkan file lain.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%menyalin%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=uBANd9aVb3Y', video_url_id='https://www.youtube.com/watch?v=mslkVwk5lRU', practice_task='Practise Ctrl+C, Ctrl+V, Ctrl+Z and Alt+Tab.', practice_task_id='Latih Ctrl+C, Ctrl+V, Ctrl+Z, dan Alt+Tab.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%shortcut%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=uBANd9aVb3Y', video_url_id='https://www.youtube.com/watch?v=mslkVwk5lRU', practice_task='Practise Ctrl+C, Ctrl+V, Ctrl+Z and Alt+Tab.', practice_task_id='Latih Ctrl+C, Ctrl+V, Ctrl+Z, dan Alt+Tab.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%ctrl%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=uBANd9aVb3Y', video_url_id='https://www.youtube.com/watch?v=mslkVwk5lRU', practice_task='Practise Ctrl+C, Ctrl+V, Ctrl+Z and Alt+Tab.', practice_task_id='Latih Ctrl+C, Ctrl+V, Ctrl+Z, dan Alt+Tab.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%alt+tab%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=uBANd9aVb3Y', video_url_id='https://www.youtube.com/watch?v=mslkVwk5lRU', practice_task='Practise Ctrl+C, Ctrl+V, Ctrl+Z and Alt+Tab.', practice_task_id='Latih Ctrl+C, Ctrl+V, Ctrl+Z, dan Alt+Tab.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%alt tab%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=uBANd9aVb3Y', video_url_id='https://www.youtube.com/watch?v=mslkVwk5lRU', practice_task='Practise Ctrl+C, Ctrl+V, Ctrl+Z and Alt+Tab.', practice_task_id='Latih Ctrl+C, Ctrl+V, Ctrl+Z, dan Alt+Tab.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%keyboard%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=uBANd9aVb3Y', video_url_id='https://www.youtube.com/watch?v=mslkVwk5lRU', practice_task='Practise Ctrl+C, Ctrl+V, Ctrl+Z and Alt+Tab.', practice_task_id='Latih Ctrl+C, Ctrl+V, Ctrl+Z, dan Alt+Tab.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%pintasan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=GtGVItw89NM', video_url_id='https://www.youtube.com/watch?v=nkR7AuDSI5M', practice_task='Use the search box to find a file by its name.', practice_task_id='Pakai kotak pencarian untuk menemukan file berdasarkan namanya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%search%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=GtGVItw89NM', video_url_id='https://www.youtube.com/watch?v=nkR7AuDSI5M', practice_task='Use the search box to find a file by its name.', practice_task_id='Pakai kotak pencarian untuk menemukan file berdasarkan namanya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%mencari%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=GtGVItw89NM', video_url_id='https://www.youtube.com/watch?v=nkR7AuDSI5M', practice_task='Use the search box to find a file by its name.', practice_task_id='Pakai kotak pencarian untuk menemukan file berdasarkan namanya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%find a file%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=VqPyEGkTDsg', video_url_id='https://www.youtube.com/watch?v=jrcIqe6jUMs', practice_task='Print a document (or use Print Preview) from your computer.', practice_task_id='Cetak sebuah dokumen (atau pakai Print Preview) dari komputermu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%print%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=VqPyEGkTDsg', video_url_id='https://www.youtube.com/watch?v=jrcIqe6jUMs', practice_task='Print a document (or use Print Preview) from your computer.', practice_task_id='Cetak sebuah dokumen (atau pakai Print Preview) dari komputermu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%cetak%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=VqPyEGkTDsg', video_url_id='https://www.youtube.com/watch?v=jrcIqe6jUMs', practice_task='Print a document (or use Print Preview) from your computer.', practice_task_id='Cetak sebuah dokumen (atau pakai Print Preview) dari komputermu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%mencetak%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=P9uWUz-e1V0', video_url_id='https://www.youtube.com/watch?v=5R35dR22Hgc', practice_task='Save or print a document as a PDF and open it to check.', practice_task_id='Simpan atau cetak dokumen sebagai PDF lalu buka untuk memeriksanya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%pdf%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=c7x-Q3AQEgw', video_url_id='https://www.youtube.com/watch?v=v8BBPk31RD4', practice_task='Put two files into a ZIP folder, then extract them.', practice_task_id='Masukkan dua file ke folder ZIP, lalu ekstrak kembali.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%zip%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=c7x-Q3AQEgw', video_url_id='https://www.youtube.com/watch?v=v8BBPk31RD4', practice_task='Put two files into a ZIP folder, then extract them.', practice_task_id='Masukkan dua file ke folder ZIP, lalu ekstrak kembali.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%unzip%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=c7x-Q3AQEgw', video_url_id='https://www.youtube.com/watch?v=v8BBPk31RD4', practice_task='Put two files into a ZIP folder, then extract them.', practice_task_id='Masukkan dua file ke folder ZIP, lalu ekstrak kembali.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%extract%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=c7x-Q3AQEgw', video_url_id='https://www.youtube.com/watch?v=v8BBPk31RD4', practice_task='Put two files into a ZIP folder, then extract them.', practice_task_id='Masukkan dua file ke folder ZIP, lalu ekstrak kembali.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%kompres%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=BbqoACLRbTI', video_url_id='https://www.youtube.com/watch?v=NjQ-Mdl0t7w', practice_task='Lock your screen with Windows+L, then unlock it.', practice_task_id='Kunci layar dengan Windows+L, lalu buka kembali.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%lock%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=BbqoACLRbTI', video_url_id='https://www.youtube.com/watch?v=NjQ-Mdl0t7w', practice_task='Lock your screen with Windows+L, then unlock it.', practice_task_id='Kunci layar dengan Windows+L, lalu buka kembali.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%screen%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=BbqoACLRbTI', video_url_id='https://www.youtube.com/watch?v=NjQ-Mdl0t7w', practice_task='Lock your screen with Windows+L, then unlock it.', practice_task_id='Kunci layar dengan Windows+L, lalu buka kembali.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%kunci%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=BbqoACLRbTI', video_url_id='https://www.youtube.com/watch?v=NjQ-Mdl0t7w', practice_task='Lock your screen with Windows+L, then unlock it.', practice_task_id='Kunci layar dengan Windows+L, lalu buka kembali.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%mengunci%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=hUW5MEKDtMM', video_url_id='https://www.youtube.com/watch?v=7D1XFiCBgHo', practice_task='Point out the difference between a file and a folder on your computer.', practice_task_id='Tunjukkan perbedaan antara file dan folder di komputermu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%file%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=hUW5MEKDtMM', video_url_id='https://www.youtube.com/watch?v=7D1XFiCBgHo', practice_task='Point out the difference between a file and a folder on your computer.', practice_task_id='Tunjukkan perbedaan antara file dan folder di komputermu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%folder%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=hUW5MEKDtMM', video_url_id='https://www.youtube.com/watch?v=7D1XFiCBgHo', practice_task='Point out the difference between a file and a folder on your computer.', practice_task_id='Tunjukkan perbedaan antara file dan folder di komputermu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%directory%';

  -- Module 2 · Internet Safety, Email & Security Awareness
  SELECT m.id INTO v_mod FROM course_modules m JOIN courses c ON c.id=m.course_id
   WHERE c.title='Microsoft Digital Skills for University Prep' AND m.title LIKE 'Internet Safety%' LIMIT 1;
  IF v_mod IS NULL THEN RAISE EXCEPTION 'module not found'; END IF;
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Ss-Xf5FqetM', video_url_id='https://www.youtube.com/watch?v=s5oIAbAd1r4', practice_task='Report a spam or phishing email using the report button.', practice_task_id='Laporkan email spam atau phishing memakai tombol lapor.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%report%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Ss-Xf5FqetM', video_url_id='https://www.youtube.com/watch?v=s5oIAbAd1r4', practice_task='Report a spam or phishing email using the report button.', practice_task_id='Laporkan email spam atau phishing memakai tombol lapor.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%spam%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Ss-Xf5FqetM', video_url_id='https://www.youtube.com/watch?v=s5oIAbAd1r4', practice_task='Report a spam or phishing email using the report button.', practice_task_id='Laporkan email spam atau phishing memakai tombol lapor.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%laporkan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Ss-Xf5FqetM', video_url_id='https://www.youtube.com/watch?v=s5oIAbAd1r4', practice_task='Report a spam or phishing email using the report button.', practice_task_id='Laporkan email spam atau phishing memakai tombol lapor.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%melaporkan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=eVnf3x5w4rA', video_url_id='https://www.youtube.com/watch?v=jbxHYdEPz9c', practice_task='Turn on two-factor authentication (2FA) on one account.', practice_task_id='Aktifkan autentikasi dua faktor (2FA) di satu akun.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%two-factor%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=eVnf3x5w4rA', video_url_id='https://www.youtube.com/watch?v=jbxHYdEPz9c', practice_task='Turn on two-factor authentication (2FA) on one account.', practice_task_id='Aktifkan autentikasi dua faktor (2FA) di satu akun.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%two factor%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=eVnf3x5w4rA', video_url_id='https://www.youtube.com/watch?v=jbxHYdEPz9c', practice_task='Turn on two-factor authentication (2FA) on one account.', practice_task_id='Aktifkan autentikasi dua faktor (2FA) di satu akun.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%2fa%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=eVnf3x5w4rA', video_url_id='https://www.youtube.com/watch?v=jbxHYdEPz9c', practice_task='Turn on two-factor authentication (2FA) on one account.', practice_task_id='Aktifkan autentikasi dua faktor (2FA) di satu akun.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%authentication%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=eVnf3x5w4rA', video_url_id='https://www.youtube.com/watch?v=jbxHYdEPz9c', practice_task='Turn on two-factor authentication (2FA) on one account.', practice_task_id='Aktifkan autentikasi dua faktor (2FA) di satu akun.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%autentikasi%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=eVnf3x5w4rA', video_url_id='https://www.youtube.com/watch?v=jbxHYdEPz9c', practice_task='Turn on two-factor authentication (2FA) on one account.', practice_task_id='Aktifkan autentikasi dua faktor (2FA) di satu akun.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%dua faktor%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=ph7AF2GWSCo', video_url_id='https://www.youtube.com/watch?v=y4BEAQKPyBU', practice_task='Create a strong password using letters, numbers and symbols.', practice_task_id='Buat kata sandi kuat memakai huruf, angka, dan simbol.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%passphrase%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=ph7AF2GWSCo', video_url_id='https://www.youtube.com/watch?v=y4BEAQKPyBU', practice_task='Create a strong password using letters, numbers and symbols.', practice_task_id='Buat kata sandi kuat memakai huruf, angka, dan simbol.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%password%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=ph7AF2GWSCo', video_url_id='https://www.youtube.com/watch?v=y4BEAQKPyBU', practice_task='Create a strong password using letters, numbers and symbols.', practice_task_id='Buat kata sandi kuat memakai huruf, angka, dan simbol.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%kata sandi%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=GeuZV2eGDpY', video_url_id='https://www.youtube.com/watch?v=GvgSKRVMqbw', practice_task='Write a short, polite email with a clear subject line.', practice_task_id='Tulis email singkat yang sopan dengan subjek yang jelas.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%professional email%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=GeuZV2eGDpY', video_url_id='https://www.youtube.com/watch?v=GvgSKRVMqbw', practice_task='Write a short, polite email with a clear subject line.', practice_task_id='Tulis email singkat yang sopan dengan subjek yang jelas.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%write a professional%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=GeuZV2eGDpY', video_url_id='https://www.youtube.com/watch?v=GvgSKRVMqbw', practice_task='Write a short, polite email with a clear subject line.', practice_task_id='Tulis email singkat yang sopan dengan subjek yang jelas.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%compose%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=GeuZV2eGDpY', video_url_id='https://www.youtube.com/watch?v=GvgSKRVMqbw', practice_task='Write a short, polite email with a clear subject line.', practice_task_id='Tulis email singkat yang sopan dengan subjek yang jelas.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%menulis email%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=GeuZV2eGDpY', video_url_id='https://www.youtube.com/watch?v=GvgSKRVMqbw', practice_task='Write a short, polite email with a clear subject line.', practice_task_id='Tulis email singkat yang sopan dengan subjek yang jelas.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%email profesional%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=zKPcqAHJDqc', video_url_id='https://www.youtube.com/watch?v=cyj-IxTxJyE', practice_task='Explain when to use To, Cc, and Bcc.', practice_task_id='Jelaskan kapan memakai To, Cc, dan Bcc.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%etiquette%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=zKPcqAHJDqc', video_url_id='https://www.youtube.com/watch?v=cyj-IxTxJyE', practice_task='Explain when to use To, Cc, and Bcc.', practice_task_id='Jelaskan kapan memakai To, Cc, dan Bcc.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%bcc%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=zKPcqAHJDqc', video_url_id='https://www.youtube.com/watch?v=cyj-IxTxJyE', practice_task='Explain when to use To, Cc, and Bcc.', practice_task_id='Jelaskan kapan memakai To, Cc, dan Bcc.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '% cc %';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=zKPcqAHJDqc', video_url_id='https://www.youtube.com/watch?v=cyj-IxTxJyE', practice_task='Explain when to use To, Cc, and Bcc.', practice_task_id='Jelaskan kapan memakai To, Cc, dan Bcc.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%cc/%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=zKPcqAHJDqc', video_url_id='https://www.youtube.com/watch?v=cyj-IxTxJyE', practice_task='Explain when to use To, Cc, and Bcc.', practice_task_id='Jelaskan kapan memakai To, Cc, dan Bcc.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%etika%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=NGu6MOEDNeI', video_url_id='https://www.youtube.com/watch?v=-smPbWzD4VM', practice_task='Send yourself an email with a file attached.', practice_task_id='Kirim email ke dirimu sendiri dengan sebuah file terlampir.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%attach%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=NGu6MOEDNeI', video_url_id='https://www.youtube.com/watch?v=-smPbWzD4VM', practice_task='Send yourself an email with a file attached.', practice_task_id='Kirim email ke dirimu sendiri dengan sebuah file terlampir.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%lampiran%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=NGu6MOEDNeI', video_url_id='https://www.youtube.com/watch?v=-smPbWzD4VM', practice_task='Send yourself an email with a file attached.', practice_task_id='Kirim email ke dirimu sendiri dengan sebuah file terlampir.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%melampirkan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=qwh9SFNLQCA', video_url_id='https://www.youtube.com/watch?v=fVE9WGNxunY', practice_task='Review and tighten the privacy settings on one social media account.', practice_task_id='Tinjau dan perketat pengaturan privasi di satu akun media sosial.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%privacy%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=qwh9SFNLQCA', video_url_id='https://www.youtube.com/watch?v=fVE9WGNxunY', practice_task='Review and tighten the privacy settings on one social media account.', practice_task_id='Tinjau dan perketat pengaturan privasi di satu akun media sosial.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%privasi%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=qwh9SFNLQCA', video_url_id='https://www.youtube.com/watch?v=fVE9WGNxunY', practice_task='Review and tighten the privacy settings on one social media account.', practice_task_id='Tinjau dan perketat pengaturan privasi di satu akun media sosial.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%social media%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=qwh9SFNLQCA', video_url_id='https://www.youtube.com/watch?v=fVE9WGNxunY', practice_task='Review and tighten the privacy settings on one social media account.', practice_task_id='Tinjau dan perketat pengaturan privasi di satu akun media sosial.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%media sosial%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=b0rZZXH1t3c', video_url_id='https://www.youtube.com/watch?v=6uJGJ31UgBs', practice_task='Check a website address (https, spelling) before trusting it.', practice_task_id='Periksa alamat situs (https, ejaan) sebelum mempercayainya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%fake site%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=b0rZZXH1t3c', video_url_id='https://www.youtube.com/watch?v=6uJGJ31UgBs', practice_task='Check a website address (https, spelling) before trusting it.', practice_task_id='Periksa alamat situs (https, ejaan) sebelum mempercayainya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%fake website%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=b0rZZXH1t3c', video_url_id='https://www.youtube.com/watch?v=6uJGJ31UgBs', practice_task='Check a website address (https, spelling) before trusting it.', practice_task_id='Periksa alamat situs (https, ejaan) sebelum mempercayainya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%scam%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=b0rZZXH1t3c', video_url_id='https://www.youtube.com/watch?v=6uJGJ31UgBs', practice_task='Check a website address (https, spelling) before trusting it.', practice_task_id='Periksa alamat situs (https, ejaan) sebelum mempercayainya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%situs palsu%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=b0rZZXH1t3c', video_url_id='https://www.youtube.com/watch?v=6uJGJ31UgBs', practice_task='Check a website address (https, spelling) before trusting it.', practice_task_id='Periksa alamat situs (https, ejaan) sebelum mempercayainya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%penipuan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=b0rZZXH1t3c', video_url_id='https://www.youtube.com/watch?v=6uJGJ31UgBs', practice_task='Check a website address (https, spelling) before trusting it.', practice_task_id='Periksa alamat situs (https, ejaan) sebelum mempercayainya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%safe browsing%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=b0rZZXH1t3c', video_url_id='https://www.youtube.com/watch?v=6uJGJ31UgBs', practice_task='Check a website address (https, spelling) before trusting it.', practice_task_id='Periksa alamat situs (https, ejaan) sebelum mempercayainya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%browsing%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=7vhXRC8Tp04', video_url_id='https://www.youtube.com/watch?v=kVEWChw6UCI', practice_task='Name two ways to avoid malware and online scams.', practice_task_id='Sebutkan dua cara menghindari malware dan penipuan online.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%malware%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=7vhXRC8Tp04', video_url_id='https://www.youtube.com/watch?v=kVEWChw6UCI', practice_task='Name two ways to avoid malware and online scams.', practice_task_id='Sebutkan dua cara menghindari malware dan penipuan online.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%virus%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=7vhXRC8Tp04', video_url_id='https://www.youtube.com/watch?v=kVEWChw6UCI', practice_task='Name two ways to avoid malware and online scams.', practice_task_id='Sebutkan dua cara menghindari malware dan penipuan online.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%threat%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=7vhXRC8Tp04', video_url_id='https://www.youtube.com/watch?v=kVEWChw6UCI', practice_task='Name two ways to avoid malware and online scams.', practice_task_id='Sebutkan dua cara menghindari malware dan penipuan online.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%ancaman%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=0IzgWhnuH0M', video_url_id='https://www.youtube.com/watch?v=_99iuQo6h7w', practice_task='List three red flags that show an email is phishing.', practice_task_id='Sebutkan tiga ciri yang menandakan sebuah email adalah phishing.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%phishing%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=0IzgWhnuH0M', video_url_id='https://www.youtube.com/watch?v=_99iuQo6h7w', practice_task='List three red flags that show an email is phishing.', practice_task_id='Sebutkan tiga ciri yang menandakan sebuah email adalah phishing.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%phising%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=0IzgWhnuH0M', video_url_id='https://www.youtube.com/watch?v=_99iuQo6h7w', practice_task='List three red flags that show an email is phishing.', practice_task_id='Sebutkan tiga ciri yang menandakan sebuah email adalah phishing.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%red flag%';
  RAISE NOTICE 'Filled Module 1 & 2 lesson clips by label match.';
END $$;

SELECT m.title AS module, i.item_key, i.label
  FROM module_checklist_items i JOIN course_modules m ON m.id=i.course_module_id
 WHERE m.course_id=(SELECT id FROM courses WHERE title='Microsoft Digital Skills for University Prep')
   AND i.item_type='student' AND i.video_url IS NULL
   AND (m.title LIKE 'Computer Survival%' OR m.title LIKE 'Internet Safety%')
 ORDER BY m.title, i.sort_order;

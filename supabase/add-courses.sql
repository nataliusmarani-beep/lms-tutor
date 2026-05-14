-- ============================================================
-- add-courses.sql
-- Multi-course system for LMS Tutor
-- ============================================================

-- 1. Create new tables
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS courses (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title       TEXT NOT NULL,
  description TEXT,
  icon        TEXT NOT NULL DEFAULT '📚',
  created_by  UUID REFERENCES profiles(id),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS course_modules (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id        UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  title            TEXT NOT NULL,
  focus            TEXT,
  icon             TEXT NOT NULL DEFAULT '📚',
  week_number      INT,
  sort_order       INT NOT NULL DEFAULT 0,
  legacy_module_id SMALLINT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS course_enrollments (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id  UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  student_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  enrolled_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (course_id, student_id)
);

-- 2. Add course_module_id columns to existing tables
-- ------------------------------------------------------------

ALTER TABLE module_checklist_items
  ADD COLUMN IF NOT EXISTS course_module_id UUID REFERENCES course_modules(id);

ALTER TABLE learning_sessions
  ADD COLUMN IF NOT EXISTS course_module_id UUID REFERENCES course_modules(id);

ALTER TABLE checklist_completions
  ADD COLUMN IF NOT EXISTS course_module_id UUID REFERENCES course_modules(id);

ALTER TABLE assignments
  ADD COLUMN IF NOT EXISTS course_module_id UUID REFERENCES course_modules(id);

-- Make legacy integer module_id nullable in session / completion tables
ALTER TABLE learning_sessions    ALTER COLUMN module_id DROP NOT NULL;
ALTER TABLE checklist_completions ALTER COLUMN module_id DROP NOT NULL;

-- 3. Row-Level Security
-- ------------------------------------------------------------

ALTER TABLE courses            ENABLE ROW LEVEL SECURITY;
ALTER TABLE course_modules     ENABLE ROW LEVEL SECURITY;
ALTER TABLE course_enrollments ENABLE ROW LEVEL SECURITY;

-- All authenticated users can read
CREATE POLICY "courses_select" ON courses
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "course_modules_select" ON course_modules
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "course_enrollments_select" ON course_enrollments
  FOR SELECT TO authenticated USING (true);

-- Tutors can do everything
CREATE POLICY "courses_tutor_all" ON courses
  FOR ALL TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  );

CREATE POLICY "course_modules_tutor_all" ON course_modules
  FOR ALL TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  );

CREATE POLICY "course_enrollments_tutor_all" ON course_enrollments
  FOR ALL TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  );

-- 4. Seed data
-- ------------------------------------------------------------

DO $$
DECLARE
  v_course_id UUID;
  v_module_count INT;
BEGIN

  -- 4a. Insert Microsoft App Course (skip if already present)
  SELECT id INTO v_course_id FROM courses WHERE title = 'Microsoft App Course' LIMIT 1;

  IF v_course_id IS NULL THEN
    INSERT INTO courses (title, description, icon)
    VALUES (
      'Microsoft App Course',
      'College prep course covering Microsoft 365 apps over 8 weeks.',
      '💻'
    )
    RETURNING id INTO v_course_id;
  END IF;

  -- 4b. Insert 8 course_modules if not already there
  SELECT COUNT(*) INTO v_module_count FROM course_modules WHERE course_id = v_course_id;

  IF v_module_count = 0 THEN
    INSERT INTO course_modules (course_id, legacy_module_id, icon, week_number, sort_order, title, focus) VALUES
      (v_course_id, 1, '💻', 1, 1,
        'Digital Basics, Security, Printer & OneNote',
        'Computer literacy, file management, cyber safety, printer use, OneNote notebooks.'),
      (v_course_id, 2, '📄', 2, 2,
        'Word Foundations – Academic Papers & Formatting',
        'Document creation, formatting, referencing, review.'),
      (v_course_id, 3, '📊', 3, 3,
        'Excel Foundations – Data, Formulas & Charts',
        'Spreadsheet literacy, basic analysis, visualization.'),
      (v_course_id, 4, '🎨', 4, 4,
        'PowerPoint Essentials & Presentation Design',
        'Slide creation, design principles, delivery tools.'),
      (v_course_id, 5, '📑', 5, 5,
        'Advanced Word – Long Documents & Automation',
        'Complex academic writing, templates.'),
      (v_course_id, 6, '📈', 6, 6,
        'Advanced Excel – Analysis & Modeling',
        'PivotTables, what-if tools, dashboard.'),
      (v_course_id, 7, '🧑‍🤝‍🧑', 7, 7,
        'Teams & OneNote – Collaboration for Group Projects',
        'Seamless teamwork, meetings, shared notes.'),
      (v_course_id, 8, '⚙️', 8, 8,
        'Integration, Automation & Final Portfolio',
        'Cross-app efficiency, Power Automate, portfolio.');
  END IF;

  -- 4c. Backfill course_module_id on module_checklist_items
  UPDATE module_checklist_items mci
  SET    course_module_id = cm.id
  FROM   course_modules cm
  WHERE  cm.course_id          = v_course_id
    AND  cm.legacy_module_id   = mci.module_id
    AND  mci.course_module_id  IS NULL;

  -- 4d. Backfill course_module_id on learning_sessions
  UPDATE learning_sessions ls
  SET    course_module_id = cm.id
  FROM   course_modules cm
  WHERE  cm.course_id         = v_course_id
    AND  cm.legacy_module_id  = ls.module_id
    AND  ls.course_module_id  IS NULL;

  -- 4e. Backfill course_module_id on checklist_completions
  UPDATE checklist_completions cc
  SET    course_module_id = cm.id
  FROM   course_modules cm
  WHERE  cm.course_id         = v_course_id
    AND  cm.legacy_module_id  = cc.module_id
    AND  cc.course_module_id  IS NULL;

  -- 4f. Enrol all existing students in the Microsoft App Course
  INSERT INTO course_enrollments (course_id, student_id)
  SELECT v_course_id, id
  FROM   profiles
  WHERE  role = 'student'
  ON CONFLICT (course_id, student_id) DO NOTHING;

END $$;

-- ============================================================
-- Microsoft App Tutor LMS – Supabase Schema
-- Run this in Supabase SQL Editor (Project > SQL Editor)
-- ============================================================

-- 1. Profiles (linked to Supabase Auth users)
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('tutor', 'student', 'parent')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read all profiles" ON profiles
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- 2. Parent–Student links
CREATE TABLE IF NOT EXISTS parent_student (
  parent_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  student_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  PRIMARY KEY (parent_id, student_id)
);

ALTER TABLE parent_student ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read parent_student" ON parent_student
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can insert parent_student" ON parent_student
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- 3. Learning sessions
CREATE TABLE IF NOT EXISTS learning_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  module_id SMALLINT NOT NULL CHECK (module_id BETWEEN 1 AND 8),
  date DATE NOT NULL,
  duration_minutes SMALLINT NOT NULL CHECK (duration_minutes > 0),
  tutor_notes TEXT,
  student_notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE learning_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Tutors and the student can read sessions" ON learning_sessions
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
    OR student_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM parent_student ps WHERE ps.parent_id = auth.uid() AND ps.student_id = learning_sessions.student_id
    )
  );

CREATE POLICY "Tutors can insert sessions" ON learning_sessions
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  );

CREATE POLICY "Tutors can update sessions" ON learning_sessions
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  );

-- 4. Checklist completions
CREATE TABLE IF NOT EXISTS checklist_completions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  module_id SMALLINT NOT NULL CHECK (module_id BETWEEN 1 AND 8),
  item_key TEXT NOT NULL,
  item_type TEXT NOT NULL CHECK (item_type IN ('student', 'teacher')),
  confirmed_at TIMESTAMPTZ DEFAULT NOW(),
  confirmed_by UUID REFERENCES profiles(id),
  UNIQUE (student_id, item_key)
);

ALTER TABLE checklist_completions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Read checklist" ON checklist_completions
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
    OR student_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM parent_student ps WHERE ps.parent_id = auth.uid() AND ps.student_id = checklist_completions.student_id
    )
  );

CREATE POLICY "Tutor or student can insert checklist items" ON checklist_completions
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
    OR (student_id = auth.uid() AND item_type = 'student')
  );

CREATE POLICY "Tutor or student can delete checklist items" ON checklist_completions
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
    OR (student_id = auth.uid() AND item_type = 'student')
  );

-- 5. Assignments
CREATE TABLE IF NOT EXISTS assignments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  module_id SMALLINT NOT NULL CHECK (module_id BETWEEN 1 AND 8),
  title TEXT NOT NULL,
  description TEXT,
  due_date DATE,
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE assignments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read assignments" ON assignments
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Tutors can manage assignments" ON assignments
  FOR ALL USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  );

-- 6. Submissions
CREATE TABLE IF NOT EXISTS submissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  assignment_id UUID REFERENCES assignments(id) ON DELETE CASCADE NOT NULL,
  student_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  file_link TEXT,
  notes TEXT,
  submitted_at TIMESTAMPTZ DEFAULT NOW(),
  grade TEXT,
  feedback TEXT,
  graded_at TIMESTAMPTZ,
  UNIQUE (assignment_id, student_id)
);

ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Read submissions" ON submissions
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
    OR student_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM parent_student ps WHERE ps.parent_id = auth.uid() AND ps.student_id = submissions.student_id
    )
  );

CREATE POLICY "Students can submit" ON submissions
  FOR INSERT WITH CHECK (student_id = auth.uid());

CREATE POLICY "Tutors can grade" ON submissions
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  );

-- ============================================================
-- Auto-create profile on user signup via trigger
-- ============================================================
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  INSERT INTO profiles (id, name, role)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'name', split_part(NEW.email, '@', 1)),
    COALESCE(NEW.raw_user_meta_data->>'role', 'student')
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE handle_new_user();

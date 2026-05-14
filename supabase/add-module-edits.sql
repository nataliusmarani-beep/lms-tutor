-- Module customizations (override title/focus per module)
CREATE TABLE IF NOT EXISTS module_customizations (
  module_id SMALLINT PRIMARY KEY CHECK (module_id BETWEEN 1 AND 8),
  custom_title TEXT,
  custom_focus TEXT,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE module_customizations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read module_customizations" ON module_customizations
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Tutors can manage module_customizations" ON module_customizations
  FOR ALL USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  );

-- Custom checklist items (add extra items beyond the defaults)
CREATE TABLE IF NOT EXISTS custom_checklist_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  module_id SMALLINT NOT NULL CHECK (module_id BETWEEN 1 AND 8),
  item_type TEXT NOT NULL CHECK (item_type IN ('student', 'teacher')),
  label TEXT NOT NULL,
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE custom_checklist_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read custom_checklist_items" ON custom_checklist_items
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Tutors can manage custom_checklist_items" ON custom_checklist_items
  FOR ALL USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  );

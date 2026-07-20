-- ============================================================
-- notifications.sql
-- Bell notifications for students and guardians when the tutor makes an
-- update. A notification row is created for the student AND each of their
-- linked parents/guardians whenever the tutor:
--   * logs a learning session          (learning_sessions INSERT)
--   * confirms a checklist item         (checklist_completions INSERT where
--                                        the confirmer is not the student)
--
-- The `link` is stored as a role-neutral suffix (e.g. '/sessions'); the
-- NotificationBell prepends the viewer's base ('/student' or '/parent').
--
-- Run in the Supabase SQL Editor. Safe to re-run.
-- ============================================================

CREATE TABLE IF NOT EXISTS notifications (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  recipient_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  actor_id     UUID REFERENCES profiles(id) ON DELETE SET NULL,
  type         TEXT NOT NULL,
  title        TEXT NOT NULL,
  title_id     TEXT,
  body         TEXT,
  body_id      TEXT,
  link         TEXT,
  read         BOOLEAN NOT NULL DEFAULT FALSE,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS notifications_recipient_idx
  ON notifications (recipient_id, read, created_at DESC);

-- ── Row Level Security: a user only sees / manages their own ──────────────
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS notifications_select ON notifications;
CREATE POLICY notifications_select ON notifications
  FOR SELECT TO authenticated USING (recipient_id = auth.uid());

DROP POLICY IF EXISTS notifications_update ON notifications;
CREATE POLICY notifications_update ON notifications
  FOR UPDATE TO authenticated
  USING (recipient_id = auth.uid()) WITH CHECK (recipient_id = auth.uid());

DROP POLICY IF EXISTS notifications_delete ON notifications;
CREATE POLICY notifications_delete ON notifications
  FOR DELETE TO authenticated USING (recipient_id = auth.uid());
-- (No INSERT policy: rows are created by the SECURITY DEFINER triggers below,
--  which bypass RLS. Clients never insert directly.)

-- ── Helper: notify a student and all of their guardians ───────────────────
CREATE OR REPLACE FUNCTION notify_student_and_guardians(
  p_student  UUID, p_actor UUID, p_type TEXT,
  p_title    TEXT, p_title_id TEXT,
  p_body     TEXT, p_body_id  TEXT, p_link TEXT
) RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  -- the student
  INSERT INTO notifications (recipient_id, actor_id, type, title, title_id, body, body_id, link)
  VALUES (p_student, p_actor, p_type, p_title, p_title_id, p_body, p_body_id, p_link);
  -- each linked guardian/parent
  INSERT INTO notifications (recipient_id, actor_id, type, title, title_id, body, body_id, link)
  SELECT ps.parent_id, p_actor, p_type, p_title, p_title_id, p_body, p_body_id, p_link
    FROM parent_student ps
   WHERE ps.student_id = p_student;
END $$;

-- ── Trigger 1: tutor logs a learning session ─────────────────────────────
CREATE OR REPLACE FUNCTION notify_on_session() RETURNS trigger
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  PERFORM notify_student_and_guardians(
    NEW.student_id, NULL, 'session',
    'New session logged',        'Sesi baru dicatat',
    'Your tutor logged a learning session.', 'Tutor mencatat sesi belajar.',
    '/sessions');
  RETURN NEW;
END $$;

DROP TRIGGER IF EXISTS trg_notify_session ON learning_sessions;
CREATE TRIGGER trg_notify_session
  AFTER INSERT ON learning_sessions
  FOR EACH ROW EXECUTE FUNCTION notify_on_session();

-- ── Trigger 2: tutor confirms a checklist item for a student ─────────────
CREATE OR REPLACE FUNCTION notify_on_checklist() RETURNS trigger
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_label    TEXT;
  v_label_id TEXT;
BEGIN
  -- only when someone OTHER than the student confirmed it (i.e. the tutor)
  IF NEW.confirmed_by IS NULL OR NEW.confirmed_by = NEW.student_id THEN
    RETURN NEW;
  END IF;

  SELECT label, label_id INTO v_label, v_label_id
    FROM module_checklist_items WHERE item_key = NEW.item_key LIMIT 1;

  PERFORM notify_student_and_guardians(
    NEW.student_id, NEW.confirmed_by, 'checklist',
    'Tutor updated your progress',   'Tutor memperbarui progresmu',
    COALESCE('Marked complete: ' || v_label, 'Your tutor marked a task complete.'),
    COALESCE('Ditandai selesai: ' || COALESCE(v_label_id, v_label), 'Tutor menandai sebuah tugas selesai.'),
    '/courses');
  RETURN NEW;
END $$;

DROP TRIGGER IF EXISTS trg_notify_checklist ON checklist_completions;
CREATE TRIGGER trg_notify_checklist
  AFTER INSERT ON checklist_completions
  FOR EACH ROW EXECUTE FUNCTION notify_on_checklist();

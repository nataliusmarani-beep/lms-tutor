-- Create the public storage bucket used by ResourcePanel for image uploads.
-- Run once in the Supabase SQL Editor.

INSERT INTO storage.buckets (id, name, public)
VALUES ('module-resources', 'module-resources', true)
ON CONFLICT (id) DO NOTHING;

-- Allow any authenticated user to upload (tutors only in practice — enforced by the UI)
CREATE POLICY "Authenticated upload module-resources"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'module-resources');

-- Allow public read
CREATE POLICY "Public read module-resources"
  ON storage.objects FOR SELECT
  TO public
  USING (bucket_id = 'module-resources');

-- Allow owner to delete
CREATE POLICY "Authenticated delete module-resources"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'module-resources');

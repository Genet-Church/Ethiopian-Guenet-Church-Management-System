-- =====================================================
-- FIX 1: Add missing `baptism_date` column to members table
-- The form sends this field but it was never added to the schema
-- =====================================================
ALTER TABLE public.members
ADD COLUMN IF NOT EXISTS baptism_date date;

COMMENT ON COLUMN public.members.baptism_date IS 'Date of baptism, set when baptism_status is done';

-- =====================================================
-- FIX 2: Fix departments RLS policies for INSERT operations
-- The previous migration created FOR ALL policies with only USING
-- but no WITH CHECK. For INSERT operations, PostgreSQL needs
-- WITH CHECK to validate the NEW row. Without it, inserts fail
-- because USING references columns on the "existing" row which
-- doesn't exist yet during INSERT.
--
-- Also removes the duplicate overlapping policies that were
-- created by the previous migration (two FOR ALL policies
-- for the same roles causes conflicts).
-- =====================================================

-- Drop ALL existing department management policies to start clean
DROP POLICY IF EXISTS "Church staff can manage departments in their church" ON public.departments;
DROP POLICY IF EXISTS "Admins can manage departments in their church" ON public.departments;
DROP POLICY IF EXISTS "Pastors can manage departments in their church" ON public.departments;
DROP POLICY IF EXISTS "Super Admins can manage departments" ON public.departments;
DROP POLICY IF EXISTS "Super Admins can view departments" ON public.departments;
DROP POLICY IF EXISTS "Super Admins can update departments" ON public.departments;
DROP POLICY IF EXISTS "Super Admins can delete departments" ON public.departments;

-- Keep the SELECT policy (viewable by everyone) 
-- It should already exist, but ensure it's there
DROP POLICY IF EXISTS "Departments are viewable by everyone" ON public.departments;
CREATE POLICY "Departments are viewable by everyone"
  ON public.departments FOR SELECT
  USING (true);

-- Super Admins: full access to all departments (SELECT, UPDATE, DELETE — no INSERT per original design)
CREATE POLICY "Super Admins can manage departments"
  ON public.departments FOR ALL
  USING (public.get_my_role() = 'super_admin')
  WITH CHECK (public.get_my_role() = 'super_admin');

-- Admins & Servants: full access to their church's departments (including INSERT)
-- The WITH CHECK clause is CRITICAL for INSERT to work — it validates the new row
CREATE POLICY "Church staff can manage departments in their church"
  ON public.departments FOR ALL
  USING (
    public.get_my_role() IN ('admin', 'servant') AND
    church_id = public.get_my_church_id()
  )
  WITH CHECK (
    public.get_my_role() IN ('admin', 'servant') AND
    church_id = public.get_my_church_id()
  );

-- =====================================================
-- FIX 3: Also fix members RLS to include WITH CHECK
-- Same issue: FOR ALL without WITH CHECK blocks inserts
-- =====================================================
DROP POLICY IF EXISTS "Admins can manage members in their church" ON public.members;
DROP POLICY IF EXISTS "Church staff can manage members in their church" ON public.members;

CREATE POLICY "Church staff can manage members in their church"
  ON public.members FOR ALL
  USING (
    public.get_my_role() IN ('admin', 'servant') AND
    church_id = public.get_my_church_id()
  )
  WITH CHECK (
    public.get_my_role() IN ('admin', 'servant') AND
    church_id = public.get_my_church_id()
  );

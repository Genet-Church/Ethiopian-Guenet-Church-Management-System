-- 1. Update RLS policies for `members` table
DROP POLICY IF EXISTS "Pastors can manage members in their church" ON public.members;
CREATE POLICY "Admins can manage members in their church"
  ON public.members FOR ALL
  USING (
    (public.get_my_role() = 'admin' OR public.get_my_role() = 'servant') AND
    church_id = public.get_my_church_id()
  );

-- 2. Update RLS policies for `profiles` table
DROP POLICY IF EXISTS "Pastors can manage servants in their church" ON public.profiles;
CREATE POLICY "Admins can manage servants in their church"
  ON public.profiles FOR ALL
  USING (
    (public.get_my_role() = 'admin' OR public.get_my_role() = 'super_admin') AND
    (
      public.get_my_role() = 'super_admin' OR 
      church_id = public.get_my_church_id()
    ) AND
    role = 'servant'
  )
  WITH CHECK (
    (public.get_my_role() = 'admin' OR public.get_my_role() = 'super_admin') AND
    (
      public.get_my_role() = 'super_admin' OR 
      church_id = public.get_my_church_id()
    ) AND
    role = 'servant'
  );

DROP POLICY IF EXISTS "Church staff can manage servants in their church" ON public.profiles;
CREATE POLICY "Church staff can manage servants in their church"
  ON public.profiles FOR ALL
  USING (
    (public.get_my_role() = 'admin' OR public.get_my_role() = 'servant') AND
    church_id = public.get_my_church_id() AND
    role = 'servant'
  );

-- 3. Update RLS policies for `departments` table
DROP POLICY IF EXISTS "Church staff can manage departments in their church" ON public.departments;
CREATE POLICY "Church staff can manage departments in their church"
  ON public.departments FOR ALL
  USING (
    (public.get_my_role() = 'admin' OR public.get_my_role() = 'servant') AND
    church_id = public.get_my_church_id()
  );

DROP POLICY IF EXISTS "Pastors can manage departments in their church" ON public.departments;
CREATE POLICY "Admins can manage departments in their church"
  ON public.departments FOR ALL
  USING (
    public.get_my_role() = 'admin' AND
    church_id = public.get_my_church_id()
  );

-- 4. Update RLS policies for `profile_departments` table
DROP POLICY IF EXISTS "Pastors can manage profile_departments in their church" ON public.profile_departments;
CREATE POLICY "Admins can manage profile_departments in their church"
  ON public.profile_departments FOR ALL
  USING (
    public.get_my_role() = 'admin' AND 
    EXISTS (
      SELECT 1 FROM public.departments d 
      WHERE d.id = profile_departments.department_id 
      AND d.church_id = public.get_my_church_id()
    )
  );

-- 5. Update RLS policies for `activity_logs` table
DROP POLICY IF EXISTS "Activity logs viewable by appropriate staff" ON public.activity_logs;
CREATE POLICY "Activity logs viewable by appropriate staff"
  ON public.activity_logs FOR SELECT
  USING (
    public.get_my_role() = 'super_admin' OR
    public.get_my_role() = 'admin' OR
    (public.get_my_role() = 'servant' AND user_id = auth.uid())
  );

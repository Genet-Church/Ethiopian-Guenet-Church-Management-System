-- 1. Create a new enum type with the desired values
CREATE TYPE user_role_new AS ENUM ('super_admin', 'admin', 'servant');

-- 2. Update existing 'pastor' roles to 'admin' (casting to text to avoid type errors temporarily)
UPDATE public.profiles
SET role = 'admin'::text::user_role
WHERE role = 'pastor';

-- 3. Remove default value and alter the 'role' column in public.profiles to use the new enum type
ALTER TABLE public.profiles ALTER COLUMN role DROP DEFAULT;

ALTER TABLE public.profiles
  ALTER COLUMN role TYPE user_role_new
  USING (
    CASE 
      WHEN role::text = 'pastor' THEN 'admin'::user_role_new
      ELSE role::text::user_role_new
    END
  );

-- 4. Re-apply the default value with the new type
ALTER TABLE public.profiles
  ALTER COLUMN role SET DEFAULT 'servant'::user_role_new;

-- 5. Drop the old enum type
DROP TYPE user_role;

-- 6. Rename the new enum type to the original name
ALTER TYPE user_role_new RENAME TO user_role;

-- 7. (Optional but recommended) Update any view or function dependencies if they were broken,
-- For example, we recreate the get_my_role function to be safe:
CREATE OR REPLACE FUNCTION public.get_my_role()
RETURNS user_role AS $$
  SELECT role FROM public.profiles WHERE id = auth.uid() LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER;

-- ============================================================================
-- Patch: ensure new auth.users inserts create a profiles row with
-- must_change_password = true by default (unless explicitly provided in metadata).
-- This fixes deployments where handle_new_user previously set must_change_password=false.
-- ============================================================================

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_role public.app_role;
  v_must_change boolean;
  v_full_name text;
BEGIN
  v_full_name := COALESCE(NEW.raw_user_meta_data->>'full_name', NULL);

  BEGIN
    v_role := COALESCE((NEW.raw_user_meta_data->>'role')::public.app_role, 'STAFF'::public.app_role);
  EXCEPTION WHEN others THEN
    v_role := 'STAFF'::public.app_role;
  END;

  BEGIN
    v_must_change := COALESCE((NEW.raw_user_meta_data->>'must_change_password')::boolean, true);
  EXCEPTION WHEN others THEN
    v_must_change := true;
  END;

  INSERT INTO public.profiles (id, role, must_change_password, status, created_at, email, full_name)
  VALUES (NEW.id, v_role, v_must_change, 'active', now(), NEW.email, v_full_name)
  ON CONFLICT (id) DO UPDATE
    SET role = EXCLUDED.role,
        email = COALESCE(EXCLUDED.email, public.profiles.email),
        full_name = COALESCE(EXCLUDED.full_name, public.profiles.full_name),
        must_change_password = COALESCE(public.profiles.must_change_password, EXCLUDED.must_change_password);

  RETURN NEW;
END;
$$;

-- Recreate trigger to ensure it points at the latest function definition.
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

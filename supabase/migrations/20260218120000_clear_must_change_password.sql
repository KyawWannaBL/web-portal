-- ============================================================================
-- Allow authenticated users to clear their own must_change_password flag safely
-- (works even if RLS is enabled on public.profiles).
-- ============================================================================

CREATE OR REPLACE FUNCTION public.clear_must_change_password()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.profiles
  SET must_change_password = false
  WHERE id = auth.uid();
END;
$$;

GRANT EXECUTE ON FUNCTION public.clear_must_change_password() TO authenticated;

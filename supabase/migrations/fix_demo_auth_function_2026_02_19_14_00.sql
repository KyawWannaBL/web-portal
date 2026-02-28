-- Fix the authentication function with proper column references
CREATE OR REPLACE FUNCTION authenticate_demo_user_2026_02_19_14_00(
  p_email TEXT,
  p_password TEXT
)
RETURNS TABLE(
  success BOOLEAN,
  user_id UUID,
  email TEXT,
  role TEXT,
  full_name TEXT,
  message TEXT
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_user_id UUID;
  v_email TEXT;
  v_role TEXT;
  v_full_name TEXT;
BEGIN
  -- Check if user exists and password matches
  SELECT 
    dlc.id,
    dlc.email,
    dlc.role,
    dlc.full_name
  INTO v_user_id, v_email, v_role, v_full_name
  FROM demo_login_credentials_2026_02_19_14_00 dlc
  WHERE dlc.email = p_email 
    AND dlc.password_hash = p_password 
    AND dlc.is_active = true;

  -- If no match found
  IF NOT FOUND THEN
    RETURN QUERY SELECT false, NULL::UUID, NULL::TEXT, NULL::TEXT, NULL::TEXT, 'Invalid email or password'::TEXT;
  ELSE
    -- Update last login
    UPDATE demo_login_credentials_2026_02_19_14_00 
    SET last_login = NOW(), login_attempts = 0
    WHERE demo_login_credentials_2026_02_19_14_00.email = p_email;
    
    -- Return success
    RETURN QUERY SELECT true, v_user_id, v_email, v_role, v_full_name, 'Login successful'::TEXT;
  END IF;
END;
$$;

-- Test the fixed function
SELECT * FROM authenticate_demo_user_2026_02_19_14_00('admin@britiumexpress.com', 'demo123');
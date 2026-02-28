-- Create a debug function to see what's happening
CREATE OR REPLACE FUNCTION public.debug_auth_2026_02_17_18_40(user_email text, user_password text)
RETURNS json AS $$
DECLARE
    user_record public.auth_users_2026_02_17_18_40%ROWTYPE;
    branch_info public.branches_2026_02_17_18_40%ROWTYPE;
    result json;
BEGIN
    -- Step 1: Check if user exists
    SELECT * INTO user_record
    FROM public.auth_users_2026_02_17_18_40
    WHERE email = user_email;
    
    IF NOT FOUND THEN
        RETURN json_build_object('step', 'user_lookup', 'found', false, 'email', user_email);
    END IF;
    
    -- Step 2: Check if user is active
    IF NOT user_record.is_active THEN
        RETURN json_build_object('step', 'active_check', 'is_active', false, 'email', user_email);
    END IF;
    
    -- Step 3: Check password
    IF user_record.password_hash != user_password THEN
        RETURN json_build_object(
            'step', 'password_check', 
            'match', false, 
            'provided', user_password,
            'stored', user_record.password_hash
        );
    END IF;
    
    -- Step 4: Get branch info
    SELECT * INTO branch_info
    FROM public.branches_2026_02_17_18_40
    WHERE id = user_record.branch_id;
    
    -- Step 5: Return success
    RETURN json_build_object(
        'step', 'success',
        'user_id', user_record.id,
        'email', user_record.email,
        'role', user_record.role,
        'branch_name', COALESCE(branch_info.name, 'No Branch'),
        'must_change_password', user_record.must_change_password
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Test the debug function
SELECT public.debug_auth_2026_02_17_18_40('admin@logistics.com', 'admin123') as debug_result;
CREATE OR REPLACE PROCEDURE PURCHASE_MEMBERSHIP_SP(
    p_membership_id INTEGER,
    p_pass_type VARCHAR,
    p_pass_total NUMERIC,
    p_start_time DATE,
    p_end_time DATE,
    p_account_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    -- Declare a variable for when exceptions arise to enable rollback
    should_rollback BOOLEAN DEFAULT FALSE;
BEGIN
    -- Checking for mandatory variables
    IF p_pass_type IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter pass_type in PURCHASE_MEMBERSHIP_SP. No membership added.';
    ELSIF p_pass_total IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter pass_total in PURCHASE_MEMBERSHIP_SP. No membership added.';
    ELSIF p_start_time IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter start_time in PURCHASE_MEMBERSHIP_SP. No membership added.';
    ELSIF p_end_time IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter end_time in PURCHASE_MEMBERSHIP_SP. No membership added.';
    ELSIF p_account_id IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter account_id in PURCHASE_MEMBERSHIP_SP. No membership added.';
    END IF;

    -- Validating the pass type 
    IF NOT EXISTS (SELECT 1 FROM BC_PASS WHERE pass_type = p_pass_type) THEN
        RAISE EXCEPTION 'Invalid membership pass type (%).', p_pass_type;
    END IF;

    -- Validateing the account_id
    IF NOT EXISTS (SELECT 1 FROM BC_ACCOUNT WHERE account_id = p_account_id) THEN
        RAISE EXCEPTION 'Invalid account (%).', p_account_id;
    END IF;

    -- Use a Begin to start the code block and Exception block for handling transactions
    BEGIN
        -- Insert a new membership and return the new membership_id
        INSERT INTO BC_MEMBERSHIP(pass_type, pass_total, start_time, end_time, account_id)
        VALUES (p_pass_type, p_pass_total, p_start_time, p_end_time, p_account_id)
        RETURNING membership_id INTO p_membership_id;

        -- Set the flag to commit the transaction
        should_rollback := FALSE;
    EXCEPTION
        WHEN OTHERS THEN
            -- An exception occurred, rollback the transaction
            should_rollback := TRUE;
            -- Re-raise the exception
            RAISE;
    END;

    -- Commit the transaction if no exception occurred
    IF NOT should_rollback THEN
        COMMIT;
    END IF;
END;
$$;

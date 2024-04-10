DROP PROCEDURE IF EXISTS CREATE_ACCOUNT_SP;


-- Table structure for account information

CREATE TABLE IF NOT EXISTS BC_ACCOUNT (
	account_id SERIAL PRIMARY KEY, 
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	email VARCHAR UNIQUE NOT NULL, 
	password VARCHAR NOT NULL, 
	mobile_phone VARCHAR NOT NULL,
	street VARCHAR NOT NULL,
	apartment VARCHAR,
	city VARCHAR NOT NULL,
	state_province VARCHAR NOT NULL, 
	postal_code VARCHAR NOT NULL
);

-- Procedure to create a new account

CREATE OR REPLACE PROCEDURE CREATE_ACCOUNT_SP (
	OUT p_account_id INTEGER,
	p_account_first_name VARCHAR,
	p_account_last_name VARCHAR,
	p_account_email VARCHAR, 
	p_account_password VARCHAR, 
	p_account_mobile_phone VARCHAR,
	p_account_street VARCHAR,
	p_account_apartment VARCHAR,
	p_account_city VARCHAR,
	p_account_state_province VARCHAR, 
	p_account_postal_code VARCHAR
)

AS $$
BEGIN

-- Checking for missing mandatory parameters

IF 	p_account_first_name IS NULL THEN
		RAISE EXCEPTION 'Missing mandatory value for parameter p_account_first_name in CREATE_ACCOUNT_SP. No account added.';
		RETURN;
END IF;

IF 	p_account_last_name IS NULL THEN
		RAISE EXCEPTION 'Missing mandatory value for parameter p_account_last_name in CREATE_ACCOUNT_SP. No account added.';
		RETURN;
END IF;

IF p_account_email IS NULL THEN
		RAISE EXCEPTION 'Missing mandatory value for parameter p_account_email in CREATE_ACCOUNT_SP. No account added.';
		RETURN;
END IF;

-- Check for duplicate email
IF EXISTS (SELECT 1 FROM BC_ACCOUNT WHERE account_email = p_account_email) THEN
		RAISE EXCEPTION 'Duplicate email address. Account email addresses must be unique.';
		RETURN;
END IF;

IF 	p_account_password IS NULL THEN
		RAISE EXCEPTION 'Missing mandatory value for parameter p_account_password in CREATE_ACCOUNT_SP. No account added.';
		RETURN;
END IF;

IF 	p_account_mobile_phone IS NULL THEN
		RAISE EXCEPTION 'Missing mandatory value for parameter p_account_mobile_phone in CREATE_ACCOUNT_SP. No account added.';
		RETURN;
END IF;

IF 	p_account_street IS NULL THEN
		RAISE EXCEPTION 'Missing mandatory value for parameter p_account_street in CREATE_ACCOUNT_SP. No account added.';
		RETURN;
END IF;

IF 	p_account_city IS NULL THEN
		RAISE EXCEPTION 'Missing mandatory value for parameter p_account_city in CREATE_ACCOUNT_SP. No account added.';
		RETURN;
END IF;

IF 	p_account_state_province IS NULL THEN
		RAISE EXCEPTION 'Missing mandatory value for parameter p_account_state_province in CREATE_ACCOUNT_SP. No account added.';
		RETURN;
END IF;

IF 	p_account_postal_code IS NULL THEN
		RAISE EXCEPTION 'Missing mandatory value for parameter p_account_postal_code in CREATE_ACCOUNT_SP. No account added.';
		RETURN;
END IF;


-- Insert new account into BC_ACCOUNT
INSERT INTO BC_ACCOUNT (
    first_name,
    last_name,
    email,
    password,
    mobile_phone,
    street,
    apartment,
    city,
    state_province,
    postal_code
)

VALUES (
    p_account_first_name,
    p_account_last_name,
    p_account_email,
    p_account_password,
    p_account_mobile_phone,
    p_account_street,
    p_account_apartment,
    p_account_city,
    p_account_state_province,
    p_account_postal_code
)
RETURNING account_id INTO p_account_id;

 -- Commiting the transaction if all operations were sucessful
    COMMIT;

-- Catch and rollback any exceptions to ensure errors are not hidden

	EXCEPTION
        WHEN OTHERS THEN
		-- Rollback the transaction in case of an execption
	    ROLLBACK;
		-- Raise the exception again so that it can be handled outside this code
            RAISE;

END;
$$ LANGUAGE plpgsql;
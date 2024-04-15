-- CREATE_BICYCLE_SP

DROP PROCEDURE IF EXISTS CREATE_BICYCLE_SP;

-- Creating the BC_BICYCLE table

CREATE TABLE IF NOT EXISTS BC_BICYCLE (
	bicycle_id SERIAL PRIMARY KEY,
	bicycle_type VARCHAR NOT NULL,
	capacity INTEGER,
	make VARCHAR,
	model VARCHAR,
	color VARCHAR,
	year_acquired INTEGER,
	status VARCHAR NOT NULL,
	latitude INTEGER,
	longitude INTEGER,
	current_power NUMERIC,
	current_range NUMERIC,
	updated DATE
);

-- Adding a new bicycle with CREATE_BICYCLE_SP, to the BC_BICYCLE table

CREATE OR REPLACE PROCEDURE CREATE_BICYCLE_SP (
    OUT p_bicycle_id INTEGER,
    p_bicycle_type VARCHAR,
	p_capacity INTEGER,
    p_make VARCHAR,
    p_model VARCHAR,
    p_color VARCHAR,
    p_year_acquired INTEGER,
    p_status VARCHAR,
    p_latitude INTEGER,
    p_longitude INTEGER,
    p_current_power NUMERIC,
    p_current_range NUMERIC,
    p_updated DATE
)
AS $$
BEGIN
   
	 -- Check for invalid p_bicycle_type
    IF p_bicycle_type IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter (%). in CREATE_BICYCLE_SP. No bicycle added.', p_bicycle_type;
    END IF;
	
    -- Check for invalid bicycle type
    IF p_bicycle_type NOT IN ('electric', 'classic', 'cargo', 'smart') THEN
        RAISE EXCEPTION 'Invalid bicycle type (%). No new bicycle inserted into the BC_BICYCLE table.', p_bicycle_type;
    END IF;

    -- Check for invalid bicycle status
    IF p_status NOT IN ('available', 'in use', 'not available') THEN
        RAISE EXCEPTION 'Invalid bicycle status (%). No new bicycle inserted into the BC_BICYCLE table.', p_status;
    END IF;

    -- Check for invalid bicycle current power value
    IF p_current_power < 0 OR p_current_power > 100 THEN
        RAISE EXCEPTION 'Invalid bicycle current power value (%). No new bicycle inserted into the BC_BICYCLE table.', p_current_power;
    END IF;
	
	 -- Check for invalid bicycle current power value
    IF p_current_range < 0 THEN
        RAISE EXCEPTION 'Invalid bicycle current range value (%), must not be a negative number. No new bicycle inserted into the BC_BICYCLE table.', p_current_range;
    END IF;

    -- Check for invalid latitude
    IF p_latitude < -90 OR p_latitude > 90 THEN
        RAISE EXCEPTION 'Invalid Latitude (%). No new bicycle inserted into the BC_BICYCLE table.', p_latitude;
    END IF;

    -- Check for invalid longitude
    IF p_longitude < -180 OR p_longitude > 180 THEN
        RAISE EXCEPTION 'Invalid longitude (%). No new bicycle inserted into the BC_BICYCLE table.', p_longitude;
    END IF;

    -- Check for invalid bicycle rider capacity
    IF p_capacity <= 0 THEN
        RAISE EXCEPTION 'Invalid bicycle rider capacity (%). No new bicycle created.', p_capacity;
    END IF;

    -- If all checks pass, insert the bicycle into the table
    INSERT INTO BC_BICYCLE (
        bicycle_type,
		capacity,
		make,
		model,
		color,
		year_acquired,
		status,
		latitude,
		longitude,
		current_power,
		current_range,
		updated 
    ) VALUES (
        p_bicycle_type,
		p_capacity,
		p_make,
		p_model,
		p_color,
		p_year_acquired,
		p_status,
		p_latitude,
		p_longitude,
		p_current_power,
		p_current_range,
		p_updated 
    );
	
	 -- If all above were successful, the table is commited
COMMIT;

 -- Catch and re-throw any exceptions. Making sure errors are not hidden and can be dealt with outside this code.
EXCEPTION
    WHEN OTHERS THEN
    	ROLLBACK;
        RAISE;

END;
$$ LANGUAGE plpgsql;

-- Test Case 6: Invalid bicycle current range value
BEGIN;
DO $$
BEGIN
    CALL CREATE_BICYCLE_SP(NULL, 'electric', 1, 'Brand X', 'Model A', 'Red', 2023, 'available', 10, 20, 50, -100, CURRENT_DATE);
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Test Case 6: %', SQLERRM;
END;
$$;
ROLLBACK;

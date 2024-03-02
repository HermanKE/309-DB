-- CREATE_STATION_SP

DROP PROCEDURE IF EXISTS CREATE_STATION_SP;


-- Creating the BC_STATION table

CREATE TABLE IF NOT EXISTS BC_STATION (
	station_id SERIAL PRIMARY KEY, 
    station_name VARCHAR NOT NULL,
    station_short_name VARCHAR,
    latitude NUMERIC NOT NULL,
    longitude NUMERIC NOT NULL,
    address VARCHAR,
    postal_code VARCHAR,
    contact_phone VARCHAR,
    capacity INTEGER NOT NULL,
    vehicles_available INTEGER NOT NULL,
    docks_available INTEGER NOT NULL,
    is_renting NUMERIC NOT NULL,
    is_returning NUMERIC NOT NULL,
    last_report DATE NOT NULL,
    program_id VARCHAR NOT NULL
);

-- Adding a new station with CREATE_STATION_SP, to the BC_STATION table

CREATE OR REPLACE PROCEDURE CREATE_STATION_SP (
    p_station_name VARCHAR, 
    p_station_short_name VARCHAR,
    p_latitude NUMERIC, 
    p_longitude NUMERIC,
    p_address VARCHAR,
    p_postal_code VARCHAR,
    p_contact_phone VARCHAR,
    p_capacity INTEGER, 
    p_vehicles_available INTEGER, 
    p_docks_available INTEGER, 
    p_is_renting NUMERIC, 
    p_is_returning NUMERIC,
    p_last_report DATE, 
    p_program_id VARCHAR
)

AS $$
BEGIN
 -- Check for invalid station_name
IF	p_station_name IS NULL THEN
		RAISE EXCEPTION 'Missing mandatory value for parameter p_station_name in CREATE_STATION_SP. No account added.';
		RETURN;
END IF;

 -- Check for invalid latitude
IF	p_latitude IS NULL THEN
		RAISE EXCEPTION 'Missing mandatory value for parameter p_latitude in CREATE_STATION_SP. No account added.';
		RETURN;
END IF;

 -- Check for invalid longitude
IF	p_longitude IS NULL THEN
		RAISE EXCEPTION 'Missing mandatory value for parameter p_longitude in CREATE_STATION_SP. No account added.';
		RETURN;
END IF;

 -- Check for invalid capacity
IF	p_capacity IS NULL THEN
		RAISE EXCEPTION 'Missing mandatory value for parameter p_capacity in CREATE_STATION_SP. No account added.';
		RETURN;
END IF;

 -- Check for invalid vehicles_available
IF	p_vehicles_available IS NULL THEN
		RAISE EXCEPTION 'Missing mandatory value for parameter p_vehicles_available in CREATE_STATION_SP. No account added.';
		RETURN;
END IF;

 -- Check for invalid docks_available
IF	p_docks_available IS NULL THEN
		RAISE EXCEPTION 'Missing mandatory value for parameter p_docks_available in CREATE_STATION_SP. No account added.';
		RETURN;
END IF;

 -- Check for invalid is_renting
IF	p_is_renting IS NULL THEN
		RAISE EXCEPTION 'Missing mandatory value for parameter p_is_renting in CREATE_STATION_SP. No account added.';
		RETURN;
END IF;

 -- Check for invalid is_returning
IF	p_is_returning IS NULL THEN
		RAISE EXCEPTION 'Missing mandatory value for parameter p_is_returning in CREATE_STATION_SP. No account added.';
		RETURN;
END IF;

 -- Check for invalid last_report
IF	p_last_report IS NULL THEN
		RAISE EXCEPTION 'Missing mandatory value for parameter p_last_report in CREATE_STATION_SP. No account added.';
		RETURN;
END IF;

 -- Check for invalid program_id
IF	p_program_id IS NULL THEN
		RAISE EXCEPTION 'Missing mandatory value for parameter p_program_id in CREATE_STATION_SP. No account added.';
		RETURN;
END IF;

 -- If all checks are passed, insert the station into the table
INSERT INTO BC_STATION (
    station_name,
    station_short_name,
    latitude,
    longitude,
    address,
    postal_code,
    contact_phone,
    capacity,
    vehicles_available,
    docks_available,
    is_renting,
    is_returning,
    last_report,
    program_id
) VALUES (
    p_station_name, 
    p_station_short_name,
    p_latitude, 
    p_longitude,
    p_address,
    p_postal_code,
    p_contact_phone,
    p_capacity, 
    p_vehicles_available, 
    p_docks_available, 
    p_is_renting, 
    p_is_returning,
    p_last_report, 
    p_program_id
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




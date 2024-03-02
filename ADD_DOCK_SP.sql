-- PROCEDURE: public.ADD_DOCK_SP()

-- DROP PROCEDURE IF EXISTS public."ADD_DOCK_SP"();

-- Since Postgres automatically makes everything lowercase letters we have to use "Word" to maintain Upercase letters. (The assignment called it ADD_DOCK_SP in all upercase letters so im doing the same)
CREATE OR REPLACE PROCEDURE public."ADD_DOCK_SP"(
	)
-- PGadmin that made the ownership and language, might be a result of me creating the database on a docker container, with a different username, then had to add postgres as a user and give it superuser to make the .tar file work
LANGUAGE 'sql'
AS $BODY$
CREATE OR REPLACE PROCEDURE ADD_DOCK_SP(
    p_station_id VARCHAR,
    p_dock_id INTEGER,
    p_dock_status VARCHAR,
    p_bicycle_id INTEGER DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
	BEGIN;
    -- Check for mandatory values
    IF p_station_id IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter station_id in ADD_DOCK_SP. No dock added.';
    ELSIF p_dock_id IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter dock_id in ADD_DOCK_SP. No dock added.';
    ELSIF p_dock_status IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter dock_status in ADD_DOCK_SP. No dock added.';
    END IF;

    -- Checks if there is no record in the BC_STATION table where station_id matches the given p_station_id.
    -- (%) = p_station_id
    IF NOT EXISTS (SELECT 1 FROM BC_STATION WHERE station_id = p_station_id) THEN
        RAISE EXCEPTION 'Invalid station identifier (%).', p_station_id;
    END IF;

    -- Checks if there is no record in the BC_BICYCLE table where bicycle_id matches the given p_bicycle_id. Since its the only one that is allowed to be Null, it will not raise an exception if Null or if there is a matching entry id to id in bicycle table.
    -- (%) = p_bicycle_id
    IF p_bicycle_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM BC_BICYCLE WHERE bicycle_id = p_bicycle_id) THEN
        RAISE EXCEPTION 'Invalid bicycle identifier (%).', p_bicycle_id;
    END IF;

    -- Validate dock number
    -- (%) = p_dock_id
    IF p_dock_id < 1 THEN
        RAISE EXCEPTION 'Invalid dock number (%).', p_dock_id;
    END IF;

    -- Validate dock status with the three valid options
    -- (%) = p_dock_status
    IF p_dock_status NOT IN ('occupied', 'out of service', 'unoccupied') THEN
        RAISE EXCEPTION 'Invalid dock status (%).', p_dock_status;
    END IF;

    -- Check if dock number already exists for station
    -- (%) = p_dock_id
    IF EXISTS (SELECT 1 FROM BC_DOCK WHERE dock_id = p_dock_id AND station_id = p_station_id) THEN
        RAISE EXCEPTION 'Dock number (%) already exists.', p_dock_id;
    END IF;

    -- Insert new dock
    -- only if the procedure has not been interupted by an exception
    INSERT INTO BC_DOCK(station_id, dock_id, dock_status, bicycle_id)
    VALUES (p_station_id, p_dock_id, p_dock_status, p_bicycle_id);

    -- If all operations were successful, commit the transaction
    COMMIT;

    -- Catch and re-throw any exceptions. This makes sure errors are not hidden and can be dealt with outside this code.
    EXCEPTION
        WHEN OTHERS THEN
	    ROLLBACK;
            RAISE;
END;
$$;
$BODY$;
ALTER PROCEDURE public."ADD_DOCK_SP"()
    OWNER TO postgres;

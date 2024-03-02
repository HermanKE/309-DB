-- PROCEDURE: public.ADD_DOCK_SP()

-- DROP PROCEDURE IF EXISTS public."ADD_DOCK_SP"();

CREATE OR REPLACE PROCEDURE public."ADD_DOCK_SP"(
	)
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
    -- Check for mandatory values
    IF p_station_id IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter station_id in ADD_DOCK_SP. No dock added.';
    ELSIF p_dock_id IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter dock_id in ADD_DOCK_SP. No dock added.';
    ELSIF p_dock_status IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter dock_status in ADD_DOCK_SP. No dock added.';
    END IF;

    -- Validate station_id exists
    IF NOT EXISTS (SELECT 1 FROM BC_STATION WHERE station_id = p_station_id) THEN
        RAISE EXCEPTION 'Invalid station identifier (%).', p_station_id;
    END IF;

    -- Validate bicycle_id exists if provided
    IF p_bicycle_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM BC_BICYCLE WHERE bicycle_id = p_bicycle_id) THEN
        RAISE EXCEPTION 'Invalid bicycle identifier (%).', p_bicycle_id;
    END IF;

    -- Validate dock number
    IF p_dock_id < 1 THEN
        RAISE EXCEPTION 'Invalid dock number (%).', p_dock_id;
    END IF;

    -- Validate dock status
    IF p_dock_status NOT IN ('occupied', 'out of service', 'unoccupied') THEN
        RAISE EXCEPTION 'Invalid dock status (%).', p_dock_status;
    END IF;

    -- Check if dock number already exists for station
    IF EXISTS (SELECT 1 FROM BC_DOCK WHERE dock_id = p_dock_id AND station_id = p_station_id) THEN
        RAISE EXCEPTION 'Dock number (%) already exists.', p_dock_id;
    END IF;

    -- Insert new dock
    INSERT INTO BC_DOCK(station_id, dock_id, dock_status, bicycle_id)
    VALUES (p_station_id, p_dock_id, p_dock_status, p_bicycle_id);

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
END;
$$;
$BODY$;
ALTER PROCEDURE public."ADD_DOCK_SP"()
    OWNER TO postgres;

-- PROCEDURE: public.CREATE_BICYCLE_SP()

-- DROP PROCEDURE IF EXISTS public."CREATE_BICYCLE_SP"();

CREATE OR REPLACE PROCEDURE public."CREATE_BICYCLE_SP"(
	)
LANGUAGE 'sql'
AS $BODY$
CREATE OR REPLACE PROCEDURE CREATE_BICYCLE_SP(
    bicycle_id integer,
    bicycle_type character varying(20),
    bicycle_rider_capacity integer,
    bicycle_make character varying(25),
    bicycle_model character varying(25),
    bicycle_color character varying(25),
    bicycle_year_acquired integer,
    bicycle_status character varying(15),
    bicycle_latitude numeric(8,6),
    bicycle_longitude numeric(9,6),
    bicycle_current_power numeric(4,1),
    bicycle_current_range numeric(7,1),
    bicycle_status_updated date
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Checks for values i have estimated as "madatory"
    IF bicycle_id IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter bicycle_id in CREATE_BICYCLE_SP. No bicycle added.';
    ELSIF bicycle_type IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter bicycle_type in CREATE_BICYCLE_SP. No bicycle added.';
    ELSIF bicycle_rider_capacity IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter bicycle_rider_capacity in CREATE_BICYCLE_SP. No bicycle added.';
    ELSIF bicycle_make IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter bicycle_make in CREATE_BICYCLE_SP. No bicycle added.';
    ELSIF bicycle_model IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter bicycle_model in CREATE_BICYCLE_SP. No bicycle added.';
    ELSIF bicycle_color IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter bicycle_color in CREATE_BICYCLE_SP. No bicycle added.';
    ELSIF bicycle_year_acquired IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter bicycle_year_acquired in CREATE_BICYCLE_SP. No bicycle added.';
    ELSIF bicycle_status IS NULL THEN
        RAISE EXCEPTION 'Missing mandatory value for parameter bicycle_status in CREATE_BICYCLE_SP. No bicycle added.';
    END IF;

    -- Check for invalid bicycle type
    IF bicycle_type NOT IN ('electric', 'classic', 'cargo', 'smart') THEN
        RAISE EXCEPTION 'Invalid bicycle type (%). No new bicycle inserted into the BC_BICYCLE table.', bicycle_type;
    END IF;

    -- Check for invalid bicycle status
    IF bicycle_status NOT IN ('available', 'in use', 'not available') THEN
        RAISE EXCEPTION 'Invalid bicycle status (%). No new bicycle inserted into the BC_BICYCLE table.', bicycle_status;
    END IF;

    -- Check for invalid bicycle current power value
    IF bicycle_current_power < 0 OR bicycle_current_power > 100 THEN
        RAISE EXCEPTION 'Invalid bicycle current power value (%). No new bicycle inserted into the BC_BICYCLE table.', bicycle_current_power;
    END IF;

    -- Check for invalid latitude
    IF bicycle_latitude < -90 OR bicycle_latitude > 90 THEN
        RAISE EXCEPTION 'Invalid Latitude (%). No new bicycle inserted into the BC_BICYCLE table.', bicycle_latitude;
    END IF;

    -- Check for invalid longitude
    IF bicycle_longitude < -180 OR bicycle_longitude > 180 THEN
        RAISE EXCEPTION 'Invalid longitude (%). No new bicycle inserted into the BC_BICYCLE table.', bicycle_longitude;
    END IF;

    -- Check for invalid bicycle rider capacity
    IF bicycle_rider_capacity <= 0 THEN
        RAISE EXCEPTION 'Invalid bicycle rider capacity (%). No new bicycle created.', bicycle_rider_capacity;
    END IF;

    -- If all checks pass, insert the bicycle into the table
    INSERT INTO public.bc_bicycle (
        bicycle_id,
        bicycle_type,
        bicycle_rider_capacity,
        bicycle_make,
        bicycle_model,
        bicycle_color,
        bicycle_year_acquired,
        bicycle_status,
        bicycle_latitude,
        bicycle_longitude,
        bicycle_current_power,
        bicycle_current_range,
        bicycle_status_updated
    ) VALUES (
        bicycle_id,
        bicycle_type,
        bicycle_rider_capacity,
        bicycle_make,
        bicycle_model,
        bicycle_color,
        bicycle_year_acquired,
        bicycle_status,
        bicycle_latitude,
        bicycle_longitude,
        bicycle_current_power,
        bicycle_current_range,
        bicycle_status_updated
    );
END $$;
$BODY$;
ALTER PROCEDURE public."CREATE_BICYCLE_SP"()
    OWNER TO postgres;

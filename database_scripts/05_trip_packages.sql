ALTER SESSION SET CURRENT_SCHEMA = TA_APP;
SET DEFINE OFF;

BEGIN
    DELETE FROM trip_package_transport_modes;
    DELETE FROM trip_package_attractions;
    DELETE FROM trip_package_hotels;
    DELETE FROM trip_packages;
    COMMIT;
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

INSERT INTO trip_packages (
    package_id,
    package_name,
    city_start,
    city_target,
    base_days,
    base_budget
)
SELECT 
    seq_trip_packages.NEXTVAL,
    src.city_start || ' → ' || src.city_target || ' Explorer',
    src.city_start,
    src.city_target,
    CEIL(src.distance_km / 250),
    ROUND(src.distance_km * 1.8 + CEIL(src.distance_km / 250) * 120)
FROM routes src;

COMMIT;

INSERT INTO trip_package_hotels (id, package_id, hotel_id)
SELECT 
    seq_trip_package_hotels.NEXTVAL,
    p.package_id,
    h.hotel_id
FROM trip_packages p
JOIN hotels h
    ON h.city = p.city_target;

COMMIT;

INSERT INTO trip_package_attractions (id, package_id, attraction_id)
SELECT
    seq_trip_package_attractions.NEXTVAL,
    p.package_id,
    a.attraction_id
FROM trip_packages p
JOIN attractions a
    ON a.city = p.city_target;

COMMIT;

INSERT INTO trip_package_transport_modes (id, package_id, transport_mode)
SELECT 
    seq_trip_package_transport_modes.NEXTVAL,
    p.package_id,
    'FLIGHT'
FROM trip_packages p
WHERE EXISTS (
    SELECT 1 FROM transport_flights f
    WHERE f.city_start = p.city_start
      AND f.city_target = p.city_target
);

COMMIT;

INSERT INTO trip_package_transport_modes (id, package_id, transport_mode)
SELECT
    seq_trip_package_transport_modes.NEXTVAL,
    p.package_id,
    'TRAIN'
FROM trip_packages p
WHERE EXISTS (
    SELECT 1 FROM transport_trains t
    WHERE t.city_start = p.city_start
      AND t.city_target = p.city_target
);

COMMIT;

INSERT INTO trip_package_transport_modes (id, package_id, transport_mode)
SELECT
    seq_trip_package_transport_modes.NEXTVAL,
    p.package_id,
    'COACH'
FROM trip_packages p
WHERE EXISTS (
    SELECT 1 FROM transport_coaches c
    WHERE c.city_start = p.city_start
      AND c.city_target = p.city_target
);

COMMIT;


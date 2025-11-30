WHENEVER SQLERROR EXIT SQL.SQLCODE
ALTER SESSION SET CURRENT_SCHEMA = TA_APP;
SET DEFINE OFF;
/

CREATE OR REPLACE VIEW vw_flight_options AS
SELECT
    'FLIGHT'               AS transport_mode,
    f.flight_id            AS transport_id,
    f.city_start,
    f.city_target,
    f.depart_time,
    f.seats_econ_free      AS col1,
    f.seats_bus_free       AS col2,
    f.seats_vip_free       AS col3,
    f.price_econ           AS col4,
    f.price_bus            AS col5,
    f.price_vip            AS col6,
    f.status               AS status,
    CAST(NULL AS VARCHAR2(50)) AS extra
FROM transport_flights f;
/

CREATE OR REPLACE VIEW vw_train_options AS
SELECT
    'TRAIN'                AS transport_mode,
    t.train_id             AS transport_id,
    t.city_start,
    t.city_target,
    t.depart_time,
    t.seats_standard_free  AS col1,
    t.seats_quiet_free     AS col2,
    t.seats_vip_free       AS col3,
    t.price_standard       AS col4,
    t.price_quiet          AS col5,
    t.price_vip            AS col6,
    t.status               AS status,
    CAST(NULL AS VARCHAR2(50)) AS extra
FROM transport_trains t;
/

CREATE OR REPLACE VIEW vw_coach_options AS
SELECT
    'COACH'                AS transport_mode,
    c.coach_id             AS transport_id,
    c.city_start,
    c.city_target,
    c.depart_time,
    c.seats_free           AS col1,
    CAST(NULL AS NUMBER)   AS col2,
    CAST(NULL AS NUMBER)   AS col3,
    c.price_standard       AS col4,
    CAST(NULL AS NUMBER)   AS col5,
    CAST(NULL AS NUMBER)   AS col6,
    c.status               AS status,
    CAST(NULL AS VARCHAR2(50)) AS extra
FROM transport_coaches c;
/

CREATE OR REPLACE VIEW vw_transport_options AS
SELECT * FROM vw_flight_options
UNION ALL
SELECT * FROM vw_train_options
UNION ALL
SELECT * FROM vw_coach_options;
/

CREATE OR REPLACE VIEW vw_available_packages AS
SELECT
    p.package_id,
    p.package_name,
    p.city_start,
    p.city_target,
    p.base_days,
    p.base_budget,
    COUNT(DISTINCT tph.hotel_id)      AS hotels_count,
    COUNT(DISTINCT tpa.attraction_id) AS attractions_count,
    COUNT(DISTINCT tpt.transport_mode) AS transport_modes_count
FROM trip_packages p
LEFT JOIN trip_package_hotels tph
    ON p.package_id = tph.package_id
LEFT JOIN trip_package_attractions tpa
    ON p.package_id = tpa.package_id
LEFT JOIN trip_package_transport_modes tpt
    ON p.package_id = tpt.package_id
GROUP BY
    p.package_id,
    p.package_name,
    p.city_start,
    p.city_target,
    p.base_days,
    p.base_budget;
/

CREATE OR REPLACE VIEW vw_package_details AS
SELECT
    p.package_id,
    p.package_name,
    p.city_start,
    p.city_target,
    h.hotel_name,
    a.attraction_name,
    a.category AS attraction_category,
    t.transport_mode
FROM trip_packages p
LEFT JOIN trip_package_hotels tph
    ON p.package_id = tph.package_id
LEFT JOIN hotels h
    ON tph.hotel_id = h.hotel_id
LEFT JOIN trip_package_attractions tpa
    ON p.package_id = tpa.package_id
LEFT JOIN attractions a
    ON tpa.attraction_id = a.attraction_id
LEFT JOIN trip_package_transport_modes t
    ON p.package_id = t.package_id;
/

CREATE OR REPLACE VIEW vw_reservation_list AS
SELECT
    r.reservation_id,
    c.first_name || ' ' || c.last_name AS client_name,
    r.city_start,
    r.city_target,
    r.date_from,
    r.date_to,
    r.status,
    r.budget_amount,
    r.summary_note,
    (SELECT COUNT(*) FROM participants p
     WHERE p.reservation_id = r.reservation_id) AS participants_count
FROM reservations r
JOIN clients c ON c.client_id = r.client_id;
/

CREATE OR REPLACE VIEW vw_reservation_details AS
SELECT
    r.reservation_id,
    r.client_id,
    c.first_name || ' ' || c.last_name AS client_name,
    r.city_start,
    r.city_target,
    r.date_from,
    r.date_to,
    r.trip_type,
    r.status,
    r.budget_amount,
    r.transport_pref,
    r.room_pref,
    r.summary_note
FROM reservations r
JOIN clients c ON c.client_id = r.client_id;
/

CREATE OR REPLACE VIEW vw_participants AS
SELECT
    p.participant_id,
    p.reservation_id,
    p.first_name,
    p.last_name,
    p.birth_date,
    p.age_years,
    p.participant_type,
    p.relation_to_client
FROM participants p;
/

CREATE OR REPLACE VIEW vw_hotel_room_availability AS
SELECT
    h.hotel_name,
    h.city,
    r.room_id,
    r.room_type,
    r.max_persons,
    r.has_child_bed,
    r.base_price_per_night,
    r.status
FROM hotels h
JOIN hotel_rooms r ON h.hotel_id = r.hotel_id;
/

CREATE OR REPLACE VIEW vw_full_trip_plan AS
SELECT
    r.reservation_id,
    r.city_start,
    r.city_target,
    r.date_from,
    r.date_to,
    ac.hotel_id,
    h.hotel_name,
    ac.room_id,
    ac.room_type,
    ac.total_price AS room_total,
    tr.transport_type,
    tr.assigned_class,
    tr.total_price AS transport_total,
    COUNT(td.participant_id) AS passengers
FROM reservations r
LEFT JOIN accommodation ac
    ON r.reservation_id = ac.reservation_id
LEFT JOIN hotels h
    ON ac.hotel_id = h.hotel_id
LEFT JOIN transport_reservations tr
    ON tr.reservation_id = r.reservation_id
LEFT JOIN transport_details td
    ON td.transport_res_id = tr.transport_res_id
GROUP BY
    r.reservation_id,
    r.city_start,
    r.city_target,
    r.date_from,
    r.date_to,
    ac.hotel_id,
    h.hotel_name,
    ac.room_id,
    ac.room_type,
    ac.total_price,
    tr.transport_type,
    tr.assigned_class,
    tr.total_price;
/

CREATE OR REPLACE VIEW vw_city_attractions AS
SELECT
    a.attraction_id,
    a.city,
    a.attraction_name,
    a.category,
    a.description,
    a.price_per_person,
    a.open_days,
    a.rating
FROM attractions a;
/

CREATE OR REPLACE VIEW vw_client_loyalty AS
SELECT
    c.client_id,
    c.first_name || ' ' || c.last_name AS client_name,
    travel_agency_intelligence.loyalty_level(c.client_id) AS loyalty_level,
    travel_agency_intelligence.proposed_discount(c.client_id) AS proposed_discount
FROM clients c;
/

CREATE OR REPLACE VIEW vw_reservation_summary AS
SELECT
    r.reservation_id,
    travel_agency_intelligence.trip_summary(r.reservation_id) AS summary_clob
FROM reservations r;
/

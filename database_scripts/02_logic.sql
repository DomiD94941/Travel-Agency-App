ALTER SESSION SET CURRENT_SCHEMA = TA_APP;
SET DEFINE OFF;


-- Support function to pick a random seat number

CREATE OR REPLACE FUNCTION pick_seat RETURN VARCHAR2 IS
BEGIN
    RETURN 'S' || TRUNC(DBMS_RANDOM.VALUE(1, 200));
END;
/


-- ##########################################################################
-- APEX helper constants: collection names used by the APEX application
-- ##########################################################################

CREATE OR REPLACE PACKAGE travel_agency_apex_constants AS
  gc_coll_tmp_participants CONSTANT VARCHAR2(30) := 'APEX_COLLECTIONS_TMP_PARTICIPANTS';
  gc_coll_selected_attr    CONSTANT VARCHAR2(30) := 'APEX_COLLECTIONS_SELECTED_ATTRACTIONS';
END travel_agency_apex_constants;
/

-- PACKAGE HEADER: travel_agency_operations

CREATE OR REPLACE PACKAGE travel_agency_operations AS

  PROCEDURE create_reservation(
      p_client_id       IN reservations.client_id%TYPE,
      p_trip_type       IN reservations.trip_type%TYPE,
      p_date_from       IN reservations.date_from%TYPE,
      p_date_to         IN reservations.date_to%TYPE,
      p_city_start      IN reservations.city_start%TYPE,
      p_city_target     IN reservations.city_target%TYPE,
      p_budget_amount   IN reservations.budget_amount%TYPE,
      p_budget_currency IN reservations.budget_currency%TYPE,
      p_transport_pref  IN reservations.transport_pref%TYPE,
      p_room_pref       IN reservations.room_pref%TYPE,
      p_reservation_id  OUT reservations.reservation_id%TYPE
  );

  PROCEDURE add_participant(
      p_reservation_id IN participants.reservation_id%TYPE,
      p_first_name     IN participants.first_name%TYPE,
      p_last_name      IN participants.last_name%TYPE,
      p_birth_date     IN participants.birth_date%TYPE,
      p_relation       IN participants.relation_to_client%TYPE
  );

  PROCEDURE set_transport_pref(
      p_reservation_id IN reservations.reservation_id%TYPE,
      p_preference     IN reservations.transport_pref%TYPE
  );

  PROCEDURE add_room_pref(
      p_reservation_id IN reservations.reservation_id%TYPE,
      p_preference     IN reservations.room_pref%TYPE
  );

  PROCEDURE assign_transport(
      p_reservation_id IN reservations.reservation_id%TYPE
  );

  PROCEDURE assign_rooms(
      p_reservation_id IN reservations.reservation_id%TYPE
  );

  PROCEDURE assign_guides(
      p_reservation_id IN reservations.reservation_id%TYPE
  );

  PROCEDURE generate_transfers(
      p_reservation_id IN reservations.reservation_id%TYPE
  );

  PROCEDURE finalize_plan(
      p_reservation_id IN reservations.reservation_id%TYPE
  );

  PROCEDURE confirm_reservation(
      p_reservation_id IN reservations.reservation_id%TYPE
  );

  PROCEDURE cancel_reservation(
      p_reservation_id IN reservations.reservation_id%TYPE
  );

END travel_agency_operations;
/

-- PACKAGE HEADER: travel_agency_intelligence

CREATE OR REPLACE PACKAGE BODY travel_agency_operations AS

  PROCEDURE create_reservation(
      p_client_id       IN reservations.client_id%TYPE,
      p_trip_type       IN reservations.trip_type%TYPE,
      p_date_from       IN reservations.date_from%TYPE,
      p_date_to         IN reservations.date_to%TYPE,
      p_city_start      IN reservations.city_start%TYPE,
      p_city_target     IN reservations.city_target%TYPE,
      p_budget_amount   IN reservations.budget_amount%TYPE,
      p_budget_currency IN reservations.budget_currency%TYPE,
      p_transport_pref  IN reservations.transport_pref%TYPE,
      p_room_pref       IN reservations.room_pref%TYPE,
      p_reservation_id  OUT reservations.reservation_id%TYPE
  ) IS
  BEGIN
    IF p_date_from >= p_date_to THEN
        RAISE_APPLICATION_ERROR(-20002,'date_from must be before date_to.');
    END IF;

    INSERT INTO reservations(
        reservation_id,
        client_id, trip_type, date_from, date_to,
        city_start, city_target,
        budget_amount, budget_currency,
        status, transport_pref, room_pref
    ) VALUES (
        seq_reservations.NEXTVAL,
        p_client_id, p_trip_type, p_date_from, p_date_to,
        p_city_start, p_city_target,
        p_budget_amount, p_budget_currency,
        'DRAFT', p_transport_pref, p_room_pref
    )
    RETURNING reservation_id INTO p_reservation_id;
  END create_reservation;


  PROCEDURE add_participant(
      p_reservation_id IN participants.reservation_id%TYPE,
      p_first_name     IN participants.first_name%TYPE,
      p_last_name      IN participants.last_name%TYPE,
      p_birth_date     IN participants.birth_date%TYPE,
      p_relation       IN participants.relation_to_client%TYPE
  ) IS
  BEGIN
    INSERT INTO participants(
        participant_id,
        reservation_id,
        first_name,
        last_name,
        birth_date,
        relation_to_client
    ) VALUES (
        seq_participants.NEXTVAL,
        p_reservation_id,
        p_first_name,
        p_last_name,
        p_birth_date,
        p_relation
    );
  END add_participant;


  PROCEDURE set_transport_pref(
      p_reservation_id IN reservations.reservation_id%TYPE,
      p_preference     IN reservations.transport_pref%TYPE
  ) IS
  BEGIN
    UPDATE reservations
    SET transport_pref = p_preference
    WHERE reservation_id = p_reservation_id;
  END set_transport_pref;


  PROCEDURE add_room_pref(
      p_reservation_id IN reservations.reservation_id%TYPE,
      p_preference     IN reservations.room_pref%TYPE
  ) IS
  BEGIN
    UPDATE reservations
    SET room_pref = p_preference
    WHERE reservation_id = p_reservation_id;
  END add_room_pref;


  PROCEDURE assign_transport(
      p_reservation_id IN reservations.reservation_id%TYPE
  ) IS
    v_city_start   reservations.city_start%TYPE;
    v_city_target  reservations.city_target%TYPE;
    v_date_from    reservations.date_from%TYPE;
    v_date_to      reservations.date_to%TYPE;
    v_pref         reservations.transport_pref%TYPE;
    v_mode         VARCHAR2(10);
  BEGIN
    SELECT city_start, city_target, date_from, date_to, NVL(transport_pref,'ANY')
    INTO v_city_start, v_city_target, v_date_from, v_date_to, v_pref
    FROM reservations
    WHERE reservation_id = p_reservation_id;

    v_mode := CASE
                WHEN v_pref = 'CAR' THEN 'COACH'
                WHEN v_pref = 'TRAIN' THEN 'TRAIN'
                WHEN v_pref = 'PLANE' THEN 'FLIGHT'
                ELSE 'FLIGHT'
              END;

    IF v_mode = 'FLIGHT' THEN
        INSERT INTO transport_reservations(
            transport_res_id,
            reservation_id,
            transport_type,
            flight_id,
            passengers_count,
            assigned_class,
            total_price
        )
        SELECT
            seq_transport_reservations.NEXTVAL,
            p_reservation_id,
            'FLIGHT',
            f.flight_id,
            1,
            'ECONOMY',
            f.price_econ
        FROM transport_flights f
        WHERE f.city_start = v_city_start
          AND f.city_target = v_city_target
          AND f.depart_time BETWEEN v_date_from AND v_date_to
          AND f.status = 'ACTIVE'
          AND ROWNUM = 1;

    ELSIF v_mode = 'TRAIN' THEN
        INSERT INTO transport_reservations(
            transport_res_id,
            reservation_id,
            transport_type,
            train_id,
            passengers_count,
            assigned_class,
            total_price
        )
        SELECT
            seq_transport_reservations.NEXTVAL,
            p_reservation_id,
            'TRAIN',
            t.train_id,
            1,
            'STANDARD',
            t.price_standard
        FROM transport_trains t
        WHERE t.city_start = v_city_start
          AND t.city_target = v_city_target
          AND t.depart_time BETWEEN v_date_from AND v_date_to
          AND t.status = 'ACTIVE'
          AND ROWNUM = 1;

    ELSE
        INSERT INTO transport_reservations(
            transport_res_id,
            reservation_id,
            transport_type,
            coach_id,
            passengers_count,
            assigned_class,
            total_price
        )
        SELECT
            seq_transport_reservations.NEXTVAL,
            p_reservation_id,
            'COACH',
            c.coach_id,
            1,
            'STANDARD',
            c.price_standard
        FROM transport_coaches c
        WHERE c.city_start = v_city_start
          AND c.city_target = v_city_target
          AND c.depart_time BETWEEN v_date_from AND v_date_to
          AND c.status = 'ACTIVE'
          AND ROWNUM = 1;
    END IF;
  END assign_transport;



  PROCEDURE assign_rooms(
      p_reservation_id IN reservations.reservation_id%TYPE
  ) IS
    v_city_target reservations.city_target%TYPE;
    v_date_from   reservations.date_from%TYPE;
    v_date_to     reservations.date_to%TYPE;
    v_hotel_id    hotels.hotel_id%TYPE;
    v_room_id     hotel_rooms.room_id%TYPE;
  BEGIN
    SELECT city_target, date_from, date_to
    INTO v_city_target, v_date_from, v_date_to
    FROM reservations
    WHERE reservation_id = p_reservation_id;

    SELECT h.hotel_id, r.room_id
    INTO v_hotel_id, v_room_id
    FROM hotels h
    JOIN hotel_rooms r ON r.hotel_id = h.hotel_id
    WHERE h.city = v_city_target
      AND r.status = 'AVAILABLE'
      AND ROWNUM = 1;

    INSERT INTO accommodation(
        accommodation_id,
        reservation_id,
        hotel_id,
        room_id,
        room_type,
        guests_count,
        total_price,
        check_in,
        check_out
    ) VALUES (
        seq_accommodation.NEXTVAL,
        p_reservation_id,
        v_hotel_id,
        v_room_id,
        (SELECT room_type FROM hotel_rooms WHERE room_id = v_room_id),
        1,
        0,
        v_date_from,
        v_date_to
    );

    UPDATE hotel_rooms
    SET status = 'RESERVED'
    WHERE room_id = v_room_id;
  END assign_rooms;



  PROCEDURE assign_guides(
      p_reservation_id IN reservations.reservation_id%TYPE
  ) IS
    v_city_target reservations.city_target%TYPE;
    v_guide_id    guides.guide_id%TYPE;
  BEGIN
    SELECT city_target
    INTO v_city_target
    FROM reservations
    WHERE reservation_id = p_reservation_id;

    SELECT guide_id
    INTO v_guide_id
    FROM guides
    WHERE city = v_city_target
      AND availability_status = 'AVAILABLE'
      AND ROWNUM = 1;

    INSERT INTO guide_assignments(
        assign_id,
        reservation_id,
        guide_id,
        trip_day
    ) VALUES (
        seq_guides_assign.NEXTVAL,
        p_reservation_id,
        v_guide_id,
        1
    );

    UPDATE guides
    SET availability_status = 'ASSIGNED'
    WHERE guide_id = v_guide_id;
  END assign_guides;



  PROCEDURE generate_transfers(
      p_reservation_id IN reservations.reservation_id%TYPE
  ) IS
    v_city_start  reservations.city_start%TYPE;
    v_city_target reservations.city_target%TYPE;
  BEGIN
    SELECT city_start, city_target
    INTO v_city_start, v_city_target
    FROM reservations
    WHERE reservation_id = p_reservation_id;

    INSERT INTO transfers(transfer_id, reservation_id, description)
    VALUES (seq_transfers.NEXTVAL, p_reservation_id,
            'Transfer from '||v_city_start||' to hotel in '||v_city_target);

    INSERT INTO transfers(transfer_id, reservation_id, description)
    VALUES (seq_transfers.NEXTVAL, p_reservation_id,
            'Transfer from hotel in '||v_city_target||' to departure point');
  END generate_transfers;



  PROCEDURE finalize_plan(p_reservation_id IN reservations.reservation_id%TYPE) IS
  BEGIN
    UPDATE reservations
    SET status = 'PLANNED'
    WHERE reservation_id = p_reservation_id;
  END finalize_plan;



  PROCEDURE confirm_reservation(p_reservation_id IN reservations.reservation_id%TYPE) IS
  BEGIN
    UPDATE reservations
    SET status = 'CONFIRMED'
    WHERE reservation_id = p_reservation_id;
  END confirm_reservation;



  PROCEDURE cancel_reservation(p_reservation_id IN reservations.reservation_id%TYPE) IS
  BEGIN
    UPDATE reservations
    SET status = 'CANCELLED'
    WHERE reservation_id = p_reservation_id;

    UPDATE hotel_rooms
    SET status = 'AVAILABLE'
    WHERE room_id IN (
        SELECT room_id
        FROM accommodation
        WHERE reservation_id = p_reservation_id
    );

    UPDATE guides
    SET availability_status = 'AVAILABLE'
    WHERE guide_id IN (
        SELECT guide_id
        FROM guide_assignments
        WHERE reservation_id = p_reservation_id
    );
  END cancel_reservation;

END travel_agency_operations;
/


-- PACKAGE BODY: travel_agency_intelligence
CREATE OR REPLACE PACKAGE BODY travel_agency_intelligence AS

------------------------------------------------------------------------
-- HOTEL RECOMMENDATION
------------------------------------------------------------------------
FUNCTION recommend_best_hotel(
      p_city        VARCHAR2,
      p_budget      NUMBER,
      p_with_kids   BOOLEAN
) RETURN VARCHAR2 IS
    v_name VARCHAR2(200);
BEGIN
    IF p_with_kids THEN
        SELECT hotel_name
        INTO v_name
        FROM (
            SELECT hotel_name
            FROM hotels h
            JOIN hotel_rooms r ON r.hotel_id = h.hotel_id
            WHERE h.city = p_city
              AND r.base_price_per_night <= p_budget
              AND h.family_rooms = 'T'
              AND r.status = 'AVAILABLE'
            ORDER BY h.rating DESC, r.base_price_per_night
        )
        WHERE ROWNUM = 1;

    ELSE
        SELECT hotel_name
        INTO v_name
        FROM (
            SELECT hotel_name
            FROM hotels h
            JOIN hotel_rooms r ON r.hotel_id = h.hotel_id
            WHERE h.city = p_city
              AND r.base_price_per_night <= p_budget
              AND r.status = 'AVAILABLE'
            ORDER BY h.rating DESC, r.base_price_per_night
        )
        WHERE ROWNUM = 1;
    END IF;

    RETURN v_name;

EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN 'No suitable hotel found';
END recommend_best_hotel;


------------------------------------------------------------------------
-- TRANSPORT RECOMMENDATION
------------------------------------------------------------------------
FUNCTION recommend_transport(
      p_distance    NUMBER,
      p_budget      NUMBER,
      p_preference  VARCHAR2
) RETURN VARCHAR2 IS
BEGIN
    IF p_preference IS NOT NULL THEN
        RETURN p_preference;
    END IF;

    IF p_distance < 200 THEN
        RETURN 'TRAIN';
    ELSIF p_distance BETWEEN 200 AND 800 THEN
        IF p_budget < 100 THEN
            RETURN 'TRAIN';
        ELSE
            RETURN 'PLANE';
        END IF;
    ELSE
        RETURN 'PLANE';
    END IF;
END recommend_transport;


------------------------------------------------------------------------
-- ATTRACTION RECOMMENDATION
------------------------------------------------------------------------
FUNCTION recommend_attractions(
      p_city VARCHAR2,
      p_interests VARCHAR2
) RETURN SYS_REFCURSOR IS
    rc SYS_REFCURSOR;
BEGIN
    OPEN rc FOR
        SELECT attraction_name, description, price_per_person
        FROM attractions
        WHERE city = p_city
          AND (p_interests IS NULL
               OR LOWER(description) LIKE '%' || LOWER(p_interests) || '%')
        ORDER BY rating DESC, price_per_person;

    RETURN rc;
END recommend_attractions;


------------------------------------------------------------------------
-- TRIP SUMMARY
------------------------------------------------------------------------
FUNCTION trip_summary(p_reservation_id NUMBER) RETURN CLOB IS
    res CLOB;
    v_city_start reservations.city_start%TYPE;
    v_city_target reservations.city_target%TYPE;
    v_trip_type reservations.trip_type%TYPE;
    v_date_from DATE;
    v_date_to   DATE;
    v_budget    NUMBER;
    v_currency  VARCHAR2(10);
    v_status    VARCHAR2(20);
    v_cost      NUMBER;
    v_client_name VARCHAR2(200);
BEGIN
    SELECT c.first_name || ' ' || c.last_name,
           r.city_start, r.city_target,
           r.trip_type, r.date_from, r.date_to,
           r.budget_amount, r.budget_currency, r.status
    INTO v_client_name, v_city_start, v_city_target,
         v_trip_type, v_date_from, v_date_to,
         v_budget, v_currency, v_status
    FROM reservations r
    JOIN clients c ON c.client_id = r.client_id
    WHERE reservation_id = p_reservation_id;

    v_cost := estimated_cost(p_reservation_id);

    res :=
        'Reservation summary for '||v_client_name||CHR(10)||
        'Route: '||v_city_start||' -> '||v_city_target||CHR(10)||
        'Trip type: '||v_trip_type||CHR(10)||
        'Dates: '||TO_CHAR(v_date_from,'YYYY-MM-DD')||' to '||TO_CHAR(v_date_to,'YYYY-MM-DD')||CHR(10)||
        'Budget: '||v_budget||' '||v_currency||CHR(10)||
        'Status: '||v_status||CHR(10)||CHR(10)||
        'Estimated cost: '||v_cost||CHR(10);

    RETURN res;
END trip_summary;


------------------------------------------------------------------------
-- LOYALTY
------------------------------------------------------------------------
FUNCTION loyalty_level(p_client_id NUMBER) RETURN VARCHAR2 IS
    v_total NUMBER;
BEGIN
    SELECT NVL(SUM(estimated_cost(reservation_id)), 0)
    INTO v_total
    FROM reservations
    WHERE client_id = p_client_id
      AND status IN ('CONFIRMED','COMPLETED');

    IF v_total > 10000 THEN
        RETURN 'PLATINUM';
    ELSIF v_total > 5000 THEN
        RETURN 'GOLD';
    ELSIF v_total > 2000 THEN
        RETURN 'SILVER';
    ELSE
        RETURN 'NEW';
    END IF;
END loyalty_level;


FUNCTION proposed_discount(p_client_id NUMBER) RETURN NUMBER IS
    v_level VARCHAR2(20);
BEGIN
    v_level := loyalty_level(p_client_id);

    CASE v_level
        WHEN 'PLATINUM' THEN RETURN 15;
        WHEN 'GOLD'     THEN RETURN 10;
        WHEN 'SILVER'   THEN RETURN 5;
        ELSE RETURN 0;
    END CASE;
END proposed_discount;


------------------------------------------------------------------------
-- COST ESTIMATION
------------------------------------------------------------------------
FUNCTION estimated_cost(p_reservation_id NUMBER) RETURN NUMBER IS
    v_base   NUMBER := 0;
    v_trans  NUMBER := 0;
    v_accom  NUMBER := 0;
    v_attr   NUMBER := 0;
BEGIN
    SELECT NVL(budget_amount,0)
    INTO v_base
    FROM reservations
    WHERE reservation_id = p_reservation_id;

    SELECT NVL(SUM(
              CASE tr.transport_type
                   WHEN 'FLIGHT' THEN 150
                   WHEN 'TRAIN'  THEN 80
                   WHEN 'COACH'  THEN 50
                   ELSE 0
              END
           ),0)
    INTO v_trans
    FROM transport_reservations tr
    WHERE tr.reservation_id = p_reservation_id;

    SELECT NVL(SUM((a.check_out - a.check_in) * hr.base_price_per_night), 0)
    INTO v_accom
    FROM accommodation a
    JOIN hotel_rooms hr ON hr.room_id = a.room_id
    WHERE a.reservation_id = p_reservation_id;

    SELECT NVL(SUM(attr.price_per_person * pc.cnt), 0)
    INTO v_attr
    FROM reservation_attractions ra
    JOIN attractions attr ON attr.attraction_id = ra.attraction_id
    JOIN (
        SELECT reservation_id, COUNT(*) AS cnt
        FROM participants
        GROUP BY reservation_id
    ) pc ON pc.reservation_id = ra.reservation_id
    WHERE ra.reservation_id = p_reservation_id;

    RETURN v_base + v_trans + v_accom + v_attr;
END estimated_cost;


------------------------------------------------------------------------
-- TRIP VALUE INDEX
------------------------------------------------------------------------
FUNCTION trip_value_index(p_reservation_id NUMBER) RETURN NUMBER IS
    v_cost NUMBER;
    v_days NUMBER;
BEGIN
    v_cost := estimated_cost(p_reservation_id);

    SELECT (date_to - date_from)
    INTO v_days
    FROM reservations
    WHERE reservation_id = p_reservation_id;

    IF v_days <= 0 THEN
        RETURN NULL;
    END IF;

    RETURN ROUND(v_cost / v_days, 2);
END trip_value_index;


------------------------------------------------------------------------
-- HOTEL SEARCH (REF CURSOR)
------------------------------------------------------------------------
FUNCTION search_hotels_rc(
      p_city           VARCHAR2,
      p_date_from      DATE,
      p_date_to        DATE,
      p_min_rating     NUMBER   DEFAULT NULL,
      p_max_price      NUMBER   DEFAULT NULL
) RETURN SYS_REFCURSOR IS
    rc       SYS_REFCURSOR;
    v_nights NUMBER;
BEGIN
    IF p_date_from IS NOT NULL AND p_date_to IS NOT NULL THEN
        v_nights := GREATEST(TRUNC(p_date_to) - TRUNC(p_date_from), 1);
    ELSE
        v_nights := 1;
    END IF;

    OPEN rc FOR
        SELECT
            h.hotel_id,
            h.hotel_name,
            h.city,
            h.rating,
            r.room_id,
            r.room_type,
            r.max_persons,
            r.base_price_per_night,
            r.status,
            v_nights AS nights,
            r.base_price_per_night * v_nights AS est_total_price
        FROM hotels h
        JOIN hotel_rooms r ON r.hotel_id = h.hotel_id
        WHERE (p_city IS NULL OR h.city = p_city)
          AND r.status = 'AVAILABLE'
          AND (p_min_rating IS NULL OR h.rating >= p_min_rating)
          AND (p_max_price  IS NULL OR r.base_price_per_night <= p_max_price)
        ORDER BY h.rating DESC,
                 r.base_price_per_night,
                 h.hotel_name;

    RETURN rc;
END search_hotels_rc;


------------------------------------------------------------------------
-- TRANSPORT SEARCH USING vw_transport_options
------------------------------------------------------------------------
FUNCTION search_transport_rc(
      p_city_start     VARCHAR2,
      p_city_target    VARCHAR2,
      p_date_from      DATE,
      p_date_to        DATE,
      p_mode           VARCHAR2 DEFAULT NULL
) RETURN SYS_REFCURSOR IS
    rc SYS_REFCURSOR;
BEGIN
    OPEN rc FOR
        SELECT *
        FROM vw_transport_options v
        WHERE (p_city_start  IS NULL OR v.city_start  = p_city_start)
          AND (p_city_target IS NULL OR v.city_target = p_city_target)
          AND (p_date_from   IS NULL OR v.depart_time >= p_date_from)
          AND (p_date_to     IS NULL OR v.depart_time <= p_date_to)
          AND (p_mode        IS NULL OR v.transport_mode = UPPER(p_mode))
        ORDER BY v.depart_time;

    RETURN rc;
END search_transport_rc;


------------------------------------------------------------------------
-- TRANSPORT SIMULATION (FIXED BIND VARIABLES)
------------------------------------------------------------------------
FUNCTION simulate_transport_assignment(
      p_reservation_id NUMBER,
      p_city_start     VARCHAR2,
      p_city_target    VARCHAR2,
      p_date_from      DATE,
      p_date_to        DATE
) RETURN SYS_REFCURSOR IS

    rc SYS_REFCURSOR;

    CURSOR c_opts IS
        SELECT
            v.transport_mode,
            v.transport_id,
            v.depart_time,
            v.col4 AS unit_price
        FROM vw_transport_options v
        WHERE (p_city_start  IS NULL OR v.city_start  = p_city_start)
          AND (p_city_target IS NULL OR v.city_target = p_city_target)
          AND (p_date_from   IS NULL OR v.depart_time >= p_date_from)
          AND (p_date_to     IS NULL OR v.depart_time <= p_date_to)
          AND v.status = 'ACTIVE';

    v_people       NUMBER := 0;
    v_best_total   NUMBER := NULL;
    v_best_mode    VARCHAR2(20);
    v_best_id      NUMBER;
    v_best_depart  DATE;
    v_total        NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_people
    FROM participants
    WHERE reservation_id = p_reservation_id;

    IF v_people = 0 THEN
        OPEN rc FOR SELECT * FROM vw_transport_options WHERE 1=0;
        RETURN rc;
    END IF;

    -- wybór najtańszej opcji transportu
    FOR r IN c_opts LOOP
        v_total := r.unit_price * v_people;

        IF v_best_total IS NULL OR v_total < v_best_total THEN
            v_best_total  := v_total;
            v_best_mode   := r.transport_mode;
            v_best_id     := r.transport_id;
            v_best_depart := r.depart_time;
        END IF;
    END LOOP;

    IF v_best_total IS NULL THEN
        OPEN rc FOR SELECT * FROM vw_transport_options WHERE 1=0;
        RETURN rc;
    END IF;

    -- tu nie używamy USING, Oracle tego nie akceptuje w ref cursor
    OPEN rc FOR
        SELECT
            v.transport_mode,
            v.transport_id,
            v.city_start,
            v.city_target,
            v.depart_time,
            v.col1,
            v.col2,
            v.col3,
            v.col4,
            v.col5,
            v.col6,
            v.status,
            v.extra,
            (SELECT v_best_total FROM dual) AS total_price_for_group,
            (SELECT v_people     FROM dual) AS passengers_count
        FROM vw_transport_options v
        WHERE v.transport_mode = v_best_mode
          AND v.transport_id   = v_best_id;

    RETURN rc;
END simulate_transport_assignment;


END travel_agency_intelligence;
/

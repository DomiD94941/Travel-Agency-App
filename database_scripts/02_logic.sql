ALTER SESSION SET CURRENT_SCHEMA = TA_APP;
SET DEFINE OFF;


-- Support function to pick a random seat number

CREATE OR REPLACE FUNCTION pick_seat RETURN VARCHAR2 IS
BEGIN
    RETURN 'S' || TRUNC(DBMS_RANDOM.VALUE(1, 200));
END;
/



-- PACKAGE HEADER: travel_agency_operations

CREATE OR REPLACE PACKAGE travel_agency_operations AS

  PROCEDURE create_reservation(
      p_client_id       NUMBER,
      p_trip_type       VARCHAR2,
      p_date_from       DATE,
      p_date_to         DATE,
      p_city_start      VARCHAR2,
      p_city_target     VARCHAR2,
      p_budget          NUMBER,
      p_currency        VARCHAR2,
      p_transport_pref  VARCHAR2 DEFAULT 'ANY',
      p_room_pref       VARCHAR2 DEFAULT 'ANY',
      p_reservation_id  OUT NUMBER
  );

  PROCEDURE add_participant(
      p_reservation_id NUMBER,
      p_first_name     VARCHAR2,
      p_last_name      VARCHAR2,
      p_birth_date     DATE,
      p_relation       VARCHAR2
  );

  PROCEDURE set_transport_pref(
      p_participant_id NUMBER,
      p_class          VARCHAR2,
      p_seat           VARCHAR2 DEFAULT NULL,
      p_meal           VARCHAR2 DEFAULT NULL,
      p_cabin          VARCHAR2 DEFAULT NULL,
      p_service        VARCHAR2 DEFAULT NULL
  );

  PROCEDURE add_room_pref(
      p_participant_id NUMBER,
      p_preference     VARCHAR2,
      p_value          VARCHAR2
  );

  PROCEDURE assign_transport(
      p_reservation_id NUMBER,
      p_allow_downgrade CHAR
  );

  PROCEDURE assign_transport(p_reservation_id NUMBER);

  PROCEDURE assign_rooms(p_reservation_id NUMBER);

  PROCEDURE generate_transfers(p_reservation_id NUMBER);

  PROCEDURE assign_guides(p_reservation_id NUMBER);

  PROCEDURE finalize_plan(p_reservation_id NUMBER);

  PROCEDURE confirm_reservation(p_reservation_id NUMBER);

  PROCEDURE cancel_reservation(p_reservation_id NUMBER);

END travel_agency_operations;
/


-- PACKAGE HEADER: travel_agency_intelligence

CREATE OR REPLACE PACKAGE travel_agency_intelligence AS

  FUNCTION recommend_best_hotel(
      p_city        VARCHAR2,
      p_budget      NUMBER,
      p_with_kids   BOOLEAN
  ) RETURN VARCHAR2;

  FUNCTION recommend_transport(
      p_distance    NUMBER,
      p_budget      NUMBER,
      p_preference  VARCHAR2
  ) RETURN VARCHAR2;

  FUNCTION recommend_attractions(
      p_city       VARCHAR2,
      p_interests  VARCHAR2
  ) RETURN SYS_REFCURSOR;

  FUNCTION trip_summary(p_reservation_id NUMBER) RETURN CLOB;

  FUNCTION loyalty_level(p_client_id NUMBER) RETURN VARCHAR2;

  FUNCTION proposed_discount(p_client_id NUMBER) RETURN NUMBER;

  FUNCTION estimated_cost(p_reservation_id NUMBER) RETURN NUMBER;

  FUNCTION trip_value_index(p_reservation_id NUMBER) RETURN NUMBER;

END travel_agency_intelligence;
/

-- PACKAGE BODY: travel_agency_operations

CREATE OR REPLACE PACKAGE BODY travel_agency_operations AS

-- create reservation

PROCEDURE create_reservation(
      p_client_id       NUMBER,
      p_trip_type       VARCHAR2,
      p_date_from       DATE,
      p_date_to         DATE,
      p_city_start      VARCHAR2,
      p_city_target     VARCHAR2,
      p_budget          NUMBER,
      p_currency        VARCHAR2,
      p_transport_pref  VARCHAR2 DEFAULT 'ANY',
      p_room_pref       VARCHAR2 DEFAULT 'ANY',
      p_reservation_id  OUT NUMBER
) IS
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt
    FROM clients
    WHERE client_id = p_client_id;

    IF v_cnt = 0 THEN
        RAISE_APPLICATION_ERROR(-20001,'Client does not exist.');
    END IF;

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
        p_budget, p_currency,
        'IN_PROGRESS',
        UPPER(NVL(p_transport_pref,'ANY')),
        UPPER(NVL(p_room_pref,'ANY'))
    )
    RETURNING reservation_id INTO p_reservation_id;

END create_reservation;

-- add participant

PROCEDURE add_participant(
      p_reservation_id NUMBER,
      p_first_name     VARCHAR2,
      p_last_name      VARCHAR2,
      p_birth_date     DATE,
      p_relation       VARCHAR2
) IS
    v_cnt NUMBER;
    v_age NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt
    FROM reservations
    WHERE reservation_id = p_reservation_id;

    IF v_cnt = 0 THEN
        RAISE_APPLICATION_ERROR(-20010,'Reservation does not exist.');
    END IF;

    v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, p_birth_date)/12);

    INSERT INTO participants(
        participant_id, reservation_id,
        first_name, last_name, birth_date,
        age_years, participant_type, relation_to_client
    ) VALUES (
        seq_participants.NEXTVAL,
        p_reservation_id,
        p_first_name, p_last_name,
        p_birth_date,
        v_age,
        CASE WHEN v_age < 12 THEN 'CHILD' ELSE 'ADULT' END,
        p_relation
    );
END add_participant;

-- set transport preference
PROCEDURE set_transport_pref(
      p_participant_id NUMBER,
      p_class          VARCHAR2,
      p_seat           VARCHAR2 DEFAULT NULL,
      p_meal           VARCHAR2 DEFAULT NULL,
      p_cabin          VARCHAR2 DEFAULT NULL,
      p_service        VARCHAR2 DEFAULT NULL
) IS
BEGIN
    MERGE INTO participant_transport_prefs p
    USING (SELECT p_participant_id pid FROM dual) x
    ON (p.participant_id = x.pid)
    WHEN MATCHED THEN UPDATE SET
        preferred_class   = UPPER(p_class),
        preferred_seat    = UPPER(p_seat),
        preferred_meal    = UPPER(p_meal),
        preferred_cabin   = UPPER(p_cabin),
        preferred_service = UPPER(p_service)
    WHEN NOT MATCHED THEN INSERT (
        participant_id, preferred_class, preferred_seat,
        preferred_meal, preferred_cabin, preferred_service
    ) VALUES (
        p_participant_id, UPPER(p_class), UPPER(p_seat),
        UPPER(p_meal), UPPER(p_cabin), UPPER(p_service)
    );
END set_transport_pref;

-- add room preference
PROCEDURE add_room_pref(
      p_participant_id NUMBER,
      p_preference     VARCHAR2,
      p_value          VARCHAR2
) IS
BEGIN
    MERGE INTO participant_room_prefs p
    USING (SELECT p_participant_id pid, UPPER(p_preference) pref FROM dual) x
    ON (p.participant_id = x.pid AND p.preference = x.pref)
    WHEN MATCHED THEN UPDATE SET
        pref_value = p_value
    WHEN NOT MATCHED THEN INSERT (
        participant_id, preference, pref_value
    ) VALUES (
        p_participant_id, UPPER(p_preference), p_value
    );
END add_room_pref;

-- assign transport
PROCEDURE assign_transport(
      p_reservation_id NUMBER,
      p_allow_downgrade CHAR
) IS
    v_start     VARCHAR2(100);
    v_target    VARCHAR2(100);
    v_date      DATE;
    v_distance  NUMBER;

    TYPE t_part IS RECORD (
      pid NUMBER,
      pref_class VARCHAR2(20),
      age NUMBER
    );
    TYPE t_tab IS TABLE OF t_part;
    v_parts t_tab;

    v_people NUMBER;
    v_mode VARCHAR2(20);
    v_tr_res_id NUMBER;

BEGIN
    -- Reservation info
    SELECT city_start, city_target, date_from
    INTO v_start, v_target, v_date
    FROM reservations
    WHERE reservation_id = p_reservation_id;

    -- Distance from routes
    SELECT distance_km INTO v_distance
    FROM routes
    WHERE city_start=v_start
      AND city_target=v_target;

    -- People
    SELECT COUNT(*) INTO v_people
    FROM participants
    WHERE reservation_id = p_reservation_id;

    -- Load participants
    SELECT p.participant_id,
           NVL(t.preferred_class,'ECONOMY'),
           p.age_years
    BULK COLLECT INTO v_parts
    FROM participants p
    LEFT JOIN participant_transport_prefs t
           ON p.participant_id=t.participant_id
    WHERE p.reservation_id = p_reservation_id;

    -- Choose mode
    IF v_distance > 800 THEN
        v_mode := 'FLIGHT';
    ELSIF v_distance BETWEEN 200 AND 800 THEN
        v_mode := 'TRAIN';
    ELSE
        v_mode := 'COACH';
    END IF;

    -- try flight
    IF v_mode='FLIGHT' THEN
        DECLARE
            r transport_flights%ROWTYPE;
            v_class VARCHAR2(20);
            v_price NUMBER;
        BEGIN
            SELECT *
            INTO r
            FROM transport_flights
            WHERE city_start=v_start
              AND city_target=v_target
              AND depart_time BETWEEN v_date-2 AND v_date+2
              AND status='ACTIVE'
            FETCH FIRST 1 ROW ONLY;

            v_class := v_parts(1).pref_class;

            -- Downgrades
            IF v_class='VIP' AND r.seats_vip_free < v_people THEN
                IF p_allow_downgrade='T' THEN v_class:='BUSINESS';
                ELSE RAISE_APPLICATION_ERROR(-21001,'VIP full'); END IF;
            END IF;

            IF v_class='BUSINESS' AND r.seats_bus_free < v_people THEN
                IF p_allow_downgrade='T' THEN v_class:='ECONOMY';
                ELSE RAISE_APPLICATION_ERROR(-21002,'BUSINESS full'); END IF;
            END IF;

            IF v_class='ECONOMY' AND r.seats_econ_free < v_people THEN
                RAISE_APPLICATION_ERROR(-21003,'ECONOMY full');
            END IF;

            v_price :=
                CASE v_class
                WHEN 'VIP' THEN r.price_vip
                WHEN 'BUSINESS' THEN r.price_bus
                ELSE r.price_econ
                END * v_people;

            INSERT INTO transport_reservations(
                transport_res_id,reservation_id,transport_type,
                flight_id,passengers_count,assigned_class,total_price
            ) VALUES (
                seq_transport_reservations.NEXTVAL,
                p_reservation_id,'FLIGHT',
                r.flight_id,v_people,v_class,v_price
            ) RETURNING transport_res_id INTO v_tr_res_id;

            -- Seats
            FOR i IN 1..v_parts.COUNT LOOP
                INSERT INTO transport_details(
                    detail_id, transport_res_id,
                    participant_id, seat_no, section, preference_met
                ) VALUES (
                    seq_transport_details.NEXTVAL,
                    v_tr_res_id,
                    v_parts(i).pid,
                    pick_seat,
                    v_class,
                    'T'
                );
            END LOOP;

            RETURN;
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
        END;
    END IF;

    -- try train
    IF v_mode IN ('TRAIN','FLIGHT') THEN
        DECLARE
            r transport_trains%ROWTYPE;
            v_class VARCHAR2(20);
            v_price NUMBER;
        BEGIN
            SELECT *
            INTO r
            FROM transport_trains
            WHERE city_start=v_start
              AND city_target=v_target
              AND depart_time BETWEEN v_date-2 AND v_date+2
              AND status='ACTIVE'
            FETCH FIRST 1 ROW ONLY;

            v_class := NVL(v_parts(1).pref_class,'STANDARD');

            -- Quiet rules
            IF v_class='QUIET' THEN
                FOR i IN 1..v_parts.COUNT LOOP
                    IF v_parts(i).age < 12 THEN
                        v_class := 'STANDARD';
                    END IF;
                END LOOP;
            END IF;

            -- Downgrades
            IF v_class='VIP' AND r.seats_vip_free < v_people THEN
                IF p_allow_downgrade='T' THEN v_class:='STANDARD';
                ELSE RAISE_APPLICATION_ERROR(-21004,'Train VIP full'); END IF;
            END IF;

            IF v_class='QUIET' AND r.seats_quiet_free < v_people THEN
                IF p_allow_downgrade='T' THEN v_class:='STANDARD';
                ELSE RAISE_APPLICATION_ERROR(-21005,'Quiet full'); END IF;
            END IF;

            IF v_class='STANDARD' AND r.seats_standard_free < v_people THEN
                RAISE_APPLICATION_ERROR(-21006,'Train standard full');
            END IF;

            v_price :=
                CASE v_class
                WHEN 'VIP' THEN r.price_vip
                WHEN 'QUIET' THEN r.price_quiet
                ELSE r.price_standard
                END * v_people;

            INSERT INTO transport_reservations(
                transport_res_id,reservation_id,transport_type,
                train_id,passengers_count,assigned_class,total_price
            ) VALUES (
                seq_transport_reservations.NEXTVAL,
                p_reservation_id,'TRAIN',
                r.train_id,v_people,v_class,v_price
            ) RETURNING transport_res_id INTO v_tr_res_id;

            -- Seat list
            FOR i IN 1..v_parts.COUNT LOOP
                INSERT INTO transport_details(
                    detail_id, transport_res_id,
                    participant_id, seat_no, section, preference_met
                ) VALUES (
                    seq_transport_details.NEXTVAL,
                    v_tr_res_id,
                    v_parts(i).pid,
                    pick_seat,
                    v_class,
                    'T'
                );
            END LOOP;

            RETURN;
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
        END;
    END IF;

    -- try coach
    DECLARE
        r transport_coaches%ROWTYPE;
        v_price NUMBER;
    BEGIN
        SELECT *
        INTO r
        FROM transport_coaches
        WHERE city_start=v_start
          AND city_target=v_target
          AND depart_time BETWEEN v_date-2 AND v_date+2
          AND status='ACTIVE'
        FETCH FIRST 1 ROW ONLY;

        IF r.seats_free < v_people THEN
            RAISE_APPLICATION_ERROR(-21020,'Coach full');
        END IF;

        v_price := r.price_standard * v_people;

        INSERT INTO transport_reservations(
            transport_res_id,reservation_id,transport_type,
            coach_id,passengers_count,assigned_class,total_price
        ) VALUES (
            seq_transport_reservations.NEXTVAL,
            p_reservation_id,'COACH',
            r.coach_id,v_people,'STANDARD',v_price
        ) RETURNING transport_res_id INTO v_tr_res_id;

        FOR i IN 1..v_parts.COUNT LOOP
            INSERT INTO transport_details(
                detail_id, transport_res_id,
                participant_id, seat_no, section, preference_met
            ) VALUES (
                seq_transport_details.NEXTVAL,
                v_tr_res_id,
                v_parts(i).pid,
                pick_seat,
                'STANDARD',
                'T'
            );
        END LOOP;

        RETURN;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-21030,'No transport available');
    END;
END assign_transport;


PROCEDURE assign_transport(p_reservation_id NUMBER) IS
BEGIN
    assign_transport(p_reservation_id,'T');
END assign_transport;

-- assign rooms

PROCEDURE assign_rooms(p_reservation_id NUMBER) IS
    v_city VARCHAR2(100);
    v_people NUMBER;
    v_children NUMBER;
    v_infants NUMBER;

    TYPE t_rec IS RECORD(pid NUMBER, age NUMBER);
    TYPE t_tab IS TABLE OF t_rec;
    v_parts t_tab;

    v_hotel NUMBER;
    v_room NUMBER;
    v_type VARCHAR2(20);
    v_price NUMBER;
BEGIN
    SELECT city_target INTO v_city
    FROM reservations WHERE reservation_id=p_reservation_id;

    SELECT COUNT(*) INTO v_people
    FROM participants WHERE reservation_id=p_reservation_id;

    SELECT COUNT(*) INTO v_children
    FROM participants WHERE reservation_id=p_reservation_id AND age_years<12;

    SELECT COUNT(*) INTO v_infants
    FROM participants WHERE reservation_id=p_reservation_id AND age_years<3;

    SELECT participant_id, age_years BULK COLLECT INTO v_parts
    FROM participants WHERE reservation_id=p_reservation_id;

    -- hotel
    SELECT hotel_id
    INTO v_hotel
    FROM hotels
    WHERE city=v_city
      AND (v_children=0 OR family_rooms='T')
    ORDER BY rating DESC
    FETCH FIRST 1 ROW ONLY;

    -- room
    SELECT room_id, room_type, base_price_per_night
    INTO v_room, v_type, v_price
    FROM hotel_rooms
    WHERE hotel_id=v_hotel
      AND status='FREE'
      AND max_persons>=v_people
      AND (v_children=0 OR room_type='FAMILY')
      AND (v_infants=0 OR has_child_bed='T')
    ORDER BY base_price_per_night
    FETCH FIRST 1 ROW ONLY;

    -- accommodation 
    INSERT INTO accommodation(
        accommodation_id,reservation_id,
        hotel_id,room_id,room_type,
        guests_count,total_price
    ) VALUES (
        seq_accommodation.NEXTVAL,
        p_reservation_id,
        v_hotel,v_room,v_type,
        v_people,
        v_price * v_people
    );

    -- assign participants to room
    FOR i IN 1..v_parts.COUNT LOOP
        INSERT INTO room_assignments(
            room_assign_id,accommodation_id,participant_id
        )
        SELECT seq_room_assignments.NEXTVAL,
               accommodation_id,
               v_parts(i).pid
        FROM accommodation
        WHERE reservation_id=p_reservation_id;
    END LOOP;

    UPDATE hotel_rooms
    SET status='BOOKED'
    WHERE room_id=v_room;
END assign_rooms;

-- generate transfers

PROCEDURE generate_transfers(p_reservation_id NUMBER) IS
    v_city VARCHAR2(100);
    v_start VARCHAR2(100);
    v_date DATE;
BEGIN
    SELECT city_target, city_start, date_from
    INTO v_city, v_start, v_date
    FROM reservations WHERE reservation_id=p_reservation_id;

    INSERT INTO transport_segments(
        segment_id,reservation_id,segment_type,
        transport_mode,vehicle_no,capacity,
        passengers,depart_time,arrive_time,
        from_city,to_city,price,service_class,zone_type
    ) VALUES (
        seq_segments.NEXTVAL,p_reservation_id,'TRANSFER',
        'MINIVAN','IN-'||p_reservation_id,7,
        7,v_date+1/24,v_date+2/24,
        v_city,v_city||' Hotel Area',50,'STD',NULL
    );

    INSERT INTO transport_segments(
        segment_id,reservation_id,segment_type,
        transport_mode,vehicle_no,capacity,
        passengers,depart_time,arrive_time,
        from_city,to_city,price,service_class,zone_type
    ) VALUES (
        seq_segments.NEXTVAL,p_reservation_id,'RETURN',
        'MINIVAN','OUT-'||p_reservation_id,7,
        7,v_date+5,v_date+5+1/24,
        v_city||' Hotel Area',v_city,50,'STD',NULL
    );
END generate_transfers;

-- assign guides

PROCEDURE assign_guides(p_reservation_id NUMBER) IS
    v_city VARCHAR2(100);
    v_date DATE;
BEGIN
    SELECT city_target, date_from
    INTO v_city, v_date
    FROM reservations WHERE reservation_id=p_reservation_id;

    FOR d IN 1..3 LOOP
        BEGIN
            INSERT INTO guide_assignments(
                assign_id,reservation_id,trip_day,guide_id
            ) SELECT
                seq_guides_assign.NEXTVAL,
                p_reservation_id,d,guide_id
            FROM (
                SELECT guide_id
                FROM guides
                WHERE city=v_city
                  AND availability='AVAILABLE'
                ORDER BY rating DESC
            )
            WHERE ROWNUM=1;

            UPDATE guides
            SET availability='ASSIGNED'
            WHERE guide_id IN (
                SELECT guide_id
                FROM guide_assignments
                WHERE reservation_id=p_reservation_id
                  AND trip_day=d
        );
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
        END;
    END LOOP;
END assign_guides;

-- finalize plan

PROCEDURE finalize_plan(p_reservation_id NUMBER) IS
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt
    FROM transport_reservations
    WHERE reservation_id=p_reservation_id;
    IF v_cnt=0 THEN RAISE_APPLICATION_ERROR(-22001,'No transport'); END IF;

    SELECT COUNT(*) INTO v_cnt
    FROM accommodation
    WHERE reservation_id=p_reservation_id;
    IF v_cnt=0 THEN RAISE_APPLICATION_ERROR(-22002,'No room'); END IF;

    SELECT COUNT(*) INTO v_cnt
    FROM transport_segments
    WHERE reservation_id=p_reservation_id
      AND segment_type IN ('TRANSFER','RETURN');
    IF v_cnt<2 THEN RAISE_APPLICATION_ERROR(-22003,'No transfers'); END IF;

    UPDATE reservations
    SET summary_note='Finalized on '||TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI')
    WHERE reservation_id=p_reservation_id;
END finalize_plan;

-- confirm reservation

PROCEDURE confirm_reservation(p_reservation_id NUMBER) IS
    v_status VARCHAR2(20);
BEGIN
    SELECT status INTO v_status
    FROM reservations
    WHERE reservation_id=p_reservation_id;

    IF v_status='CONFIRMED' THEN
        RAISE_APPLICATION_ERROR(-23001,'Already confirmed');
    END IF;

    IF v_status='CANCELED' THEN
        RAISE_APPLICATION_ERROR(-23002,'Cannot confirm canceled');
    END IF;

    UPDATE reservations
    SET status='CONFIRMED'
    WHERE reservation_id=p_reservation_id;
END confirm_reservation;

-- cancel reservation

PROCEDURE cancel_reservation(p_reservation_id NUMBER) IS
BEGIN
    UPDATE hotel_rooms
    SET status='FREE'
    WHERE room_id IN (
        SELECT room_id FROM accommodation
        WHERE reservation_id=p_reservation_id
    );

    UPDATE guides
    SET availability='AVAILABLE'
    WHERE guide_id IN (
        SELECT guide_id FROM guide_assignments
        WHERE reservation_id=p_reservation_id
    );

    DELETE FROM transport_segments WHERE reservation_id=p_reservation_id;
    DELETE FROM transport_details WHERE transport_res_id IN (
        SELECT transport_res_id FROM transport_reservations
        WHERE reservation_id=p_reservation_id
    );
    DELETE FROM transport_reservations WHERE reservation_id=p_reservation_id;
    DELETE FROM accommodation WHERE reservation_id=p_reservation_id;
    DELETE FROM guide_assignments WHERE reservation_id=p_reservation_id;

    UPDATE reservations
    SET status='CANCELED'
    WHERE reservation_id=p_reservation_id;
END cancel_reservation;

END travel_agency_operations;
/

-- PACKAGE BODY: travel_agency_intelligence

CREATE OR REPLACE PACKAGE BODY travel_agency_intelligence AS

-- hotel recommendation

FUNCTION recommend_best_hotel(
      p_city        VARCHAR2,
      p_budget      NUMBER,
      p_with_kids   BOOLEAN
) RETURN VARCHAR2 IS
    v_name VARCHAR2(200);
BEGIN
    IF p_with_kids THEN
        SELECT hotel_name INTO v_name
        FROM (
            SELECT hotel_name
            FROM hotels h
            JOIN hotel_rooms r ON r.hotel_id=h.hotel_id
            WHERE h.city=p_city
              AND r.base_price_per_night <= p_budget
              AND h.family_rooms='T'
              AND r.status='FREE'
            GROUP BY hotel_name, h.rating
            ORDER BY h.rating DESC
        )
        WHERE ROWNUM=1;
    ELSE
        SELECT hotel_name INTO v_name
        FROM (
            SELECT hotel_name
            FROM hotels h
            JOIN hotel_rooms r ON r.hotel_id=h.hotel_id
            WHERE h.city=p_city
              AND r.base_price_per_night <= p_budget
              AND r.status='FREE'
            GROUP BY hotel_name, h.rating
            ORDER BY h.rating DESC
        )
        WHERE ROWNUM=1;
    END IF;

    RETURN v_name;
EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN 'NO HOTEL AVAILABLE';
END recommend_best_hotel;

-- recommend transport

FUNCTION recommend_transport(
      p_distance NUMBER,
      p_budget NUMBER,
      p_preference VARCHAR2
) RETURN VARCHAR2 IS
BEGIN
    IF p_preference='COMFORT' THEN
        RETURN 'FLIGHT or EXPRESS TRAIN';

    ELSIF p_preference='ECONOMY' THEN
        RETURN CASE WHEN p_distance<400
                    THEN 'COACH'
                    ELSE 'LOW-COST FLIGHT'
               END;

    ELSE
        RETURN 'ANY MODE POSSIBLE';
    END IF;
END recommend_transport;

-- attractions

FUNCTION recommend_attractions(
      p_city VARCHAR2,
      p_interests VARCHAR2
) RETURN SYS_REFCURSOR IS
    rc SYS_REFCURSOR;
BEGIN
    OPEN rc FOR
        SELECT attraction_name, description, price_per_person
        FROM attractions
        WHERE city=p_city
          AND LOWER(category) LIKE LOWER('%'||p_interests||'%')
        ORDER BY rating DESC;
    RETURN rc;
END recommend_attractions;

-- total cost

FUNCTION estimated_cost(p_reservation_id NUMBER) RETURN NUMBER IS
    v_sum NUMBER;
BEGIN
    SELECT NVL(SUM(total_price),0)
    INTO v_sum
    FROM (
        SELECT total_price FROM accommodation WHERE reservation_id=p_reservation_id
        UNION ALL
        SELECT total_price FROM transport_reservations WHERE reservation_id=p_reservation_id
        UNION ALL
        SELECT price FROM transport_segments WHERE reservation_id=p_reservation_id
    );

    RETURN v_sum;
END estimated_cost;

-- value index

FUNCTION trip_value_index(p_reservation_id NUMBER) RETURN NUMBER IS
    v_cost NUMBER;
    v_rating NUMBER;
BEGIN
    v_cost := estimated_cost(p_reservation_id);

    IF v_cost=0 THEN RETURN 0; END IF;

    BEGIN
        SELECT NVL(AVG(rating),5)
        INTO v_rating
        FROM reviews
        WHERE reservation_id=p_reservation_id;
    EXCEPTION WHEN OTHERS THEN
        v_rating := 5;
    END;

    RETURN ROUND(v_rating * 1000 / v_cost, 2);
END trip_value_index;

-- loyalty

FUNCTION loyalty_level(p_client_id NUMBER) RETURN VARCHAR2 IS
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_cnt
    FROM reservations
    WHERE client_id=p_client_id
      AND status='CONFIRMED';

    IF v_cnt>=10 THEN RETURN 'PLATINUM';
    ELSIF v_cnt>=5 THEN RETURN 'GOLD';
    ELSIF v_cnt>=2 THEN RETURN 'SILVER';
    ELSE RETURN 'NEW';
    END IF;
END loyalty_level;

-- discount

FUNCTION proposed_discount(p_client_id NUMBER) RETURN NUMBER IS
    v_lvl VARCHAR2(20);
BEGIN
    v_lvl := loyalty_level(p_client_id);

    CASE v_lvl
        WHEN 'PLATINUM' THEN RETURN 20;
        WHEN 'GOLD' THEN RETURN 15;
        WHEN 'SILVER' THEN RETURN 10;
        ELSE RETURN 0;
    END CASE;
END proposed_discount;

-- trip summary

FUNCTION trip_summary(p_reservation_id NUMBER) RETURN CLOB IS
    res CLOB;
    v reservations%ROWTYPE;
    v_cost NUMBER;
BEGIN
    SELECT * INTO v FROM reservations
    WHERE reservation_id=p_reservation_id;

    v_cost := estimated_cost(p_reservation_id);

    res :=
        'TRIP SUMMARY'||CHR(10)||
        '------------'||CHR(10)||
        'Destination: '||v.city_target||CHR(10)||
        'Trip type: '||v.trip_type||CHR(10)||
        'Dates: '||TO_CHAR(v.date_from,'YYYY-MM-DD')||' to '||TO_CHAR(v.date_to,'YYYY-MM-DD')||CHR(10)||
        'Budget: '||v.budget_amount||' '||v.budget_currency||CHR(10)||
        'Status: '||v.status||CHR(10)||CHR(10)||
        'Estimated cost: '||v_cost||CHR(10);

    RETURN res;
END trip_summary;

END travel_agency_intelligence;
/

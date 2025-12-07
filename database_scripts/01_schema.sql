WHENEVER SQLERROR EXIT SQL.SQLCODE
ALTER SESSION SET CURRENT_SCHEMA = TA_APP;

BEGIN
  FOR s IN (
      SELECT sequence_name FROM all_sequences WHERE sequence_owner = 'TA_APP'
  )
  LOOP
    BEGIN
      EXECUTE IMMEDIATE 'DROP SEQUENCE TA_APP.' || s.sequence_name;
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
  END LOOP;
END;
/

BEGIN
  FOR t IN (
      SELECT table_name FROM all_tables WHERE owner = 'TA_APP'
  )
  LOOP
    BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE TA_APP.' || t.table_name || ' CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
  END LOOP;
END;
/


CREATE SEQUENCE seq_clients START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_guides START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_routes START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_hotels START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_rooms START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_attractions START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE SEQUENCE seq_reservations START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_participants START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE SEQUENCE seq_transport_reservations START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_transport_details START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_segments START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE SEQUENCE seq_accommodation START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_room_assignments START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_guides_assign START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE SEQUENCE seq_transport_flights START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_transport_trains START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_transport_coaches START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE SEQUENCE seq_trip_packages START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_trip_package_hotels START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_trip_package_attractions START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_trip_package_transport_modes START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE clients (
    client_id      NUMBER PRIMARY KEY,
    first_name     VARCHAR2(50),
    last_name      VARCHAR2(50),
    email          VARCHAR2(100) UNIQUE,
    phone          VARCHAR2(30),
    country        VARCHAR2(50)
);

CREATE TABLE guides (
    guide_id       NUMBER PRIMARY KEY,
    first_name     VARCHAR2(50),
    last_name      VARCHAR2(50),
    city           VARCHAR2(100),
    availability   VARCHAR2(20),
    rating         NUMBER(3,1)
);

CREATE TABLE routes (
    route_id       NUMBER PRIMARY KEY,
    city_start     VARCHAR2(100),
    city_target    VARCHAR2(100),
    distance_km    NUMBER
);

CREATE TABLE hotels (
    hotel_id       NUMBER PRIMARY KEY,
    hotel_name     VARCHAR2(100),
    city           VARCHAR2(100),
    rating         NUMBER(3,1),
    family_rooms   CHAR(1)
);

CREATE TABLE hotel_rooms (
    room_id              NUMBER PRIMARY KEY,
    hotel_id             NUMBER REFERENCES hotels(hotel_id),
    room_type            VARCHAR2(50),
    max_persons          NUMBER,
    has_child_bed        CHAR(1),
    base_price_per_night NUMBER,
    status               VARCHAR2(20)
);

CREATE TABLE attractions (
    attraction_id    NUMBER PRIMARY KEY,
    city             VARCHAR2(100),
    attraction_name  VARCHAR2(100),
    category         VARCHAR2(50),
    description      VARCHAR2(400),
    price_per_person NUMBER,
    open_days        VARCHAR2(50),
    rating           NUMBER(3,1)
);

CREATE TABLE reservations (
    reservation_id  NUMBER PRIMARY KEY,
    client_id       NUMBER REFERENCES clients(client_id),
    trip_type       VARCHAR2(50),
    date_from       DATE,
    date_to         DATE,
    city_start      VARCHAR2(100),
    city_target     VARCHAR2(100),
    budget_amount   NUMBER,
    budget_currency VARCHAR2(10),
    status          VARCHAR2(20),
    transport_pref  VARCHAR2(20),
    room_pref       VARCHAR2(20),
    summary_note    CLOB
);

CREATE TABLE participants (
    participant_id      NUMBER PRIMARY KEY,
    reservation_id      NUMBER REFERENCES reservations(reservation_id),
    first_name          VARCHAR2(50),
    last_name           VARCHAR2(50),
    birth_date          DATE,
    age_years           NUMBER,
    participant_type    VARCHAR2(20),
    relation_to_client  VARCHAR2(50)
);

CREATE TABLE participant_transport_prefs (
    participant_id    NUMBER PRIMARY KEY REFERENCES participants(participant_id),
    preferred_class   VARCHAR2(20),
    preferred_seat    VARCHAR2(10),
    preferred_meal    VARCHAR2(50),
    preferred_cabin   VARCHAR2(20),
    preferred_service VARCHAR2(50)
);

CREATE TABLE participant_room_prefs (
    participant_id NUMBER REFERENCES participants(participant_id),
    preference     VARCHAR2(50),
    pref_value     VARCHAR2(100),
    PRIMARY KEY (participant_id, preference)
);

CREATE TABLE transport_flights (
    flight_id        NUMBER PRIMARY KEY,
    city_start       VARCHAR2(100),
    city_target      VARCHAR2(100),
    depart_time      DATE,
    seats_econ_free  NUMBER,
    seats_bus_free   NUMBER,
    seats_vip_free   NUMBER,
    price_econ       NUMBER,
    price_bus        NUMBER,
    price_vip        NUMBER,
    status           VARCHAR2(20)
);

CREATE TABLE transport_trains (
    train_id           NUMBER PRIMARY KEY,
    city_start         VARCHAR2(100),
    city_target        VARCHAR2(100),
    depart_time        DATE,
    seats_standard_free NUMBER,
    seats_quiet_free    NUMBER,
    seats_vip_free      NUMBER,
    price_standard      NUMBER,
    price_quiet         NUMBER,
    price_vip           NUMBER,
    status              VARCHAR2(20)
);

CREATE TABLE transport_coaches (
    coach_id       NUMBER PRIMARY KEY,
    city_start     VARCHAR2(100),
    city_target    VARCHAR2(100),
    depart_time    DATE,
    seats_total    NUMBER,
    seats_free     NUMBER,
    price_standard NUMBER,
    status         VARCHAR2(20)
);

CREATE TABLE transport_reservations (
    transport_res_id NUMBER PRIMARY KEY,
    reservation_id   NUMBER REFERENCES reservations(reservation_id),
    transport_type   VARCHAR2(20),
    flight_id        NUMBER,
    train_id         NUMBER,
    coach_id         NUMBER,
    passengers_count NUMBER,
    assigned_class   VARCHAR2(20),
    total_price      NUMBER
);

CREATE TABLE transport_details (
    detail_id         NUMBER PRIMARY KEY,
    transport_res_id  NUMBER REFERENCES transport_reservations(transport_res_id),
    participant_id    NUMBER REFERENCES participants(participant_id),
    seat_no           VARCHAR2(10),
    section           VARCHAR2(20),
    preference_met    CHAR(1)
);

CREATE TABLE transport_segments (
    segment_id      NUMBER PRIMARY KEY,
    reservation_id  NUMBER REFERENCES reservations(reservation_id),
    segment_type    VARCHAR2(20),
    transport_mode  VARCHAR2(20),
    vehicle_no      VARCHAR2(50),
    capacity        NUMBER,
    passengers      NUMBER,
    depart_time     DATE,
    arrive_time     DATE,
    from_city       VARCHAR2(100),
    to_city         VARCHAR2(100),
    price           NUMBER,
    service_class   VARCHAR2(20),
    zone_type       VARCHAR2(20)
);

CREATE TABLE accommodation (
    accommodation_id NUMBER PRIMARY KEY,
    reservation_id   NUMBER REFERENCES reservations(reservation_id),
    hotel_id         NUMBER REFERENCES hotels(hotel_id),
    room_id          NUMBER REFERENCES hotel_rooms(room_id),
    room_type        VARCHAR2(50),
    guests_count     NUMBER,
    total_price      NUMBER
);

CREATE TABLE room_assignments (
    room_assign_id   NUMBER PRIMARY KEY,
    accommodation_id NUMBER REFERENCES accommodation(accommodation_id),
    participant_id   NUMBER REFERENCES participants(participant_id)
);

CREATE TABLE guide_assignments (
    assign_id      NUMBER PRIMARY KEY,
    reservation_id NUMBER REFERENCES reservations(reservation_id),
    trip_day       NUMBER,
    guide_id       NUMBER REFERENCES guides(guide_id)
);

CREATE TABLE reviews (
    review_id       NUMBER PRIMARY KEY,
    reservation_id  NUMBER REFERENCES reservations(reservation_id),
    rating          NUMBER(3,1),
    review_comment  VARCHAR2(400)
);

CREATE TABLE trip_packages (
    package_id     NUMBER PRIMARY KEY,
    package_name   VARCHAR2(200),
    city_start     VARCHAR2(100),
    city_target    VARCHAR2(100),
    base_days      NUMBER,
    base_budget    NUMBER
);

CREATE TABLE trip_package_hotels (
    id          NUMBER PRIMARY KEY,
    package_id  NUMBER REFERENCES trip_packages(package_id),
    hotel_id    NUMBER REFERENCES hotels(hotel_id)
);

CREATE TABLE trip_package_attractions (
    id              NUMBER PRIMARY KEY,
    package_id      NUMBER REFERENCES trip_packages(package_id),
    attraction_id   NUMBER REFERENCES attractions(attraction_id)
);

CREATE TABLE trip_package_transport_modes (
    id             NUMBER PRIMARY KEY,
    package_id     NUMBER REFERENCES trip_packages(package_id),
    transport_mode VARCHAR2(50)
);


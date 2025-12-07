SET DEFINE OFF;
WHENEVER SQLERROR EXIT SQL.SQLCODE;
ALTER SESSION SET CURRENT_SCHEMA = TA_APP;

INSERT INTO clients (first_name, last_name, email, phone, country)
VALUES ('John','Doe','john@example.com','123456789','Germany');

INSERT INTO clients (first_name, last_name, email, phone, country)
VALUES ('Anna','Smith','anna@example.com','987654321','France');

INSERT INTO clients (first_name, last_name, email, phone, country)
VALUES ('Mark','Brown','mark@example.com','555222111','USA');

INSERT INTO clients (first_name, last_name, email, phone, country)
VALUES ('Laura','White','laura@example.com','332211445','Poland');

INSERT INTO clients (first_name, last_name, email, phone, country)
VALUES ('David','Black','david@example.com','778899221','UK');

INSERT INTO guides (first_name, last_name, city, availability_status, rating)
VALUES ('Michael','Ford','Berlin','AVAILABLE',4.7);

INSERT INTO guides (first_name, last_name, city, availability_status, rating)
VALUES ('Maria','Lopez','Paris','AVAILABLE',4.8);

INSERT INTO guides (first_name, last_name, city, availability_status, rating)
VALUES ('James','Miller','Munich','AVAILABLE',4.6);

INSERT INTO routes (city_start, city_target, distance_km)
VALUES ('Berlin','Paris',1050);

INSERT INTO routes (city_start, city_target, distance_km)
VALUES ('Berlin','Munich',580);

INSERT INTO routes (city_start, city_target, distance_km)
VALUES ('Munich','Vienna',400);

INSERT INTO routes (city_start, city_target, distance_km)
VALUES ('Paris','London',450);

INSERT INTO hotels (hotel_name, city, rating, family_rooms)
VALUES ('Berlin Grand Hotel','Berlin',4.8,'T');

INSERT INTO hotels (hotel_name, city, rating, family_rooms)
VALUES ('Paris Luxury Inn','Paris',4.6,'F');

INSERT INTO hotels (hotel_name, city, rating, family_rooms)
VALUES ('Munich Central Hotel','Munich',4.2,'T');

INSERT INTO hotel_rooms (hotel_id, room_type, max_persons, has_child_bed, base_price_per_night, status)
VALUES (1, 'FAMILY', 4, 'T', 180, 'AVAILABLE');

INSERT INTO hotel_rooms (hotel_id, room_type, max_persons, has_child_bed, base_price_per_night, status)
VALUES (1, 'DOUBLE', 2, 'F', 120, 'AVAILABLE');

INSERT INTO hotel_rooms (hotel_id, room_type, max_persons, has_child_bed, base_price_per_night, status)
VALUES (2, 'DOUBLE', 2, 'F', 160, 'AVAILABLE');

INSERT INTO hotel_rooms (hotel_id, room_type, max_persons, has_child_bed, base_price_per_night, status)
VALUES (2, 'SUITE', 3, 'T', 250, 'AVAILABLE');

INSERT INTO hotel_rooms (hotel_id, room_type, max_persons, has_child_bed, base_price_per_night, status)
VALUES (3, 'FAMILY', 4, 'T', 140, 'AVAILABLE');

INSERT INTO attractions (city, attraction_name, category, description, price_per_person, open_days, rating)
VALUES ('Berlin','Museum Island','MUSEUM','Historic museums',25,'MON-FRI',4.7);

INSERT INTO attractions (city, attraction_name, category, description, price_per_person, open_days, rating)
VALUES ('Paris','Eiffel Tower','LANDMARK','Iconic tower',30,'DAILY',4.9);

INSERT INTO attractions (city, attraction_name, category, description, price_per_person, open_days, rating)
VALUES ('Munich','BMW Museum','MUSEUM','Car museum',20,'TUE-SUN',4.6);

INSERT INTO transport_flights (
    city_start, city_target, depart_time,
    seats_econ_free, seats_bus_free, seats_vip_free,
    price_econ, price_bus, price_vip, status
)
VALUES ('Berlin','Paris',SYSDATE+2,
        50,20,10,120,220,450,'ACTIVE');

INSERT INTO transport_flights (
    city_start, city_target, depart_time,
    seats_econ_free, seats_bus_free, seats_vip_free,
    price_econ, price_bus, price_vip, status
)
VALUES ('Paris','London',SYSDATE+3,
        60,25,12,100,200,400,'ACTIVE');

INSERT INTO transport_trains (
    city_start, city_target, depart_time,
    seats_standard_free, seats_quiet_free, seats_vip_free,
    price_standard, price_quiet, price_vip, status
)
VALUES ('Berlin','Munich',SYSDATE+1,
        80,40,15,60,90,150,'ACTIVE');

INSERT INTO transport_coaches (
    city_start, city_target, depart_time,
    seats_total, seats_free, price_standard, status
)
VALUES ('Berlin','Prague',SYSDATE+4,
        55,55,40,'ACTIVE');

INSERT INTO transport_coaches (
    city_start, city_target, depart_time,
    seats_total, seats_free, price_standard, status
)
VALUES ('Berlin','Paris',SYSDATE+5, 55,55,40,'ACTIVE');

INSERT INTO transport_coaches
VALUES (seq_transport_coaches.NEXTVAL, 'Berlin','Paris',SYSDATE+5,55,55,40,'ACTIVE');

COMMIT;

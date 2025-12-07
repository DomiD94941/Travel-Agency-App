
ALTER SESSION SET CURRENT_SCHEMA = TA_APP;
SET DEFINE OFF;

CREATE OR REPLACE TRIGGER trg_clients_pk
BEFORE INSERT ON clients
FOR EACH ROW
BEGIN
    IF :new.client_id IS NULL THEN
        :new.client_id := seq_clients.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_guides_pk
BEFORE INSERT ON guides
FOR EACH ROW
BEGIN
    IF :new.guide_id IS NULL THEN
        :new.guide_id := seq_guides.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_routes_pk
BEFORE INSERT ON routes
FOR EACH ROW
BEGIN
    IF :new.route_id IS NULL THEN
        :new.route_id := seq_routes.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_hotels_pk
BEFORE INSERT ON hotels
FOR EACH ROW
BEGIN
    IF :new.hotel_id IS NULL THEN
        :new.hotel_id := seq_hotels.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_rooms_pk
BEFORE INSERT ON hotel_rooms
FOR EACH ROW
BEGIN
    IF :new.room_id IS NULL THEN
        :new.room_id := seq_rooms.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_attractions_pk
BEFORE INSERT ON attractions
FOR EACH ROW
BEGIN
    IF :new.attraction_id IS NULL THEN
        :new.attraction_id := seq_attractions.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_reservations_pk
BEFORE INSERT ON reservations
FOR EACH ROW
BEGIN
    IF :new.reservation_id IS NULL THEN
        :new.reservation_id := seq_reservations.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_participants_pk
BEFORE INSERT ON participants
FOR EACH ROW
BEGIN
    IF :new.participant_id IS NULL THEN
        :new.participant_id := seq_participants.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_flights_pk
BEFORE INSERT ON transport_flights
FOR EACH ROW
BEGIN
    IF :new.flight_id IS NULL THEN
        :new.flight_id := seq_transport_flights.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_trains_pk
BEFORE INSERT ON transport_trains
FOR EACH ROW
BEGIN
    IF :new.train_id IS NULL THEN
        :new.train_id := seq_transport_trains.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_coaches_pk
BEFORE INSERT ON transport_coaches
FOR EACH ROW
BEGIN
    IF :new.coach_id IS NULL THEN
        :new.coach_id := seq_transport_coaches.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_trans_res_pk
BEFORE INSERT ON transport_reservations
FOR EACH ROW
BEGIN
    IF :new.transport_res_id IS NULL THEN
        :new.transport_res_id := seq_transport_reservations.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_transport_details_pk
BEFORE INSERT ON transport_details
FOR EACH ROW
BEGIN
    IF :new.detail_id IS NULL THEN
        :new.detail_id := seq_transport_details.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_segments_pk
BEFORE INSERT ON transport_segments
FOR EACH ROW
BEGIN
    IF :new.segment_id IS NULL THEN
        :new.segment_id := seq_segments.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_accommodation_pk
BEFORE INSERT ON accommodation
FOR EACH ROW
BEGIN
    IF :new.accommodation_id IS NULL THEN
        :new.accommodation_id := seq_accommodation.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_room_assign_pk
BEFORE INSERT ON room_assignments
FOR EACH ROW
BEGIN
    IF :new.room_assign_id IS NULL THEN
        :new.room_assign_id := seq_room_assignments.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_guide_assign_pk
BEFORE INSERT ON guide_assignments
FOR EACH ROW
BEGIN
    IF :new.assign_id IS NULL THEN
        :new.assign_id := seq_guides_assign.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_reservation_dates
BEFORE INSERT OR UPDATE ON reservations
FOR EACH ROW
BEGIN
    IF :new.date_from >= :new.date_to THEN
        RAISE_APPLICATION_ERROR(-30010,'Invalid dates: date_from must be before date_to.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_participant_age
BEFORE INSERT OR UPDATE ON participants
FOR EACH ROW
BEGIN
    IF :new.birth_date IS NULL THEN
        RAISE_APPLICATION_ERROR(-30011,'Birth date is required.');
    END IF;

    :new.age_years := TRUNC(MONTHS_BETWEEN(SYSDATE, :new.birth_date)/12);

    :new.participant_type :=
        CASE WHEN :new.age_years < 12 THEN 'CHILD'
             ELSE 'ADULT'
        END;
END;
/

CREATE OR REPLACE TRIGGER trg_client_delete_block
BEFORE DELETE ON clients
FOR EACH ROW
DECLARE
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_cnt
    FROM reservations
    WHERE client_id=:old.client_id
      AND status <> 'CANCELED';

    IF v_cnt > 0 THEN
        RAISE_APPLICATION_ERROR(-30020,'Cannot delete client with active reservations!');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_transport_seats_update
AFTER INSERT ON transport_reservations
FOR EACH ROW
BEGIN
    IF :new.transport_type='FLIGHT' THEN
        UPDATE transport_flights
        SET seats_econ_free = seats_econ_free -
                CASE WHEN :new.assigned_class='ECONOMY' THEN :new.passengers_count ELSE 0 END,
            seats_bus_free = seats_bus_free -
                CASE WHEN :new.assigned_class='BUSINESS' THEN :new.passengers_count ELSE 0 END,
            seats_vip_free = seats_vip_free -
                CASE WHEN :new.assigned_class='VIP' THEN :new.passengers_count ELSE 0 END
        WHERE flight_id=:new.flight_id;

    ELSIF :new.transport_type='TRAIN' THEN
        UPDATE transport_trains
        SET seats_standard_free = seats_standard_free -
                CASE WHEN :new.assigned_class='STANDARD' THEN :new.passengers_count ELSE 0 END,
            seats_quiet_free = seats_quiet_free -
                CASE WHEN :new.assigned_class='QUIET' THEN :new.passengers_count ELSE 0 END,
            seats_vip_free = seats_vip_free -
                CASE WHEN :new.assigned_class='VIP' THEN :new.passengers_count ELSE 0 END
        WHERE train_id=:new.train_id;

    ELSIF :new.transport_type='COACH' THEN
        UPDATE transport_coaches
        SET seats_free = seats_free - :new.passengers_count
        WHERE coach_id=:new.coach_id;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_room_book
AFTER INSERT ON accommodation
FOR EACH ROW
BEGIN
    UPDATE hotel_rooms
    SET status='BOOKED'
    WHERE room_id=:new.room_id;
END;
/

CREATE OR REPLACE TRIGGER trg_guide_assign_status
AFTER INSERT ON guide_assignments
FOR EACH ROW
BEGIN
    UPDATE guides
    SET availability_status='ASSIGNED'
    WHERE guide_id=:new.guide_id;
END;
/

-- Fictional sample records for Hotel Reservation System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."hotel" ("hotel_id", "name", "city") VALUES (101, 'Harborlight Hotel', 'Portland');
INSERT INTO portfolio."guest" ("guest_id", "full_name", "email") VALUES (301, 'Avery Morgan', 'avery.morgan@example.test');
INSERT INTO portfolio."room" ("room_id", "hotel_id", "room_number", "nightly_rate") VALUES (201, 101, '101', 145);
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status", "total_amount") VALUES (401, 301, 201, '2026-11-10', '2026-11-12', 'confirmed', 290);
COMMIT;

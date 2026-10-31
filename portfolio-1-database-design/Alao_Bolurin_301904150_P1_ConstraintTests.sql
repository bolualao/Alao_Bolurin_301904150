-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. hotel pk duplicate. Expected: pk_hotel, SQLSTATE 23505.
INSERT INTO portfolio."hotel" ("hotel_id", "name", "city")
VALUES (101, 'Riverside Lodge', 'Salem');

-- 2. hotel unique duplicate. Expected: uq_hotel_0, SQLSTATE 23505.
INSERT INTO portfolio."hotel" ("hotel_id", "name", "city")
VALUES (1001, 'Harborlight Hotel', 'Portland');

-- 3. hotel missing id. Expected: hotel_id, SQLSTATE 23502.
INSERT INTO portfolio."hotel" ("hotel_id", "name", "city")
VALUES (NULL, 'Cedar House', 'Eugene');

-- 4. room pk duplicate. Expected: pk_room, SQLSTATE 23505.
INSERT INTO portfolio."room" ("room_id", "hotel_id", "room_number", "nightly_rate")
VALUES (201, 101, '102', 155);

-- 5. room unique duplicate. Expected: uq_room_0, SQLSTATE 23505.
INSERT INTO portfolio."room" ("room_id", "hotel_id", "room_number", "nightly_rate")
VALUES (1002, 101, '101', 165);

-- 6. room missing hotel. Expected: fk_room_0, SQLSTATE 23503.
INSERT INTO portfolio."room" ("room_id", "hotel_id", "room_number", "nightly_rate")
VALUES (1003, 99991, '999', 120);

-- 7. guest pk duplicate. Expected: pk_guest, SQLSTATE 23505.
INSERT INTO portfolio."guest" ("guest_id", "full_name", "email")
VALUES (301, 'Jordan Lee', 'jordan.lee@example.test');

-- 8. guest unique duplicate. Expected: uq_guest_0, SQLSTATE 23505.
INSERT INTO portfolio."guest" ("guest_id", "full_name", "email")
VALUES (1004, 'Taylor Reed', 'avery.morgan@example.test');

-- 9. reservation pk duplicate. Expected: pk_reservation, SQLSTATE 23505.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status", "total_amount")
VALUES (401, 301, 201, '2026-12-01', '2026-12-03', 'confirmed', 290);

-- 10. reservation missing guest. Expected: fk_reservation_0, SQLSTATE 23503.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status", "total_amount")
VALUES (1005, 99992, 201, '2026-12-04', '2026-12-06', 'confirmed', 290);

-- 11. reservation missing room. Expected: fk_reservation_1, SQLSTATE 23503.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status", "total_amount")
VALUES (1006, 301, 99993, '2026-12-07', '2026-12-09', 'confirmed', 290);

-- 12. reservation invalid dates. Expected: reservation_dates_valid, SQLSTATE 23514.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status", "total_amount")
VALUES (1007, 301, 201, '2026-12-10', '2026-12-10', 'confirmed', 145);

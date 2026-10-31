-- Show related reservation, guest, room, hotel records (up to 20).
SELECT t0."reservation_id" AS "reservation_reservation_id",
       t0."check_in" AS "reservation_check_in",
       t1."guest_id" AS "guest_guest_id",
       t1."full_name" AS "guest_full_name",
       t2."room_id" AS "room_room_id",
       t2."room_number" AS "room_room_number",
       t3."hotel_id" AS "hotel_hotel_id",
       t3."name" AS "hotel_name"
FROM portfolio."reservation" t0
JOIN portfolio."guest" t1 ON t0."guest_id" = t1."guest_id"
JOIN portfolio."room" t2 ON t0."room_id" = t2."room_id"
JOIN portfolio."hotel" t3 ON t2."hotel_id" = t3."hotel_id"
ORDER BY t0."reservation_id", t1."guest_id", t2."room_id", t3."hotel_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."reservation_id" AS "reservation_reservation_id",
       t0."check_in" AS "reservation_check_in",
       t1."guest_id" AS "guest_guest_id",
       t1."full_name" AS "guest_full_name",
       t2."room_id" AS "room_room_id",
       t2."room_number" AS "room_room_number",
       t3."hotel_id" AS "hotel_hotel_id",
       t3."name" AS "hotel_name"
FROM portfolio."reservation" t0
JOIN portfolio."guest" t1 ON t0."guest_id" = t1."guest_id"
JOIN portfolio."room" t2 ON t0."room_id" = t2."room_id"
JOIN portfolio."hotel" t3 ON t2."hotel_id" = t3."hotel_id"
ORDER BY t0."reservation_id", t1."guest_id", t2."room_id", t3."hotel_id"
LIMIT 20;

-- Find reservation records where check_in matches "2026-11-10" (up to 20).
SELECT * FROM portfolio."reservation"
WHERE "check_in" IS NOT DISTINCT FROM '2026-11-10'
ORDER BY "reservation_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."reservation"
WHERE "check_in" IS NOT DISTINCT FROM '2026-11-10'
ORDER BY "reservation_id"
LIMIT 20;

-- Count reservation records for each guest_id (up to 20 groups).
SELECT "guest_id", count(*) AS record_count
FROM portfolio."reservation"
GROUP BY "guest_id"
ORDER BY record_count DESC, "guest_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "guest_id", count(*) AS record_count
FROM portfolio."reservation"
GROUP BY "guest_id"
ORDER BY record_count DESC, "guest_id" NULLS LAST
LIMIT 20;

# Hotel Reservation System — SQL queries

## 1. Show related reservation, guest, room, hotel records (up to 20).

```sql
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
```

| reservation_reservation_id | reservation_check_in | guest_guest_id | guest_full_name | room_room_id | room_room_number | hotel_hotel_id | hotel_name |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 401 | 2026-11-10 | 301 | Avery Morgan | 201 | 101 | 101 | Harborlight Hotel |

## 2. Find reservation records where check_in matches "2026-11-10" (up to 20).

```sql
SELECT * FROM portfolio."reservation"
WHERE "check_in" IS NOT DISTINCT FROM '2026-11-10'
ORDER BY "reservation_id"
LIMIT 20;
```

| reservation_id | guest_id | room_id | check_in | check_out | status | total_amount |
| --- | --- | --- | --- | --- | --- | --- |
| 401 | 301 | 201 | 2026-11-10 | 2026-11-12 | confirmed | 290 |

## 3. Count reservation records for each guest_id (up to 20 groups).

```sql
SELECT "guest_id", count(*) AS record_count
FROM portfolio."reservation"
GROUP BY "guest_id"
ORDER BY record_count DESC, "guest_id" NULLS LAST
LIMIT 20;
```

| guest_id | record_count |
| --- | --- |
| 301 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 0.894 | 0.894, 0.879, 1.374 | Sort → Seq Scan | 112 |
| After index | 0.194 | 0.18, 0.194, 0.204 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 0.894 ms to 0.194 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=0.861..0.863 rows=20 loops=1)
  Seq Scan on reservation (actual time=0.015..0.82 rows=20 loops=1)
Planning Time: 0.437 ms
Execution Time: 0.894 ms
```

### Before index, run 2

```text
Sort (actual time=0.851..0.852 rows=20 loops=1)
  Seq Scan on reservation (actual time=0.016..0.816 rows=20 loops=1)
Planning Time: 0.371 ms
Execution Time: 0.879 ms
```

### Before index, run 3

```text
Sort (actual time=1.337..1.34 rows=20 loops=1)
  Seq Scan on reservation (actual time=0.021..1.291 rows=20 loops=1)
Planning Time: 0.458 ms
Execution Time: 1.374 ms
```

### After index, run 1

```text
Sort (actual time=0.131..0.133 rows=20 loops=1)
  Bitmap Heap Scan on reservation (actual time=0.028..0.096 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=20 loops=1)
Planning Time: 0.58 ms
Execution Time: 0.18 ms
```

### After index, run 2

```text
Sort (actual time=0.143..0.145 rows=20 loops=1)
  Bitmap Heap Scan on reservation (actual time=0.029..0.108 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.015 rows=20 loops=1)
Planning Time: 0.568 ms
Execution Time: 0.194 ms
```

### After index, run 3

```text
Sort (actual time=0.133..0.134 rows=20 loops=1)
  Bitmap Heap Scan on reservation (actual time=0.028..0.095 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=20 loops=1)
Planning Time: 0.586 ms
Execution Time: 0.204 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Alao_Bolurin_301904150_P2_Queries.sql, then Alao_Bolurin_301904150_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Alao_Bolurin_301904150_P2_QueryResults.png) · [Index comparison](screenshots/Alao_Bolurin_301904150_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)


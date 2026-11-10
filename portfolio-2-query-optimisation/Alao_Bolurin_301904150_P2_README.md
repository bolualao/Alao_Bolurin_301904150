# Portfolio 2 Query Processing and Optimisation

## Queries and results

Three queries were executed against the `clinic_portfolio` database. The first joined four tables to filter a complete appointment history for Patient PT-1001, returning two records: one completed and one cancelled. The second used `NOT EXISTS` to successfully identify that Dr. Sarah Smith (doctor_id 1) was the only doctor available on `2026-12-10 14:00:00+00`. The final query used a `LEFT JOIN` to count appointments per doctor, correctly verifying that Dr. Smith had 3 appointments and Dr. Lee had 1.

## Index comparison

| Metric | Before Indexing | After Indexing |
| :--- | :--- | :--- |
| Scan Type | Seq Scan | Bitmap Heap Scan |
| Run 1 Execution Time | 7.079 ms | 1.723 ms |
| Run 2 Execution Time | 7.280 ms | 1.950 ms |
| Run 3 Execution Time | 7.133 ms | 1.427 ms |
| Median Time | 7.133 ms | 1.723 ms |
| Run 3 Shared Buffer Hits | 1235 | 995 |

## Performance analysis

Before indexing, the database had to perform a sequential scan on all 100,000 rows in the synthetic `appointment_history` table, filtering out 97,923 rows to find the matching records. This required accessing 1,235 memory buffers and took a median of 7.133 ms. Adding a composite B-tree index on `(patient_id, scheduled_at)` shifted the plan to a Bitmap Heap Scan, which looks up qualifying blocks in the index first before retrieving the heap data. This reduced the required shared buffer hits to 995 and lowered the median execution time to 1.723 ms. While this query ran substantially faster, the exact execution times will vary slightly depending on server load, and the new index will impose a small storage and write-overhead penalty on future `INSERT` and `UPDATE` operations.

## Files

| File | Description |
| :--- | :--- |
| [Queries](Alao_Bolurin_301904150_P2_Queries.sql) | Three test queries filtering and counting data. |
| [Optimisation](Alao_Bolurin_301904150_P2_Optimisation.sql) | Synthetic data setup and indexing benchmark. |
| [Screenshots](screenshots/) | Saved execution plans and query results. |

## Reference

PostgreSQL Global Development Group (2025) *PostgreSQL 17.2 Documentation: 14.1. Using EXPLAIN*. Available at: https://www.postgresql.org/docs/current/using-explain.html (Accessed: 14 January 2025).
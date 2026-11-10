# Portfolio 3 Transactions and Concurrency

## Commit and rollback
Transactions ensure that multiple database operations are treated as a single, indivisible unit of work. In the clinic database, a valid transaction successfully updated a scheduled appointment to a completed state, adding notes and a timestamp, and was permanently saved using `COMMIT`. A second transaction attempted to update a patient's phone number but was followed by an invalid insertion that violated the `idx_unique_doctor_schedule` constraint. This triggered an error, forcing a `ROLLBACK` that safely discarded the entire block, reverting the valid phone number change to maintain database consistency.

## Isolation and concurrency control
When two users attempt conflicting operations simultaneously, the database must enforce isolation to prevent corruption. In this test, both sessions operated under the `read committed` isolation level. Session A successfully initiated an insert to book a time slot for Doctor 2 but left the transaction open. When Session B attempted to book the exact same slot for a different patient, it was forced to wait because the database recognized a potential conflict with Session A's uncommitted lock on the index. Once Session A committed, Session B immediately received a duplicate key violation error and was rolled back, proving the partial unique index successfully prevented the double-booking.

## Conclusion
This exercise demonstrated how PostgreSQL handles transactions and concurrent data modifications using the clinic database schema. The `COMMIT` and `ROLLBACK` commands effectively managed successful and failed multi-step operations, ensuring partial updates were not saved when constraints were violated. The concurrency test confirmed that the `read committed` isolation level, combined with a partial unique index, successfully forces conflicting transactions to wait and ultimately rejects invalid double-bookings.

## Files
- [Transactions](Alao_Bolurin_301904150_P3_Transactions.SQL)
- [Session A](Alao_Bolurin_301904150_P3_SessionA.SQL)
- [Session B](Alao_Bolurin_301904150_P3_SessionB.SQL)
- [Commit and Rollback Screenshot](Screenshots/Alao_Bolurin_301904150_P3_CommitRollback.png)
- [Sessions Waiting Screenshot](Screenshots/Alao_Bolurin_301904150_P3_SessionsWaiting.png)
- [Concurrency Result Screenshot](Screenshots/Alao_Bolurin_301904150_P3_ConcurrencyResult.png)

## References
PostgreSQL Global Development Group (2025) *PostgreSQL 17.2 Documentation: 13.2. Transaction Isolation*. Available at: https://www.postgresql.org/docs/current/transaction-iso.html (Accessed: 14 January 2025).
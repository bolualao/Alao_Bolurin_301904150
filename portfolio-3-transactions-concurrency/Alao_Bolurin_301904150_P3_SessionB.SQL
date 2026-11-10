-- Attempt to book same slot

BEGIN;
SHOW transaction_isolation;

INSERT INTO appointment (patient_id, doctor_id, scheduled_at, status) 
VALUES (2, 2, '2026-12-15 09:00:00+00', 'scheduled');

-- switch back to Session A

-- clean up the failed transaction in Session B
ROLLBACK;
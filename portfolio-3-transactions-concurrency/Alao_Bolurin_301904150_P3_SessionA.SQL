-- Data check

SELECT appointment_id, patient_id, doctor_id, scheduled_at, status 
FROM appointment 
WHERE doctor_id = 2 AND scheduled_at = '2026-12-15 09:00:00+00';


BEGIN;
SHOW transaction_isolation;

INSERT INTO appointment (patient_id, doctor_id, scheduled_at, status) 
VALUES (1, 2, '2026-12-15 09:00:00+00', 'scheduled');

-- switch to Session B
COMMIT;


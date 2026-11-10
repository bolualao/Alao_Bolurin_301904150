-- Data Check

SELECT appointment_id, status, consultation_notes 
FROM appointment 
WHERE appointment_id = 2;

SELECT patient_id, phone 
FROM patient 
WHERE patient_id = 1;

-- Commit

BEGIN;

UPDATE appointment 
SET status = 'completed', 
    consultation_notes = 'Routine checkup completed normally.', 
    notes_added_at = '2026-12-10 14:30:00+00' 
WHERE appointment_id = 2 AND status = 'scheduled';

COMMIT;

-- Rollback

BEGIN;

-- 1. A valid change: updating a patient's phone number
UPDATE patient 
SET phone = '555-9999' 
WHERE patient_id = 1;

-- 2. A deliberate violation: trying to schedule an appointment for doctor 1 
-- at a time they are already booked (Appointment 4 is active at this time)
INSERT INTO appointment (patient_id, doctor_id, scheduled_at, status) 
VALUES (1, 1, '2026-12-12 10:00:00+00', 'scheduled');

ROLLBACK;

SELECT appointment_id, status 
FROM appointment 
WHERE appointment_id = 2;

SELECT patient_id, phone 
FROM patient 
WHERE patient_id = 1;
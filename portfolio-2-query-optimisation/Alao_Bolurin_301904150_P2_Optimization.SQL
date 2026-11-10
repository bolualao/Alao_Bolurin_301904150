-- 1. Setup synthetic data
BEGIN;

CREATE SCHEMA p2_benchmark;

-- Create a synthetic history table for indexing tests without affecting the main schema
CREATE TABLE p2_benchmark.appointment_history (
    appointment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    doctor_id BIGINT NOT NULL,
    scheduled_at TIMESTAMPTZ NOT NULL,
    status VARCHAR(20) NOT NULL,
    consultation_notes TEXT
);

-- Generate 100,000 synthetic rows distributing appointments across existing patient and doctor IDs
INSERT INTO p2_benchmark.appointment_history (patient_id, doctor_id, scheduled_at, status, consultation_notes)
SELECT 
    (random() * 1 + 1)::INT, 
    (random() * 1 + 1)::INT, 
    TIMESTAMP '2025-01-01 09:00:00' + random() * (TIMESTAMP '2026-12-31 17:00:00' - TIMESTAMP '2025-01-01 09:00:00'),
    CASE WHEN random() < 0.8 THEN 'completed' ELSE 'cancelled' END,
    'Routine consultation notes.'
FROM generate_series(1, 100000);

-- Update query planner statistics
ANALYZE p2_benchmark.appointment_history;

COMMIT;

-- Verify total row count
SELECT count(*) FROM p2_benchmark.appointment_history;

-- The target query filters appointments for Patient 1 scheduled in October 2026
SELECT appointment_id, doctor_id, scheduled_at, status
FROM p2_benchmark.appointment_history
WHERE patient_id = 1
  AND scheduled_at >= '2026-10-01 00:00:00'
  AND scheduled_at < '2026-11-01 00:00:00';

  -- Analyze execution plan and buffer usage before adding a targeted index
EXPLAIN (ANALYZE, BUFFERS) 
SELECT appointment_id, doctor_id, scheduled_at, status
FROM p2_benchmark.appointment_history
WHERE patient_id = 1
  AND scheduled_at >= '2026-10-01 00:00:00'
  AND scheduled_at < '2026-11-01 00:00:00';

-- Create a composite B-tree index on patient_id and scheduled_at to optimize the target query
CREATE INDEX idx_benchmark_patient_schedule 
ON p2_benchmark.appointment_history (patient_id, scheduled_at);


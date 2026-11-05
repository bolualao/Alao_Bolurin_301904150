BEGIN;

-- department: A medical specialty area within the clinic
CREATE TABLE department (
    department_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- patient: A registered person seeking medical care
-- Rule 1: patient_number and phone have unique constraints separately
CREATE TABLE patient (
    patient_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_number VARCHAR(30) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(120) NOT NULL
);

-- doctor: A medical professional working at the clinic
-- Rule 2: license_number is unique; required FK to department
CREATE TABLE doctor (
    doctor_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_id BIGINT NOT NULL,
    license_number VARCHAR(50) NOT NULL UNIQUE,
    full_name VARCHAR(120) NOT NULL,
    CONSTRAINT fk_doctor_department FOREIGN KEY (department_id) 
        REFERENCES department (department_id)
);

-- appointment: A scheduled visit between a patient and doctor
-- Rule 3: Required FKs link visit to one existing patient and doctor
-- Rule 7: notes_added_at must be on or after scheduled_at
CREATE TABLE appointment (
    appointment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    doctor_id BIGINT NOT NULL,
    scheduled_at TIMESTAMPTZ NOT NULL,
    status VARCHAR(20) NOT NULL,
    consultation_notes TEXT,
    notes_added_at TIMESTAMPTZ,
    CONSTRAINT fk_appointment_patient FOREIGN KEY (patient_id) 
        REFERENCES patient (patient_id),
    CONSTRAINT fk_appointment_doctor FOREIGN KEY (doctor_id) 
        REFERENCES doctor (doctor_id),
    CONSTRAINT chk_notes_date CHECK (notes_added_at >= scheduled_at)
);

-- Rule 4 and Rule 8: Prevents double-booking a doctor
-- Applies only to active appointments; frees slot if 'cancelled'
CREATE UNIQUE INDEX idx_unique_doctor_schedule 
ON appointment (doctor_id, scheduled_at) 
WHERE status != 'cancelled';

-- Rule 6 and Rule 8: Ensures a patient cannot have two appointments at the exact same time
-- Applies only to active appointments; frees slot if 'cancelled'
CREATE UNIQUE INDEX idx_unique_patient_schedule 
ON appointment (patient_id, scheduled_at) 
WHERE status != 'cancelled';

-- Note on Rule 5: A table CHECK constraint cannot reliably compare dynamic dates like current time. 
-- Ensuring scheduled_at is in the future when originally booked requires application transaction logic or a trigger.

COMMIT;
# Clinic Management System Normalisation

Normalisation separates information into related tables to reduce repeated details and avoid inconsistent updates. The same three appointments are used below. Only the fields needed to explain the changes are shown; the full design keeps the other fields from the design document.

Dates are shortened for readability. `scheduled_at` represents the full appointment date and time. Names and phone numbers are fictional.

## Starting appointment list

| patient_id | full_name | phone | Scheduled appointments |
|---|---|---|---|
| 1 | Ada James | 0411111111 | Doctor 10: license MED001, Dr. Sam Smith, Cardiology, scheduled 2026-10-01 09:00, status confirmed; Doctor 11: license MED002, Dr. Mia Wong, Pediatrics, scheduled 2026-10-01 10:00, status confirmed |
| 2 | Ben Cole | 0422222222 | Doctor 10: license MED001, Dr. Sam Smith, Cardiology, scheduled 2026-10-15 09:00, status confirmed |

The first row contains two appointments in one cell. Finding one appointment or updating its status is awkward. Ada's first appointment is with Doctor 10, while her second is with Doctor 11.

## 1NF: One value per cell

1NF requires each table cell to contain a single atomic value and each row to be unique. Each appointment now has its own row, removing the repeated list.

| doctor_id | scheduled_at | patient_id | full_name | phone | license_number | doctor_name | department_name | status |
|---|---|---|---|---|---|---|---|---|
| 10 | 2026-10-01 09:00 | 1 | Ada James | 0411111111 | MED001 | Dr. Sam Smith | Cardiology | confirmed |
| 11 | 2026-10-01 10:00 | 1 | Ada James | 0411111111 | MED002 | Dr. Mia Wong | Pediatrics | confirmed |
| 10 | 2026-10-15 09:00 | 2 | Ben Cole | 0422222222 | MED001 | Dr. Sam Smith | Cardiology | confirmed |

For this un-normalised flat table, the composite primary key is `(doctor_id, scheduled_at)`. Both values together identify one appointment, assuming a doctor cannot have two appointments at the exact same instant. `doctor_id` alone is not enough: Doctor 10 appears twice.

The rows are in 1NF, but doctor and department details are repeated. Correcting the spelling of a doctor's name or department requires changing every related appointment row.

## 2NF: Details depend on the whole key

2NF requires the table to be in 1NF and that all non-key fields depend on the entire primary key, not just a part of it (no partial dependencies).

Here, `doctor_id` alone determines `license_number`, `doctor_name`, and `department_name`. Those details belong to the doctor, regardless of when an appointment is scheduled. They move into a separate table.

### Doctor details

Key: `doctor_id`.

| doctor_id | license_number | doctor_name | department_name |
|---|---|---|---|
| 10 | MED001 | Dr. Sam Smith | Cardiology |
| 11 | MED002 | Dr. Mia Wong | Pediatrics |

### Appointment details

Key: `(doctor_id, scheduled_at)`. `doctor_id` links to Doctor details.

| doctor_id | scheduled_at | patient_id | full_name | phone | status |
|---|---|---|---|---|---|
| 10 | 2026-10-01 09:00 | 1 | Ada James | 0411111111 | confirmed |
| 11 | 2026-10-01 10:00 | 1 | Ada James | 0411111111 | confirmed |
| 10 | 2026-10-15 09:00 | 2 | Ben Cole | 0422222222 | confirmed |

Doctor names and departments no longer repeat for every appointment. However, Ada's phone number still repeats across her appointments, and department names are embedded in the doctor table.

## 3NF: Keep details with the thing they describe

3NF requires the table to be in 2NF and that no non-key field depends on another non-key field (no transitive dependencies). Two remaining dependencies explain the next split:

- `department_name` depends on department context: The specialty describes a department entity, which should be independent of individual doctors.
- `patient_id` determines `full_name` and `phone`: These describe the patient, not the appointment.

### department

Key: `department_id`.

| department_id | name |
|---|---|
| 1 | Cardiology |
| 2 | Pediatrics |

### patient

Key: `patient_id`.

| patient_id | full_name | phone |
|---|---|---|
| 1 | Ada James | 0411111111 |
| 2 | Ben Cole | 0422222222 |

### doctor

Key: `doctor_id`. `department_id` is a foreign key to `department`.

| doctor_id | department_id | license_number | full_name |
|---|---|---|---|
| 10 | 1 | MED001 | Dr. Sam Smith |
| 11 | 2 | MED002 | Dr. Mia Wong |

### appointment

The final design uses `appointment_id` as a surrogate primary key (an automatically generated ID), rather than relying on the composite key `(doctor_id, scheduled_at)`. `patient_id` and `doctor_id` are foreign keys linking back to the `patient` and `doctor` tables. Replacing a composite key with a single auto-generated ID simplifies foreign key references across the database, but an ID alone does not prove 3NF. 3NF is achieved because every non-key attribute depends strictly on the key, the whole key, and nothing but the key.

| appointment_id | patient_id | doctor_id | scheduled_at | status |
|---|---|---|---|---|
| 100 | 1 | 10 | 2026-10-01 09:00 | confirmed |
| 101 | 1 | 11 | 2026-10-01 10:00 | confirmed |
| 102 | 2 | 10 | 2026-10-15 09:00 | confirmed |

Now Ada's phone number is stored once in `patient`, and doctor and department details are stored once in their respective tables. Foreign key IDs preserve the links so appointment details can still be joined when needed.

These four resulting tables match the agreed ER diagram design. For readability, optional fields (`consultation_notes`, `notes_added_at`) and additional unique identifier columns (`patient_number`) are omitted from these small examples, but exist in the complete schema.
# Clinic Management System Database Design

## 1. Entities
I chose four entities for my clinic management system:
* **department:** A medical specialty area within the clinic
* **patient:** A registered person seeking medical care
* **doctor:** A medical professional working at the clinic
* **appointment:** A scheduled visit between a patient and doctor, including status and consultation notes

I kept **department** and **doctor** separate so the clinic can maintain multiple doctors under one specialty. The **appointment** entity handles both the future scheduling and the historical medical notes.

## 2. Attributes and keys
I use an automatically generated ID for each record as the Primary Key (PK). Unique means no repeated values. Required means the value cannot be missing.

## department

| Column | Data type | Key | Required |
|---|---|---|---|
| `department_id` | BIGINT | PK | Yes |
| `name` | VARCHAR(100) | Unique | Yes |

## patient

| Column | Data type | Key | Required |
|---|---|---|---|
| `patient_id` | BIGINT | PK | Yes |
| `patient_number` | VARCHAR(30) | Unique | Yes |
| `phone` | VARCHAR(20) | Unique | Yes |
| `full_name` | VARCHAR(120) | | Yes |

`patient_number` and `phone` are each unique on their own, not as a combination.

## doctor

| Column | Data type | Key | Required |
|---|---|---|---|
| `doctor_id` | BIGINT | PK | Yes |
| `department_id` | BIGINT | FK → `department.department_id` | Yes |
| `license_number` | VARCHAR(50) | Unique | Yes |
| `full_name` | VARCHAR(120) | | Yes |

## appointment

| Column | Data type | Key | Required |
|---|---|---|---|
| `appointment_id` | BIGINT | PK | Yes |
| `patient_id` | BIGINT | FK → `patient.patient_id` | Yes |
| `doctor_id` | BIGINT | FK → `doctor.doctor_id` | Yes |
| `scheduled_at` | TIMESTAMPTZ | | Yes |
| `status` | VARCHAR(20) | | Yes |
| `consultation_notes` | TEXT | | No |
| `notes_added_at` | TIMESTAMPTZ | | No |

BIGINT holds whole numbers for IDs. VARCHAR(120) holds short text up to 120 characters. TEXT holds long, unrestricted text. TIMESTAMPTZ holds a date and time with time-zone-aware handling. 
I leave `consultation_notes` and `notes_added_at` empty until the appointment finishes.

## 3. Relationships
* **department → doctor:** One to many. A department can have zero or more doctors; each doctor belongs to exactly one department.
* **patient → appointment:** One to many over time. A patient can have zero or more appointments; each appointment belongs to exactly one patient.
* **doctor → appointment:** One to many over time. A doctor can have zero or more appointments; each appointment belongs to exactly one doctor.

## 4. Business rules and constraints
* **Rule 1:** Patient `patient_number` and `phone` have unique constraints on the **patient** table.
* **Rule 2:** Doctor `license_number` is unique. A required foreign key links the doctor to exactly one existing department.
* **Rule 3:** Required foreign keys in **appointment** link the visit to one existing patient and one existing doctor.
* **Rule 4:** A unique index on `doctor_id` and `scheduled_at` prevents double-booking a doctor. I apply this index only to appointments where `status` is not 'cancelled'.
* **Rule 5:** A date check requires `scheduled_at` to be greater than the current time when the appointment is originally created.
* **Rule 6:** A unique index on `patient_id` and `scheduled_at` ensures a patient cannot have two appointments at the exact same time, excluding cancelled ones.
* **Rule 7:** A date check requires `notes_added_at` to be on or after `scheduled_at`. The notes and `notes_added_at` fields remain empty until the visit concludes.
* **Rule 8:** Cancelling an appointment changes its status to 'cancelled'. This removes the record from the active unique indexes (freeing the time slot for new bookings) but keeps the row in the table to retain the cancellation history. A key alone cannot enforce this; it requires a partial index based on `status`.

## 5. Design assumptions
* All appointment times start at exact intervals (e.g., 09:00, 09:30) managed by the system application, allowing exact timestamp matches for double-booking checks.
* Phone numbers are formatted consistently before being saved so the unique constraint works reliably.

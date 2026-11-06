#Portfolio 1 Database Design and Modelling

##Case study
A clinic management system tracks patients, doctors, medical appointments, and consultation records. Patients book visits with doctors, while staff manage schedules and record diagnoses. The system ensures efficient allocation of medical personnel and maintains accurate patient histories.

##Users
Patients schedule and attend medical appointments. Doctors conduct consultations and update medical records, while clinic receptionists register new patients, manage daily schedules, and handle appointment cancellations.

##Main operations
Register a new patient; add a doctor to the clinic directory; schedule a medical appointment; record consultation notes and diagnoses; cancel an existing appointment; view a patient's medical history; check a doctor's daily availability.

##Business rules
Each patient has a unique patient ID number and contact phone number.

Each doctor has a unique medical license number and is assigned to exactly one department.

Every appointment must link one existing patient to one existing doctor.

A doctor can only have one appointment scheduled at any specific date and time slot.

The appointment date and time must be set in the future when originally booked.

A patient can have multiple appointments, but cannot book two different appointments at the exact same time.

Consultation notes are recorded only after an appointment concludes and cannot be dated earlier than the appointment time.

Cancelling an appointment frees the doctor's time slot for other patients but retains the cancellation history.

##Scope
One outpatient clinic branch utilizing fictional records for patients, doctors, and general appointments. 

FILES
| File | Contents |
| --- | --- |
| [Design]( Alao_Bolurin_301904150_P1_Design.md) | Entities, attributes, keys and relationships. |
| [ER diagram]( Alao_Bolurin_301904150_P1_ERDiagram.md) | The four tables and their relationships. |
| [Normalisation]( Alao_Bolurin_301904150_P1_Normalisation.md) | Example tables showing 1NF, 2NF and 3NF. |
| [Schema]( Alao_Bolurin_301904150_P1_Schema.sql) | Table definitions, keys and constraints. |
| [Sample records]( Alao_Bolurin_301904150_P1_SampleData.sql) | Fictional Doctors, Appointment, Patients and Departments. |
| [Constraint tests]( Alao_Bolurin_301904150_P1_ConstraintTests.sql) | Invalid inserts and the final count query. |
| [Screenshots](screenshots/) | Saved commands and results. |

The database runs on PostgreSQL in GitHub Codespaces. Its name is clinic_portfolio. It contains four tables: department, patient, doctor, and appointment. Each table has an automatically generated identity ID as its primary key. 
The schema uses constraints to enforce business rules. patient_number, phone, and license_number are marked UNIQUE. Required fields are set to NOT NULL. Foreign keys link doctors to departments and appointments to both patients and doctors. Partial unique indexes prevent double-booking for active appointments, and a CHECK constraint ensures consultation notes are not dated before an appointment starts. The schema and valid sample records were committed before running the invalid inserts. 

##Test results
The constraint tests successfully rejected invalid data. When testing the requirements, the database blocked an insert missing a required patient name, blocked duplicate patient numbers, and rejected a duplicate doctor license number. It also correctly prevented an appointment from referencing a non-existent patient ID.
The partial unique indexes worked as intended, stopping double-bookings for both doctors and patients when the status was active. The date CHECK constraint successfully rejected an attempt to add consultation notes dated earlier than the appointment time. As noted in the schema.
After all invalid inserts failed, the final query confirmed the database maintained only the original valid sample data: 2 departments, 2 patients, 2 doctors, and 4 appointments. Screenshots of the tests, executions, and the final row count were saved in the screenshots folder. 

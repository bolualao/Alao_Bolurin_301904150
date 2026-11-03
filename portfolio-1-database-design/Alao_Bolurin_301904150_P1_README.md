Portfolio 1 Database Design and Modelling
Case study
A clinic management system tracks patients, doctors, medical appointments, and consultation records. Patients book visits with doctors, while staff manage schedules and record diagnoses. The system ensures efficient allocation of medical personnel and maintains accurate patient histories.

Users
Patients schedule and attend medical appointments. Doctors conduct consultations and update medical records, while clinic receptionists register new patients, manage daily schedules, and handle appointment cancellations.

Main operations
Register a new patient; add a doctor to the clinic directory; schedule a medical appointment; record consultation notes and diagnoses; cancel an existing appointment; view a patient's medical history; check a doctor's daily availability.

Business rules
Each patient has a unique patient ID number and contact phone number.

Each doctor has a unique medical license number and is assigned to exactly one department.

Every appointment must link one existing patient to one existing doctor.

A doctor can only have one appointment scheduled at any specific date and time slot.

The appointment date and time must be set in the future when originally booked.

A patient can have multiple appointments, but cannot book two different appointments at the exact same time.

Consultation notes are recorded only after an appointment concludes and cannot be dated earlier than the appointment time.

Cancelling an appointment frees the doctor's time slot for other patients but retains the cancellation history.

Scope
One outpatient clinic branch utilizing fictional records for patients, doctors, and general appointments. 
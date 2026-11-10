// 1. Select the database
clinic_portfolio_db;

// 2. Check that the collection is empty before inserting (Expected: 0)
db.clinic_events.countDocuments();

// 3. Insert the four event documents in one batch
db.clinic_events.insertMany([
  {
    _id: "EVT-001",
    event_type: "appointment_scheduled",
    event_time: new Date("2026-10-10T09:00:00Z"),
    patient: { patient_number: "PT-1001", full_name: "Alice Green" },
    doctor: { license_number: "MED-001", full_name: "Dr. Sarah Smith", department: "Cardiology" },
    scheduling_details: { scheduled_for: new Date("2026-10-15T09:00:00Z"), status: "scheduled" }
  },
  {
    _id: "EVT-002",
    event_type: "consultation_completed",
    event_time: new Date("2026-10-15T09:45:00Z"),
    patient: { patient_number: "PT-1001", full_name: "Alice Green" },
    doctor: { license_number: "MED-001", full_name: "Dr. Sarah Smith", department: "Cardiology" },
    consultation_details: { notes: "Routine checkup completed normally.", follow_up_required: false }
  },
  {
    _id: "EVT-003",
    event_type: "appointment_scheduled",
    event_time: new Date("2026-11-20T10:30:00Z"),
    patient: { patient_number: "PT-1002", full_name: "Bob Carter" },
    doctor: { license_number: "MED-002", full_name: "Dr. James Lee", department: "Pediatrics" },
    scheduling_details: { scheduled_for: new Date("2026-12-10T14:00:00Z"), status: "scheduled" }
  },
  {
    _id: "EVT-004",
    event_type: "appointment_scheduled",
    event_time: new Date("2026-11-25T11:00:00Z"),
    patient: { patient_number: "PT-1001", full_name: "Alice Green" },
    doctor: { license_number: "MED-002", full_name: "Dr. James Lee", department: "Pediatrics" },
    scheduling_details: { scheduled_for: new Date("2026-12-20T10:00:00Z"), status: "scheduled" }
  }
]);

// 4. Query A: Total count of events
// Expected result: 4
db.clinic_events.countDocuments();

// 5. Query B: One entity's ordered event history (Alice Green's events, oldest first)
// Expected result: Documents EVT-001, EVT-002, and EVT-004 in that order.
db.clinic_events.find({ "patient.patient_number": "PT-1001" }).sort({ event_time: 1 });

// 6. Query C: Nested-field filter (Find all events handled by the Pediatrics department)
// Expected result: Documents EVT-003 and EVT-004.
db.clinic_events.find({ "doctor.department": "Pediatrics" });
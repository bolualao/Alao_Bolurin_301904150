# Portfolio 4 NoSQL and Advanced Data Models

## Document model

This MongoDB model adapts the clinic scheduling case into an event-based NoSQL structure. Instead of separate tables for patients, doctors, and appointments linked by foreign keys, we use a single `clinic_events` collection. Every time a significant action occurs (like scheduling an appointment or completing a consultation), a new event document is inserted. 

Each document includes core event details (`_id`, `event_type`, `event_time`) and embeds subsets of patient and doctor details to avoid complex joins. A variable section is included depending on the `event_type`: a `scheduling_details` object for booking events, or a `consultation_details` object for completed appointments.

### Example Document
```json
{
  "_id": "EVT-001",
  "event_type": "appointment_scheduled",
  "event_time": ISODate("2026-10-10T09:00:00.000Z"),
  "patient": {
    "patient_number": "PT-1001",
    "full_name": "Alice Green"
  },
  "doctor": {
    "license_number": "MED-001",
    "full_name": "Dr. Sarah Smith",
    "department": "Cardiology"
  },
  "scheduling_details": {
    "scheduled_for": ISODate("2026-10-15T09:00:00.000Z"),
    "status": "scheduled"
  }
}

## Implementation and results

The implementation was tested using a local MongoDB Community Server running in GitHub Codespaces.

- **Insertion:** The collection started empty. A single `insertMany` command successfully added all four event documents, returning `acknowledged: true` with the four unique `_id` values.
- **Total count:** Running `db.clinic_events.countDocuments()` verified that the collection contained exactly 4 documents.
- **Ordered history:** Querying for `patient.patient_number: "PT-1001"` and sorting by `event_time` ascending successfully retrieved Alice Green's three events in chronological order (EVT-001, EVT-002, and EVT-004).
- **Nested filter:** Querying the nested field `doctor.department: "Pediatrics"` correctly filtered the collection to return only the two events handled by Dr. James Lee (EVT-003 and EVT-004).

## Why MongoDB fits

MongoDB's flexible schema is highly suitable for an event-based logging model. In a traditional SQL database, handling different event types (booking an appointment vs. recording clinical notes) often requires either a rigid table with many `NULL` columns or complex table inheritance structures. MongoDB easily accommodates polymorphism, allowing a single `clinic_events` collection to hold different event schemas natively.

A limitation of this approach is data duplication and update anomalies. If a patient changes their legal name or a doctor changes departments, updating that information requires finding and modifying every historical event document they are embedded in, whereas a relational model only requires a single row update.

## Files

| File | Contents |
|---|---|
| Setup Guide | Steps used to install and start the MongoDB server. |
| MongoDB Commands | The insert and query scripts for the event model. |
| Screenshots | Saved command executions and query results. |
-- Join appointment, patient, doctor, and department tables
-- to view complete visit history filtered by patient number
SELECT 
    p.patient_number,
    p.full_name AS patient_name,
    a.scheduled_at,
    a.status,
    d.full_name AS doctor_name,
    dept.name AS department_name,
    a.consultation_notes
FROM appointment a
JOIN patient p ON a.patient_id = p.patient_id
JOIN doctor d ON a.doctor_id = d.doctor_id
JOIN department dept ON d.department_id = dept.department_id
WHERE p.patient_number = 'PT-1001'
ORDER BY a.scheduled_at ASC;

-- Check doctor availability for a target timestamp by finding doctors 
-- without active (non-cancelled) appointments using NOT EXISTS
SELECT 
    d.doctor_id,
    d.license_number,
    d.full_name AS doctor_name,
    dept.name AS department_name
FROM doctor d
JOIN department dept ON d.department_id = dept.department_id
WHERE NOT EXISTS (
    SELECT 1 
    FROM appointment a 
    WHERE a.doctor_id = d.doctor_id
      AND a.scheduled_at = '2026-12-10 14:00:00+00'
      AND a.status != 'cancelled'
)
ORDER BY d.doctor_id ASC;

-- Group total appointments by doctor using LEFT JOIN 
-- to ensure doctors with zero appointments are included
SELECT 
    d.doctor_id,
    d.full_name AS doctor_name,
    dept.name AS department_name,
    COUNT(a.appointment_id) AS total_appointments
FROM doctor d
JOIN department dept ON d.department_id = dept.department_id
LEFT JOIN appointment a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.full_name, dept.name
ORDER BY d.doctor_id ASC;
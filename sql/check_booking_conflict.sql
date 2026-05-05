-- ============================================================
-- Check booking conflict
-- ============================================================

-- Business rule:
-- BR-003. Нельзя создать пересекающееся бронирование.
--
-- Two bookings overlap if:
-- new_start < existing_end
-- AND
-- new_end > existing_start

-- Example:
-- Existing booking:
-- room_id = 1
-- start_time = 2026-05-10 14:00:00
-- end_time   = 2026-05-10 15:00:00
--
-- New booking request:
-- room_id = 1
-- start_time = 2026-05-10 14:30:00
-- end_time   = 2026-05-10 15:30:00

SELECT
    b.id AS booking_id,
    r.name AS room_name,
    u.full_name AS booked_by,
    bs.code AS booking_status,
    b.start_time,
    b.end_time
FROM bookings b
JOIN rooms r
    ON b.room_id = r.id
JOIN users u
    ON b.user_id = u.id
JOIN booking_statuses bs
    ON b.status_id = bs.id
WHERE b.room_id = 1
    AND bs.code = 'confirmed'
    AND TIMESTAMP '2026-05-10 14:30:00' < b.end_time
    AND TIMESTAMP '2026-05-10 15:30:00' > b.start_time;
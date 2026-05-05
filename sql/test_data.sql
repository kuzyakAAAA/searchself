-- ============================================================
-- Test data for Meeting Room Booking System
-- ============================================================

-- ============================================================
-- booking_statuses
-- ============================================================

INSERT INTO booking_statuses (code, name)
VALUES
    ('confirmed', 'Подтверждено'),
    ('cancelled', 'Отменено'),
    ('completed', 'Завершено'),
    ('rejected', 'Отклонено');

-- ============================================================
-- users
-- ============================================================

INSERT INTO users (full_name, email, role)
VALUES
    ('Иван Петров', 'ivan.petrov@example.com', 'employee'),
    ('Анна Смирнова', 'anna.smirnova@example.com', 'employee'),
    ('Олег Иванов', 'oleg.ivanov@example.com', 'admin');

-- ============================================================
-- rooms
-- ============================================================

INSERT INTO rooms (name, capacity, location, description, is_active)
VALUES
    ('Meeting Room A', 6, '2 этаж', 'Комната для небольших командных встреч', TRUE),
    ('Meeting Room B', 10, '3 этаж', 'Комната с экраном и системой видеосвязи', TRUE),
    ('Meeting Room C', 4, '1 этаж', 'Небольшая переговорная комната', FALSE);

-- ============================================================
-- bookings
-- ============================================================

INSERT INTO bookings (user_id, room_id, status_id, start_time, end_time)
VALUES
    (
        1,
        1,
        (SELECT id FROM booking_statuses WHERE code = 'confirmed'),
        '2026-05-10 14:00:00',
        '2026-05-10 15:00:00'
    ),
    (
        2,
        2,
        (SELECT id FROM booking_statuses WHERE code = 'confirmed'),
        '2026-05-10 16:00:00',
        '2026-05-10 17:00:00'
    ),
    (
        1,
        2,
        (SELECT id FROM booking_statuses WHERE code = 'cancelled'),
        '2026-05-09 11:00:00',
        '2026-05-09 12:00:00'
    );

-- ============================================================
-- notifications
-- ============================================================

INSERT INTO notifications (booking_id, event_type, status)
VALUES
    (1, 'booking_created', 'sent'),
    (2, 'booking_created', 'pending'),
    (3, 'booking_cancelled', 'sent');
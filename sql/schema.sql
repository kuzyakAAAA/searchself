-- ============================================================
-- Schema for Meeting Room Booking System
-- ============================================================

-- Drop tables if they already exist.
-- The order is important because of foreign key dependencies.

DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS booking_statuses;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS users;

-- ============================================================
-- users
-- ============================================================

CREATE TABLE users (
    id SERIAL PRIMARY KEY,

    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    role VARCHAR(50) NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT check_user_role
        CHECK (role IN ('employee', 'admin'))
);

-- ============================================================
-- rooms
-- ============================================================

CREATE TABLE rooms (
    id SERIAL PRIMARY KEY,

    name VARCHAR(255) NOT NULL,
    capacity INTEGER NOT NULL,
    location VARCHAR(255),
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT check_room_capacity
        CHECK (capacity > 0)
);

-- ============================================================
-- booking_statuses
-- ============================================================

CREATE TABLE booking_statuses (
    id SERIAL PRIMARY KEY,

    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL
);

-- ============================================================
-- bookings
-- ============================================================

CREATE TABLE bookings (
    id SERIAL PRIMARY KEY,

    user_id INTEGER NOT NULL,
    room_id INTEGER NOT NULL,
    status_id INTEGER NOT NULL,

    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_bookings_user
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT fk_bookings_room
        FOREIGN KEY (room_id)
        REFERENCES rooms(id),

    CONSTRAINT fk_bookings_status
        FOREIGN KEY (status_id)
        REFERENCES booking_statuses(id),

    CONSTRAINT check_booking_time
        CHECK (end_time > start_time)
);

-- ============================================================
-- notifications
-- ============================================================

CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,

    booking_id INTEGER NOT NULL,
    event_type VARCHAR(100) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_notifications_booking
        FOREIGN KEY (booking_id)
        REFERENCES bookings(id),

    CONSTRAINT check_notification_event_type
        CHECK (event_type IN ('booking_created', 'booking_cancelled')),

    CONSTRAINT check_notification_status
        CHECK (status IN ('pending', 'sent', 'failed'))
);

-- ============================================================
-- Indexes
-- ============================================================

CREATE INDEX idx_bookings_user_id
    ON bookings(user_id);

CREATE INDEX idx_bookings_room_id
    ON bookings(room_id);

CREATE INDEX idx_bookings_status_id
    ON bookings(status_id);

CREATE INDEX idx_bookings_room_time
    ON bookings(room_id, start_time, end_time);

CREATE INDEX idx_notifications_booking_id
    ON notifications(booking_id);
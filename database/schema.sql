
CREATE DATABASE IF NOT EXISTS doctor_appointment_db;

USE doctor_appointment_db;

-- 1. USERS TABLE
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role ENUM('patient', 'doctor', 'admin') NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. DOCTORS TABLE
CREATE TABLE IF NOT EXISTS doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    specialization VARCHAR(100) NOT NULL,
    qualifications TEXT,
    experience_years INT DEFAULT 0,
    clinic_address VARCHAR(255),
    fees DECIMAL(10,2) DEFAULT 0.00,
    profile_verified BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

-- 3. SLOTS TABLE
CREATE TABLE IF NOT EXISTS slots (
    slot_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    slot_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_booked BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
        ON DELETE CASCADE,

    UNIQUE KEY unique_doctor_slot
        (doctor_id, slot_date, start_time),

    CHECK (end_time > start_time)
);

-- 4. APPOINTMENTS TABLE
CREATE TABLE IF NOT EXISTS appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    patient_id INT NOT NULL,
    slot_id INT NOT NULL UNIQUE,

    status ENUM(
        'Pending',
        'Confirmed',
        'Cancelled',
        'Completed'
    ) DEFAULT 'Pending',

    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason TEXT,
    consultation_notes TEXT,

    FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id),

    FOREIGN KEY (patient_id)
        REFERENCES users(user_id),

    FOREIGN KEY (slot_id)
        REFERENCES slots(slot_id),

    INDEX idx_patient (patient_id),
    INDEX idx_doctor (doctor_id)
);

-- 5. NOTIFICATIONS TABLE
CREATE TABLE IF NOT EXISTS notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

-- Verify tables
SHOW TABLES;

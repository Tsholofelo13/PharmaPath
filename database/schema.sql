-- ============================================
-- PharmaPath Database Schema
-- ============================================
USE pharma_db;

-- Drop tables in reverse order to avoid foreign key errors
DROP TABLE IF EXISTS collection_history;
DROP TABLE IF EXISTS no_shows;
DROP TABLE IF EXISTS chatbot_interactions;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS authorised_collectors;
DROP TABLE IF EXISTS prescriptions;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS facilities;

-- ============================================
-- Create all tables
-- ============================================

CREATE TABLE facilities (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    facility_code VARCHAR(10) UNIQUE NOT NULL,
    facility_name VARCHAR(100) NOT NULL,
    province VARCHAR(50),
    district VARCHAR(50),
    address TEXT,
    phone VARCHAR(15),
    email VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_facility_code (facility_code),
    INDEX idx_province (province),
    INDEX idx_district (district)
);

CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    staff_id VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    role ENUM('PHARMACIST', 'RECEPTIONIST', 'ADMIN') NOT NULL,
    facility_code VARCHAR(10) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    last_login DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by BIGINT,
    FOREIGN KEY (facility_code) REFERENCES facilities(facility_code) ON DELETE RESTRICT,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_staff_id (staff_id),
    INDEX idx_facility (facility_code),
    INDEX idx_role (role),
    INDEX idx_active (is_active)
);

CREATE TABLE patients (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    patient_id VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    id_number VARCHAR(20) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(100),
    facility_code VARCHAR(10) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    gender ENUM('MALE', 'FEMALE', 'OTHER'),
    address TEXT,
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(15),
    is_active BOOLEAN DEFAULT TRUE,
    consent_given BOOLEAN DEFAULT FALSE,
    consent_given_at DATETIME,
    last_login DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (facility_code) REFERENCES facilities(facility_code) ON DELETE RESTRICT,
    INDEX idx_patient_id (patient_id),
    INDEX idx_id_number (id_number),
    INDEX idx_phone (phone),
    INDEX idx_facility (facility_code),
    INDEX idx_active (is_active)
);

CREATE TABLE prescriptions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    patient_id BIGINT NOT NULL,
    medication_name VARCHAR(100) NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    quantity VARCHAR(50) NOT NULL,
    prescription_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    status ENUM('NOT_STARTED', 'PREPARING', 'READY', 'COLLECTED', 'EXPIRED', 'CANCELLED') DEFAULT 'NOT_STARTED',
    pre_retrieved_at DATETIME,
    prepared_at DATETIME,
    ready_at DATETIME,
    collected_at DATETIME,
    collected_by BIGINT,
    notes TEXT,
    is_repeat BOOLEAN DEFAULT TRUE,
    repeat_cycle_months INT DEFAULT 2,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (collected_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_patient (patient_id),
    INDEX idx_status (status),
    INDEX idx_expiry (expiry_date),
    INDEX idx_ready_at (ready_at)
);

CREATE TABLE authorised_collectors (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    patient_id BIGINT NOT NULL,
    collector_name VARCHAR(100) NOT NULL,
    collector_id_number VARCHAR(20) NOT NULL,
    collector_phone VARCHAR(15),
    relationship VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    verified_at DATETIME,
    verified_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (verified_by) REFERENCES users(id) ON DELETE SET NULL,
    UNIQUE KEY unique_patient_collector (patient_id, collector_id_number),
    INDEX idx_patient (patient_id),
    INDEX idx_collector_id (collector_id_number),
    INDEX idx_active (is_active)
);

CREATE TABLE audit_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    user_type ENUM('STAFF', 'PATIENT') NOT NULL,
    action VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50),
    entity_id BIGINT,
    patient_id BIGINT,
    prescription_id BIGINT,
    details TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    facility_code VARCHAR(10),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE SET NULL,
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(id) ON DELETE SET NULL,
    INDEX idx_user (user_id),
    INDEX idx_patient (patient_id),
    INDEX idx_action (action),
    INDEX idx_created_at (created_at),
    INDEX idx_facility (facility_code)
);

CREATE TABLE notifications (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    patient_id BIGINT NOT NULL,
    prescription_id BIGINT,
    type ENUM('PREPARING', 'READY', 'NO_SHOW', 'APPOINTMENT_REMINDER', 'GENERAL') NOT NULL,
    channel ENUM('SMS', 'WHATSAPP') NOT NULL,
    message TEXT NOT NULL,
    status ENUM('PENDING', 'SENT', 'FAILED', 'DELIVERED', 'READ') DEFAULT 'PENDING',
    provider_response TEXT,
    sent_at DATETIME,
    delivered_at DATETIME,
    read_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(id) ON DELETE SET NULL,
    INDEX idx_patient (patient_id),
    INDEX idx_status (status),
    INDEX idx_type (type),
    INDEX idx_created_at (created_at)
);

CREATE TABLE appointments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    patient_id BIGINT NOT NULL,
    prescription_id BIGINT,
    appointment_date DATE NOT NULL,
    appointment_time TIME,
    purpose VARCHAR(100),
    status ENUM('SCHEDULED', 'CHECKED_IN', 'NO_SHOW', 'CANCELLED', 'COMPLETED') DEFAULT 'SCHEDULED',
    checked_in_at DATETIME,
    checked_in_by BIGINT,
    no_show_reason TEXT,
    rescheduled_to DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(id) ON DELETE SET NULL,
    FOREIGN KEY (checked_in_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_patient (patient_id),
    INDEX idx_status (status),
    INDEX idx_date (appointment_date),
    INDEX idx_checked_in (checked_in_at)
);

CREATE TABLE chatbot_interactions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    user_message TEXT NOT NULL,
    bot_response TEXT NOT NULL,
    intent VARCHAR(50),
    confidence_score DECIMAL(3,2),
    is_helpful BOOLEAN,
    ip_address VARCHAR(45),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_intent (intent),
    INDEX idx_created_at (created_at)
);

CREATE TABLE no_shows (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    patient_id BIGINT NOT NULL,
    prescription_id BIGINT NOT NULL,
    appointment_id BIGINT,
    marked_by BIGINT NOT NULL,
    reason TEXT,
    notification_sent BOOLEAN DEFAULT FALSE,
    notification_sent_at DATETIME,
    rescheduled_at DATETIME,
    rescheduled_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE SET NULL,
    FOREIGN KEY (marked_by) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (rescheduled_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_patient (patient_id),
    INDEX idx_prescription (prescription_id),
    INDEX idx_created_at (created_at)
);

CREATE TABLE collection_history (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    patient_id BIGINT NOT NULL,
    prescription_id BIGINT NOT NULL,
    collected_by BIGINT NOT NULL,
    collector_name VARCHAR(100),
    collector_id_number VARCHAR(20),
    is_authorised_collector BOOLEAN DEFAULT FALSE,
    collected_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(id) ON DELETE CASCADE,
    FOREIGN KEY (collected_by) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_patient (patient_id),
    INDEX idx_prescription (prescription_id),
    INDEX idx_collected_at (collected_at)
);

-- ============================================
-- Insert Sample Data
-- ============================================
INSERT INTO facilities (facility_code, facility_name, province, district, address, phone) VALUES
('CL254', 'Soweto PHC Clinic', 'Gauteng', 'City of Johannesburg', '123 Soweto Street, Soweto, 1804', '011-123-4567'),
('CL255', 'KwaZulu-Natal PHC Clinic', 'KwaZulu-Natal', 'eThekwini', '456 Durban Road, Durban, 4001', '031-123-4567');

INSERT INTO users (staff_id, full_name, email, phone, role, facility_code, password_hash) VALUES
('PHA_8721', 'Thabo Nkosi', 'thabo@clinic.org', '0712345678', 'PHARMACIST', 'CL254', '$2a$10$dummyhash1'),
('REC_3415', 'Siphokazi Mthembu', 'siphokazi@clinic.org', '0723456789', 'RECEPTIONIST', 'CL254', '$2a$10$dummyhash2'),
('ADM_2098', 'Dr. Mokoena', 'mokoena@clinic.org', '0734567890', 'ADMIN', 'CL254', '$2a$10$dummyhash3');

INSERT INTO patients (patient_id, full_name, id_number, phone, facility_code, password_hash, date_of_birth, gender, consent_given) VALUES
('PAT_001', 'Thandi Ndlovu', '8501015080088', '0712345678', 'CL254', '$2a$10$dummyhash4', '1985-01-01', 'FEMALE', TRUE),
('PAT_002', 'Mark Petersen', '9205055080123', '0723456789', 'CL254', '$2a$10$dummyhash5', '1992-05-05', 'MALE', TRUE);

INSERT INTO prescriptions (patient_id, medication_name, dosage, quantity, prescription_date, expiry_date, status, pre_retrieved_at, prepared_at, ready_at) VALUES
(1, 'Insulin', '20 units daily', '2-month supply (60 units)', '2026-11-15', '2027-01-15', 'READY', '2026-11-12 08:00:00', '2026-11-14 09:00:00', '2026-11-15 08:15:00'),
(2, 'Insulin', '15 units daily', '2-month supply (45 units)', '2026-11-15', '2027-01-15', 'NOT_STARTED', '2026-11-12 08:00:00', NULL, NULL);

INSERT INTO authorised_collectors (patient_id, collector_name, collector_id_number, collector_phone, relationship) VALUES
(1, 'Sipho Ndlovu', '8210155080099', '0712345678', 'Son'),
(1, 'Mary Mokoena', '7503205080100', '0723456789', 'Neighbour');

INSERT INTO appointments (patient_id, prescription_id, appointment_date, appointment_time, purpose, status) VALUES
(1, 1, '2026-11-15', '09:00:00', 'Prescription refill', 'CHECKED_IN'),
(2, 2, '2026-11-15', '09:30:00', 'Prescription refill', 'SCHEDULED');

INSERT INTO audit_logs (user_id, user_type, action, entity_type, entity_id, patient_id, prescription_id, details, ip_address, facility_code) VALUES
(1, 'STAFF', 'LOGIN', 'USER', 1, NULL, NULL, '{"success": true}', '192.168.1.1', 'CL254'),
(1, 'STAFF', 'COLLECT', 'PRESCRIPTION', 1, 1, 1, '{"collector": "Sipho Ndlovu"}', '192.168.1.1', 'CL254');

INSERT INTO notifications (patient_id, prescription_id, type, channel, message, status, sent_at) VALUES
(1, 1, 'READY', 'SMS', 'Your prescription is ready for collection at Soweto PHC Clinic.', 'SENT', '2026-11-15 08:20:00'),
(2, 2, 'PREPARING', 'WHATSAPP', 'We are preparing your prescription. You will be notified when it is ready.', 'SENT', '2026-11-15 09:00:00');

-- ============================================
-- Verification Queries
-- ============================================
SHOW TABLES;
SELECT COUNT(*) FROM facilities;
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM patients;
SELECT COUNT(*) FROM prescriptions;

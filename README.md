# PharmaPath 🏥

**Digital pre-retrieval and prescription fulfilment platform for stable insulin-dependent patients in South Africa's public health system.**

## 🎯 Problem

Stable insulin patients at public PHC clinics face:
- **Long pharmacy queues** (90–120 minutes)
- **Manual file retrieval delays** for unchanged repeat prescriptions
- **Missed collections** leading to poor medication adherence
- **Overburdened pharmacy staff** with predictable, automatable cases

## 💡 Solution

PharmaPath transforms prescription dispensing from a **reactive queue model** into a **proactive, automated workflow**.

- **Predictive Scheduling Engine** – identifies stable patients 3–5 days before their visit
- **Staff Dashboard (SvelteKit)** – real-time queue management and collection confirmation
- **Patient Notifications (SMS/WhatsApp)** – feature-phone compatible alerts

> **"The pharmacy is ready before the patient walks in."**


## 👥 User Roles

| Role | Description |
|------|-------------|
| **Patient** | Mobile app user. Views prescription status, manages collectors |
| **Receptionist** | Checks in patients, verifies collectors, marks no-shows |
| **Pharmacist** | Prepares prescriptions, confirms collection handover |
| **Admin** | Manages users, views audit logs, system configuration |


## 🚀 Features

### For Patients
- ✅ Prescription status tracking (Ready/Preparing/Not started)
- ✅ Authorised collector management
- ✅ Appointment reminders
- ✅ SMS/WhatsApp notifications

### For Staff
- ✅ Pharmacist Dashboard – Express queue management
- ✅ Receptionist Check-in – Patient arrival & collector verification
- ✅ Admin User Management – Staff accounts & permissions
- ✅ Audit Logs – POPIA-compliant trail of all actions

### For Compliance
- ✅ POPIA-compliant data handling
- ✅ Immutable audit logs
- ✅ Role-based access control
- ✅ Facility isolation


## 🛠️ Tech Stack

### Backend
- **Framework:** Spring Boot 3.4 (Java 21) 
- **Security:** Spring Security + JWT
- **Database:** MySQL 8.0
- **ORM:** Spring Data JPA (Hibernate)
- **API:** RESTful with Swagger/OpenAPI

### Frontend
- **Framework:** Flutter (TypeScript)
- **Styling:** Tailwind CSS
- **State:** Svelte Stores
- **Deployment:** Vercel / Netlify (frontend) + AWS/GCP (backend)

### Infrastructure
- **Cloud:** AWS / Google Cloud Platform
- **Containers:** Docker + Docker Compose
- **CI/CD:** GitHub Actions
- **Monitoring:** CloudWatch / Stackdriver






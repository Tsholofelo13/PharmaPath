package com.rxflow.pharmapath.enums;

public enum CollectionStatus {
    PENDING,        // Refill identified, not yet packaged
    PACKAGING,      // Pharmacist is preparing
    READY,          // SMS sent, waiting for patient
    COLLECTED,      // Successfully collected
    EXPIRED,        // Not collected in time
    CANCELLED
}
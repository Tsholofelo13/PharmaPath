package com.rxflow.pharmapath.entity;

import com.rxflow.pharmapath.enums.CollectionStatus;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "medication_packages")
public class MedicationPackage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "package_code", nullable = false, unique = true)
    private String packageCode;

    @Column(name = "collection_token", nullable = false, unique = true)
    private String collectionToken;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @Column(name = "medication_name", nullable = false)
    private String medicationName;

    @Column(name = "dosage")
    private String dosage;

    @Column(name = "quantity")
    private Integer quantity;

    @Column(name = "expiry_window_days")
    private Integer expiryWindowDays = 7;

    @Column(name = "ready_date")
    private LocalDate readyDate;

    @Column(name = "expiry_date")
    private LocalDate expiryDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private CollectionStatus status = CollectionStatus.PENDING;

    @Column(name = "prepared_by_staff_id")
    private Long preparedByStaffId;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() { updatedAt = LocalDateTime.now(); }

    public MedicationPackage() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getPackageCode() { return packageCode; }
    public void setPackageCode(String packageCode) { this.packageCode = packageCode; }
    public String getCollectionToken() { return collectionToken; }
    public void setCollectionToken(String collectionToken) { this.collectionToken = collectionToken; }
    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }
    public String getMedicationName() { return medicationName; }
    public void setMedicationName(String medicationName) { this.medicationName = medicationName; }
    public String getDosage() { return dosage; }
    public void setDosage(String dosage) { this.dosage = dosage; }
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    public Integer getExpiryWindowDays() { return expiryWindowDays; }
    public void setExpiryWindowDays(Integer expiryWindowDays) { this.expiryWindowDays = expiryWindowDays; }
    public LocalDate getReadyDate() { return readyDate; }
    public void setReadyDate(LocalDate readyDate) { this.readyDate = readyDate; }
    public LocalDate getExpiryDate() { return expiryDate; }
    public void setExpiryDate(LocalDate expiryDate) { this.expiryDate = expiryDate; }
    public CollectionStatus getStatus() { return status; }
    public void setStatus(CollectionStatus status) { this.status = status; }
    public Long getPreparedByStaffId() { return preparedByStaffId; }
    public void setPreparedByStaffId(Long preparedByStaffId) { this.preparedByStaffId = preparedByStaffId; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
}
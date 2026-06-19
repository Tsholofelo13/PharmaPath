package com.rxflow.pharmapath.entity;

import com.rxflow.pharmapath.enums.CollectionStatus;
import com.rxflow.pharmapath.enums.CollectorType;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "collection_records")
public class CollectionRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "package_id", nullable = false)
    private MedicationPackage medicationPackage;

    @Enumerated(EnumType.STRING)
    @Column(name = "collector_type")
    private CollectorType collectorType;

    @Column(name = "collector_id_verified")
    private String collectorIdVerified;

    @Column(name = "verified_by_staff_id")
    private Long verifiedByStaffId;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private CollectionStatus status;

    @Column(name = "collected_at")
    private LocalDateTime collectedAt;

    @Column(name = "notes")
    private String notes;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() { createdAt = LocalDateTime.now(); }

    public CollectionRecord() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public MedicationPackage getMedicationPackage() { return medicationPackage; }
    public void setMedicationPackage(MedicationPackage medicationPackage) { this.medicationPackage = medicationPackage; }
    public CollectorType getCollectorType() { return collectorType; }
    public void setCollectorType(CollectorType collectorType) { this.collectorType = collectorType; }
    public String getCollectorIdVerified() { return collectorIdVerified; }
    public void setCollectorIdVerified(String collectorIdVerified) { this.collectorIdVerified = collectorIdVerified; }
    public Long getVerifiedByStaffId() { return verifiedByStaffId; }
    public void setVerifiedByStaffId(Long verifiedByStaffId) { this.verifiedByStaffId = verifiedByStaffId; }
    public CollectionStatus getStatus() { return status; }
    public void setStatus(CollectionStatus status) { this.status = status; }
    public LocalDateTime getCollectedAt() { return collectedAt; }
    public void setCollectedAt(LocalDateTime collectedAt) { this.collectedAt = collectedAt; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public LocalDateTime getCreatedAt() { return createdAt; }
}
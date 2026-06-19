package com.rxflow.pharmapath.entity;

import com.rxflow.pharmapath.enums.StabilityStatus;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "patients")
public class Patient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "id_number", nullable = false, unique = true)
    private String idNumber;

    @Column(name = "full_name", nullable = false)
    private String fullName;

    @Column(name = "phone_number", nullable = false)
    private String phoneNumber;

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @Column(name = "next_refill_date")
    private LocalDate nextRefillDate;

    @Column(name = "last_refill_date")
    private LocalDate lastRefillDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "stability_status")
    private StabilityStatus stabilityStatus = StabilityStatus.STABLE;

    @Column(name = "stability_score")
    private Integer stabilityScore = 100;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() { createdAt = LocalDateTime.now(); }

    public Patient() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public String getIdNumber() { return idNumber; }
    public void setIdNumber(String idNumber) { this.idNumber = idNumber; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    public LocalDate getNextRefillDate() { return nextRefillDate; }
    public void setNextRefillDate(LocalDate nextRefillDate) { this.nextRefillDate = nextRefillDate; }
    public LocalDate getLastRefillDate() { return lastRefillDate; }
    public void setLastRefillDate(LocalDate lastRefillDate) { this.lastRefillDate = lastRefillDate; }
    public StabilityStatus getStabilityStatus() { return stabilityStatus; }
    public void setStabilityStatus(StabilityStatus stabilityStatus) { this.stabilityStatus = stabilityStatus; }
    public Integer getStabilityScore() { return stabilityScore; }
    public void setStabilityScore(Integer stabilityScore) { this.stabilityScore = stabilityScore; }
    public LocalDateTime getCreatedAt() { return createdAt; }
}
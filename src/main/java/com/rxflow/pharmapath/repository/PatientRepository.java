package com.rxflow.pharmapath.repository;

import com.rxflow.pharmapath.entity.Patient;
import com.rxflow.pharmapath.enums.StabilityStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface PatientRepository extends JpaRepository<Patient, Long> {
    Optional<Patient> findByIdNumber(String idNumber);
    List<Patient> findByNextRefillDateBetween(LocalDate start, LocalDate end);
    List<Patient> findByStabilityStatus(StabilityStatus status);
}
package com.rxflow.pharmapath.repository;

import com.rxflow.pharmapath.entity.NominatedCollector;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface NominatedCollectorRepository extends JpaRepository<NominatedCollector, Long> {
    List<NominatedCollector> findByPatientIdAndIsActiveTrue(Long patientId);
    Optional<NominatedCollector> findByCollectorIdNumberAndPatientId(
            String collectorIdNumber, Long patientId);
}
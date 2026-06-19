package com.rxflow.pharmapath.repository;

import com.rxflow.pharmapath.entity.CollectionRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface CollectionRecordRepository extends JpaRepository<CollectionRecord, Long> {
    Optional<CollectionRecord> findByMedicationPackageId(Long packageId);
}
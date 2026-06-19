package com.rxflow.pharmapath.repository;

import com.rxflow.pharmapath.entity.MedicationPackage;
import com.rxflow.pharmapath.enums.CollectionStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface MedicationPackageRepository extends JpaRepository<MedicationPackage, Long> {
    Optional<MedicationPackage> findByCollectionToken(String collectionToken);
    Optional<MedicationPackage> findByPackageCode(String packageCode);
    List<MedicationPackage> findByStatus(CollectionStatus status);
    List<MedicationPackage> findByPatientIdAndStatus(Long patientId, CollectionStatus status);
}
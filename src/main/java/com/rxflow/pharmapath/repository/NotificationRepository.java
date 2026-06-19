package com.rxflow.pharmapath.repository;

import com.rxflow.pharmapath.entity.Notification;
import com.rxflow.pharmapath.enums.NotificationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findByStatus(NotificationStatus status);
    List<Notification> findByPatientId(Long patientId);
}
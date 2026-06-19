package com.rxflow.pharmapath.repository;

import com.rxflow.pharmapath.entity.AuditLog;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface AuditLogRepository extends JpaRepository<AuditLog, Long> {
    List<AuditLog> findByPerformedByUserId(Long userId);
    List<AuditLog> findByEntityTypeAndEntityId(String entityType, Long entityId);
}
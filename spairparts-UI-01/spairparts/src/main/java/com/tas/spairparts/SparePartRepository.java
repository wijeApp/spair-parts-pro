package com.tas.spairparts;

import org.springframework.data.jpa.repository.JpaRepository;

public interface SparePartRepository extends JpaRepository<SparePartItem, Long> {
}

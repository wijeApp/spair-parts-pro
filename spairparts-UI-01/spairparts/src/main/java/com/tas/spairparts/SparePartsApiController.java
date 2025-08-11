package com.tas.spairparts;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

/**
 * REST API Controller for spare parts statistics and data
 */
@RestController
@RequestMapping("/api/spareparts")
@CrossOrigin(origins = "*")
public class SparePartsApiController {
    
    @Autowired
    private SparePartsService sparePartsService;

    /**
     * Get all spare parts
     */
    @GetMapping("/items")
    public ResponseEntity<List<SparePartItem>> getAllItems() {
        try {
            List<SparePartItem> items = sparePartsService.getAll();
            return ResponseEntity.ok(items);
        } catch (Exception e) {
            System.err.println("Error fetching spare parts: " + e.getMessage());
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * Get dashboard statistics
     */
    @GetMapping("/statistics")
    public ResponseEntity<DashboardStatistics> getStatistics() {
        try {
            DashboardStatistics stats = sparePartsService.calculateDashboardStatistics();
            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            System.err.println("Error calculating statistics: " + e.getMessage());
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * Get low stock items
     */
    @GetMapping("/low-stock")
    public ResponseEntity<List<SparePartItem>> getLowStockItems(
            @RequestParam(defaultValue = "10") int threshold) {
        try {
            List<SparePartItem> lowStockItems = sparePartsService.getLowStockItems(threshold);
            return ResponseEntity.ok(lowStockItems);
        } catch (Exception e) {
            System.err.println("Error fetching low stock items: " + e.getMessage());
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * Get a specific spare part by ID
     */
    @GetMapping("/items/{id}")
    public ResponseEntity<SparePartItem> getItemById(@PathVariable Long id) {
        try {
            SparePartItem item = sparePartsService.getById(id);
            if (item != null) {
                return ResponseEntity.ok(item);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            System.err.println("Error fetching item by ID: " + e.getMessage());
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * Health check endpoint
     */
    @GetMapping("/health")
    public ResponseEntity<String> healthCheck() {
        try {
            long totalCount = sparePartsService.getTotalItemCount();
            return ResponseEntity.ok("API is healthy. Total items: " + totalCount);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("API health check failed: " + e.getMessage());
        }
    }
}

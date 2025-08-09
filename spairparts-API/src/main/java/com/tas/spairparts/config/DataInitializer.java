package com.tas.spairparts.config;

import com.tas.spairparts.service.InventoryManagementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

/**
 * Sample data initialization for demonstration purposes
 */
@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private InventoryManagementService inventoryService;

    @Override
    public void run(String... args) throws Exception {
        // Create sample categories
        inventoryService.createCategory("ENG", "Engine Parts", null);
        inventoryService.createCategory("BRK", "Brake System", null);
        inventoryService.createCategory("ELE", "Electrical", null);
        inventoryService.createCategory("FIL", "Filters", null);

        // Create sample suppliers
        inventoryService.createSupplier("SUP001", "Auto Parts Inc.", "contact@autoparts.com", "+1-555-0001");
        inventoryService.createSupplier("SUP002", "Engine Components Ltd.", "sales@enginecomp.com", "+1-555-0002");
        inventoryService.createSupplier("SUP003", "Brake Systems Pro", "info@brakesys.com", "+1-555-0003");

        // Create sample spare parts with initial stock
        inventoryService.createSparePart("ENG-001", "Oil Filter", "Filters", 
                new BigDecimal("25.99"), 50, "Warehouse-A");
        
        inventoryService.createSparePart("BRK-001", "Brake Pad Set", "Brake System", 
                new BigDecimal("89.99"), 25, "Warehouse-A");
        
        inventoryService.createSparePart("ELE-001", "Spark Plug", "Electrical", 
                new BigDecimal("12.50"), 100, "Warehouse-B");
        
        inventoryService.createSparePart("ENG-002", "Air Filter", "Filters", 
                new BigDecimal("35.75"), 30, "Warehouse-A");
        
        inventoryService.createSparePart("BRK-002", "Brake Disc", "Brake System", 
                new BigDecimal("156.00"), 15, "Warehouse-C");

        System.out.println("Sample data initialized successfully!");
        System.out.println("Created 5 spare parts with initial inventory");
        System.out.println("Created 4 categories");
        System.out.println("Created 3 suppliers");
        
        // Demonstrate some operations
        System.out.println("\n--- Demonstration Operations ---");
        
        // Issue some parts
        boolean issued = inventoryService.issueSparepart(1L, 5, "John Doe", "WO-001");
        System.out.println("Issued 5 oil filters: " + issued);
        
        // Reserve some parts
        boolean reserved = inventoryService.reserveSparepart(2L, 3);
        System.out.println("Reserved 3 brake pad sets: " + reserved);
        
        // Check current stock
        int oilFilterStock = inventoryService.getCurrentStock(1L);
        System.out.println("Current oil filter stock: " + oilFilterStock);
        
        // Get low stock parts (if any)
        var lowStockParts = inventoryService.getLowStockParts();
        System.out.println("Low stock parts count: " + lowStockParts.size());
    }
}

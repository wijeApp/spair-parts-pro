package com.tas.spairparts.controller;

import com.tas.spairparts.model.SparePart;
import com.tas.spairparts.model.Supplier;
import com.tas.spairparts.model.Category;
import com.tas.spairparts.model.InventoryTransaction;
import com.tas.spairparts.service.InventoryManagementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * REST Controller for spare parts inventory management
 */
@RestController
@RequestMapping("/api/inventory")
public class InventoryController {

    @Autowired
    private InventoryManagementService inventoryService;

    /**
     * Create a new spare part
     */
    @PostMapping("/spareparts")
    public ResponseEntity<SparePart> createSparePart(
            @RequestParam String partNumber,
            @RequestParam String partName,
            @RequestParam String category,
            @RequestParam BigDecimal unitPrice,
            @RequestParam(defaultValue = "0") int initialStock,
            @RequestParam String location) {
        
        SparePart sparePart = inventoryService.createSparePart(
                partNumber, partName, category, unitPrice, initialStock, location);
        return ResponseEntity.ok(sparePart);
    }

    /**
     * Get all spare parts
     */
    @GetMapping("/spareparts")
    public ResponseEntity<Map<Long, SparePart>> getAllSpareParts() {
        return ResponseEntity.ok(inventoryService.getAllSpareParts());
    }

    /**
     * Search spare parts
     */
    @GetMapping("/spareparts/search")
    public ResponseEntity<List<SparePart>> searchSpareParts(@RequestParam String searchTerm) {
        List<SparePart> results = inventoryService.searchSpareParts(searchTerm);
        return ResponseEntity.ok(results);
    }

    /**
     * Get spare parts by category
     */
    @GetMapping("/spareparts/category/{categoryName}")
    public ResponseEntity<List<SparePart>> getSparePartsByCategory(@PathVariable String categoryName) {
        List<SparePart> results = inventoryService.getSparePartsByCategory(categoryName);
        return ResponseEntity.ok(results);
    }

    /**
     * Get low stock parts
     */
    @GetMapping("/spareparts/lowstock")
    public ResponseEntity<List<SparePart>> getLowStockParts() {
        List<SparePart> lowStockParts = inventoryService.getLowStockParts();
        return ResponseEntity.ok(lowStockParts);
    }

    /**
     * Issue spare parts
     */
    @PostMapping("/spareparts/{sparePartId}/issue")
    public ResponseEntity<String> issueSparePart(
            @PathVariable Long sparePartId,
            @RequestParam int quantity,
            @RequestParam String issuedBy,
            @RequestParam(required = false) String referenceNumber) {
        
        boolean success = inventoryService.issueSparepart(sparePartId, quantity, issuedBy, referenceNumber);
        if (success) {
            return ResponseEntity.ok("Spare part issued successfully");
        } else {
            return ResponseEntity.badRequest().body("Insufficient stock or spare part not found");
        }
    }

    /**
     * Receive spare parts
     */
    @PostMapping("/spareparts/{sparePartId}/receive")
    public ResponseEntity<String> receiveSparePart(
            @PathVariable Long sparePartId,
            @RequestParam int quantity,
            @RequestParam String receivedBy,
            @RequestParam(required = false) String referenceNumber) {
        
        inventoryService.receiveSparepart(sparePartId, quantity, receivedBy, referenceNumber);
        return ResponseEntity.ok("Spare part received successfully");
    }

    /**
     * Reserve spare parts
     */
    @PostMapping("/spareparts/{sparePartId}/reserve")
    public ResponseEntity<String> reserveSparePart(
            @PathVariable Long sparePartId,
            @RequestParam int quantity) {
        
        boolean success = inventoryService.reserveSparepart(sparePartId, quantity);
        if (success) {
            return ResponseEntity.ok("Spare part reserved successfully");
        } else {
            return ResponseEntity.badRequest().body("Insufficient available stock");
        }
    }

    /**
     * Get current stock level
     */
    @GetMapping("/spareparts/{sparePartId}/stock")
    public ResponseEntity<Integer> getCurrentStock(@PathVariable Long sparePartId) {
        int stock = inventoryService.getCurrentStock(sparePartId);
        return ResponseEntity.ok(stock);
    }

    /**
     * Get transaction history for a spare part
     */
    @GetMapping("/spareparts/{sparePartId}/transactions")
    public ResponseEntity<List<InventoryTransaction>> getTransactionHistory(@PathVariable Long sparePartId) {
        List<InventoryTransaction> history = inventoryService.getTransactionHistory(sparePartId);
        return ResponseEntity.ok(history);
    }

    /**
     * Create a new supplier
     */
    @PostMapping("/suppliers")
    public ResponseEntity<Supplier> createSupplier(
            @RequestParam String supplierCode,
            @RequestParam String companyName,
            @RequestParam String email,
            @RequestParam String phoneNumber) {
        
        Supplier supplier = inventoryService.createSupplier(supplierCode, companyName, email, phoneNumber);
        return ResponseEntity.ok(supplier);
    }

    /**
     * Get all suppliers
     */
    @GetMapping("/suppliers")
    public ResponseEntity<Map<Long, Supplier>> getAllSuppliers() {
        return ResponseEntity.ok(inventoryService.getAllSuppliers());
    }

    /**
     * Create a new category
     */
    @PostMapping("/categories")
    public ResponseEntity<Category> createCategory(
            @RequestParam String categoryCode,
            @RequestParam String categoryName,
            @RequestParam(required = false) Long parentCategoryId) {
        
        Category category = inventoryService.createCategory(categoryCode, categoryName, parentCategoryId);
        return ResponseEntity.ok(category);
    }

    /**
     * Get all categories
     */
    @GetMapping("/categories")
    public ResponseEntity<Map<Long, Category>> getAllCategories() {
        return ResponseEntity.ok(inventoryService.getAllCategories());
    }

    /**
     * Get all transactions
     */
    @GetMapping("/transactions")
    public ResponseEntity<List<InventoryTransaction>> getAllTransactions() {
        return ResponseEntity.ok(inventoryService.getAllTransactions());
    }
}

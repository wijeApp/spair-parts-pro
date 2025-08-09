package com.tas.spairparts.service;

import com.tas.spairparts.model.*;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
//import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Service class for managing spare parts inventory operations
 */
@Service
public class InventoryManagementService {
    
    // In-memory storage for demonstration (in real application, use repositories/databases)
    private final Map<Long, SparePart> spareParts = new HashMap<>();
    private final Map<Long, Inventory> inventories = new HashMap<>();
    private final Map<Long, Supplier> suppliers = new HashMap<>();
    private final Map<Long, Category> categories = new HashMap<>();
    private final List<InventoryTransaction> transactions = new ArrayList<>();
    
    private Long nextSparePartId = 1L;
    private Long nextInventoryId = 1L;
    private Long nextSupplierId = 1L;
    private Long nextCategoryId = 1L;
    private Long nextTransactionId = 1L;

    /**
     * Create a new spare part with initial inventory
     */
    public SparePart createSparePart(String partNumber, String partName, String category, 
                                   BigDecimal unitPrice, int initialStock, String location) {
        SparePart sparePart = new SparePart(partNumber, partName, category, unitPrice);
        sparePart.setId(nextSparePartId++);
        sparePart.setLocation(location);
        spareParts.put(sparePart.getId(), sparePart);
        
        // Create initial inventory record
        Inventory inventory = new Inventory(sparePart.getId(), initialStock, location);
        inventory.setId(nextInventoryId++);
        inventories.put(inventory.getId(), inventory);
        
        // Record initial stock transaction
        if (initialStock > 0) {
            recordTransaction(sparePart.getId(), inventory.getId(), 
                            InventoryTransaction.TransactionType.STOCK_IN, 
                            initialStock, "Initial Stock", "SYSTEM");
        }
        
        return sparePart;
    }

    /**
     * Create a new supplier
     */
    public Supplier createSupplier(String supplierCode, String companyName, String email, String phoneNumber) {
        Supplier supplier = new Supplier(supplierCode, companyName, email, phoneNumber);
        supplier.setId(nextSupplierId++);
        suppliers.put(supplier.getId(), supplier);
        return supplier;
    }

    /**
     * Create a new category
     */
    public Category createCategory(String categoryCode, String categoryName, Long parentCategoryId) {
        Category category = new Category(categoryCode, categoryName, parentCategoryId);
        category.setId(nextCategoryId++);
        categories.put(category.getId(), category);
        return category;
    }

    /**
     * Issue spare parts from inventory
     */
    public boolean issueSparepart(Long sparePartId, int quantity, String issuedBy, String referenceNumber) {
        Inventory inventory = findInventoryBySparePartId(sparePartId);
        if (inventory == null) {
            return false;
        }
        
        if (inventory.getAvailableStock() >= quantity) {
            inventory.setCurrentStock(inventory.getCurrentStock() - quantity);
            recordTransaction(sparePartId, inventory.getId(), 
                            InventoryTransaction.TransactionType.STOCK_OUT, 
                            quantity, referenceNumber, issuedBy);
            return true;
        }
        
        return false;
    }

    /**
     * Receive spare parts into inventory
     */
    public void receiveSparepart(Long sparePartId, int quantity, String receivedBy, String referenceNumber) {
        Inventory inventory = findInventoryBySparePartId(sparePartId);
        if (inventory != null) {
            inventory.updateStock(inventory.getCurrentStock() + quantity, receivedBy);
            recordTransaction(sparePartId, inventory.getId(), 
                            InventoryTransaction.TransactionType.STOCK_IN, 
                            quantity, referenceNumber, receivedBy);
        }
    }

    /**
     * Reserve spare parts for future use
     */
    public boolean reserveSparepart(Long sparePartId, int quantity) {
        Inventory inventory = findInventoryBySparePartId(sparePartId);
        return inventory != null && inventory.reserveStock(quantity);
    }

    /**
     * Get spare parts with low stock
     */
    public List<SparePart> getLowStockParts() {
        List<SparePart> lowStockParts = new ArrayList<>();
        
        for (SparePart sparePart : spareParts.values()) {
            Inventory inventory = findInventoryBySparePartId(sparePart.getId());
            if (inventory != null && inventory.isLowStock(sparePart.getMinimumStockLevel())) {
                lowStockParts.add(sparePart);
            }
        }
        
        return lowStockParts;
    }

    /**
     * Get current stock level for a spare part
     */
    public int getCurrentStock(Long sparePartId) {
        Inventory inventory = findInventoryBySparePartId(sparePartId);
        return inventory != null ? inventory.getCurrentStock() : 0;
    }

    /**
     * Get all spare parts in a category
     */
    public List<SparePart> getSparePartsByCategory(String categoryName) {
        return spareParts.values().stream()
                .filter(part -> categoryName.equals(part.getCategory()))
                .toList();
    }

    /**
     * Search spare parts by name or part number
     */
    public List<SparePart> searchSpareParts(String searchTerm) {
        String searchLower = searchTerm.toLowerCase();
        return spareParts.values().stream()
                .filter(part -> part.getPartName().toLowerCase().contains(searchLower) ||
                               part.getPartNumber().toLowerCase().contains(searchLower))
                .toList();
    }

    /**
     * Get transaction history for a spare part
     */
    public List<InventoryTransaction> getTransactionHistory(Long sparePartId) {
        return transactions.stream()
                .filter(transaction -> transaction.getSparePartId().equals(sparePartId))
                .toList();
    }

    // Helper methods
    private Inventory findInventoryBySparePartId(Long sparePartId) {
        return inventories.values().stream()
                .filter(inv -> inv.getSparePartId().equals(sparePartId))
                .findFirst()
                .orElse(null);
    }

    private void recordTransaction(Long sparePartId, Long inventoryId, 
                                 InventoryTransaction.TransactionType type, 
                                 int quantity, String referenceNumber, String performedBy) {
        InventoryTransaction transaction = new InventoryTransaction(
                sparePartId, inventoryId, type, quantity, referenceNumber, performedBy);
        transaction.setId(nextTransactionId++);
        transactions.add(transaction);
    }

    // Getters for accessing the stored data
    public Map<Long, SparePart> getAllSpareParts() {
        return new HashMap<>(spareParts);
    }

    public Map<Long, Supplier> getAllSuppliers() {
        return new HashMap<>(suppliers);
    }

    public Map<Long, Category> getAllCategories() {
        return new HashMap<>(categories);
    }

    public List<InventoryTransaction> getAllTransactions() {
        return new ArrayList<>(transactions);
    }
}

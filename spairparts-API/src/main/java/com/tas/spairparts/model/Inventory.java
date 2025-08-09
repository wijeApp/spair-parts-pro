package com.tas.spairparts.model;

import java.time.LocalDateTime;

/**
 * Represents inventory stock information for spare parts
 */
public class Inventory {
    private Long id;
    private Long sparePartId;
    private int currentStock;
    private int reservedStock;
    private int availableStock;
    private String warehouseLocation;
    private LocalDateTime lastStockUpdate;
    private String lastUpdatedBy;

    // Default constructor
    public Inventory() {
        this.lastStockUpdate = LocalDateTime.now();
        this.currentStock = 0;
        this.reservedStock = 0;
        this.availableStock = 0;
    }

    // Constructor with essential fields
    public Inventory(Long sparePartId, int currentStock, String warehouseLocation) {
        this();
        this.sparePartId = sparePartId;
        this.currentStock = currentStock;
        this.availableStock = currentStock;
        this.warehouseLocation = warehouseLocation;
    }

    // Method to update stock levels
    public void updateStock(int newStock, String updatedBy) {
        this.currentStock = newStock;
        this.availableStock = newStock - reservedStock;
        this.lastStockUpdate = LocalDateTime.now();
        this.lastUpdatedBy = updatedBy;
    }

    // Method to reserve stock
    public boolean reserveStock(int quantity) {
        if (availableStock >= quantity) {
            this.reservedStock += quantity;
            this.availableStock -= quantity;
            this.lastStockUpdate = LocalDateTime.now();
            return true;
        }
        return false;
    }

    // Method to release reserved stock
    public void releaseReservedStock(int quantity) {
        if (this.reservedStock >= quantity) {
            this.reservedStock -= quantity;
            this.availableStock += quantity;
            this.lastStockUpdate = LocalDateTime.now();
        }
    }

    // Method to check if stock is below minimum level
    public boolean isLowStock(int minimumLevel) {
        return currentStock <= minimumLevel;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getSparePartId() {
        return sparePartId;
    }

    public void setSparePartId(Long sparePartId) {
        this.sparePartId = sparePartId;
    }

    public int getCurrentStock() {
        return currentStock;
    }

    public void setCurrentStock(int currentStock) {
        this.currentStock = currentStock;
        this.availableStock = currentStock - reservedStock;
    }

    public int getReservedStock() {
        return reservedStock;
    }

    public void setReservedStock(int reservedStock) {
        this.reservedStock = reservedStock;
        this.availableStock = currentStock - reservedStock;
    }

    public int getAvailableStock() {
        return availableStock;
    }

    public void setAvailableStock(int availableStock) {
        this.availableStock = availableStock;
    }

    public String getWarehouseLocation() {
        return warehouseLocation;
    }

    public void setWarehouseLocation(String warehouseLocation) {
        this.warehouseLocation = warehouseLocation;
    }

    public LocalDateTime getLastStockUpdate() {
        return lastStockUpdate;
    }

    public void setLastStockUpdate(LocalDateTime lastStockUpdate) {
        this.lastStockUpdate = lastStockUpdate;
    }

    public String getLastUpdatedBy() {
        return lastUpdatedBy;
    }

    public void setLastUpdatedBy(String lastUpdatedBy) {
        this.lastUpdatedBy = lastUpdatedBy;
    }

    @Override
    public String toString() {
        return "Inventory{" +
                "id=" + id +
                ", sparePartId=" + sparePartId +
                ", currentStock=" + currentStock +
                ", reservedStock=" + reservedStock +
                ", availableStock=" + availableStock +
                ", warehouseLocation='" + warehouseLocation + '\'' +
                ", lastStockUpdate=" + lastStockUpdate +
                '}';
    }
}

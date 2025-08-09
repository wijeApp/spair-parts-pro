package com.tas.spairparts.model;

import java.time.LocalDateTime;

/**
 * Represents inventory transactions (stock movements)
 */
public class InventoryTransaction {
    private Long id;
    private Long sparePartId;
    private Long inventoryId;
    private TransactionType transactionType;
    private int quantity;
    private String referenceNumber;
    private String notes;
    private String performedBy;
    private LocalDateTime transactionDate;

    // Enum for transaction types
    public enum TransactionType {
        STOCK_IN,           // Receiving new stock
        STOCK_OUT,          // Issuing stock
        ADJUSTMENT_IN,      // Positive stock adjustment
        ADJUSTMENT_OUT,     // Negative stock adjustment
        TRANSFER_IN,        // Stock transfer in
        TRANSFER_OUT,       // Stock transfer out
        RETURN,             // Stock return
        DAMAGE,             // Damaged stock write-off
        EXPIRED             // Expired stock write-off
    }

    // Default constructor
    public InventoryTransaction() {
        this.transactionDate = LocalDateTime.now();
    }

    // Constructor with essential fields
    public InventoryTransaction(Long sparePartId, Long inventoryId, TransactionType transactionType, 
                              int quantity, String performedBy) {
        this();
        this.sparePartId = sparePartId;
        this.inventoryId = inventoryId;
        this.transactionType = transactionType;
        this.quantity = quantity;
        this.performedBy = performedBy;
    }

    // Constructor with reference number
    public InventoryTransaction(Long sparePartId, Long inventoryId, TransactionType transactionType, 
                              int quantity, String referenceNumber, String performedBy) {
        this(sparePartId, inventoryId, transactionType, quantity, performedBy);
        this.referenceNumber = referenceNumber;
    }

    // Method to check if transaction increases stock
    public boolean isStockIncreasing() {
        return transactionType == TransactionType.STOCK_IN || 
               transactionType == TransactionType.ADJUSTMENT_IN || 
               transactionType == TransactionType.TRANSFER_IN ||
               transactionType == TransactionType.RETURN;
    }

    // Method to check if transaction decreases stock
    public boolean isStockDecreasing() {
        return transactionType == TransactionType.STOCK_OUT || 
               transactionType == TransactionType.ADJUSTMENT_OUT || 
               transactionType == TransactionType.TRANSFER_OUT ||
               transactionType == TransactionType.DAMAGE ||
               transactionType == TransactionType.EXPIRED;
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

    public Long getInventoryId() {
        return inventoryId;
    }

    public void setInventoryId(Long inventoryId) {
        this.inventoryId = inventoryId;
    }

    public TransactionType getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(TransactionType transactionType) {
        this.transactionType = transactionType;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getReferenceNumber() {
        return referenceNumber;
    }

    public void setReferenceNumber(String referenceNumber) {
        this.referenceNumber = referenceNumber;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getPerformedBy() {
        return performedBy;
    }

    public void setPerformedBy(String performedBy) {
        this.performedBy = performedBy;
    }

    public LocalDateTime getTransactionDate() {
        return transactionDate;
    }

    public void setTransactionDate(LocalDateTime transactionDate) {
        this.transactionDate = transactionDate;
    }

    @Override
    public String toString() {
        return "InventoryTransaction{" +
                "id=" + id +
                ", sparePartId=" + sparePartId +
                ", transactionType=" + transactionType +
                ", quantity=" + quantity +
                ", referenceNumber='" + referenceNumber + '\'' +
                ", performedBy='" + performedBy + '\'' +
                ", transactionDate=" + transactionDate +
                '}';
    }
}

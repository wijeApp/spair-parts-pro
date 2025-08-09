package com.tas.spairparts.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Represents a purchase order for spare parts
 */
public class PurchaseOrder {
    private Long id;
    private String orderNumber;
    private Long supplierId;
    private OrderStatus status;
    private LocalDateTime orderDate;
    private LocalDateTime expectedDeliveryDate;
    private LocalDateTime actualDeliveryDate;
    private BigDecimal totalAmount;
    private String currency;
    private String notes;
    private String createdBy;
    private LocalDateTime createdDate;
    private LocalDateTime lastModifiedDate;

    // Enum for order status
    public enum OrderStatus {
        DRAFT,
        PENDING,
        APPROVED,
        SENT_TO_SUPPLIER,
        PARTIALLY_RECEIVED,
        RECEIVED,
        CANCELLED
    }

    // Default constructor
    public PurchaseOrder() {
        this.orderDate = LocalDateTime.now();
        this.createdDate = LocalDateTime.now();
        this.lastModifiedDate = LocalDateTime.now();
        this.status = OrderStatus.DRAFT;
        this.currency = "USD";
        this.totalAmount = BigDecimal.ZERO;
    }

    // Constructor with essential fields
    public PurchaseOrder(String orderNumber, Long supplierId, String createdBy) {
        this();
        this.orderNumber = orderNumber;
        this.supplierId = supplierId;
        this.createdBy = createdBy;
    }

    // Method to calculate total amount
    public void calculateTotalAmount(BigDecimal amount) {
        this.totalAmount = amount;
        this.lastModifiedDate = LocalDateTime.now();
    }

    // Method to update status
    public void updateStatus(OrderStatus newStatus) {
        this.status = newStatus;
        this.lastModifiedDate = LocalDateTime.now();
        
        if (newStatus == OrderStatus.RECEIVED && this.actualDeliveryDate == null) {
            this.actualDeliveryDate = LocalDateTime.now();
        }
    }

    // Method to check if order is overdue
    public boolean isOverdue() {
        if (expectedDeliveryDate == null || status == OrderStatus.RECEIVED || status == OrderStatus.CANCELLED) {
            return false;
        }
        return LocalDateTime.now().isAfter(expectedDeliveryDate);
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(String orderNumber) {
        this.orderNumber = orderNumber;
    }

    public Long getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(Long supplierId) {
        this.supplierId = supplierId;
    }

    public OrderStatus getStatus() {
        return status;
    }

    public void setStatus(OrderStatus status) {
        this.status = status;
    }

    public LocalDateTime getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(LocalDateTime orderDate) {
        this.orderDate = orderDate;
    }

    public LocalDateTime getExpectedDeliveryDate() {
        return expectedDeliveryDate;
    }

    public void setExpectedDeliveryDate(LocalDateTime expectedDeliveryDate) {
        this.expectedDeliveryDate = expectedDeliveryDate;
    }

    public LocalDateTime getActualDeliveryDate() {
        return actualDeliveryDate;
    }

    public void setActualDeliveryDate(LocalDateTime actualDeliveryDate) {
        this.actualDeliveryDate = actualDeliveryDate;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public LocalDateTime getLastModifiedDate() {
        return lastModifiedDate;
    }

    public void setLastModifiedDate(LocalDateTime lastModifiedDate) {
        this.lastModifiedDate = lastModifiedDate;
    }

    @Override
    public String toString() {
        return "PurchaseOrder{" +
                "id=" + id +
                ", orderNumber='" + orderNumber + '\'' +
                ", supplierId=" + supplierId +
                ", status=" + status +
                ", orderDate=" + orderDate +
                ", expectedDeliveryDate=" + expectedDeliveryDate +
                ", totalAmount=" + totalAmount +
                ", currency='" + currency + '\'' +
                ", createdBy='" + createdBy + '\'' +
                '}';
    }
}

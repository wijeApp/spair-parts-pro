package com.tas.spairparts.model;

import java.math.BigDecimal;

/**
 * Represents individual line items in a purchase order
 */
public class PurchaseOrderItem {
    private Long id;
    private Long purchaseOrderId;
    private Long sparePartId;
    private int quantityOrdered;
    private int quantityReceived;
    private BigDecimal unitPrice;
    private BigDecimal totalPrice;
    private String notes;

    // Default constructor
    public PurchaseOrderItem() {
        this.quantityReceived = 0;
        this.totalPrice = BigDecimal.ZERO;
    }

    // Constructor with essential fields
    public PurchaseOrderItem(Long purchaseOrderId, Long sparePartId, int quantityOrdered, BigDecimal unitPrice) {
        this();
        this.purchaseOrderId = purchaseOrderId;
        this.sparePartId = sparePartId;
        this.quantityOrdered = quantityOrdered;
        this.unitPrice = unitPrice;
        calculateTotalPrice();
    }

    // Method to calculate total price
    public void calculateTotalPrice() {
        if (unitPrice != null) {
            this.totalPrice = unitPrice.multiply(BigDecimal.valueOf(quantityOrdered));
        }
    }

    // Method to receive items
    public void receiveItems(int quantity) {
        if (quantity > 0 && (quantityReceived + quantity) <= quantityOrdered) {
            this.quantityReceived += quantity;
        }
    }

    // Method to check if item is fully received
    public boolean isFullyReceived() {
        return quantityReceived >= quantityOrdered;
    }

    // Method to check if item is partially received
    public boolean isPartiallyReceived() {
        return quantityReceived > 0 && quantityReceived < quantityOrdered;
    }

    // Method to get remaining quantity to receive
    public int getRemainingQuantity() {
        return quantityOrdered - quantityReceived;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getPurchaseOrderId() {
        return purchaseOrderId;
    }

    public void setPurchaseOrderId(Long purchaseOrderId) {
        this.purchaseOrderId = purchaseOrderId;
    }

    public Long getSparePartId() {
        return sparePartId;
    }

    public void setSparePartId(Long sparePartId) {
        this.sparePartId = sparePartId;
    }

    public int getQuantityOrdered() {
        return quantityOrdered;
    }

    public void setQuantityOrdered(int quantityOrdered) {
        this.quantityOrdered = quantityOrdered;
        calculateTotalPrice();
    }

    public int getQuantityReceived() {
        return quantityReceived;
    }

    public void setQuantityReceived(int quantityReceived) {
        this.quantityReceived = quantityReceived;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
        calculateTotalPrice();
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    @Override
    public String toString() {
        return "PurchaseOrderItem{" +
                "id=" + id +
                ", purchaseOrderId=" + purchaseOrderId +
                ", sparePartId=" + sparePartId +
                ", quantityOrdered=" + quantityOrdered +
                ", quantityReceived=" + quantityReceived +
                ", unitPrice=" + unitPrice +
                ", totalPrice=" + totalPrice +
                '}';
    }
}

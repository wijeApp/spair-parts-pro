package com.tas.spairparts;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * DTO class for dashboard statistics
 */
public class DashboardStatistics {
    private long totalItems;
    private BigDecimal totalValue;
    private long lowStockItems;
    private BigDecimal averagePrice;
    private long totalQuantity;
    private BigDecimal highestPrice;
    private BigDecimal lowestPrice;
    private String lastUpdated;

    // Default constructor
    public DashboardStatistics() {
        this.totalItems = 0;
        this.totalValue = BigDecimal.ZERO;
        this.lowStockItems = 0;
        this.averagePrice = BigDecimal.ZERO;
        this.totalQuantity = 0;
        this.highestPrice = BigDecimal.ZERO;
        this.lowestPrice = BigDecimal.ZERO;
        this.lastUpdated = "";
    }

    // Constructor with main statistics
    public DashboardStatistics(long totalItems, BigDecimal totalValue, long lowStockItems, BigDecimal averagePrice) {
        this.totalItems = totalItems;
        this.totalValue = totalValue != null ? totalValue.setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO;
        this.lowStockItems = lowStockItems;
        this.averagePrice = averagePrice != null ? averagePrice.setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO;
        this.totalQuantity = 0;
        this.highestPrice = BigDecimal.ZERO;
        this.lowestPrice = BigDecimal.ZERO;
        this.lastUpdated = "";
    }

    // Getters and Setters
    public long getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(long totalItems) {
        this.totalItems = totalItems;
    }

    public BigDecimal getTotalValue() {
        return totalValue;
    }

    public void setTotalValue(BigDecimal totalValue) {
        this.totalValue = totalValue != null ? totalValue.setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO;
    }

    public long getLowStockItems() {
        return lowStockItems;
    }

    public void setLowStockItems(long lowStockItems) {
        this.lowStockItems = lowStockItems;
    }

    public BigDecimal getAveragePrice() {
        return averagePrice;
    }

    public void setAveragePrice(BigDecimal averagePrice) {
        this.averagePrice = averagePrice != null ? averagePrice.setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO;
    }

    public long getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(long totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public BigDecimal getHighestPrice() {
        return highestPrice;
    }

    public void setHighestPrice(BigDecimal highestPrice) {
        this.highestPrice = highestPrice != null ? highestPrice.setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO;
    }

    public BigDecimal getLowestPrice() {
        return lowestPrice;
    }

    public void setLowestPrice(BigDecimal lowestPrice) {
        this.lowestPrice = lowestPrice != null ? lowestPrice.setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO;
    }

    public String getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(String lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    // Utility method to get formatted total value
    public String getFormattedTotalValue() {
        return totalValue.toString();
    }

    // Utility method to get formatted average price
    public String getFormattedAveragePrice() {
        return averagePrice.toString();
    }

    @Override
    public String toString() {
        return "DashboardStatistics{" +
                "totalItems=" + totalItems +
                ", totalValue=" + totalValue +
                ", lowStockItems=" + lowStockItems +
                ", averagePrice=" + averagePrice +
                ", totalQuantity=" + totalQuantity +
                ", highestPrice=" + highestPrice +
                ", lowestPrice=" + lowestPrice +
                ", lastUpdated='" + lastUpdated + '\'' +
                '}';
    }
}

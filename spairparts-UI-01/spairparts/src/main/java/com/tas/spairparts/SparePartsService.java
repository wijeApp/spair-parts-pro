package com.tas.spairparts;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
public class SparePartsService {
    
    @Autowired
    private SparePartRepository repository;
    
    public List<SparePartItem> getAll() {
        return repository.findAll();
    }

    public SparePartItem getById(Long id) {
        return repository.findById(id).orElse(null);
    }

    public SparePartItem create(SparePartItem item) {
        return repository.save(item);
    }

    public SparePartItem update(Long id, SparePartItem item) {
        if (!repository.existsById(id)) return null;
        item.setId(id);
        return repository.save(item);
    }

    public boolean delete(Long id) {
        if (repository.existsById(id)) {
            repository.deleteById(id);
            return true;
        }
        return false;
    }

    /**
     * Calculate comprehensive dashboard statistics
     * @return DashboardStatistics object with all calculated values
     */
    public DashboardStatistics calculateDashboardStatistics() {
        List<SparePartItem> allItems = repository.findAll();
        
        if (allItems == null || allItems.isEmpty()) {
            DashboardStatistics emptyStats = new DashboardStatistics();
            emptyStats.setLastUpdated(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            return emptyStats;
        }

        // Calculate statistics
        long totalItems = allItems.size();
        BigDecimal totalValue = BigDecimal.ZERO;
        long totalQuantity = 0;
        long lowStockItems = 0;
        BigDecimal highestPrice = BigDecimal.ZERO;
        BigDecimal lowestPrice = null;
          for (SparePartItem item : allItems) {
            if (item != null) {
                // Calculate total value (price * quantity)
                Double itemPrice = item.getPrice() != null ? item.getPrice() : 0.0;
                Integer itemQuantity = item.getQuantity() != null ? item.getQuantity() : 0;
                
                BigDecimal itemValue = BigDecimal.valueOf(itemPrice).multiply(BigDecimal.valueOf(itemQuantity));
                totalValue = totalValue.add(itemValue);
                
                // Count total quantity
                totalQuantity += itemQuantity;
                
                // Count low stock items (quantity < 10)
                if (itemQuantity < 10) {
                    lowStockItems++;
                }
                
                // Track highest price
                BigDecimal itemPriceBD = BigDecimal.valueOf(itemPrice);
                if (itemPriceBD.compareTo(highestPrice) > 0) {
                    highestPrice = itemPriceBD;
                }
                
                // Track lowest price
                if (lowestPrice == null || (itemPrice > 0.0 && itemPriceBD.compareTo(lowestPrice) < 0)) {
                    lowestPrice = itemPriceBD;
                }
            }
        }

        // Calculate average price (total value / total quantity)
        BigDecimal averagePrice = BigDecimal.ZERO;
        if (totalQuantity > 0) {
            averagePrice = totalValue.divide(BigDecimal.valueOf(totalQuantity), 2, RoundingMode.HALF_UP);
        }

        // Create statistics object
        DashboardStatistics stats = new DashboardStatistics(totalItems, totalValue, lowStockItems, averagePrice);
        stats.setTotalQuantity(totalQuantity);
        stats.setHighestPrice(highestPrice);
        stats.setLowestPrice(lowestPrice != null ? lowestPrice : BigDecimal.ZERO);
        stats.setLastUpdated(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));

        return stats;
    }

    /**
     * Get items with low stock (quantity < threshold)
     * @param threshold the stock threshold (default: 10)
     * @return list of low stock items
     */
    public List<SparePartItem> getLowStockItems(int threshold) {
        List<SparePartItem> allItems = repository.findAll();
        return allItems.stream()
                .filter(item -> item.getQuantity() != null && item.getQuantity() < threshold)
                .sorted(Comparator.comparing(SparePartItem::getQuantity))
                .toList();
    }

    /**
     * Get items with low stock using default threshold of 10
     * @return list of low stock items
     */
    public List<SparePartItem> getLowStockItems() {
        return getLowStockItems(10);
    }

    /**
     * Get total count of items
     * @return total number of spare part items
     */
    public long getTotalItemCount() {
        return repository.count();
    }    /**
     * Get total inventory value
     * @return total value of all items (price * quantity)
     */
    public BigDecimal getTotalInventoryValue() {
        List<SparePartItem> allItems = repository.findAll();
        return allItems.stream()
                .filter(item -> item.getPrice() != null && item.getQuantity() != null)
                .map(item -> BigDecimal.valueOf(item.getPrice()).multiply(BigDecimal.valueOf(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}

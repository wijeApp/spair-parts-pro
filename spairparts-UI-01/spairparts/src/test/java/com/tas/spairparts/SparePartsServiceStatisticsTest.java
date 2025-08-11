package com.tas.spairparts;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

/**
 * Unit tests for SparePartsService statistics calculation
 */
@ExtendWith(MockitoExtension.class)
public class SparePartsServiceStatisticsTest {

    @Mock
    private SparePartRepository repository;

    @InjectMocks
    private SparePartsService sparePartsService;

    private List<SparePartItem> testItems;

    @BeforeEach
    void setUp() {
        // Create test data
        SparePartItem item1 = new SparePartItem("Engine Oil", "High quality engine oil", 25.50, 15);
        item1.setId(1L);
        
        SparePartItem item2 = new SparePartItem("Brake Pads", "Front brake pads", 45.00, 8);
        item2.setId(2L);
        
        SparePartItem item3 = new SparePartItem("Air Filter", "Engine air filter", 12.75, 20);
        item3.setId(3L);
        
        SparePartItem item4 = new SparePartItem("Spark Plug", "Iridium spark plug", 8.99, 5);
        item4.setId(4L);

        testItems = Arrays.asList(item1, item2, item3, item4);
    }

    @Test
    void testCalculateDashboardStatistics_WithValidData() {
        // Arrange
        when(repository.findAll()).thenReturn(testItems);

        // Act
        DashboardStatistics stats = sparePartsService.calculateDashboardStatistics();

        // Assert
        assertNotNull(stats);
        assertEquals(4, stats.getTotalItems());
        
        // Total value = (25.50*15) + (45.00*8) + (12.75*20) + (8.99*5)
        // = 382.5 + 360 + 255 + 44.95 = 1042.45
        assertEquals(new BigDecimal("1042.45"), stats.getTotalValue());
        
        // Low stock items (quantity < 10): Brake Pads (8) and Spark Plug (5)
        assertEquals(2, stats.getLowStockItems());
        
        // Average price = 1042.45 / (15+8+20+5) = 1042.45 / 48 = 21.72
        assertEquals(new BigDecimal("21.72"), stats.getAveragePrice());
        
        assertNotNull(stats.getLastUpdated());
    }

    @Test
    void testCalculateDashboardStatistics_WithEmptyData() {
        // Arrange
        when(repository.findAll()).thenReturn(Collections.emptyList());

        // Act
        DashboardStatistics stats = sparePartsService.calculateDashboardStatistics();

        // Assert
        assertNotNull(stats);
        assertEquals(0, stats.getTotalItems());
        assertEquals(BigDecimal.ZERO, stats.getTotalValue());
        assertEquals(0, stats.getLowStockItems());
        assertEquals(BigDecimal.ZERO, stats.getAveragePrice());
    }

    @Test
    void testCalculateDashboardStatistics_WithNullValues() {
        // Arrange
        SparePartItem itemWithNulls = new SparePartItem("Test Item", "Description", null, null);
        itemWithNulls.setId(1L);
        
        when(repository.findAll()).thenReturn(Arrays.asList(itemWithNulls));

        // Act
        DashboardStatistics stats = sparePartsService.calculateDashboardStatistics();        // Assert
        assertNotNull(stats);
        assertEquals(1, stats.getTotalItems());
        assertEquals(0, stats.getTotalValue().compareTo(BigDecimal.ZERO));
        assertEquals(1, stats.getLowStockItems()); // null quantity treated as 0, which is < 10
        assertEquals(0, stats.getAveragePrice().compareTo(BigDecimal.ZERO));
    }

    @Test
    void testGetLowStockItems_DefaultThreshold() {
        // Arrange
        when(repository.findAll()).thenReturn(testItems);

        // Act
        List<SparePartItem> lowStockItems = sparePartsService.getLowStockItems();

        // Assert
        assertEquals(2, lowStockItems.size());
        
        // Should be sorted by quantity
        assertEquals("Spark Plug", lowStockItems.get(0).getName());
        assertEquals(5, lowStockItems.get(0).getQuantity());
        assertEquals("Brake Pads", lowStockItems.get(1).getName());
        assertEquals(8, lowStockItems.get(1).getQuantity());
    }

    @Test
    void testGetLowStockItems_CustomThreshold() {
        // Arrange
        when(repository.findAll()).thenReturn(testItems);

        // Act
        List<SparePartItem> lowStockItems = sparePartsService.getLowStockItems(16);

        // Assert
        assertEquals(3, lowStockItems.size()); // All except Air Filter (20)
    }

    @Test
    void testGetTotalInventoryValue() {
        // Arrange
        when(repository.findAll()).thenReturn(testItems);

        // Act
        BigDecimal totalValue = sparePartsService.getTotalInventoryValue();

        // Assert
        assertEquals(new BigDecimal("1042.45"), totalValue);
    }

    @Test
    void testGetTotalItemCount() {
        // Arrange
        when(repository.count()).thenReturn(4L);

        // Act
        long count = sparePartsService.getTotalItemCount();

        // Assert
        assertEquals(4L, count);
    }
}

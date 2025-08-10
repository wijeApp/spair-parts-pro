package com.tas.spairparts;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/test")
public class DatabaseTestController {
    
    @Autowired
    private DataSource dataSource;
    
    @Autowired
    private SparePartRepository sparePartRepository;
    
    @GetMapping("/db-connection")
    public ResponseEntity<Map<String, Object>> testDatabaseConnection() {
        Map<String, Object> result = new HashMap<>();
        
        try (Connection connection = dataSource.getConnection()) {
            DatabaseMetaData metaData = connection.getMetaData();
            
            result.put("status", "SUCCESS");
            result.put("database_url", metaData.getURL());
            result.put("database_name", connection.getCatalog());
            result.put("database_version", metaData.getDatabaseProductVersion());
            result.put("driver_name", metaData.getDriverName());
            result.put("driver_version", metaData.getDriverVersion());
            result.put("connection_valid", connection.isValid(5));
            
            // Test if spare_part_items table exists
            try (ResultSet tables = metaData.getTables(null, null, "spare_part_items", null)) {
                boolean tableExists = tables.next();
                result.put("spare_part_items_table_exists", tableExists);
            }
            
            // Test repository count
            try {
                long count = sparePartRepository.count();
                result.put("spare_parts_count", count);
            } catch (Exception e) {
                result.put("spare_parts_count_error", e.getMessage());
            }
            
        } catch (Exception e) {
            result.put("status", "ERROR");
            result.put("error_message", e.getMessage());
            result.put("error_type", e.getClass().getSimpleName());
            e.printStackTrace();
        }        
        return ResponseEntity.ok(result);
    }
    
    @GetMapping("/create-sample")
    public ResponseEntity<Map<String, Object>> createSampleItem() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            SparePartItem testItem = new SparePartItem(
                "Test Engine Oil", 
                "High-quality synthetic motor oil for testing database insert", 
                25.99, 
                10
            );
            
            SparePartItem saved = sparePartRepository.save(testItem);
            result.put("status", "SUCCESS");
            result.put("created_item", saved);
            result.put("message", "Test item created successfully!");
            
        } catch (Exception e) {
            result.put("status", "ERROR");
            result.put("error_message", e.getMessage());
            result.put("error_type", e.getClass().getSimpleName());
            e.printStackTrace();
        }
        
        return ResponseEntity.ok(result);
    }
}

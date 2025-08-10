package com.tas.spairparts;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/spareparts")
@CrossOrigin(origins = "*")
public class SparePartsController {
    @Autowired
    private SparePartsService service;
    
    @Autowired
    private UserRepository userRepository;

    @GetMapping
    public List<SparePartItem> getAll() {
        return service.getAll();
    }

    @GetMapping("/{id}")
    public SparePartItem getById(@PathVariable Long id) {
        return service.getById(id);
    }

    @PostMapping
    public SparePartItem create(@RequestBody SparePartItem item) {
        return service.create(item);
    }    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @RequestBody SparePartItem item, Authentication authentication) {
        // Check if user is authenticated
        if (authentication == null) {
            return ResponseEntity.status(401).body("Authentication required");
        }
        
        // Get user and check if admin
        String username = authentication.getName();
        User user = userRepository.findByUsername(username).orElse(null);
        
        if (user == null || !"ADMIN".equals(user.getRole())) {
            return ResponseEntity.status(403).body("Admin access required to update items");
        }
        
        // Perform update
        try {
            SparePartItem updatedItem = service.update(id, item);
            if (updatedItem != null) {
                return ResponseEntity.ok(updatedItem);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Failed to update item: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id, Authentication authentication) {
        // Check if user is authenticated
        if (authentication == null) {
            return ResponseEntity.status(401).body("Authentication required");
        }
        
        // Get user and check if admin
        String username = authentication.getName();
        User user = userRepository.findByUsername(username).orElse(null);
        
        if (user == null || !"ADMIN".equals(user.getRole())) {
            return ResponseEntity.status(403).body("Admin access required to delete items");
        }
        
        // Perform deletion
        boolean deleted = service.delete(id);
        
        if (deleted) {
            return ResponseEntity.ok().body("Item deleted successfully");
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}

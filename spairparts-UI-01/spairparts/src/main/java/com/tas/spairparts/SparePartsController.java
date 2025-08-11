package com.tas.spairparts;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/spareparts")
@CrossOrigin(origins = "*")
public class SparePartsController {
    @Autowired
    private SparePartsService service;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private FileUploadService fileUploadService;

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
    }
    
    // New endpoint for creating items with image
    @PostMapping("/with-image")
    public ResponseEntity<?> createWithImage(
            @RequestParam("name") String name,
            @RequestParam("description") String description,
            @RequestParam("price") Double price,
            @RequestParam("quantity") Integer quantity,
            @RequestParam(value = "currency", defaultValue = "LKR") String currency,
            @RequestParam(value = "image", required = false) MultipartFile image) {
        
        try {
            SparePartItem item = new SparePartItem(name, description, price, quantity);
            item.setCurrency(currency);
            
            // Handle image upload if provided
            if (image != null && !image.isEmpty()) {
                String imagePath = fileUploadService.saveImage(image);
                item.setImagePath(imagePath);
            }
            
            SparePartItem savedItem = service.create(item);
            return ResponseEntity.ok(savedItem);
        } catch (IOException e) {
            return ResponseEntity.badRequest().body("Failed to upload image: " + e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Failed to create item: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
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
    
    // New endpoint for updating items with image
    @PutMapping("/{id}/with-image")
    public ResponseEntity<?> updateWithImage(
            @PathVariable Long id,
            @RequestParam("name") String name,
            @RequestParam("description") String description,
            @RequestParam("price") Double price,
            @RequestParam("quantity") Integer quantity,
            @RequestParam(value = "currency", defaultValue = "LKR") String currency,
            @RequestParam(value = "image", required = false) MultipartFile image,
            Authentication authentication) {
        
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
        
        try {
            SparePartItem existingItem = service.getById(id);
            if (existingItem == null) {
                return ResponseEntity.notFound().build();
            }
            
            // Update basic fields
            existingItem.setName(name);
            existingItem.setDescription(description);
            existingItem.setPrice(price);
            existingItem.setQuantity(quantity);
            existingItem.setCurrency(currency);
            
            // Handle image update if provided
            if (image != null && !image.isEmpty()) {
                // Delete old image if exists
                if (existingItem.getImagePath() != null) {
                    fileUploadService.deleteImage(existingItem.getImagePath());
                }
                
                // Save new image
                String imagePath = fileUploadService.saveImage(image);
                existingItem.setImagePath(imagePath);
            }
            
            SparePartItem updatedItem = service.update(id, existingItem);
            return ResponseEntity.ok(updatedItem);
        } catch (IOException e) {
            return ResponseEntity.badRequest().body("Failed to upload image: " + e.getMessage());
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
        
        // Get item to delete its image
        SparePartItem item = service.getById(id);
        if (item != null && item.getImagePath() != null) {
            fileUploadService.deleteImage(item.getImagePath());
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

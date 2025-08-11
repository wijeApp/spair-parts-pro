package com.tas.spairparts;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service
public class FileUploadService {
    
    private final String uploadDir = "uploads/images/";
      public String saveImage(MultipartFile file) throws IOException {
        if (file.isEmpty()) {
            throw new IllegalArgumentException("File is empty");
        }
        
        // Validate file type
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new IllegalArgumentException("File must be an image");
        }
        
        // Create uploads directory if it doesn't exist
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
            System.out.println("Created upload directory: " + uploadPath.toAbsolutePath());
        }
        
        // Generate unique filename
        String originalFilename = file.getOriginalFilename();
        String fileExtension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }
        String uniqueFilename = UUID.randomUUID().toString() + fileExtension;
        
        // Save file
        Path filePath = uploadPath.resolve(uniqueFilename);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
        
        System.out.println("=== IMAGE UPLOAD SUCCESS ===");
        System.out.println("Original filename: " + originalFilename);
        System.out.println("Saved as: " + uniqueFilename);
        System.out.println("Full path: " + filePath.toAbsolutePath());
        System.out.println("File size: " + file.getSize() + " bytes");
        System.out.println("Content type: " + contentType);
        System.out.println("Access URL: /uploads/" + uniqueFilename);
        System.out.println("============================");
        
        // Return just the unique filename for storing in database
        return uniqueFilename;
    }
    
    public void deleteImage(String imagePath) {
        if (imagePath != null && !imagePath.isEmpty()) {
            try {
                // imagePath is now the filename
                Path filePath = Paths.get(uploadDir, imagePath);
                Files.deleteIfExists(filePath);
            } catch (IOException e) {
                // Log error but don't throw exception
                System.err.println("Failed to delete image: " + imagePath);
            }
        }
    }
}

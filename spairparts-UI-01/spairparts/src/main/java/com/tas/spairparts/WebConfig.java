package com.tas.spairparts;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Get absolute path to uploads directory
        Path uploadDir = Paths.get("uploads/images/").toAbsolutePath().normalize();
        String uploadPath = uploadDir.toUri().toString();
        
        System.out.println("=== IMAGE UPLOAD CONFIGURATION ===");
        System.out.println("Upload directory absolute path: " + uploadDir.toString());
        System.out.println("Upload directory URI: " + uploadPath);
        System.out.println("URL pattern: /uploads/**");
        System.out.println("===================================");
        
        // Configure static resource handler for uploaded images
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(uploadPath)
                .setCachePeriod(3600) // Cache for 1 hour
                .resourceChain(true);
    }
}

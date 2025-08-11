package com.tas.spairparts;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/debug")
public class ImageDebugController {

    @GetMapping("/image-config")
    public ResponseEntity<Map<String, Object>> getImageConfiguration() {
        Map<String, Object> info = new HashMap<>();
        
        try {
            // Check upload directory
            Path uploadDir = Paths.get("uploads/images/").toAbsolutePath().normalize();
            File uploadDirFile = uploadDir.toFile();
            
            info.put("uploadDirectory", uploadDir.toString());
            info.put("uploadDirectoryExists", uploadDirFile.exists());
            info.put("uploadDirectoryCanRead", uploadDirFile.canRead());
            info.put("uploadDirectoryCanWrite", uploadDirFile.canWrite());
            
            if (uploadDirFile.exists() && uploadDirFile.isDirectory()) {
                File[] files = uploadDirFile.listFiles();
                if (files != null) {
                    info.put("fileCount", files.length);
                    String[] fileNames = new String[Math.min(files.length, 10)]; // Show max 10 files
                    for (int i = 0; i < Math.min(files.length, 10); i++) {
                        fileNames[i] = files[i].getName();
                    }
                    info.put("sampleFiles", fileNames);
                } else {
                    info.put("fileCount", 0);
                    info.put("sampleFiles", new String[0]);
                }
            }
            
            info.put("accessUrl", "/uploads/");
            info.put("status", "OK");
            
        } catch (Exception e) {
            info.put("status", "ERROR");
            info.put("error", e.getMessage());
        }
        
        return ResponseEntity.ok(info);
    }
}

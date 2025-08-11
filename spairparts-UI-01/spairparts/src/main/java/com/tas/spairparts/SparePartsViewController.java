package com.tas.spairparts;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.security.Principal;
import java.util.List;

@Controller
public class SparePartsViewController {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private SparePartsService sparePartsService;
    
    @Autowired
    private FileUploadService fileUploadService;
      private void addCommonModelAttributes(Model model, Principal principal) {
        List<SparePartItem> spareparts = sparePartsService.getAll();
        model.addAttribute("spareparts", spareparts);
        model.addAttribute("newSparepart", new SparePartItem());
        
        // Calculate and add dashboard statistics
        DashboardStatistics stats = sparePartsService.calculateDashboardStatistics();
        model.addAttribute("dashboardStats", stats);
        
        // Individual statistics attributes for backward compatibility
        model.addAttribute("totalItems", stats.getTotalItems());
        model.addAttribute("totalValue", stats.getFormattedTotalValue());
        model.addAttribute("lowStockItems", stats.getLowStockItems());
        model.addAttribute("averagePrice", stats.getFormattedAveragePrice());
        
        System.out.println("=== STATISTICS DEBUG ===");
        System.out.println("Total Items: " + stats.getTotalItems());
        System.out.println("Total Value: " + stats.getFormattedTotalValue());
        System.out.println("Low Stock Items: " + stats.getLowStockItems());
        System.out.println("Average Price: " + stats.getFormattedAveragePrice());
        System.out.println("Spare Parts Count: " + (spareparts != null ? spareparts.size() : 0));
        System.out.println("=== END STATISTICS DEBUG ===");
        
        if (principal != null) {
            String username = principal.getName();
            model.addAttribute("username", username);
            
            User user = userRepository.findByUsername(username).orElse(null);
            if (user != null) {
                String userRole = user.getRole();
                boolean isAdmin = "ADMIN".equals(userRole);
                model.addAttribute("userRole", userRole);
                model.addAttribute("isAdmin", isAdmin);
            } else {
                model.addAttribute("userRole", "UNKNOWN");
                model.addAttribute("isAdmin", false);
            }
        } else {
            model.addAttribute("username", "Anonymous");
            model.addAttribute("userRole", "ANONYMOUS");
            model.addAttribute("isAdmin", false);
        }
    }

    @GetMapping("/dashboard")
    public String viewDashboard(Model model, Principal principal) {
        System.out.println("=== DASHBOARD ACCESS DEBUG ===");
        addCommonModelAttributes(model, principal);
        System.out.println("=== END DASHBOARD DEBUG ===");
        return "spareparts-sample";
    }

    @GetMapping("/")
    public String home(Model model, Principal principal) {
        System.out.println("=== HOME ACCESS DEBUG ===");
        addCommonModelAttributes(model, principal);
        System.out.println("=== END HOME DEBUG ===");
        return "spareparts-sample";
    }
      
    @GetMapping("/spareparts-sample")
    public String sparePartsSample(Model model, Principal principal) {
        addCommonModelAttributes(model, principal);
        if (principal != null) {
            User user = userRepository.findByUsername(principal.getName()).orElse(null);
            if (user != null) {
                boolean isAdmin = "ADMIN".equals(user.getRole());
                System.out.println("SparePartsSample: User=" + principal.getName() + ", Role=" + user.getRole() + ", isAdmin=" + isAdmin);
            }
        }
        return "spareparts-sample";
    }
    
    // Form submission handler for adding new spare parts with image
    @PostMapping("/spareparts/add")
    public String addSparePart(
            @ModelAttribute("newSparepart") SparePartItem newSparepart,
            @RequestParam(value = "image", required = false) MultipartFile image,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            Model model,
            Principal principal) {
        
        try {
            // Handle image upload if provided
            if (image != null && !image.isEmpty()) {
                String imagePath = fileUploadService.saveImage(image);
                newSparepart.setImagePath(imagePath);
            }
            
            // Save the spare part
            sparePartsService.create(newSparepart);
            redirectAttributes.addFlashAttribute("successMessage", "Item added successfully!");
            
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to upload image: " + e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to add item: " + e.getMessage());
        }
        
        return "redirect:/spareparts-sample";
    }
    
    // Debug endpoint to check user roles
    @GetMapping("/debug/users")
    public String debugUsers(Model model, Principal principal) {
        System.out.println("=== DEBUG USERS ENDPOINT ===");
        
        // Get all users from database
        Iterable<User> allUsers = userRepository.findAll();
        StringBuilder userInfo = new StringBuilder();
        
        userInfo.append("All users in database:\n");
        for (User user : allUsers) {
            userInfo.append(String.format("- Username: %s, Role: %s, Enabled: %s\n", 
                user.getUsername(), user.getRole(), user.isEnabled()));
        }
        
        // Current user info
        if (principal != null) {
            userInfo.append("\nCurrent authenticated user: " + principal.getName());
            User currentUser = userRepository.findByUsername(principal.getName()).orElse(null);
            if (currentUser != null) {
                userInfo.append(String.format("\nCurrent user details: Role=%s, isAdmin=%s", 
                    currentUser.getRole(), "ADMIN".equals(currentUser.getRole())));
            }
        } else {
            userInfo.append("\nNo authenticated user");
        }
        
        System.out.println(userInfo.toString());
        model.addAttribute("userDebugInfo", userInfo.toString());
        model.addAttribute("currentUser", principal != null ? principal.getName() : "None");
        
        return "debug-users"; // We'll create this template
    }
    
    @GetMapping("/spareparts-responsive")
    public String sparePartsResponsive(Model model, Principal principal) {
        addCommonModelAttributes(model, principal);
        return "spareparts-responsive";
    }
}

package com.tas.spairparts;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import java.security.Principal;

@Controller
public class SparePartsViewController {
    
    @Autowired
    private UserRepository userRepository;    @GetMapping("/dashboard")
    public String viewDashboard(Model model, Principal principal) {
        System.out.println("=== DASHBOARD ACCESS DEBUG ===");
        
        if (principal != null) {
            String username = principal.getName();
            System.out.println("Authenticated user: " + username);
            model.addAttribute("username", username);
            
            // Get user role with detailed logging
            User user = userRepository.findByUsername(username).orElse(null);
            if (user != null) {
                String userRole = user.getRole();
                boolean isAdmin = "ADMIN".equals(userRole);
                
                System.out.println("User found in database:");
                System.out.println("  - Username: " + user.getUsername());
                System.out.println("  - Role: " + userRole);
                System.out.println("  - isAdmin: " + isAdmin);
                System.out.println("  - Enabled: " + user.isEnabled());
                
                model.addAttribute("userRole", userRole);
                model.addAttribute("isAdmin", isAdmin);
                
                System.out.println("Model attributes set:");
                System.out.println("  - username: " + username);
                System.out.println("  - userRole: " + userRole);
                System.out.println("  - isAdmin: " + isAdmin);
            } else {
                System.out.println("ERROR: User not found in database for username: " + username);
                model.addAttribute("userRole", "UNKNOWN");
                model.addAttribute("isAdmin", false);
            }
        } else {
            System.out.println("ERROR: No authenticated user (principal is null)");
            model.addAttribute("username", "Anonymous");
            model.addAttribute("userRole", "ANONYMOUS");
            model.addAttribute("isAdmin", false);
        }
        
        System.out.println("=== END DASHBOARD DEBUG ===");
        return "spareparts-sample";
    }    @GetMapping("/")
    public String home(Model model, Principal principal) {
        System.out.println("=== HOME ACCESS DEBUG ===");
        
        if (principal != null) {
            String username = principal.getName();
            System.out.println("Authenticated user: " + username);
            model.addAttribute("username", username);
            
            // Get user role with detailed logging
            User user = userRepository.findByUsername(username).orElse(null);
            if (user != null) {
                String userRole = user.getRole();
                boolean isAdmin = "ADMIN".equals(userRole);
                
                System.out.println("User found in database:");
                System.out.println("  - Username: " + user.getUsername());
                System.out.println("  - Role: " + userRole);
                System.out.println("  - isAdmin: " + isAdmin);
                
                model.addAttribute("userRole", userRole);
                model.addAttribute("isAdmin", isAdmin);
            } else {
                System.out.println("ERROR: User not found in database for username: " + username);
                model.addAttribute("userRole", "UNKNOWN");
                model.addAttribute("isAdmin", false);
            }
        } else {
            System.out.println("ERROR: No authenticated user (principal is null)");
            model.addAttribute("username", "Anonymous");
            model.addAttribute("userRole", "ANONYMOUS");
            model.addAttribute("isAdmin", false);
        }
        
        System.out.println("=== END HOME DEBUG ===");
        return "spareparts-sample";
    }
      @GetMapping("/spareparts-sample")
    public String sparePartsSample(Model model, Principal principal) {
        if (principal != null) {
            model.addAttribute("username", principal.getName());
            
            // Get user role
            User user = userRepository.findByUsername(principal.getName()).orElse(null);
            if (user != null) {
                boolean isAdmin = "ADMIN".equals(user.getRole());
                model.addAttribute("userRole", user.getRole());
                model.addAttribute("isAdmin", isAdmin);
                System.out.println("SparePartsSample: User=" + principal.getName() + ", Role=" + user.getRole() + ", isAdmin=" + isAdmin);
            }
        }
        return "spareparts-sample";
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
}

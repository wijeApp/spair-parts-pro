package com.tas.spairparts;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.CommandLineRunner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Arrays;
import java.util.List;

@SpringBootApplication
public class SpairpartsApplication implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private SparePartRepository sparePartRepository;

    public static void main(String[] args) {
        SpringApplication.run(SpairpartsApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        // Create default admin user if not exists
        if (userRepository.findByUsername("admin").isEmpty()) {
            User admin = new User();
            admin.setUsername("admin");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setRole("ADMIN");
            admin.setEnabled(true);
            userRepository.save(admin);
            System.out.println("Default admin user created: admin/admin123");
        }
        
        // Create Admin user with administrator access if not exists
        if (userRepository.findByUsername("Admin").isEmpty()) {
            User adminUser = new User();
            adminUser.setUsername("Admin");
            adminUser.setPassword(passwordEncoder.encode("Admin123"));
            adminUser.setRole("ADMIN");
            adminUser.setEnabled(true);
            userRepository.save(adminUser);
            System.out.println("Administrator user created: Admin/Admin123");
        }
        
        // Create default user if not exists
        if (userRepository.findByUsername("user").isEmpty()) {
            User user = new User();
            user.setUsername("user");
            user.setPassword(passwordEncoder.encode("user123"));
            user.setRole("USER");
            userRepository.save(user);
            System.out.println("Default user created: user/user123");
        }

        // Add sample spare part items
        if (sparePartRepository.count() == 0) {
            List<SparePartItem> sampleItems = Arrays.asList(
                new SparePartItem("Brake Pad", "High-quality brake pad", 1500.00, 50),
                new SparePartItem("Oil Filter", "Durable oil filter", 800.00, 100),
                new SparePartItem("Air Filter", "Efficient air filter", 1200.00, 75),
                new SparePartItem("Spark Plug", "Reliable spark plug", 600.00, 200),
                new SparePartItem("Battery", "Long-lasting car battery", 18000.00, 20)
            );
            sparePartRepository.saveAll(sampleItems);
            System.out.println("Sample spare part items added to the database.");
        }
    }
}

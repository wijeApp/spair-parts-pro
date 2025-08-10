package com.tas.spairparts;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {
    
    @Autowired
    private SparePartRepository repository;

    @Override
    public void run(String... args) throws Exception {
        // Only add sample data if database is empty
        if (repository.count() == 0) {
            System.out.println("Database is empty. Adding sample data...");
            
            repository.save(new SparePartItem(
                "Engine Oil Filter", 
                "High-quality oil filter for car engines", 
                25.99, 
                50
            ));
            
            repository.save(new SparePartItem(
                "Brake Pads Set", 
                "Ceramic brake pads for front wheels", 
                89.99, 
                25
            ));
            
            repository.save(new SparePartItem(
                "Air Filter", 
                "High-flow air filter for better performance", 
                15.50, 
                100
            ));
            
            repository.save(new SparePartItem(
                "Spark Plugs (Set of 4)", 
                "Premium iridium spark plugs", 
                45.00, 
                75
            ));
            
            repository.save(new SparePartItem(
                "Transmission Fluid", 
                "1 liter premium transmission fluid", 
                35.25, 
                30
            ));
            
            System.out.println("Sample data added successfully!");
        } else {
            System.out.println("Database already contains " + repository.count() + " items.");
        }
    }
}

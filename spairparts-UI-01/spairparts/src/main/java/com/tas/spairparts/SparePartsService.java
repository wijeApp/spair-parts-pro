package com.tas.spairparts;

import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class SparePartsService {
    private final Map<Long, SparePartItem> store = new HashMap<>();
    private Long nextId = 1L;    public SparePartsService() {
        // Initialize with 5 sample items
        create(new SparePartItem("Brake Pad", "Front brake pad for sedan cars", 25.50, 10));
        create(new SparePartItem("Oil Filter", "Standard oil filter for engine maintenance", 8.75, 20));
        create(new SparePartItem("Air Filter", "High performance air filter", 15.00, 15));
        create(new SparePartItem("Spark Plug", "Platinum spark plug for better performance", 12.25, 30));
        create(new SparePartItem("Timing Belt", "Durable timing belt for engine timing", 45.00, 5));
    }

    public List<SparePartItem> getAll() {
        return new ArrayList<>(store.values());
    }

    public SparePartItem getById(Long id) {
        return store.get(id);
    }

    public SparePartItem create(SparePartItem item) {
        item.setId(nextId++);
        store.put(item.getId(), item);
        return item;
    }

    public SparePartItem update(Long id, SparePartItem item) {
        if (!store.containsKey(id)) return null;
        item.setId(id);
        store.put(id, item);
        return item;
    }

    public boolean delete(Long id) {
        return store.remove(id) != null;
    }
}

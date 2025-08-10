package com.tas.spairparts;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class SparePartsService {
    
    @Autowired
    private SparePartRepository repository;
    
    public List<SparePartItem> getAll() {
        return repository.findAll();
    }

    public SparePartItem getById(Long id) {
        return repository.findById(id).orElse(null);
    }

    public SparePartItem create(SparePartItem item) {
        return repository.save(item);
    }

    public SparePartItem update(Long id, SparePartItem item) {
        if (!repository.existsById(id)) return null;
        item.setId(id);
        return repository.save(item);
    }

    public boolean delete(Long id) {
        if (repository.existsById(id)) {
            repository.deleteById(id);
            return true;
        }
        return false;
    }
}

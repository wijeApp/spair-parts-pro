package com.tas.spairparts;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/spareparts")
@CrossOrigin(origins = "*")
public class SparePartsController {
    @Autowired
    private SparePartsService service;

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

    @PutMapping("/{id}")
    public SparePartItem update(@PathVariable Long id, @RequestBody SparePartItem item) {
        return service.update(id, item);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}

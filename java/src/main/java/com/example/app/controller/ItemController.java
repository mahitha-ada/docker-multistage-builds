package com.example.app.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

@Controller
public class ItemController {

    private final List<Map<String, Object>> items = new ArrayList<>();
    private final AtomicLong counter = new AtomicLong();

    public ItemController() {
        // Initialize with some sample data
        addItem("Item 1", "This is item 1");
        addItem("Item 2", "This is item 2");
        addItem("Item 3", "This is item 3");
    }

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("items", items);
        return "home";
    }

    @GetMapping("/api/items")
    @ResponseBody
    public List<Map<String, Object>> getItems() {
        return items;
    }

    @GetMapping("/api/items/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getItem(@PathVariable long id) {
        for (Map<String, Object> item : items) {
            if (item.get("id").equals(id)) {
                return ResponseEntity.ok(item);
            }
        }
        return ResponseEntity.notFound().build();
    }

    @PostMapping("/api/items")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createItem(@RequestBody Map<String, String> payload) {
        String name = payload.get("name");
        String description = payload.get("description");
        
        if (name == null || name.isEmpty()) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Name is required");
            return ResponseEntity.badRequest().body(error);
        }
        
        if (description == null || description.isEmpty()) {
            description = "This is item " + (items.size() + 1);
        }
        
        Map<String, Object> newItem = addItem(name, description);
        return ResponseEntity.ok(newItem);
    }
    
    private Map<String, Object> addItem(String name, String description) {
        Map<String, Object> item = new HashMap<>();
        item.put("id", counter.incrementAndGet());
        item.put("name", name);
        item.put("description", description);
        items.add(item);
        return item;
    }
}

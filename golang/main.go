package main

import (
	"encoding/json"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"
	"strconv"
	"sync/atomic"
)

// Item represents a simple data item
type Item struct {
	ID          int64  `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description"`
}

// ItemStore is a simple in-memory data store
type ItemStore struct {
	items     []Item
	nextID    int64
	itemsHTML string
}

// NewItemStore creates a new item store with sample data
func NewItemStore() *ItemStore {
	store := &ItemStore{
		items:  make([]Item, 0),
		nextID: 0,
	}
	
	// Add sample items
	store.AddItem("Item 1", "This is item 1")
	store.AddItem("Item 2", "This is item 2")
	store.AddItem("Item 3", "This is item 3")
	
	return store
}

// AddItem adds a new item to the store
func (s *ItemStore) AddItem(name, description string) Item {
	id := atomic.AddInt64(&s.nextID, 1)
	item := Item{
		ID:          id,
		Name:        name,
		Description: description,
	}
	s.items = append(s.items, item)
	return item
}

// GetItems returns all items
func (s *ItemStore) GetItems() []Item {
	return s.items
}

// GetItem returns a specific item by ID
func (s *ItemStore) GetItem(id int64) (Item, bool) {
	for _, item := range s.items {
		if item.ID == id {
			return item, true
		}
	}
	return Item{}, false
}

// HTML template for the homepage
const htmlTemplate = `
<!DOCTYPE html>
<html>
<head>
    <title>Go Multi-Stage Build Example</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
        h1 { color: #333; }
        .container { border: 1px solid #ddd; padding: 20px; border-radius: 5px; }
        .item { margin-bottom: 10px; padding: 10px; background-color: #f9f9f9; border-radius: 3px; }
        .footer { margin-top: 30px; font-size: 12px; color: #666; }
    </style>
</head>
<body>
    <h1>Go Multi-Stage Build Example</h1>
    <div class="container">
        <h2>API Endpoints:</h2>
        <ul>
            <li>GET /api/items - List all items</li>
            <li>GET /api/items/{id} - Get a specific item</li>
            <li>POST /api/items - Create a new item</li>
        </ul>
        
        <h2>Current Items:</h2>
        <div id="items">
            {{range .Items}}
            <div class="item">
                <strong>{{.Name}}</strong>: {{.Description}}
            </div>
            {{end}}
        </div>
    </div>
    
    <div class="footer">
        <p>Docker Multi-Stage Build Example | Running in a container</p>
        <p>Environment: {{.Env}}</p>
    </div>
</body>
</html>
`

func main() {
	store := NewItemStore()
	
	// Get port from environment or use default
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	
	// Parse the HTML template
	tmpl, err := template.New("home").Parse(htmlTemplate)
	if err != nil {
		log.Fatal("Error parsing template:", err)
	}
	
	// Home page handler
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		data := struct {
			Items []Item
			Env   string
		}{
			Items: store.GetItems(),
			Env:   os.Getenv("GO_ENV"),
		}
		
		err := tmpl.Execute(w, data)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	})
	
	// API handlers
	http.HandleFunc("/api/items", func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			// Return all items
			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(store.GetItems())
			
		case http.MethodPost:
			// Create a new item
			var item struct {
				Name        string `json:"name"`
				Description string `json:"description"`
			}
			
			if err := json.NewDecoder(r.Body).Decode(&item); err != nil {
				http.Error(w, err.Error(), http.StatusBadRequest)
				return
			}
			
			if item.Name == "" {
				http.Error(w, "Name is required", http.StatusBadRequest)
				return
			}
			
			if item.Description == "" {
				item.Description = fmt.Sprintf("This is item %d", len(store.GetItems())+1)
			}
			
			newItem := store.AddItem(item.Name, item.Description)
			
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusCreated)
			json.NewEncoder(w).Encode(newItem)
			
		default:
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		}
	})
	
	// Get a specific item
	http.HandleFunc("/api/items/", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodGet {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
			return
		}
		
		// Extract ID from URL
		idStr := r.URL.Path[len("/api/items/"):]
		id, err := strconv.ParseInt(idStr, 10, 64)
		if err != nil {
			http.Error(w, "Invalid ID", http.StatusBadRequest)
			return
		}
		
		item, found := store.GetItem(id)
		if !found {
			http.Error(w, "Item not found", http.StatusNotFound)
			return
		}
		
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(item)
	})
	
	// Start the server
	fmt.Printf("Server running on port %s\n", port)
	fmt.Printf("Visit http://localhost:%s in your browser\n", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}

const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

// Simple in-memory data store
const items = [
  { id: 1, name: 'Item 1', description: 'This is item 1' },
  { id: 2, name: 'Item 2', description: 'This is item 2' },
  { id: 3, name: 'Item 3', description: 'This is item 3' }
];

// Middleware
app.use(express.json());
app.use(express.static('public'));

// Routes
app.get('/', (req, res) => {
  res.send(`
    <html>
      <head>
        <title>Node.js Multi-Stage Build Example</title>
        <style>
          body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
          h1 { color: #333; }
          .container { border: 1px solid #ddd; padding: 20px; border-radius: 5px; }
          .item { margin-bottom: 10px; padding: 10px; background-color: #f9f9f9; border-radius: 3px; }
          .footer { margin-top: 30px; font-size: 12px; color: #666; }
        </style>
      </head>
      <body>
        <h1>Node.js Multi-Stage Build Example</h1>
        <div class="container">
          <h2>API Endpoints:</h2>
          <ul>
            <li>GET /api/items - List all items</li>
            <li>GET /api/items/:id - Get a specific item</li>
            <li>POST /api/items - Create a new item</li>
          </ul>
          
          <h2>Current Items:</h2>
          <div id="items">Loading...</div>
        </div>
        
        <div class="footer">
          <p>Docker Multi-Stage Build Example | Running in a container</p>
          <p>Environment: ${process.env.NODE_ENV || 'development'}</p>
        </div>
        
        <script>
          fetch('/api/items')
            .then(response => response.json())
            .then(data => {
              const itemsDiv = document.getElementById('items');
              itemsDiv.innerHTML = '';
              
              data.forEach(item => {
                const itemDiv = document.createElement('div');
                itemDiv.className = 'item';
                itemDiv.innerHTML = `<strong>${item.name}</strong>: ${item.description}`;
                itemsDiv.appendChild(itemDiv);
              });
            })
            .catch(error => {
              document.getElementById('items').innerHTML = 'Error loading items: ' + error.message;
            });
        </script>
      </body>
    </html>
  `);
});

// API Routes
app.get('/api/items', (req, res) => {
  res.json(items);
});

app.get('/api/items/:id', (req, res) => {
  const item = items.find(i => i.id === parseInt(req.params.id));
  if (!item) return res.status(404).json({ error: 'Item not found' });
  res.json(item);
});

app.post('/api/items', (req, res) => {
  const newItem = {
    id: items.length + 1,
    name: req.body.name || `Item ${items.length + 1}`,
    description: req.body.description || `This is item ${items.length + 1}`
  };
  
  items.push(newItem);
  res.status(201).json(newItem);
});

// Start server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
  console.log(`Visit http://localhost:${port} in your browser`);
});

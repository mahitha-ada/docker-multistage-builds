from flask import Flask, jsonify, request, render_template_string
import os

app = Flask(__name__)

# Simple in-memory data store
items = [
    {"id": 1, "name": "Item 1", "description": "This is item 1"},
    {"id": 2, "name": "Item 2", "description": "This is item 2"},
    {"id": 3, "name": "Item 3", "description": "This is item 3"}
]

# HTML template for the homepage
HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>Python Multi-Stage Build Example</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
        h1 { color: #333; }
        .container { border: 1px solid #ddd; padding: 20px; border-radius: 5px; }
        .item { margin-bottom: 10px; padding: 10px; background-color: #f9f9f9; border-radius: 3px; }
        .footer { margin-top: 30px; font-size: 12px; color: #666; }
    </style>
</head>
<body>
    <h1>Python Multi-Stage Build Example</h1>
    <div class="container">
        <h2>API Endpoints:</h2>
        <ul>
            <li>GET /api/items - List all items</li>
            <li>GET /api/items/&lt;id&gt; - Get a specific item</li>
            <li>POST /api/items - Create a new item</li>
        </ul>
        
        <h2>Current Items:</h2>
        <div id="items">
            {% for item in items %}
            <div class="item">
                <strong>{{ item.name }}</strong>: {{ item.description }}
            </div>
            {% endfor %}
        </div>
    </div>
    
    <div class="footer">
        <p>Docker Multi-Stage Build Example | Running in a container</p>
        <p>Environment: {{ environment }}</p>
    </div>
</body>
</html>
"""

@app.route('/')
def home():
    return render_template_string(
        HTML_TEMPLATE, 
        items=items,
        environment=os.environ.get('FLASK_ENV', 'production')
    )

@app.route('/api/items', methods=['GET'])
def get_items():
    return jsonify(items)

@app.route('/api/items/<int:item_id>', methods=['GET'])
def get_item(item_id):
    item = next((item for item in items if item['id'] == item_id), None)
    if item is None:
        return jsonify({"error": "Item not found"}), 404
    return jsonify(item)

@app.route('/api/items', methods=['POST'])
def create_item():
    if not request.json or 'name' not in request.json:
        return jsonify({"error": "Invalid request"}), 400
    
    new_item = {
        'id': max(item['id'] for item in items) + 1,
        'name': request.json['name'],
        'description': request.json.get('description', f"This is item {len(items) + 1}")
    }
    items.append(new_item)
    return jsonify(new_item), 201

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8000))
    app.run(host='0.0.0.0', port=port, debug=os.environ.get('FLASK_ENV') == 'development')

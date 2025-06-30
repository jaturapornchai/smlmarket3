# SMLGOAPI - POST Method Documentation

## 🔍 Product Search API

### **POST /v1/search**
Search for auto parts with AI-powered multi-language support

#### Request
```json
POST /v1/search
Content-Type: application/json

{
  "query": "string (required)",
  "ai": "integer (optional, default: 0)",
  "limit": "integer (optional, default: 10, max: 100)",
  "offset": "integer (optional, default: 0)"
}
```

#### Parameters
| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `query` | string | ✅ Yes | - | Search query (Thai/English) |
| `ai` | integer | ❌ No | 0 | 0=No AI, 1=Use AI translation |
| `limit` | integer | ❌ No | 10 | Max results (1-100) |
| `offset` | integer | ❌ No | 0 | Pagination offset |

#### Examples

**Basic Search**
```bash
curl -X POST "http://localhost:8008/v1/search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "toyota"
  }'
```

**AI-Enhanced Search (Thai)**
```bash
curl -X POST "http://localhost:8008/v1/search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "เบรค",
    "ai": 1,
    "limit": 20
  }'
```

**Pagination**
```bash
curl -X POST "http://localhost:8008/v1/search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "brake pad",
    "limit": 10,
    "offset": 20
  }'
```

#### Response
```json
{
  "success": true,
  "message": "Search completed successfully",
  "data": {
    "data": [
      {
        "id": "TOYOTA-001",
        "code": "TOYOTA-001",
        "name": "แผง TOYOTA VIGO (แท้)",
        "similarity_score": 5,
        "balance_qty": 0,
        "price": 2600,
        "unit": "แผ่น",
        "search_priority": 5,
        "sale_price": 2600,
        "premium_word": "",
        "discount_price": 2350,
        "discount_percent": 0,
        "final_price": 2600,
        "sold_qty": 0,
        "multi_packing": 0,
        "multi_packing_name": "",
        "barcodes": "",
        "qty_available": -1
      }
    ],
    "total_count": 2182,
    "query": "toyota",
    "duration": 731.5
  }
}
```

## 🤖 Vector Search API

### **POST /v1/search-by-vector**
Search using vector database (Weaviate) then PostgreSQL

#### Request
```json
POST /v1/search-by-vector
Content-Type: application/json

{
  "query": "string (required)",
  "limit": "integer (optional, default: 20, max: 100)",
  "offset": "integer (optional, default: 0)"
}
```

#### Example
```bash
curl -X POST "http://localhost:8008/v1/search-by-vector" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "brake toyota",
    "limit": 10
  }'
```

## 🐘 PostgreSQL Database Operations

### **POST /v1/pgcommand**
Execute PostgreSQL commands (CREATE, INSERT, UPDATE, DELETE)

#### Request
```json
POST /v1/pgcommand
Content-Type: application/json

{
  "query": "string (required) - SQL command"
}
```

#### Examples
```bash
# Create table
curl -X POST "http://localhost:8008/v1/pgcommand" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "CREATE TABLE products (id SERIAL PRIMARY KEY, name VARCHAR(255))"
  }'

# Insert data
curl -X POST "http://localhost:8008/v1/pgcommand" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "INSERT INTO products (name) VALUES ('"'Brake Pad'"')"
  }'
```

### **POST /v1/pgselect**
Execute PostgreSQL SELECT queries

#### Request
```json
POST /v1/pgselect
Content-Type: application/json

{
  "query": "string (required) - SELECT query"
}
```

#### Example
```bash
curl -X POST "http://localhost:8008/v1/pgselect" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "SELECT * FROM ic_inventory WHERE name ILIKE '"'%toyota%'"' LIMIT 10"
  }'
```

## 🇹🇭 Thai Administrative Data

### **POST /v1/provinces**
Get all Thai provinces

#### Request
```json
POST /v1/provinces
Content-Type: application/json

{}
```

#### Example
```bash
curl -X POST "http://localhost:8008/v1/provinces" \
  -H "Content-Type: application/json" \
  -d '{}'
```

#### Response
```json
{
  "success": true,
  "message": "Retrieved 77 provinces successfully",
  "data": [
    {
      "id": 1,
      "name_th": "กรุงเทพมหานคร",
      "name_en": "Bangkok"
    }
  ]
}
```

### **POST /v1/amphures**
Get districts in a province

#### Request
```json
POST /v1/amphures
Content-Type: application/json

{
  "province_id": "integer (required)"
}
```

#### Example
```bash
curl -X POST "http://localhost:8008/v1/amphures" \
  -H "Content-Type: application/json" \
  -d '{
    "province_id": 1
  }'
```

### **POST /v1/tambons**
Get sub-districts in an amphure

#### Request
```json
POST /v1/tambons
Content-Type: application/json

{
  "amphure_id": "integer (required)",
  "province_id": "integer (required)"
}
```

#### Example
```bash
curl -X POST "http://localhost:8008/v1/tambons" \
  -H "Content-Type: application/json" \
  -d '{
    "amphure_id": 1001,
    "province_id": 1
  }'
```

### **POST /v1/findbyzipcode**
Find location by zip code

#### Request
```json
POST /v1/findbyzipcode
Content-Type: application/json

{
  "zip_code": "integer (required)"
}
```

#### Example
```bash
curl -X POST "http://localhost:8008/v1/findbyzipcode" \
  -H "Content-Type: application/json" \
  -d '{
    "zip_code": 10200
  }'
```

## 🤖 AI Enhancement Features

### How AI Enhancement Works (ai=1)

| Original Query | AI Enhanced Result | Description |
|----------------|-------------------|-------------|
| `เบรค` | `เบรค brake brakes ระบบเบรค brake pad` | Thai to English + related terms |
| `break` | `brake เบรค brakes` | Typo correction |
| `toyoda` | `toyota โตโยต้า TOYOTA` | Brand name correction |
| `คอมเพรสเซอร์` | `คอมเพรสเซอร์ compressor คอมแอร์` | Technical term expansion |

### JavaScript Example

```javascript
// Search with AI enhancement
async function searchProducts(query, useAI = true) {
  const response = await fetch('/v1/search', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      query: query,
      ai: useAI ? 1 : 0,
      limit: 20
    })
  });
  
  return await response.json();
}

// Usage
searchProducts('เบรค', true)
  .then(data => {
    console.log(`Found ${data.data.total_count} products`);
    data.data.data.forEach(product => {
      console.log(`[${product.code}] ${product.name} - ฿${product.final_price}`);
    });
  });
```

### Python Example

```python
import requests
import json

def search_products(query, use_ai=True, limit=20):
    url = 'http://localhost:8008/v1/search'
    headers = {'Content-Type': 'application/json'}
    
    payload = {
        'query': query,
        'ai': 1 if use_ai else 0,
        'limit': limit
    }
    
    response = requests.post(url, headers=headers, data=json.dumps(payload))
    return response.json()

# Usage
result = search_products('โตโยต้า เบรค', use_ai=True)
if result['success']:
    print(f"Found {result['data']['total_count']} products")
    for product in result['data']['data']:
        print(f"[{product['code']}] {product['name']} - ฿{product['final_price']}")
```

## 📊 Response Field Descriptions

| Field | Type | Description |
|-------|------|-------------|
| `code` | string | Product code/SKU |
| `name` | string | Product name |
| `unit` | string | Unit of measure |
| `price` | number | Base price |
| `sale_price` | number | Selling price |
| `final_price` | number | Final price after discount |
| `discount_price` | number | Discount amount |
| `discount_percent` | number | Discount percentage |
| `qty_available` | number | Available quantity |
| `sold_qty` | number | Quantity sold |
| `multi_packing` | integer | 0=Single unit, 1=Multiple units |
| `multi_packing_name` | string | Multiple units (comma separated) |
| `barcodes` | string | Barcodes (comma separated) |
| `search_priority` | integer | Relevance score (1-5) |

## ⚡ Performance Tips

1. **Use AI wisely** - Only enable `ai=1` when needed for cross-language search
2. **Limit results** - Use appropriate `limit` values (10-20 for UI)
3. **Implement pagination** - Use `offset` for large result sets
4. **Cache results** - Cache frequently searched queries on frontend
5. **Monitor duration** - Check `duration` field for performance

## 🔧 Error Handling

```json
{
  "success": false,
  "error": "Error message",
  "details": {
    "error_type": "database_error",
    "timestamp": "2025-06-19T15:30:45+07:00"
  }
}
```

Common errors:
- `Query parameter is required` - Missing search query
- `Invalid JSON format` - Malformed request body
- `Database connection failed` - PostgreSQL unavailable
- `Vector search service not available` - Weaviate offline
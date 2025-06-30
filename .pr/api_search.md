# Vector Search API Documentation

## 🤖 **POST /v1/search-by-vector**

Search products using Weaviate vector database first, then retrieve detailed information from PostgreSQL.

### 📋 **Endpoint Information**
```
POST /v1/search-by-vector
Content-Type: application/json
```

### 📝 **Request Body Format**
```json
{
  "query": "string (required) - คำค้นหา",
  "limit": "integer (optional) - จำนวนผลลัพธ์ (default: 20, max: 100)",
  "offset": "integer (optional) - ตำแหน่งเริ่มต้น (default: 0)"
}
```

### 🎯 **How It Works**

1. **Vector Search** - ค้นหาใน Weaviate vector database เพื่อหา IC codes และ barcodes
2. **PostgreSQL Lookup** - ใช้ IC codes/barcodes ที่ได้ไปดึงข้อมูลสินค้าจาก PostgreSQL
3. **Data Enhancement** - เพิ่มข้อมูลราคาและยอดคงเหลือจาก `ic_inventory_price_formula` และ `ic_balance`

### 💻 **Examples**

#### **Basic Vector Search**
```bash
curl -X POST "http://localhost:8008/v1/search-by-vector" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "brake pad toyota"
  }'
```

#### **Vector Search with Limit**
```bash
curl -X POST "http://localhost:8008/v1/search-by-vector" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "เบรคผ้า",
    "limit": 30
  }'
```

#### **Vector Search with Pagination**
```bash
curl -X POST "http://localhost:8008/v1/search-by-vector" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "compressor",
    "limit": 20,
    "offset": 40
  }'
```

### 🔧 **JavaScript Example**

```javascript
async function vectorSearch(query, limit = 20, offset = 0) {
  const response = await fetch('/v1/search-by-vector', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      query: query,
      limit: limit,
      offset: offset
    })
  });
  
  return await response.json();
}

// Usage
vectorSearch('brake toyota')
  .then(data => {
    if (data.success) {
      console.log(`Found ${data.data.total_count} products`);
      data.data.data.forEach(product => {
        console.log(`[${product.code}] ${product.name}`);
        console.log(`  Price: ฿${product.final_price}`);
        console.log(`  Available: ${product.qty_available} ${product.unit}`);
      });
    }
  })
  .catch(error => console.error('Search failed:', error));
```

### 🐍 **Python Example**

```python
import requests
import json

def vector_search(query, limit=20, offset=0):
    """
    Search products using vector similarity
    """
    url = 'http://localhost:8008/v1/search-by-vector'
    headers = {'Content-Type': 'application/json'}
    
    payload = {
        'query': query,
        'limit': limit,
        'offset': offset
    }
    
    response = requests.post(url, headers=headers, data=json.dumps(payload))
    return response.json()

# Example usage
if __name__ == "__main__":
    # Search for brake pads
    result = vector_search('brake pad', limit=10)
    
    if result['success']:
        print(f"Found {result['data']['total_count']} products")
        
        for product in result['data']['data']:
            print(f"\n[{product['code']}] {product['name']}")
            print(f"  Unit: {product['unit']}")
            print(f"  Price: ฿{product['final_price']:,.2f}")
            print(f"  Stock: {product['qty_available']} units")
            print(f"  Similarity: {product['similarity_score']}")
```

### 📊 **Response Format**

```json
{
  "success": true,
  "message": "Search completed successfully",
  "data": {
    "data": [
      {
        "id": "BRAKE-001",
        "code": "BRAKE-001",
        "name": "ผ้าเบรคหน้า TOYOTA VIGO",
        "similarity_score": 0.95,
        "balance_qty": 0,
        "price": 850,
        "supplier_code": "SUP001",
        "unit": "ชุด",
        "img_url": "",
        "search_priority": 5,
        "sale_price": 850,
        "premium_word": "",
        "discount_price": 800,
        "discount_percent": 5.88,
        "final_price": 850,
        "sold_qty": 150,
        "multi_packing": 0,
        "multi_packing_name": "",
        "barcodes": "8850001234567",
        "qty_available": 45
      }
    ],
    "total_count": 156,
    "query": "brake pad toyota",
    "duration": 450.3
  }
}
```

### 🔍 **Vector Search vs Regular Search**

| Feature | Vector Search | Regular Search |
|---------|--------------|----------------|
| **Method** | Semantic similarity | Text matching |
| **Database** | Weaviate → PostgreSQL | PostgreSQL only |
| **Accuracy** | High for similar concepts | Exact matches |
| **Speed** | Moderate | Fast |
| **Use Case** | Find similar products | Find specific items |

### ⚡ **Performance Characteristics**

- **Vector Search Time**: ~200-400ms (Weaviate)
- **PostgreSQL Lookup**: ~100-300ms
- **Total Response Time**: ~300-700ms
- **Optimal Limit**: 20-50 results

### 🎯 **Best Use Cases**

1. **Product Recommendations** - ค้นหาสินค้าที่คล้ายกัน
2. **Fuzzy Search** - ค้นหาแม้พิมพ์ผิดเล็กน้อย
3. **Concept Search** - ค้นหาด้วยแนวคิด เช่น "ของแต่งรถ"
4. **Multi-language** - ค้นหาข้ามภาษาได้ดี
5. **Similar Items** - หาสินค้าทดแทน

### ❌ **Error Responses**

#### Missing Query
```json
{
  "success": false,
  "message": "Query parameter is required"
}
```

#### Vector Service Unavailable
```json
{
  "success": false,
  "error": "Vector search service not available"
}
```

#### No Results Found
```json
{
  "success": true,
  "message": "No products found matching your search",
  "data": {
    "data": [],
    "total_count": 0,
    "query": "xyz123"
  }
}
```

### 🔧 **Implementation Notes**

1. **Vector Database**: ใช้ Weaviate สำหรับ semantic search
2. **Fallback**: ถ้าไม่พบ IC code จะใช้ barcode แทน
3. **Enrichment**: เพิ่มข้อมูลราคาและสต็อกแบบ real-time
4. **Caching**: ไม่มี cache ที่ API level (ควร cache ที่ frontend)
5. **Limit**: Maximum 100 items per request

### 💡 **Tips for Better Results**

1. **Use descriptive queries** - "ผ้าเบรคหน้า toyota" ดีกว่า "เบรค"
2. **Combine terms** - "brake pad front" หาได้แม่นยำกว่า
3. **Check similarity score** - คะแนน > 0.8 = ตรงมาก
4. **Use pagination** - สำหรับผลลัพธ์จำนวนมาก
5. **Monitor duration** - ถ้าช้ากว่า 1 วินาที ควรลด limit

### 🚀 **Advanced Usage**

```javascript
// Advanced search with error handling and retry
async function advancedVectorSearch(query, options = {}) {
  const config = {
    limit: options.limit || 20,
    offset: options.offset || 0,
    retries: options.retries || 3,
    timeout: options.timeout || 5000
  };
  
  let lastError;
  
  for (let i = 0; i < config.retries; i++) {
    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), config.timeout);
      
      const response = await fetch('/v1/search-by-vector', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          query: query,
          limit: config.limit,
          offset: config.offset
        }),
        signal: controller.signal
      });
      
      clearTimeout(timeoutId);
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      const data = await response.json();
      
      if (!data.success) {
        throw new Error(data.error || 'Search failed');
      }
      
      return data;
      
    } catch (error) {
      lastError = error;
      
      if (error.name === 'AbortError') {
        console.warn(`Attempt ${i + 1} timed out, retrying...`);
      } else {
        console.error(`Attempt ${i + 1} failed:`, error.message);
      }
      
      // Wait before retry
      if (i < config.retries - 1) {
        await new Promise(resolve => setTimeout(resolve, 1000 * (i + 1)));
      }
    }
  }
  
  throw lastError;
}
```
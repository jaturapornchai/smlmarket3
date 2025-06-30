import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'dart:math';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  String _getRandomImageUrl() {
    final random = Random();
    final imageId = 200 + random.nextInt(300);
    return 'https://picsum.photos/400/400?random=$imageId';
  }

  String _formatPrice(double? price) {
    if (price == null) return 'N/A';
    return '฿${price.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = (product.balanceQty ?? 0) <= 0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          product.name ?? 'รายละเอียดสินค้า',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('เพิ่มในรายการโปรด')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('แชร์สินค้า')));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Section
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                child: Image.network(
                  _getRandomImageUrl(),
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 80,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Product Info Section
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name ?? 'ไม่มีชื่อสินค้า',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Product Code
                  if (product.code != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Text(
                        'รหัสสินค้า: ${product.code}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Price Section
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: Colors.green[600],
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ราคา',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatPrice(product.finalPrice),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),

                  if (product.price != null &&
                      product.finalPrice != product.price)
                    Text(
                      'ราคาเดิม: ${_formatPrice(product.price)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Stock Section
                  Row(
                    children: [
                      Icon(
                        Icons.inventory,
                        color: isOutOfStock
                            ? Colors.red[600]
                            : Colors.blue[600],
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'สถานะสินค้า',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isOutOfStock ? Colors.red[50] : Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isOutOfStock
                            ? Colors.red[200]!
                            : Colors.green[200]!,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isOutOfStock ? Icons.cancel : Icons.check_circle,
                          color: isOutOfStock
                              ? Colors.red[600]
                              : Colors.green[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isOutOfStock
                              ? 'สินค้าหมด'
                              : 'คงเหลือ: ${product.balanceQty ?? 0} ชิ้น',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isOutOfStock
                                ? Colors.red[700]
                                : Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Additional Info Section
                  if (product.premiumWord != null &&
                      product.premiumWord!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.grey[600],
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'รายละเอียดเพิ่มเติม',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Text(
                            product.premiumWord!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isOutOfStock
                          ? null
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'เพิ่ม ${product.name} ลงในตะกร้า',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isOutOfStock
                            ? Colors.grey
                            : Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isOutOfStock
                                ? Icons.block
                                : Icons.shopping_cart_outlined,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isOutOfStock ? 'สินค้าหมด' : 'เพิ่มลงตะกร้า',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('ซื้อ ${product.name} ทันที'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue[700],
                        side: BorderSide(color: Colors.blue[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.flash_on,
                            size: 20,
                            color: Colors.blue[700],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ซื้อทันที',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

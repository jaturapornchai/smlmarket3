import 'dart:math';
import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Generate a random image URL if imgUrl is null or empty
    final random = Random();
    final imageUrl = (product.imgUrl != null && product.imgUrl!.isNotEmpty)
        ? product.imgUrl!
        : 'https://picsum.photos/seed/${random.nextInt(1000)}/200/300';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 200, // Set a fixed height for consistent aspect ratio
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    size: 60,
                    color: Colors.grey,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product Name
                  Text(
                    product.productName.isNotEmpty
                        ? product.productName
                        : 'ไม่มีชื่อสินค้า',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Product Code และ Unit Name
                  if (product.productCode.isNotEmpty ||
                      product.unitName?.isNotEmpty == true)
                    Text(
                      '${product.productCode} ${product.unitName ?? ''}'.trim(),
                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  // Barcode (ถ้ามี)
                  if (product.barcode?.isNotEmpty == true)
                    Text(
                      'Barcode: ${product.barcode}',
                      style: TextStyle(color: Colors.grey[500], fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  // Premium Word (ถ้ามี)
                  if (product.premiumWord != null &&
                      product.premiumWord!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product.premiumWord!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Balance Quantity or Out of Stock
                  Text(
                    product.balanceQty == 0
                        ? 'สินค้าหมด'
                        : 'คงเหลือ: ${product.formattedBalanceQty}',
                    style: TextStyle(
                      fontSize: 14,
                      color: product.balanceQty == 0 ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Product Price (Moved to the bottom)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                '฿${product.formattedFinalPrice}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

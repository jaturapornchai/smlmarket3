import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final String? id;
  final String? code;
  final String? name;
  final String? unit;
  final double? price;

  @JsonKey(name: 'sale_price')
  final double? salePrice;

  @JsonKey(name: 'final_price')
  final double? finalPrice;

  @JsonKey(name: 'discount_price')
  final double? discountPrice;

  @JsonKey(name: 'discount_percent')
  final double? discountPercent;

  @JsonKey(name: 'qty_available')
  final int? qtyAvailable;

  @JsonKey(name: 'sold_qty')
  final int? soldQty;

  @JsonKey(name: 'multi_packing')
  final int? multiPacking;

  @JsonKey(name: 'multi_packing_name')
  final String? multiPackingName;

  final String? barcodes;

  @JsonKey(name: 'search_priority')
  final int? searchPriority;

  @JsonKey(name: 'similarity_score')
  final int? similarityScore;

  @JsonKey(name: 'balance_qty')
  final int? balanceQty;

  @JsonKey(name: 'premium_word')
  final String? premiumWord;

  const ProductModel({
    this.id,
    this.code,
    this.name,
    this.unit,
    this.price,
    this.salePrice,
    this.finalPrice,
    this.discountPrice,
    this.discountPercent,
    this.qtyAvailable,
    this.soldQty,
    this.multiPacking,
    this.multiPackingName,
    this.barcodes,
    this.searchPriority,
    this.similarityScore,
    this.balanceQty,
    this.premiumWord,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  @override
  String toString() {
    return 'ProductModel(code: $code, name: $name, price: $finalPrice)';
  }

  // Getter methods สำหรับ compatibility
  String get productName => name ?? '';
  String get productCode => code ?? '';
  double get productPrice => finalPrice ?? price ?? 0.0;

  // เพิ่ม getters สำหรับ ProductCard
  String? get imgUrl => null; // ยังไม่มี image field ใน API
  String? get unitName => unit;
  String? get barcode => barcodes;

  String get formattedPrice {
    final displayPrice = finalPrice ?? price ?? 0.0;
    return displayPrice.toStringAsFixed(0);
  }

  String get formattedStock {
    final stock = qtyAvailable ?? balanceQty ?? 0;
    if (stock < 0) return 'ไม่ระบุ';
    if (stock == 0) return 'หมด';
    return stock.toString();
  }

  bool get hasStock {
    final stock = qtyAvailable ?? balanceQty ?? 0;
    return stock > 0;
  }

  String formatNumber(double? value) {
    if (value == null) return '0';
    return value
        .toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
  }

  String get formattedFinalPrice => formatNumber(finalPrice);
  String get formattedBalanceQty => formatNumber(balanceQty?.toDouble());
}

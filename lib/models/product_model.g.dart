// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['id'] as String?,
  code: json['code'] as String?,
  name: json['name'] as String?,
  unit: json['unit'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  salePrice: (json['sale_price'] as num?)?.toDouble(),
  finalPrice: (json['final_price'] as num?)?.toDouble(),
  discountPrice: (json['discount_price'] as num?)?.toDouble(),
  discountPercent: (json['discount_percent'] as num?)?.toDouble(),
  qtyAvailable: (json['qty_available'] as num?)?.toInt(),
  soldQty: (json['sold_qty'] as num?)?.toInt(),
  multiPacking: (json['multi_packing'] as num?)?.toInt(),
  multiPackingName: json['multi_packing_name'] as String?,
  barcodes: json['barcodes'] as String?,
  searchPriority: (json['search_priority'] as num?)?.toInt(),
  similarityScore: (json['similarity_score'] as num?)?.toInt(),
  balanceQty: (json['balance_qty'] as num?)?.toInt(),
  premiumWord: json['premium_word'] as String?,
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'unit': instance.unit,
      'price': instance.price,
      'sale_price': instance.salePrice,
      'final_price': instance.finalPrice,
      'discount_price': instance.discountPrice,
      'discount_percent': instance.discountPercent,
      'qty_available': instance.qtyAvailable,
      'sold_qty': instance.soldQty,
      'multi_packing': instance.multiPacking,
      'multi_packing_name': instance.multiPackingName,
      'barcodes': instance.barcodes,
      'search_priority': instance.searchPriority,
      'similarity_score': instance.similarityScore,
      'balance_qty': instance.balanceQty,
      'premium_word': instance.premiumWord,
    };

import 'package:json_annotation/json_annotation.dart';
import 'product_model.dart';

part 'search_response_model.g.dart';

@JsonSerializable()
class SearchResponseModel {
  final bool success;
  final String? message;
  final SearchDataModel? data;

  const SearchResponseModel({required this.success, this.message, this.data});

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseModelToJson(this);
}

@JsonSerializable()
class SearchDataModel {
  final List<ProductModel> data;

  @JsonKey(name: 'total_count')
  final int totalCount;

  final String query;
  final double? duration;

  const SearchDataModel({
    required this.data,
    required this.totalCount,
    required this.query,
    this.duration,
  });

  factory SearchDataModel.fromJson(Map<String, dynamic> json) =>
      _$SearchDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchDataModelToJson(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResponseModel _$SearchResponseModelFromJson(Map<String, dynamic> json) =>
    SearchResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : SearchDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SearchResponseModelToJson(
  SearchResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

SearchDataModel _$SearchDataModelFromJson(Map<String, dynamic> json) =>
    SearchDataModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['total_count'] as num).toInt(),
      query: json['query'] as String,
      duration: (json['duration'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SearchDataModelToJson(SearchDataModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'total_count': instance.totalCount,
      'query': instance.query,
      'duration': instance.duration,
    };

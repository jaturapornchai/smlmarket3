import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../data/api_service.dart';
import '../../models/product_model.dart';
import '../../config/global.dart';

class SearchState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<ProductModel> products;
  final String? error;
  final bool hasMoreData;
  final int currentOffset;
  final String currentQuery;
  final int totalCount;

  const SearchState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.products = const [],
    this.error,
    this.hasMoreData = true,
    this.currentOffset = 0,
    this.currentQuery = '',
    this.totalCount = 0,
  });

  SearchState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<ProductModel>? products,
    String? error,
    bool? hasMoreData,
    int? currentOffset,
    String? currentQuery,
    int? totalCount,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      products: products ?? this.products,
      error: error,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentOffset: currentOffset ?? this.currentOffset,
      currentQuery: currentQuery ?? this.currentQuery,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

class SearchCubit extends Cubit<SearchState> {
  final ApiService _apiService;

  SearchCubit(this._apiService) : super(const SearchState());

  Future<void> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      emit(const SearchState());
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        error: null,
        currentQuery: query,
        currentOffset: 0,
      ),
    );

    try {
      final response = await _apiService.searchProducts(
        query: query,
        offset: 0,
        limit: GlobalConfig.defaultPageSize,
      );

      final products = response.data?.data ?? [];
      final totalCount = response.data?.totalCount ?? 0;
      final hasMore =
          products.length >= GlobalConfig.defaultPageSize &&
          products.length < totalCount;

      emit(
        state.copyWith(
          isLoading: false,
          products: products,
          hasMoreData: hasMore,
          currentOffset: 0,
          totalCount: totalCount,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Search error: $e');
      }
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loadMoreProducts() async {
    if (state.isLoadingMore ||
        !state.hasMoreData ||
        state.currentQuery.isEmpty) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    try {
      final nextOffset = state.currentOffset + GlobalConfig.defaultPageSize;
      final response = await _apiService.searchProducts(
        query: state.currentQuery,
        offset: nextOffset,
        limit: GlobalConfig.defaultPageSize,
      );

      final newProducts = response.data?.data ?? [];
      final hasMore =
          (state.products.length + newProducts.length) < state.totalCount;

      emit(
        state.copyWith(
          isLoadingMore: false,
          products: [...state.products, ...newProducts],
          hasMoreData: hasMore,
          currentOffset: nextOffset,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Load more error: $e');
      }
      emit(state.copyWith(isLoadingMore: false, error: e.toString()));
    }
  }

  void clearSearch() {
    emit(const SearchState());
  }
}

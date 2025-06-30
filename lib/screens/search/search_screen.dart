import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smlmarket3/screens/product_details_screen.dart';
import 'dart:async';
import '../../data/api_service.dart';
import '../../widgets/product_card.dart';
import '../../config/global.dart';
import 'search_cubit.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(ApiService()),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late SearchCubit _searchCubit;
  List<String> _searchHistory = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    // Initialize API service
    ApiService().init();

    // Initialize SearchCubit
    _searchCubit = context.read<SearchCubit>();

    // Check for the latest search query
    _loadLatestSearchQuery();

    // Load search history
    _loadSearchHistory();

    // Set up infinite scroll
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('search_history') ?? [];
    });
  }

  Future<void> _addToSearchHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory.remove(query);
      _searchHistory.insert(0, query);
      if (_searchHistory.length > 10) {
        _searchHistory = _searchHistory.sublist(0, 10);
      }
    });
    await prefs.setStringList('search_history', _searchHistory);
  }

  Future<void> _clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory.clear();
    });
    await prefs.remove('search_history');
  }

  Future<void> _loadLatestSearchQuery() async {
    // Load default product list with empty search box
    _searchCubit.searchProducts('');
  }

  Future<void> _saveLatestSearchQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('latest_search_query', query);
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ค้นหาสินค้า...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      ),
                    BlocBuilder<SearchCubit, SearchState>(
                      builder: (context, state) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.psychology,
                            size: 20,
                            color: state.useAI ? Colors.blue : Colors.grey[400],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {}); // Update UI to show/hide clear button
              },
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _performSearch,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('ค้นหา'),
          ),
          const SizedBox(width: 8),
          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  context.read<SearchCubit>().toggleAI();
                },
                icon: Icon(
                  Icons.psychology,
                  color: state.useAI ? Colors.blue : Colors.grey,
                ),
                tooltip: state.useAI ? 'ปิด AI' : 'เปิด AI',
                style: IconButton.styleFrom(
                  backgroundColor: state.useAI ? Colors.blue.withValues(alpha: 0.1) : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.history),
            onSelected: (value) {
              if (value == 'clear') {
                _clearSearchHistory();
              } else {
                _searchController.text = value;
                _performSearch();
              }
            },
            itemBuilder: (context) {
              return [
                ..._searchHistory.map(
                  (query) => PopupMenuItem(value: query, child: Text(query)),
                ),
                if (_searchHistory.isNotEmpty) const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'clear',
                  child: Text('ล้างประวัติการค้นหา'),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<dynamic> products) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // คำนวณขนาดกล่องให้พอดีกับหน้าจอ
        final crossAxisCount =
            (constraints.maxWidth / GlobalConfig.minCardWidth).floor();

        return SingleChildScrollView(
          child: Wrap(
            spacing: 0,
            runSpacing: 0,
            children: products.map((product) {
              return SizedBox(
                width: constraints.maxWidth / crossAxisCount,
                child: ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsScreen(product: product),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _saveLatestSearchQuery(query);
      _addToSearchHistory(query);
      context.read<SearchCubit>().searchProducts(query);
    }
  }

  Widget _buildAIStatusIndicator() {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (!state.useAI) return const SizedBox.shrink();
        
        return Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.psychology, size: 16, color: Colors.blue[700]),
              const SizedBox(width: 6),
              Text(
                'ค้นหาด้วย AI',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ค้นหาสินค้า'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // TODO: Add cart navigation
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Cart pressed!')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: Add login navigation
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Login pressed!')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildAIStatusIndicator(),

          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'เกิดข้อผิดพลาด',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _performSearch,
                          child: const Text('ลองใหม่'),
                        ),
                      ],
                    ),
                  );
                }

                if (state.products.isEmpty && state.currentQuery.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'ไม่พบสินค้า',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ลองค้นหาด้วยคำอื่น',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                if (state.products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'เริ่มค้นหาสินค้า',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'พิมพ์คำที่ต้องการค้นหาในช่องด้านบน',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      _buildProductGrid(state.products),

                      if (state.isLoadingMore)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),

                      if (!state.hasMoreData && state.products.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'แสดงสินค้าครบทุกรายการแล้ว',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),

                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _searchCubit.loadMoreProducts();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

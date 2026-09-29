import 'package:flutter/material.dart';

void main() {
  runApp(const RabbitMarketApp());
}

class RabbitMarketApp extends StatelessWidget {
  const RabbitMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '당근 중고거래 검색',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF7A24),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8F9),
        useMaterial3: true,
      ),
      home: const RabbitSearchScreen(),
    );
  }
}

class RabbitSearchScreen extends StatefulWidget {
  const RabbitSearchScreen({super.key});

  @override
  State<RabbitSearchScreen> createState() => _RabbitSearchScreenState();
}

class _RabbitSearchScreenState extends State<RabbitSearchScreen> {
  static const List<String> _navigationItems = [
    '전체',
    '중고거래',
    '동네업체',
    '중고차',
    '동네생활',
    '모임',
    '알바',
    '부동산',
    '카페',
  ];

  static const List<_MarketProduct> _products = [
    _MarketProduct(
      id: 'airpods-max',
      title: 'Apple 에어팟 맥스 2 노이즈 캔슬링 블루투스 헤드폰',
      price: 757050,
      location: '위례동 · 14분 전',
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=82',
      category: '에어팟',
      isBump: true,
      likes: 12,
    ),
    _MarketProduct(
      id: 'airpods-4',
      title: '애플 에어팟 4세대(노캔) 새제품',
      price: 170000,
      location: '성남동 · 14분 전',
      imageUrl: 'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?auto=format&fit=crop&w=900&q=82',
      category: '에어팟',
      isBump: true,
      likes: 4,
    ),
    _MarketProduct(
      id: 'iphone-13-mini',
      title: '아이폰 13 미니 그린 128GB',
      price: 150000,
      location: '성남동 · 6분 전',
      imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=900&q=82',
      category: '아이폰',
      isBump: true,
      likes: 8,
    ),
    _MarketProduct(
      id: 'iphone-14-pro',
      title: '아이폰 14 프로 골드 256GB',
      price: 490000,
      location: '태평4동 · 14분 전',
      imageUrl: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=900&q=82',
      category: '아이폰',
      likes: 21,
    ),
    _MarketProduct(
      id: 'airpods-pro',
      title: '에어팟 프로 판매합니다 (완박)',
      price: 150000,
      location: '위례동 · 27분 전',
      imageUrl: 'https://images.unsplash.com/photo-1603351154351-5e2d0600bb77?auto=format&fit=crop&w=900&q=82',
      category: '에어팟',
      likes: 3,
    ),
    _MarketProduct(
      id: 'airpods-2024',
      title: 'Apple 2024 에어팟 4 노이즈 캔슬링',
      price: 150000,
      location: '양평동 · 8분 전',
      imageUrl: 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=900&q=82',
      category: '에어팟',
      isBump: true,
      likes: 9,
    ),
    _MarketProduct(
      id: 'airpods-wireless',
      title: '애플 에어팟 4세대 무선 이어폰',
      price: 110000,
      location: '송파동 · 18분 전',
      imageUrl: 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=900&q=82',
      category: '에어팟',
      isBump: true,
      likes: 2,
    ),
    _MarketProduct(
      id: 'apple-pencil',
      title: '애플펜슬 프로 풀박스',
      price: 110000,
      location: '문정동 · 2분 전',
      imageUrl: 'https://images.unsplash.com/photo-1583394838336-acd977736f90?auto=format&fit=crop&w=900&q=82',
      category: '주변기기',
      likes: 6,
    ),
    _MarketProduct(
      id: 'iphone-15',
      title: '아이폰 15 블루 256GB 상태 좋아요',
      price: 560000,
      location: '복정동 · 31분 전',
      imageUrl: 'https://images.unsplash.com/photo-1592899677977-9c10ca588bbd?auto=format&fit=crop&w=900&q=82',
      category: '아이폰',
      isBump: true,
      likes: 16,
    ),
    _MarketProduct(
      id: 'apple-watch',
      title: '애플워치 SE 2세대 나이키 에디션',
      price: 190000,
      location: '신흥동 · 45분 전',
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=900&q=82',
      category: '주변기기',
      likes: 11,
    ),
    _MarketProduct(
      id: 'macbook',
      title: '맥북 에어 M2 13인치 실버',
      price: 820000,
      location: '위례동 · 1시간 전',
      imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=900&q=82',
      category: '주변기기',
      likes: 7,
    ),
    _MarketProduct(
      id: 'iphone-case',
      title: '아이폰 정품 맥세이프 케이스 새상품',
      price: 35000,
      location: '창곡동 · 1시간 전',
      imageUrl: 'https://images.unsplash.com/photo-1603313011108-4f2e5f4c64d5?auto=format&fit=crop&w=900&q=82',
      category: '주변기기',
      isBump: true,
      likes: 5,
    ),
  ];

  final TextEditingController _searchController = TextEditingController(
    text: '애플',
  );
  final Set<String> _favoriteIds = {};
  String _searchQuery = '애플';
  String _selectedNavigation = '중고거래';
  String _selectedProductCategory = '전체';
  String _location = '경기도 성남시 수정구 위례동';
  int? _maximumPrice;
  bool _bumpOnly = false;

  List<_MarketProduct> get _visibleProducts {
    final query = _searchQuery.trim().toLowerCase();
    final queryAliases = query == '애플' || query == 'apple'
        ? ['애플', 'apple']
        : [query];
    final products = _products.where((product) {
      final title = product.title.toLowerCase();
      final matchesQuery =
          query.isEmpty || queryAliases.any((alias) => title.contains(alias));
      final matchesCategory =
          _selectedProductCategory == '전체' ||
          product.category == _selectedProductCategory;
      final matchesPrice =
          _maximumPrice == null || product.price <= _maximumPrice!;
      final matchesBump = !_bumpOnly || product.isBump;
      return matchesQuery && matchesCategory && matchesPrice && matchesBump;
    }).toList();

    if (_selectedNavigation != '중고거래' && _selectedNavigation != '전체') {
      return [];
    }
    return products;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilters() {
    var draftMaximumPrice = _maximumPrice;
    var draftBumpOnly = _bumpOnly;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '검색 필터',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 20),
                const Text('가격', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 8,
                  children: [
                    _PriceFilterChip(
                      label: '전체 가격',
                      selected: draftMaximumPrice == null,
                      onSelected: () => setSheetState(() {
                        draftMaximumPrice = null;
                      }),
                    ),
                    _PriceFilterChip(
                      label: '10만원 이하',
                      selected: draftMaximumPrice == 100000,
                      onSelected: () => setSheetState(() {
                        draftMaximumPrice = 100000;
                      }),
                    ),
                    _PriceFilterChip(
                      label: '30만원 이하',
                      selected: draftMaximumPrice == 300000,
                      onSelected: () => setSheetState(() {
                        draftMaximumPrice = 300000;
                      }),
                    ),
                  ],
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('끌어올린 상품만 보기'),
                  value: draftBumpOnly,
                  onChanged: (value) => setSheetState(() {
                    draftBumpOnly = value;
                  }),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _maximumPrice = draftMaximumPrice;
                      _bumpOnly = draftBumpOnly;
                    });
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: const Color(0xFFFF7A24),
                  ),
                  child: const Text('결과 보기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMap() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.map_outlined,
          color: Color(0xFFFF7A24),
          size: 32,
        ),
        title: const Text('내 근처 검색'),
        content: Text('현재 위치를 기준으로 상품을 찾고 있어요.\n$_location'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  void _showProduct(_MarketProduct product) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const _ProductImageFallback(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product.title,
                style: const TextStyle(
                  color: Color(0xFF25292D),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                '${_formatPrice(product.price)}원',
                style: const TextStyle(
                  color: Color(0xFF25292D),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('채팅으로 거래하기'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: const Color(0xFFFF7A24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 680;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  children: [
                    _buildHeader(isNarrow),
                    _buildNavigation(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          isNarrow ? 16 : 24,
                          18,
                          isNarrow ? 16 : 24,
                          32,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildResultHeading(isNarrow),
                            const SizedBox(height: 14),
                            _buildFilters(isNarrow),
                            const SizedBox(height: 16),
                            _buildProductGrid(constraints.maxWidth),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isNarrow) {
    final brand = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.eco_rounded, color: Color(0xFF00A878), size: 25),
        const SizedBox(width: 3),
        const Text(
          '당근',
          style: TextStyle(
            color: Color(0xFFFF7A24),
            fontSize: 21,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
    final search = SizedBox(
      height: 44,
      child: TextField(
        key: const ValueKey('market-search-field'),
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        onSubmitted: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: '동네 이름, 물품명 등을 검색해보세요',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF687078)),
          suffixIcon: IconButton(
            tooltip: '검색어 지우기',
            onPressed: () {
              _searchController.clear();
              setState(() => _searchQuery = '');
            },
            icon: const Icon(Icons.close, size: 18),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFE8EAEC)),
            borderRadius: BorderRadius.circular(24),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFFF9A58)),
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: '채팅',
          onPressed: () {},
          icon: const Icon(Icons.chat_bubble_outline),
          color: const Color(0xFF4E555B),
        ),
        IconButton(
          tooltip: '알림',
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
          color: const Color(0xFF4E555B),
        ),
      ],
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 14, 24, isNarrow ? 12 : 10),
      child: isNarrow
          ? Column(
              children: [
                Row(children: [brand, const Spacer(), actions]),
                const SizedBox(height: 9),
                search,
              ],
            )
          : Row(
              children: [
                brand,
                const SizedBox(width: 22),
                Expanded(child: search),
                const SizedBox(width: 12),
                actions,
              ],
            ),
    );
  }

  Widget _buildNavigation() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: _navigationItems.length,
        separatorBuilder: (context, index) => const SizedBox(width: 5),
        itemBuilder: (context, index) {
          final item = _navigationItems[index];
          final selected = item == _selectedNavigation;
          return Center(
            child: ChoiceChip(
              label: Text(item),
              selected: selected,
              onSelected: (_) => setState(() => _selectedNavigation = item),
              showCheckmark: false,
              labelStyle: TextStyle(
                color: selected ? Colors.white : const Color(0xFF5F666D),
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
              selectedColor: const Color(0xFF30363B),
              backgroundColor: Colors.white,
              side: BorderSide(
                color: selected ? const Color(0xFF30363B) : Colors.transparent,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              visualDensity: VisualDensity.compact,
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultHeading(bool isNarrow) {
    final heading = Text(
      '“$_searchQuery” 중고거래 검색 결과',
      key: const ValueKey('search-results-heading'),
      style: TextStyle(
        color: const Color(0xFF25292D),
        fontSize: isNarrow ? 16 : 18,
        fontWeight: FontWeight.w800,
      ),
    );
    final location = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.location_on_outlined,
          size: 14,
          color: Color(0xFF858C92),
        ),
        const SizedBox(width: 2),
        Flexible(
          child: Text(
            _location,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF70777D), fontSize: 11),
          ),
        ),
      ],
    );

    return isNarrow
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [heading, const SizedBox(height: 5), location],
          )
        : Row(
            children: [
              heading,
              const SizedBox(width: 10),
              Expanded(child: location),
            ],
          );
  }

  Widget _buildFilters(bool isNarrow) {
    final controls = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: _showFilters,
            icon: const Icon(Icons.tune, size: 15),
            label: const Text('필터'),
            style: _smallButtonStyle(),
          ),
          const SizedBox(width: 7),
          OutlinedButton(
            onPressed: () {},
            style: _smallButtonStyle(),
            child: const Text('지역 선택'),
          ),
          const SizedBox(width: 7),
          FilledButton.icon(
            onPressed: _showMap,
            icon: const Icon(Icons.my_location, size: 14),
            label: const Text('현재 위치로 설정'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 34),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              backgroundColor: const Color(0xFF30363B),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    final mapButton = TextButton.icon(
      onPressed: _showMap,
      icon: const Icon(Icons.map_outlined, size: 15),
      label: const Text('지도에서 보기'),
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF42494F),
        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );

    return Row(
      children: [
        Expanded(child: controls),
        if (!isNarrow) const SizedBox(width: 8),
        mapButton,
      ],
    );
  }

  ButtonStyle _smallButtonStyle() {
    return OutlinedButton.styleFrom(
      minimumSize: const Size(0, 34),
      padding: const EdgeInsets.symmetric(horizontal: 11),
      foregroundColor: const Color(0xFF42494F),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFE4E7E9)),
      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildProductGrid(double width) {
    final products = _visibleProducts;
    if (products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 70),
        child: Column(
          children: [
            const Icon(Icons.search_off, size: 44, color: Color(0xFFB3B9BE)),
            const SizedBox(height: 12),
            Text(
              _selectedNavigation == '중고거래' || _selectedNavigation == '전체'
                  ? '검색 결과가 없어요.'
                  : '이 메뉴의 동네 소식은 준비 중이에요.',
              style: const TextStyle(
                color: Color(0xFF656D73),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    final columns = width >= 950
        ? 4
        : width >= 650
        ? 3
        : 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              '중고거래 ${products.length}',
              key: const ValueKey('product-count'),
              style: const TextStyle(
                color: Color(0xFF747B81),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            _buildCategorySelector(),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          key: const ValueKey('product-grid'),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 14,
            mainAxisSpacing: 22,
            childAspectRatio: columns == 2 ? 0.76 : 0.70,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return _ProductTile(
              key: ValueKey('product-tile-${product.id}'),
              index: index,
              product: product,
              isFavorite: _favoriteIds.contains(product.id),
              onFavorite: () => setState(() {
                if (!_favoriteIds.add(product.id))
                  _favoriteIds.remove(product.id);
              }),
              onTap: () => _showProduct(product),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    const categories = ['전체', '에어팟', '아이폰', '주변기기'];
    return PopupMenuButton<String>(
      tooltip: '상품 종류 선택',
      initialValue: _selectedProductCategory,
      onSelected: (value) => setState(() => _selectedProductCategory = value),
      itemBuilder: (context) => categories
          .map(
            (category) => PopupMenuItem(value: category, child: Text(category)),
          )
          .toList(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _selectedProductCategory,
            style: const TextStyle(color: Color(0xFF51585E), fontSize: 11),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 17,
            color: Color(0xFF737A80),
          ),
        ],
      ),
    );
  }
}

class _MarketProduct {
  const _MarketProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.location,
    required this.imageUrl,
    required this.category,
    this.isBump = false,
    this.likes = 0,
  });

  final String id;
  final String title;
  final int price;
  final String location;
  final String imageUrl;
  final String category;
  final bool isBump;
  final int likes;
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    super.key,
    required this.index,
    required this.product,
    required this.isFavorite,
    required this.onFavorite,
    required this.onTap,
  });

  final int index;
  final _MarketProduct product;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _HoverProductImage(
            index: index,
            imageUrl: product.imageUrl,
            isFavorite: isFavorite,
            onFavorite: onFavorite,
            onTap: onTap,
          ),
        ),
        const SizedBox(height: 7),
        InkWell(
          onTap: onTap,
          child: Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF353A3E),
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${_formatPrice(product.price)}원',
          style: const TextStyle(
            color: Color(0xFF282D31),
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            Expanded(
              child: Text(
                product.location,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF858C91), fontSize: 10),
              ),
            ),
            if (product.likes > 0) ...[
              const Icon(
                Icons.favorite_border,
                size: 11,
                color: Color(0xFF9AA0A4),
              ),
              const SizedBox(width: 2),
              Text(
                '${product.likes}',
                style: const TextStyle(color: Color(0xFF858C91), fontSize: 9),
              ),
            ],
          ],
        ),
        if (product.isBump) ...[const SizedBox(height: 4), const _BumpBadge()],
      ],
    );
  }
}

class _HoverProductImage extends StatefulWidget {
  const _HoverProductImage({
    required this.index,
    required this.imageUrl,
    required this.isFavorite,
    required this.onFavorite,
    required this.onTap,
  });

  final int index;
  final String imageUrl;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  @override
  State<_HoverProductImage> createState() => _HoverProductImageState();
}

class _HoverProductImageState extends State<_HoverProductImage> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: MouseRegion(
        key: ValueKey('product-image-hover-${widget.index}'),
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Material(
              color: const Color(0xFFE8EBED),
              child: InkWell(
                onTap: widget.onTap,
                child: AnimatedScale(
                  key: ValueKey('product-image-scale-${widget.index}'),
                  scale: _isHovered ? 1.08 : 1,
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.medium,
                    loadingBuilder: (context, child, progress) =>
                        progress == null
                        ? child
                        : const _ProductImageFallback(showIcon: false),
                    errorBuilder: (context, error, stackTrace) =>
                        const _ProductImageFallback(),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 7,
              right: 7,
              child: Material(
                color: Colors.white.withValues(alpha: 0.92),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: widget.onFavorite,
                  customBorder: const CircleBorder(),
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Icon(
                      isFavoriteIcon(widget.isFavorite),
                      size: 16,
                      color: widget.isFavorite
                          ? const Color(0xFFE86C59)
                          : const Color(0xFF555D62),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImageFallback extends StatelessWidget {
  const _ProductImageFallback({this.showIcon = true});

  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE8EBED),
      child: showIcon
          ? const Center(
              child: Icon(
                Icons.image_outlined,
                size: 32,
                color: Color(0xFFADB4B8),
              ),
            )
          : const SizedBox.expand(),
    );
  }
}

class _BumpBadge extends StatelessWidget {
  const _BumpBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.local_fire_department,
          size: 11,
          color: Color(0xFFFF7A24),
        ),
        const SizedBox(width: 2),
        Text(
          '끌어올림',
          style: TextStyle(
            color: const Color(0xFFE66C22),
            fontSize: 9,
            fontWeight: FontWeight.w700,
            backgroundColor: const Color(0xFFFFF0E5),
          ),
        ),
      ],
    );
  }
}

class _PriceFilterChip extends StatelessWidget {
  const _PriceFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      showCheckmark: false,
    );
  }
}

IconData isFavoriteIcon(bool isFavorite) =>
    isFavorite ? Icons.favorite : Icons.favorite_border;

String _formatPrice(int price) {
  return price.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => ',',
  );
}

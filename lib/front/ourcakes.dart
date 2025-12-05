// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:indiangrill/front/orderonline.dart';
class OurCakes extends StatefulWidget {
  const OurCakes({super.key});

  @override
  OurCakesState createState() => OurCakesState();
}

class OurCakesState extends State<OurCakes> {
  late bool isMobileDevice;
  final WooCommerceService wooCommerceService = WooCommerceService();
  final WooCommerceCategory wooCommerceCategory = WooCommerceCategory();
  List<dynamic> products = [];
  List<Map<String, String>> categories = []; // Dynamic categories list with IDs
  bool isLoading = false;
  bool isLoadingMore = false;
  int currentPage = 1;
  int totalProducts = 0;
  int productsPerPage = 21;
  int totalPages = 1;
  String? selectedCategoryId = '73'; // Default category ID
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final screenWidth = WidgetsBinding.instance.window.physicalSize.width /
        WidgetsBinding.instance.window.devicePixelRatio;
    isMobileDevice = screenWidth < 600;
    fetchCategories(); // Fetch categories
    fetchTotalProductsCount(); // Fetch total count
    fetchProducts(
        page: currentPage,
        category: selectedCategoryId); // Fetch products for the first page
    if (isMobileDevice) {
      _scrollController.addListener(_onScroll);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore && currentPage < totalPages) {
        loadMoreProducts();
      }
    }
  }

  void loadMoreProducts() async {
    if (isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    int nextPage = currentPage + 1;

    List<dynamic> moreProducts = await wooCommerceService.fetchProducts(
      offset: (nextPage - 1) * productsPerPage,
      productsPerPage: productsPerPage,
      category: selectedCategoryId,
    );

    setState(() {
      currentPage = nextPage;
      products.addAll(moreProducts);
      isLoadingMore = false;
    });
  }

  void fetchCategories() async {
    try {
      List<dynamic> fetchedCategories =
          await wooCommerceCategory.fetchSubcategories();
      setState(() {
        categories = [
              {'name': 'ALL', 'id': '73'}
            ] +
            fetchedCategories.map<Map<String, String>>((cat) {
              return {'name': cat['name'], 'id': cat['id'].toString()};
            }).toList();
      });
    } catch (error) {
    //  print("Error fetching categories: $error");
    }
  }

  @override
  void dispose() {
    if (isMobileDevice) {
      _scrollController.removeListener(_onScroll);
    }
    _scrollController.dispose(); // Dispose controller when not needed
    super.dispose();
  }

  // Fetch products for the current page
  // Fetch products for the current page
  void fetchProducts({required int page, String? category}) async {
    setState(() {
      isLoading = true;
    });

    int offset = (page - 1) * productsPerPage;

    List<dynamic> fetchedProducts = await wooCommerceService.fetchProducts(
      offset: offset,
      productsPerPage: productsPerPage,
      category: category ??
          selectedCategoryId, // If category is null (for 'ALL'), fetch without category filter
    );

    setState(() {
      isLoading = false;

      currentPage = page;
      if (page == 1 || !isMobileDevice) {
        products = fetchedProducts;
        fetchTotalProductsCount(); // Recalculate total products count when changing category
      } else {
        products.addAll(fetchedProducts);
      }
    });
  }

  // Fetch the total number of products
  // Fetch the total number of products for the selected category
  void fetchTotalProductsCount() async {
    int count = await wooCommerceService.fetchTotalProductsCount(
        category: selectedCategoryId);
    setState(() {
      totalProducts = count;
      totalPages = (totalProducts / productsPerPage).ceil();
    });
  }

  void onCategorySelected(Map<String, String> category) {
    String? categoryId = category['name'] == 'ALL'
        ? '73'
        : category['id']; // If 'ALL', set categoryId to null
    setState(() {
      selectedCategoryId = categoryId; // If 'ALL', categoryId will be null
      currentPage = 1; // Reset to page 1 when category is changed
      products = []; // Clear the products when "ALL" is selected
    });

    if (categoryId != null) {
      fetchProducts(
          page: 1,
          category: selectedCategoryId); // Fetch products for the first page
      fetchTotalProductsCount(); // Fetch the total count of products (recalculate)
    }
  }

  // Handle page selection from the pagination bar
  void onPageSelected(int page) {
    if (page != currentPage) {
      fetchProducts(page: page, category: selectedCategoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1024) {
      return buildDesktopLayout();
    } else if (screenWidth >= 600) {
      return buildTabletLayout();
    } else {
      return buildMobileLayout();
    }
  }

  Widget buildDesktopLayout() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(190, 40, 190, 40),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: SidebarWidget(
                  items: categories,
                  onCategorySelected: onCategorySelected,
                  selectedCategoryId: selectedCategoryId,
                ),
              ),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              children: [
                                ProductGrid(
                                    products: products,
                                    controller: _scrollController),
                                const SizedBox(height: 20),
                                if (totalProducts > productsPerPage)
                                  PaginationBar(
                                    currentPage: currentPage,
                                    totalPages: totalPages,
                                    onPageSelected: onPageSelected,
                                  ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTabletLayout() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: SidebarWidget(
              items: categories,
              onCategorySelected: onCategorySelected,
              selectedCategoryId: selectedCategoryId,
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: buildProductsArea(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMobileLayout() {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height, // Provides constraints
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HorizontalSidebarWidget(
              items: categories,
              onCategorySelected: onCategorySelected,
              selectedCategoryId: selectedCategoryId,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: buildMobileProductsGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMobileProductsGrid() {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final bottomNavHeight = isMobile ? kBottomNavigationBarHeight : 0;

    if (isLoading && products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      controller: _scrollController, // infinite scroll works
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + bottomNavHeight + 70,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.6, // matches your design
      ),
      itemCount: products.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == products.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(color: Colors.red),
            ),
          );
        }

        return ProductCardMobile(product: products[index]);
      },
    );
  }

  // Widget buildMobileLayout() {
  //   return Container(
  //     color: Colors.white,
  //     height: MediaQuery.of(context).size.height, // Provides constraints
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           HorizontalSidebarWidget(
  //             items: categories,
  //             onCategorySelected: onCategorySelected,
  //             selectedCategoryId: selectedCategoryId,
  //           ),
  //           const SizedBox(height: 20),
  //           Expanded(
  //             child: buildMobileProductsGrid(),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget buildMobileProductsGrid() {
  //   final bool isMobile = MediaQuery.of(context).size.width < 600;
  //   final bottomNavHeight = isMobile ? kBottomNavigationBarHeight : 0;

  //   if (isLoading && products.isEmpty) {
  //     return const Center(child: CircularProgressIndicator());
  //   }

  //   return GridView.builder(
  //     controller: _scrollController, // infinite scroll works
  //     padding: EdgeInsets.only(
  //       bottom: MediaQuery.of(context).padding.bottom + bottomNavHeight + 70,
  //     ),
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 1,
  //       // mainAxisSpacing: 12,
  //       // crossAxisSpacing: 12,
  //       // childAspectRatio: 0.72, // matches your design
  //     ),
  //     itemCount: products.length + (isLoadingMore ? 1 : 0),
  //     itemBuilder: (context, index) {
  //       if (index == products.length) {
  //         return const Center(
  //           child: Padding(
  //             padding: EdgeInsets.all(12),
  //             child: CircularProgressIndicator(color: Colors.red),
  //           ),
  //         );
  //       }

  //       return ProductCard(product: products[index]);
  //     },
  //   );
  // }

  Widget buildProductsArea() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  ProductGrid(
                    products: products,
                    controller: _scrollController,
                    isMobile: true,
                  ),
                  const SizedBox(height: 20),
                  if (!isMobileDevice && totalProducts > productsPerPage)
                    PaginationBar(
                      currentPage: currentPage,
                      totalPages: totalPages,
                      onPageSelected: onPageSelected,
                    ),
                ],
              ),
      ],
    );
  }
}

class ProductCardMobile extends StatelessWidget {
  final dynamic product;

  const ProductCardMobile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    String imageUrl = product['image'] ?? 'https://via.placeholder.com/200';
    String safeImageUrl =
        'https://images.weserv.nl/?url=${Uri.encodeComponent(imageUrl)}';
  //  print(safeImageUrl);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: Color.fromARGB(255, 255, 135, 135), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- IMAGE SECTION ----------------
          GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed('cakeDetails', extra: product);
            },
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey.shade100,
                child: CachedNetworkImage(
                  imageUrl: safeImageUrl,
                  fit: BoxFit.cover,

                  // Placeholder while loading
                  placeholder: (_, __) => Center(
                    child: SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: Colors.red.shade300,
                      ),
                    ),
                  ),

                  // Error fallback
                  errorWidget: (_, __, ___) => const Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ---------------- NAME ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 40,
              child: Center(
                child: Text(
                  product['name'] ?? 'Cake Item',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),

          const Spacer(),

          // ---------------- ORDER NOW BUTTON ----------------
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).pushNamed('orderCake', extra: product);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffE2001A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Order Now",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SidebarWidget extends StatelessWidget {
  final List<Map<String, String>> items;
  final ValueChanged<Map<String, String>> onCategorySelected;
  final String? selectedCategoryId; // Add this property

  const SidebarWidget({
    super.key,
    required this.items,
    required this.onCategorySelected,
    required this.selectedCategoryId, // Add this to the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffdddddd), width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(items.length, (index) {
          final category = items[index];
          final isSelected = category['id'] == selectedCategoryId;

          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                onCategorySelected(category);
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.grey[300] : Colors.white,
                  border: Border(
                    bottom: index != items.length - 1
                        ? const BorderSide(color: Color(0xffdddddd), width: 0.5)
                        : BorderSide.none,
                  ),
                ),
                child: Text(
                  category['name'] ?? 'Unknown',
                  style: GoogleFonts.raleway(
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.black : const Color(0xff666666),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final List<dynamic> products;
  final ScrollController? controller;
  final bool isMobile;

  const ProductGrid({
    super.key,
    required this.products,
    this.controller,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 30.0,
        childAspectRatio: isMobile ? 0.65 : 0.75,
      ),
      itemBuilder: (context, index) {
        var product = products[index];

        String imageUrl = product['image'] ?? 'https://via.placeholder.com/200';
        final String safeImageUrl =
            'https://images.weserv.nl/?url=${Uri.encodeComponent(imageUrl)}';

        // Example target URLs (replace with your real links or navigation logic)
      

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffdddddd), width: 0.5),
          ),
          child: Column(
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    GoRouter.of(context)
                        .pushNamed('cakeDetails', extra: product);
                  },
                  child: Image.network(
                    safeImageUrl,
                    height: isMobile ? 120 : 200,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Product name
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    product['name'] ?? 'Unnamed Product',
                    style: GoogleFonts.raleway(
                      fontSize: isMobile ? 13 : 15,
                      color: const Color(0xff666666),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 👇 Separate "Order Now" button (clickable independently)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).pushNamed('orderCake', extra: product);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffE2001A),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(
                    "Order Now",
                    style: GoogleFonts.raleway(
                      fontSize: isMobile ? 11 : 13,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

class PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageSelected;

  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        int page = index + 1;
        return GestureDetector(
          onTap: () {
            onPageSelected(page);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: page == currentPage
                  ? const Color(0xffE2001A)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$page',
              style: TextStyle(
                color: page == currentPage ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class WooCommerceService {
  final String baseUrl =
      'https://www.dev.indian-grill.com/wp-json/wc/v1/products';
  final String consumerKey = 'ck_67efc00d8d814b67877da8fffad40d61d4366602';
  final String consumerSecret = 'cs_4cd4f797f1aef69089a3ce3f008d6726e98f352b';
  final String cakeCategoryId = '73';
  final int productsPerPage = 10;

  Future<List<Map<String, dynamic>>> fetchProducts({
    required int offset,
    required int productsPerPage,
    String? category,
  }) async {
    final String credentials =
        base64Encode(utf8.encode('$consumerKey:$consumerSecret'));
    final headers = {
      'Authorization': 'Basic $credentials',
      'Content-Type': 'application/json',
    };

    // Use the default category (73) if no category is provided
    category ??= cakeCategoryId;

    // Modify the URL to include category and offset
    String url = '$baseUrl?per_page=$productsPerPage&offset=$offset';
    url +=
        '&category=$category'; // Only include category filter if it's not null

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> products = json.decode(response.body);
        return products.map((product) {
          String imageUrl =
              product['images'].isNotEmpty ? product['images'][0]['src'] : '';
          return {
            'name': product['name'],
            'price': product['price'],
            'image': imageUrl,
          };
        }).toList();
      } else {
 //       print('Failed to fetch products. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
 //     print('Unexpected error: $e');
      return [];
    }
  }

  Future<int> fetchTotalProductsCount({String? category}) async {
    final String credentials =
        base64Encode(utf8.encode('$consumerKey:$consumerSecret'));
    final headers = {
      'Authorization': 'Basic $credentials',
      'Content-Type': 'application/json',
    };

    try {
      String url = '$baseUrl?per_page=1';
      if (category != null) {
        url += '&category=$category';
      }

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        int totalCount = int.parse(response.headers['x-wp-total'] ?? '0');
        return totalCount;
      } else {
        return 0;
      }
    } catch (e) {
    //  print('Error fetching total count: $e');
      return 0;
    }
  }
}

class WooCommerceCategory {
  final String baseUrl = "https://www.dev.indian-grill.com";
  final String consumerKey = "ck_67efc00d8d814b67877da8fffad40d61d4366602";
  final String consumerSecret = "cs_4cd4f797f1aef69089a3ce3f008d6726e98f352b";
  final String categoryId = '73';

  Future<List<dynamic>> fetchSubcategories() async {
    final String url =
        "$baseUrl/wp-json/wc/v1/products/categories?parent=$categoryId&consumer_key=$consumerKey&consumer_secret=$consumerSecret";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Decode the JSON response
        List<dynamic> data = json.decode(response.body);
        // print(data);
        return data; // Returns list of subcategories
      } else {
        throw Exception(
            'Failed to load subcategories with status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching subcategories: $error');
    }
  }
}

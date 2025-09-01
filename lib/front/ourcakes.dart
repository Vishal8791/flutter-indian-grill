import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OurCakes extends StatefulWidget {
  const OurCakes({super.key});

  @override
  _OurCakesState createState() => _OurCakesState();
}

class _OurCakesState extends State<OurCakes> {
  final WooCommerceService wooCommerceService = WooCommerceService();
  final WooCommerceCategory wooCommerceCategory = WooCommerceCategory();
  List<dynamic> products = [];
  List<Map<String, String>> categories = []; // Dynamic categories list with IDs
  bool isLoading = false;
  int currentPage = 1;
  int totalProducts = 0;
  int productsPerPage = 10;
  int totalPages = 1;
  String? selectedCategoryId = '73'; // Default category ID
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Fetch categories
    fetchTotalProductsCount(); // Fetch total count
    fetchProducts(
        page: currentPage,
        category: selectedCategoryId); // Fetch products for the first page
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
      print("Error fetching categories: $error");
    }
  }

  @override
  void dispose() {
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
      products = fetchedProducts;
      currentPage = page;
      if (page == 1) {
        fetchTotalProductsCount(); // Recalculate total products count when changing category
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
                  selectedCategoryId:
                      selectedCategoryId, // Pass the selected category ID here
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
                                // Check if pagination is needed
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
  final ScrollController controller;

  const ProductGrid({
    super.key,
    required this.products,
    required this.controller, // Accept the controller here
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller, // Use the controller here
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 30.0,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        var product = products[index];
        String imageUrl = product['image'] ?? 'https://via.placeholder.com/200';

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffdddddd), width: 0.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(
                imageUrl,
                height: 200,
                width: 200,
                fit: BoxFit.contain,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    double progress = loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : 0.0;
                    return Center(
                      child: CircularProgressIndicator(value: progress),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                      child: Icon(Icons.error, color: Colors.red));
                },
              ),
              const SizedBox(height: 10),
              Text(
                product['name'] ?? 'Unnamed Product',
                style: GoogleFonts.raleway(
                    fontSize: 15, color: const Color(0xff666666)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffE2001A),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                  child: Text(
                    "Order Now",
                    style:
                        GoogleFonts.raleway(fontSize: 13, color: Colors.white),
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
  final String baseUrl = 'https://www.indian-grill.com/wp-json/wc/v1/products';
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
        print('Failed to fetch products. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Unexpected error: $e');
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
      print('Error fetching total count: $e');
      return 0;
    }
  }
}

class WooCommerceCategory {
  final String baseUrl = "https://www.indian-grill.com";
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
        print(data);
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

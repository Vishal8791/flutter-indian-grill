// import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:indiangrill/front/cart_page.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../providers/cart_provider.dart';

class OrderOnline extends StatefulWidget {
  const OrderOnline({super.key});

  @override
  _OrderOnlineState createState() => _OrderOnlineState();
}

class _OrderOnlineState extends State<OrderOnline> {
  final WooCommerceService wooCommerceService = WooCommerceService();
  final WooCommerceCategory wooCommerceCategory = WooCommerceCategory();
  List<dynamic> products = [];
  List<Map<String, String>> categories = [];
  bool isLoading = false;
  int currentPage = 1;
  int totalProducts = 0;
  int productsPerPage = 10;
  int totalPages = 1;
  String? selectedCategoryId = '60';
  final ScrollController _scrollController = ScrollController();
  // MOBILE infinite scroll state
  final ScrollController mobileScrollController = ScrollController();
  List<dynamic> mobileProducts = [];
  int mobilePage = 1;
  bool mobileLoading = false;
  bool mobileHasMore = true;

  final List<String> notes = [
    "Allow extra 15 minutes for preparation time on Friday and Saturday than average waiting time.",
    "Payment by Credit Card the order amount must be at least \$15, in order to pay by Paypal/Credit Card"
  ];
  int? expandedIndex; // Track expanded index

  @override
void initState() {
  super.initState();

  // existing initial calls (keep these if you still want desktop data)
  fetchCategories();
  fetchTotalProductsCount();
  fetchProducts(page: currentPage, category: selectedCategoryId);

  // mobile infinite scroll initial load & listener
  _loadInitialMobileProducts();
mobileScrollController.addListener(() {
  //print("Scrolling...  pixels = ${mobileScrollController.position.pixels}");

  if (mobileScrollController.position.pixels >=
      mobileScrollController.position.maxScrollExtent - 200) {
  //  print("🔥 Reached bottom threshold — should load more");
    _loadMoreMobileProducts();
  }
});

}


  Future<void> _loadFirstMobilePage() async {
  setState(() {
    mobileProducts = [];
    mobilePage = 1;
    mobileHasMore = true;
  });

  await _loadMoreMobileProducts();
}

/// Resets and loads the first page for mobile
Future<void> _loadInitialMobileProducts() async {
  setState(() {
    mobileProducts = [];
    mobilePage = 1;
    mobileHasMore = true;
    mobileLoading = false;
  });

  await _loadMoreMobileProducts();
}

/// Loads next page and appends results (uses your existing wooCommerceService)
Future<void> _loadMoreMobileProducts() async {
  if (mobileLoading || !mobileHasMore) return;

  setState(() => mobileLoading = true);

  try {
    final int offset = (mobilePage - 1) * productsPerPage;

    final List<dynamic> fetched = await wooCommerceService.fetchProducts(
      offset: offset,
      productsPerPage: productsPerPage,
      category: selectedCategoryId,
    );

    setState(() {
      if (fetched.isNotEmpty) {
        mobileProducts.addAll(fetched);

        // If fetched fewer than page size, no more pages.
        if (fetched.length < productsPerPage) {
          mobileHasMore = false;
        } else {
          mobilePage++;
        }
      } else {
        mobileHasMore = false;
      }
    });
  } catch (e) {
    // optionally show error/snackbar
    debugPrint("Error loading mobile products: $e");
  } finally {
    if (mounted) {
      setState(() => mobileLoading = false);
    }
  }
}


  void fetchCategories() async {
    try {
      List<dynamic> fetchedCategories =
          await wooCommerceCategory.fetchSubcategories();
      setState(() {
        categories = [
              {'name': 'ALL', 'id': '60'}
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
    mobileScrollController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void fetchProducts({required int page, String? category}) async {
    setState(() {
      isLoading = true;
    });

    int offset = (page - 1) * productsPerPage;

    List<dynamic> fetchedProducts = await wooCommerceService.fetchProducts(
      offset: offset,
      productsPerPage: productsPerPage,
      category: category ?? selectedCategoryId,
    );

    setState(() {
      isLoading = false;
      products = fetchedProducts;
      currentPage = page;
      if (page == 1) {
        fetchTotalProductsCount();
      }
    });
  }

  void fetchTotalProductsCount() async {
    int count = await wooCommerceService.fetchTotalProductsCount(
        category: selectedCategoryId);
    setState(() {
      totalProducts = count;
      totalPages = (totalProducts / productsPerPage).ceil();
    });
  }

  void onCategorySelected(Map<String, String> category) {
    String? categoryId = category['name'] == 'ALL' ? '60' : category['id'];
    setState(() {
      selectedCategoryId = categoryId;
      currentPage = 1;
      products = [];
      expandedIndex = null; // Reset expanded index when category changes
    });
    if (categoryId != null) {
      fetchProducts(page: 1, category: selectedCategoryId);
      fetchTotalProductsCount();
      _loadInitialMobileProducts();
    }
  }

  void onPageSelected(int page) {
    if (page != currentPage) {
      fetchProducts(page: page, category: selectedCategoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return _buildMobileLayout();
        } else if (constraints.maxWidth < 1024) {
          return _buildTabletLayout();
        } else {
          return _buildDesktopLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
  return Container(
    color: Colors.white,
    height: MediaQuery.of(context).size.height,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CATEGORY BAR (Fixed)
        HorizontalSidebarWidget(
          items: categories,
          onCategorySelected: onCategorySelected,
          selectedCategoryId: selectedCategoryId,
        ),

        const SizedBox(height: 10),

        // Scrollable part
        Expanded(
          child: SingleChildScrollView(
            controller: mobileScrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PRODUCT LIST (non-scrollable ListView)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: mobileProducts.length + (mobileHasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == mobileProducts.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final product = mobileProducts[index];

                    return MobileMenuItemCard(
                      key: ValueKey(index),
                      foodType: product['foodType'],
                      title: product['name'],
                      productId: product['productId'],
                      optionName: product['optionName'],
                      description: product['description'] ?? "No description available",
                      price: double.tryParse(product['price'] ?? "0") ?? 0.0,
                      isExpanded: expandedIndex == index,
                      onExpand: () {
                        setState(() {
                          expandedIndex = expandedIndex == index ? null : index;
                        });
                      },
                      baseOptions: List<String>.from(product['baseOptions'] ?? []),
                      comboOptions: List<String>.from(product['comboOptions'] ?? []),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // SPECIAL NOTES
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Special Notes",
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...notes.map(
                        (note) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("•  ",
                                  style: GoogleFonts.raleway(fontSize: 12)),
                              Expanded(
                                child: Text(
                                  note,
                                  style: GoogleFonts.raleway(fontSize: 13.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildTabletLayout() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: SidebarWidget(
              items: categories,
              onCategorySelected: onCategorySelected,
              selectedCategoryId: null,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 5,
            child: _buildProductList(),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Special Notes",
                      style: GoogleFonts.raleway(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...notes.map((note) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("•  ",
                                  style: GoogleFonts.raleway(
                                    fontSize: 14,
                                  )),
                              Expanded(
                                child: Text(
                                  note,
                                  style: GoogleFonts.raleway(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(190, 40, 190, 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: SidebarWidget(
              items: categories,
              onCategorySelected: onCategorySelected,
              selectedCategoryId: null,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 5,
            child: _buildProductList(),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Special Notes",
                      style: GoogleFonts.raleway(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...notes.map((note) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("•  ",
                                  style: GoogleFonts.raleway(
                                    fontSize: 14,
                                  )),
                              Expanded(
                                child: Text(
                                  note,
                                  style: GoogleFonts.raleway(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Row(
          children: [
            Row(
              children: [
                Image.asset('assets/images/veg.png', width: 28, height: 28),
                const SizedBox(width: 4),
                const Text('Veg', style: TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(width: 12),
            Container(width: 1, height: 18, color: Colors.grey),
            const SizedBox(width: 12),
            Row(
              children: [
                Image.asset('assets/images/spicy.jpg', width: 28, height: 28),
                const SizedBox(width: 4),
                const Text('Spicy', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
    
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Column(
      children: [
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          Column(
            children: [
              ...products.asMap().entries.map((entry) {
                int index = entry.key;
                var product = entry.value;

                return MenuItemCard(
                  key: ValueKey(index),
                  foodType: product['foodType'],
                  title: product['name'],
                  productId: product['productId'],
                  optionName: product['optionName'],
                  description:
                      product['description'] ?? 'No description available',
                  price: double.tryParse(product['price']) ?? 0.0,
                  isExpanded: expandedIndex == index,
                  onExpand: () {
                    setState(() {
                      expandedIndex = (expandedIndex == index) ? null : index;
                    });
                  },
                  baseOptions: List<String>.from(product['baseOptions'] ?? []),
                  comboOptions:
                      List<String>.from(product['comboOptions'] ?? []),
                );
              }),
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
    );
  }

  
}

class MenuItemCard extends StatefulWidget {
  final String title;
  final String foodType;
  final int productId;
  final String description;
  final String optionName;
  final double price;
  final bool isExpanded;
  final VoidCallback onExpand;
  final List<String> baseOptions;
  final List<String> comboOptions;

  const MenuItemCard(
      {super.key,
      required this.title,
      required this.foodType,
      required this.productId,
      required this.optionName,
      required this.description,
      required this.price,
      required this.isExpanded,
      required this.onExpand,
      required this.baseOptions,
      required this.comboOptions});

  @override
  _MenuItemCardState createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  int quantity = 1;
  String? selectedPreparation; // For Preparation selection
  String? selectedChoice; // For Choice of with Rice selection
  void _increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decreaseQuantity() {
    setState(() {
      if (quantity > 1) quantity--;
    });
  }

  final TextEditingController _specialInstController = TextEditingController();
  @override
  void dispose() {
    _specialInstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onExpand,
      child: Card(
        shape: Border.all(color: Colors.transparent),
        elevation: 0,
        child: Container(
          color: const Color(0xFFF7F7F7),
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Food Type Images
              SizedBox(
                width: 24, // fixed width to align text always
                child: Column(
                  children: [
                    if ((widget.foodType ?? '').toLowerCase().contains('veg'))
                      Image.asset('assets/images/veg.png',
                          width: 25, height: 25),
                    if ((widget.foodType ?? '').toLowerCase().contains('spicy'))
                      Image.asset('assets/images/spicy.jpg',
                          width: 25, height: 25),
                  ],
                ),
              ),

              const SizedBox(width: 8), // spacing between columns

              // Right Column: Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                        Text(
                          "\$${widget.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Description
                    Text(
                      widget.description,
                      style: GoogleFonts.raleway(
                          fontSize: 13, color: Colors.black),
                      textAlign: TextAlign.left,
                      softWrap: true,
                    ),

                    const SizedBox(height: 8),

                    // Expanded Options & Instructions
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 200),
                      firstChild: Container(),
                      secondChild: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Base Options
                            if (widget.baseOptions.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.optionName,
                                    style: GoogleFonts.raleway(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    children: widget.baseOptions.map((option) {
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Transform.scale(
                                            scale: 0.7,
                                            child: Radio<String>(
                                              value: option,
                                              groupValue: selectedPreparation,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedPreparation = value!;
                                                });
                                              },
                                              activeColor: Colors.blue,
                                            ),
                                          ),
                                          Text(option,
                                              style: const TextStyle(
                                                  fontSize: 14)),
                                          const SizedBox(width: 16),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),

                            const SizedBox(height: 16),

                            // Combo Option
                            if (widget.optionName != "Served With" &&
                                widget.comboOptions.isNotEmpty &&
                                selectedPreparation != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Choice of with Rice:",
                                    style: GoogleFonts.raleway(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Transform.scale(
                                        scale: 0.7,
                                        child: Radio<String>(
                                          value: widget.comboOptions.first,
                                          groupValue: selectedChoice,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedChoice = value!;
                                            });
                                          },
                                          activeColor: Colors.blue,
                                        ),
                                      ),
                                      Text(
                                        widget.comboOptions.first
                                            .replaceFirst(
                                                RegExp(r'^.*\+\s*'), '')
                                            .replaceAllMapped(
                                              RegExp(r'\(\+\s*\$?([\d.]+)\)'),
                                              (match) =>
                                                  '(\$${match.group(1)})',
                                            ),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                            const SizedBox(height: 16),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Special Instruction:',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                TextField(
                                  controller: _specialInstController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black54),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                  maxLines: 3,
                                  style:
                                      GoogleFonts.raleway(color: Colors.black),
                                ),
                              ],
                            ),

                            // Special Instructions

                            const SizedBox(height: 16),

                            // Quantity & Add to Cart
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove,
                                          color: Colors.black),
                                      onPressed: _decreaseQuantity,
                                    ),
                                    Text(quantity.toString(),
                                        style: GoogleFonts.raleway(
                                            color: Colors.black)),
                                    IconButton(
                                      icon: const Icon(Icons.add,
                                          color: Colors.black),
                                      onPressed: _increaseQuantity,
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final String preparation =
                                        selectedPreparation ?? '';
                                    final String choice = selectedChoice ?? '';
                                    final String specialInstruction =
                                        _specialInstController.text
                                            .trim(); // ✅ FIXED

                                    // Check if preparation is required based on product options
                                    bool isPreparationRequired = false;

                                    if (selectedPreparation != null &&
                                        widget.baseOptions.isNotEmpty) {
                                      isPreparationRequired = true;
                                    }
                                    if (widget.baseOptions.isEmpty) {
                                      isPreparationRequired = true;
                                    }

                                    if (!isPreparationRequired) {
                                      _showAlertBox(context,
                                          'Please select a preparation option');
                                      return;
                                    }

                                    List<Map<String, String>> selectedOptions =
                                        [];

                                    if (selectedPreparation != null) {
                                      selectedOptions.add({
                                        widget.optionName: selectedPreparation!
                                      });
                                    }

                                    if (widget.baseOptions.isNotEmpty) {
                                      if (selectedChoice != null) {
                                        selectedOptions.add(
                                            {"Choice of with Rice:": "Yes"});
                                      } else {
                                        selectedOptions.add(
                                            {"Choice of with Rice:": "No"});
                                      }
                                    }

                                    final String combinedOption =
                                        (preparation.isNotEmpty &&
                                                choice.isNotEmpty)
                                            ? '$preparation + $choice'
                                            : '$preparation$choice';

                                    _addToCart(
                                      context,
                                      widget.productId,
                                      widget.title,
                                      widget.price,
                                      quantity,
                                      combinedOption,
                                      specialInstruction, // ✅ FIXED
                                      selectedOptions,
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xffE2001A)),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    elevation: MaterialStateProperty.all(0),
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                    ),
                                  ),
                                  child: Text(
                                    'Add to cart',
                                    style: GoogleFonts.raleway(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      crossFadeState: widget.isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showAlertBox(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      return Center(
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon inside a circle
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 40,
                  ),
                ),

                const SizedBox(height: 16),

                // Message text
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff333333),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  // Automatically dismiss the dialog after 1.5 seconds
  Future.delayed(const Duration(milliseconds: 1500), () {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  });
}

void _addToCart(
    BuildContext context,
    int productId,
    String? title,
    double price,
    int quantity,
    String option,
    String specialInst,
    List<Map<String, String>> selectedoptions) {
  // final safeProductId = productId ?? '0';

  final safeTitle = title ?? 'Product';
  // print("Product $productId Title $safeTitle Price $price Quantity $quantity");

  String? optionAmount = _optionAmount(option);
  if (optionAmount != null) {
    // Convert the optionAmount to a double and add it to the price
    price += double.tryParse(optionAmount) ?? 0.0;
  }

  // Add item to cart using the Cart provider
  Provider.of<Cart>(context, listen: false).addItem(productId.toString(),
      safeTitle, price, quantity, option, selectedoptions, specialInst);

  // Show a SnackBar with the message
  _showAlertBox(context, "$safeTitle has been added to your cart!");
}

String? _optionAmount(String option) {
  // Regex to match the amount with or without a dollar sign
  final RegExp regExp = RegExp(r'\$?([0-9]+(?:\.[0-9]+)?)');

  final match = regExp.firstMatch(option);

  if (match != null) {
    // Return the numeric value (e.g., "0.79")
    return match.group(1);
  }

  // If no amount is found, return null
  return null;
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
    return Column(children: [
      Container(
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
                          ? const BorderSide(
                              color: Color(0xffdddddd), width: 0.5)
                          : BorderSide.none,
                    ),
                  ),
                  child: Text(
                    category['name'] ?? 'Unknown',
                    style: GoogleFonts.raleway(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color:
                          isSelected ? Colors.black : const Color(0xff666666),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      const SizedBox(height: 8), // space between category and icons
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Veg section
          Row(
            children: [
              Image.asset(
                'assets/images/veg.png',
                width: 30,
                height: 30,
              ),
              const SizedBox(width: 4),
              const Text(
                'Veg',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),

          const SizedBox(width: 12),
          // Vertical separator
          Container(
            width: 1,
            height: 18,
            color: Colors.grey,
          ),
          const SizedBox(width: 12),

          // Spicy section
          Row(
            children: [
              Image.asset(
                'assets/images/spicy.jpg',
                width: 30,
                height: 30,
              ),
              const SizedBox(width: 4),
              const Text(
                'Spicy',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    ]);
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
    return SingleChildScrollView(
      scrollDirection:
          Axis.horizontal, // allows horizontal scroll on small screens
      child: Row(
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
      ),
    );
  }
}

class WooCommerceService {
  final String baseUrl = 'https://www.dev.indian-grill.com/wp-json/wc/v1';
  final String consumerKey = 'ck_67efc00d8d814b67877da8fffad40d61d4366602';
  final String consumerSecret = 'cs_4cd4f797f1aef69089a3ce3f008d6726e98f352b';
  final String cakeCategoryId = '60';
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

    category ??= cakeCategoryId;

    String url = '$baseUrl/products?per_page=$productsPerPage&offset=$offset';
    url += '&category=$category';

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> products = json.decode(response.body);

        // ✅ Parallel fetch custom fields for each product
        List<Map<String, dynamic>> enrichedProducts = await Future.wait(
          products.map((product) async {
            int productId = product['id'];

            // --- Fetch custom meta from your custom API ---
            String customApiUrl =
                'https://dev.indian-grill.com/wp-json/custom-api/v1/product-meta/$productId';

            String foodType = '';
            String spiceLevel = '';

            try {
              final customApiUrl =
                  'https://dev.indian-grill.com/wp-json/custom-api/v1/product-meta/${product['id']}';
              final customResponse = await http.get(Uri.parse(customApiUrl));

              if (customResponse.statusCode == 200) {
                final customData = json.decode(customResponse.body);

                dynamic foodValue = customData['food_type'];
                dynamic spiceValue = customData['spice_level'];

                // 🧠 Handle both string and list cases safely
                if (foodValue is List && foodValue.isNotEmpty) {
                  foodType = foodValue.join(', ');
                } else if (foodValue is String) {
                  foodType = foodValue;
                } else {
                  foodType = '';
                }

                if (spiceValue is List && spiceValue.isNotEmpty) {
                  spiceLevel = spiceValue.join(', ');
                } else if (spiceValue is String) {
                  spiceLevel = spiceValue;
                } else {
                  spiceLevel = '';
                }
              }
            } catch (err) {
              print(
                  '⚠️ Failed to fetch custom meta for product ${product['id']}: $err');
            }

            //  print(foodType);
            // --- Process main WooCommerce data ---
            String imageUrl =
                product['images'].isNotEmpty ? product['images'][0]['src'] : '';

            String rawDescription =
                product['short_description'] ?? 'No description available';
            String cleanDescription =
                rawDescription.replaceAll(RegExp(r'<[^>]*>'), '');

            List<String> baseOptions = [];
            List<String> comboOptions = [];
            String optionName = '';

            if (product['attributes'] != null &&
                product['attributes'].isNotEmpty) {
              optionName = product['attributes'][0]['name'] ?? '';

              List<dynamic> rawOptions =
                  product['attributes'][0]['options'] ?? [];

              Set<String> extractedComboSet = {};

              for (var option in rawOptions) {
                if (option.contains('+')) {
                  final parts = option.split('+');
                  if (parts.length == 2) {
                    extractedComboSet.add(parts[1].trim());
                  }
                } else {
                  baseOptions.add(option);
                }
              }

              if (extractedComboSet.length == 1) {
                comboOptions = [extractedComboSet.first];
              } else {
                comboOptions = extractedComboSet.toList();
              }
            }

            // ✅ Merge WooCommerce + Custom Fields
            return {
              'productId': productId,
              'name': product['name'],
              'price': product['price'],
              'image': imageUrl,
              'description': cleanDescription,
              'baseOptions': baseOptions,
              'comboOptions': comboOptions,
              'optionName': optionName,
              'foodType': foodType,
              'spiceLevel': spiceLevel,
            };
          }),
        );

        return enrichedProducts;
      } else {
        print(
            '❌ Failed to fetch products. Status code: ${response.statusCode}');
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
      String url = '$baseUrl/products?per_page=1';
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
  final String baseUrl = "https://www.dev.indian-grill.com/wp-json/wc/v1";
  final String consumerKey = "ck_67efc00d8d814b67877da8fffad40d61d4366602";
  final String consumerSecret = "cs_4cd4f797f1aef69089a3ce3f008d6726e98f352b";
  final String categoryId = '60';

  Future<List<dynamic>> fetchSubcategories() async {
    final String url =
        "$baseUrl/products/categories?parent=$categoryId&consumer_key=$consumerKey&consumer_secret=$consumerSecret";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
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

class HorizontalSidebarWidget extends StatelessWidget {
  final List<Map<String, String>> items;
  final ValueChanged<Map<String, String>> onCategorySelected;
  final String? selectedCategoryId;

  const HorizontalSidebarWidget({
    super.key,
    required this.items,
    required this.onCategorySelected,
    required this.selectedCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(items.length, (index) {
                final category = items[index];
                final isSelected = category['id'] == selectedCategoryId;

                return GestureDetector(
                  onTap: () => onCategorySelected(category),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Color(0xffe2001A)
                            : Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      category['name'] ?? 'Unknown',
                      style: GoogleFonts.raleway(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? Colors.black
                            : const Color(0xff666666),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // VEG / SPICY SECTION (same as original)
         ],
    );
  }
}

class MobileMenuItemCard extends StatefulWidget {
  final String title;
  final String foodType;
  final int productId;
  final String optionName;
  final String description;
  final double price;
  final bool isExpanded;
  final VoidCallback onExpand;
  final List<String> baseOptions;
  final List<String> comboOptions;

  const MobileMenuItemCard({
    super.key,
    required this.title,
    required this.foodType,
    required this.productId,
    required this.optionName,
    required this.description,
    required this.price,
    required this.isExpanded,
    required this.onExpand,
    required this.baseOptions,
    required this.comboOptions,
  });

  @override
  State<MobileMenuItemCard> createState() => _MobileMenuItemCardState();
}

class _MobileMenuItemCardState extends State<MobileMenuItemCard> {
  int quantity = 1;
  String? selectedPreparation;
  String? selectedChoice;

  final TextEditingController _specialInstController = TextEditingController();

  @override
  void dispose() {
    _specialInstController.dispose();
    super.dispose();
  }

  void _increaseQty() {
    setState(() => quantity++);
  }

  void _decreaseQty() {
    if (quantity > 1) {
      setState(() => quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onExpand,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- TITLE + PRICE ----------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Veg / Spicy icons
                Column(
                  children: [
                    if (widget.foodType.toLowerCase().contains("veg"))
                      Image.asset("assets/images/veg.png",
                          width: 20, height: 20),
                    if (widget.foodType.toLowerCase().contains("spicy"))
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Image.asset("assets/images/spicy.jpg",
                            width: 20, height: 20),
                      ),
                  ],
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.raleway(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.description,
                        style: GoogleFonts.raleway(
                            fontSize: 13, color: Colors.black87),
                      ),
                    ],
                  ),
                ),

                Text(
                  "\$${widget.price.toStringAsFixed(2)}",
                  style: GoogleFonts.raleway(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ],
            ),

            // ---------- EXPANDED AREA ----------
            AnimatedCrossFade(
              firstChild: const SizedBox(),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // -------- Base Options ----------
                  if (widget.baseOptions.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.optionName,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                        const SizedBox(height: 6),
                        ...widget.baseOptions.map((option) {
                          return Row(
                            children: [
                              Radio<String>(
                                value: option,
                                groupValue: selectedPreparation,
                                onChanged: (val) =>
                                    setState(() => selectedPreparation = val),
                              ),
                              Text(option,
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          );
                        }).toList()
                      ],
                    ),

                  const SizedBox(height: 12),

                  // -------- Combo Option ----------
                  if (widget.comboOptions.isNotEmpty &&
                      selectedPreparation != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Choice of with Rice:",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                        Row(
                          children: [
                            Radio<String>(
                              value: widget.comboOptions.first,
                              groupValue: selectedChoice,
                              onChanged: (v) =>
                                  setState(() => selectedChoice = v),
                            ),
                            Text(
                              widget.comboOptions.first
                                  .replaceFirst(RegExp(r'^.*\+\s*'), '')
                                  .replaceAllMapped(
                                      RegExp(r'\(\+\s*\$?([\d.]+)\)'),
                                      (m) => '(\$${m.group(1)})'),
                              style: const TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                      ],
                    ),

                  const SizedBox(height: 12),

                  // -------- Special Instruction ----------
                  const Text("Special Instruction:",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _specialInstController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // -------- Quantity + Add to Cart ----------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: _decreaseQty,
                                icon: const Icon(Icons.remove)),
                            Text(quantity.toString(),
                                style: const TextStyle(fontSize: 16)),
                            IconButton(
                                onPressed: _increaseQty,
                                icon: const Icon(Icons.add)),
                          ],
                        ),
                      ),

                      // -------- Add to Cart --------
                      ElevatedButton(
                        onPressed: () {
                          final prep = selectedPreparation ?? "";
                          final choice = selectedChoice ?? "";
                          final instruction =
                              _specialInstController.text.trim();

                          if (widget.baseOptions.isNotEmpty &&
                              selectedPreparation == null) {
                            _showAlertBox(context,
                                "Please select a preparation option");
                            return;
                          }

                          List<Map<String, String>> selectedOptions = [];

                          if (selectedPreparation != null) {
                            selectedOptions
                                .add({widget.optionName: selectedPreparation!});
                          }

                          if (widget.baseOptions.isNotEmpty) {
                            selectedOptions.add({
                              "Choice of with Rice:":
                                  selectedChoice != null ? "Yes" : "No"
                            });
                          }

                          final combinedOption = (prep.isNotEmpty &&
                                  choice.isNotEmpty)
                              ? "$prep + $choice"
                              : "$prep$choice";

                          _addToCart(
                            context,
                            widget.productId,
                            widget.title,
                            widget.price,
                            quantity,
                            combinedOption,
                            instruction,
                            selectedOptions,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffE2001A),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Add to cart",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
              crossFadeState: widget.isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}

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
  final List<String> notes = [
    "Allow extra 15 minutes for preparation time on Friday and Saturday than average waiting time.",
    "Payment by Credit Card the order amount must be at least \$15, in order to pay by Paypal/Credit Card"
  ];
  int? expandedIndex; // Track expanded index

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchTotalProductsCount();
    fetchProducts(page: currentPage, category: selectedCategoryId);
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
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _buildProductList(),
          const SizedBox(height: 10),
          Padding(
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
                      fontSize: 14,
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
                                  fontSize: 12,
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
          const SizedBox(height: 16),
          SidebarWidget(
            items: categories,
            onCategorySelected: onCategorySelected,
            selectedCategoryId: null,
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
          )
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
    barrierDismissible: false, // Prevent dismissing when tapping outside
    builder: (BuildContext context) {
      return Center(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 16,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning, color: Colors.orange, size: 40),
                const SizedBox(height: 10),
                Text(
                  message, // Use the message passed in
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  // Dismiss the dialog after 1 second
  Future.delayed(const Duration(seconds: 1), () {
    Navigator.of(context).pop();
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

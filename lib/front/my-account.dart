import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiangrill/session/user_session.dart';
import 'package:indiangrill/services/woocommerce_service.dart';
class MyAccount extends StatefulWidget {
  final Map<String, dynamic>? args;

  const MyAccount({super.key, this.args});

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  late String displayText;
  String selectedRoute = '/dashboard'; // default selected route

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = widget.args;
    displayText = (args != null && args['registration'] == 'yes') ? 'register' : 'login';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;

          if (kIsWeb) {
            if (screenWidth > 1024) {
              return buildDesktopLayout();
            } else if (screenWidth > 600) {
              return buildTabletLayout();
            } else {
              return buildMobileLayout();
            }
          } else {
            if (screenWidth > 1024) {
              return buildDesktopLayout();
            } else if (screenWidth > 600) {
              return buildTabletLayout();
            } else {
              return buildMobileLayout();
            }
          }
        },
      ),
    );
  }

  Widget buildDesktopLayout() {
    return Container(
      padding: const EdgeInsets.fromLTRB(190, 50, 190, 50),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: SidebarWidget(
              items: const [
                {'text': 'Dashboard', 'route': '/dashboard'},
                {'text': 'Orders', 'route': '/orders'},
                {'text': 'Downloads', 'route': '/downloads'},
                {'text': 'Addresses', 'route': '/address'},
                {'text': 'Account Details', 'route': '/account-details'},
                {'text': 'Logout', 'route': '/logout'},
              ],
              selectedRoute: selectedRoute,
              onRouteSelected: (route) async {
                if (route == '/logout') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Logout'),
                        content: const Text('Are you sure you want to log out?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          TextButton(
                            child: const Text('Logout'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    userSession.logOut();
                    GoRouter.of(context).pushNamed('logout');
                  }
                } else {
                  setState(() {
                    selectedRoute = route;
                  });
                }
              },
            ),
          ),

          const SizedBox(width: 40),

          // Dynamic content area
          Expanded(
            child: Container(
              color: Colors.white,
              child: buildContentWidget(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabletLayout() => buildDesktopLayout();

  Widget buildMobileLayout() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Content first (Dashboard, Orders, etc.)
      


        // 🔹 Sidebar becomes a vertical button list
        SidebarWidget(
          items: const [
            {'text': 'Dashboard', 'route': '/dashboard'},
            {'text': 'Orders', 'route': '/orders'},
            {'text': 'Downloads', 'route': '/downloads'},
            {'text': 'Addresses', 'route': '/address'},
            {'text': 'Account Details', 'route': '/account-details'},
            {'text': 'Logout', 'route': '/logout'},
          ],
          selectedRoute: selectedRoute,
          onRouteSelected: (route) async {
            if (route == '/logout') {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: const Text('Logout'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {
                await userSession.logOut();
                if (context.mounted) context.go('/login');
              }
            } else {
              setState(() {
                selectedRoute = route;
              });
            }
          },
        ),

        const SizedBox(height: 30),

          Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: buildContentWidget(),
        ),
        
      ],
    ),
  );
}


  /// Returns the right content widget based on selected route
  Widget buildContentWidget() {
    switch (selectedRoute) {
      case '/dashboard':
        return const DashboardWidget();
      case '/orders':
        return const OrdersWidget();
      case '/downloads':
        return const DownloadsWidget();
      case '/address':
        return const AddressWidget();
      case '/account-details':
        return const AccountDetailsWidget();
      default:
        return Center(
          child: Text(
            displayText == 'register' ? 'Register Page' : 'Login Page',
            style: GoogleFonts.raleway(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: displayText == 'register' ? Colors.red : Colors.blue,
            ),
          ),
        );
    }
  }
}

// ===================== Sidebar =====================
class SidebarWidget extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String selectedRoute;
  final ValueChanged<String> onRouteSelected;

  const SidebarWidget({
    super.key,
    required this.items,
    required this.selectedRoute,
    required this.onRouteSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items.map((item) {
          final String text = (item['text'] ?? '').toString();
          final String route = (item['route'] ?? '').toString();

          final bool isSelected = route == selectedRoute;

          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: route.isNotEmpty ? () => onRouteSelected(route) : null,
              child: Container(
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.grey[300] : Colors.white,
                  border: const Border(
                    left: BorderSide(color: Color(0xffdddddd), width: 0.5),
                    right: BorderSide(color: Color(0xffdddddd), width: 0.5),
                    bottom: BorderSide(color: Color(0xffdddddd), width: 0.5),
                  ),
                ),
                child: Text(
                  text,
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
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ===================== Content Widgets =====================

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Welcome to Dashboard!',
        style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({super.key});

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  late Future<List<dynamic>> _ordersFuture;
  final WooCommerceService _wooService = WooCommerceService();

  @override
  void initState() {
    super.initState();
    _ordersFuture = _loadOrders();
  }

  Future<List<dynamic>> _loadOrders() async {
    final user = await userSession.getUser();
    final email = user?['email'] ?? '';

    if (email.isEmpty) {
      throw Exception('User not logged in or missing email');
    }

    return _wooService.fetchOrdersByEmail('lindgren.ar@gmail.com');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _ordersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              '❌ ${snapshot.error}',
              style: GoogleFonts.raleway(fontSize: 16, color: Colors.red),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
  final order = orders[index];
  final orderId = order['id'];
  final date = order['date_created'];
  final status = order['status'];
  final total = order['total'];

  // Safely read items
  final items = order['items'] as Map<String, dynamic>? ?? {};

  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: Colors.grey.shade300, // ✅ subtle light grey border
        width: 1,
      ),
    ),    
    color: Colors.transparent,
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Order Summary (same as before)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Order #$orderId',
              style: GoogleFonts.raleway(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Date: $date\nStatus: ${status.toUpperCase()}',
              style: GoogleFonts.raleway(fontSize: 14),
            ),
            trailing: Text(
              '\$$total',
              style: GoogleFonts.raleway(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Divider(),

          // 🔹 Order Items Section
          if (items.isNotEmpty) ...[
            Text(
              'Items:',
              style: GoogleFonts.raleway(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            ...items.values.map((item) {
              final name = item['name'];
              final qty = item['quantity'];
              final price = item['total'];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        name ?? '',
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'x$qty',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '\$$price',
                        textAlign: TextAlign.end,
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ] else
            Text(
              'No items found.',
              style: GoogleFonts.raleway(fontSize: 13, color: Colors.grey),
            ),
        ],
      ),
    ),
  );
},

          );
        } else {
          return Center(
            child: Text(
              'No orders found.',
              style: GoogleFonts.raleway(
                  fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          );
        }
      },
    );
  }
}
class DownloadsWidget extends StatelessWidget {
  const DownloadsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Download your resources here.',
        style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class AddressWidget extends StatelessWidget {
  const AddressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Manage your addresses here.',
        style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class AccountDetailsWidget extends StatelessWidget {
  const AccountDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Update your account details.',
        style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

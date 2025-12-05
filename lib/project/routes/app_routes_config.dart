import 'package:go_router/go_router.dart';
import 'package:indiangrill/front/aboutus.dart';
import 'package:indiangrill/front/banquet.dart';
import 'package:indiangrill/front/banquet_contact_page.dart';
import 'package:indiangrill/front/banquet_menu.dart';
import 'package:indiangrill/front/cake_details_page.dart';
import 'package:indiangrill/front/career.dart';
import 'package:indiangrill/front/cart_page.dart';
import 'package:indiangrill/front/catering_enquiry.dart';
import 'package:indiangrill/front/checkout.dart';
import 'package:indiangrill/front/contactus.dart';
import 'package:indiangrill/front/gallery.dart';
import 'package:indiangrill/front/homepage.dart';
import 'package:indiangrill/front/my_account.dart';
import 'package:indiangrill/front/order_cake.dart';
import 'package:indiangrill/front/order_success_page.dart';
import 'package:indiangrill/front/privacy_policy.dart';
import 'package:indiangrill/front/mainlayout.dart';
import 'package:indiangrill/front/orderonline.dart';
import 'package:indiangrill/front/ourcakes.dart';
import 'package:indiangrill/front/register.dart';
import 'package:indiangrill/front/lostpassword.dart';
import 'package:indiangrill/session/user_session.dart'; // Make sure this is imported

class MyAppRouter {
  late final GoRouter router;

  MyAppRouter() {
    router = GoRouter(
      refreshListenable: userSession,
      routes: [
        GoRoute(
          name: 'privacy-policy',
          path: '/privacy-policy',
          builder: (context, state) => MainLayout(child: PrivacyPolicy()),
        ),
        GoRoute(
          name: 'banquet-contact-page',
          path: '/banquet-contact-page',
          builder: (context, state) =>
              const MainLayout(child: BanquetContactPage()),
        ),
        GoRoute(
          name: 'my_account',
          path: '/my_account',
          builder: (context, state) => const MainLayout(child: MyAccount()),
          redirect: (context, state) {
            if (!userSession.isLoggedIn) return '/login';
            return null;
          },
        ),
        GoRoute(
          name: 'home',
          path: '/',
          builder: (context, state) => const MainLayout(child: HomePage()),
        ),
        GoRoute(
          name: 'order-online',
          path: '/order-online',
          builder: (context, state) => const MainLayout(child: OrderOnline()),
        ),
        GoRoute(
          name: 'catering-enquiry',
          path: '/catering-enquiry',
          builder: (context, state) =>
              const MainLayout(child: CateringEnquiry()),
        ),
        GoRoute(
          name: 'banquet',
          path: '/banquet',
          builder: (context, state) => const MainLayout(child: Banquet()),
        ),
        GoRoute(
          name: 'gallery',
          path: '/gallery',
          builder: (context, state) => const MainLayout(child: Gallery()),
        ),
        GoRoute(
          name: 'contactus',
          path: '/contactus',
          builder: (context, state) => const MainLayout(child: Contactus()),
        ),
        GoRoute(
          name: 'ourcakes',
          path: '/ourcakes',
          builder: (context, state) => const MainLayout(child: OurCakes()),
        ),
        GoRoute(
          name: 'cakeDetails',
          path: '/cake-details',
          builder: (context, state) {
            final product = state.extra as Map? ?? {};
            return MainLayout(child: CakeDetailsPage(product: product));
          },
        ),
        GoRoute(
          name: 'orderCake',
          path: '/order-cake',
          builder: (context, state) {
            final product = state.extra as Map? ?? {};
            return MainLayout(child: OrderCakePage(product: product));
          },
        ),
        GoRoute(
          name: 'career',
          path: '/career',
          builder: (context, state) => const MainLayout(child: Career()),
        ),
        GoRoute(
          name: 'about-us',
          path: '/about-us',
          builder: (context, state) => const MainLayout(child: Aboutus()),
        ),
        GoRoute(
          name: 'login',
          path: '/login',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return MainLayout(
              child: Register(
                registration: extra?['registration'] ?? 'no',
              ),
            );
          },
          redirect: (context, state) {
            // ✅ If user is logged in, do NOT allow access to login page
            if (userSession.isLoggedIn) {
              return '/my_account';
            }
            return null; // allow access if not logged in
          },
        ),

        GoRoute(
          name: 'logout',
          path: '/logout',
          redirect: (context, state) {
            userSession.logOut(); // Clear session
            return '/login'; // Redirect to login
          },
        ),
        GoRoute(
          name: 'banquet-menu',
          path: '/banquet-menu',
          builder: (context, state) => const MainLayout(child: BanquetMenu()),
        ),
        GoRoute(
          name: 'cart',
          path: '/cart',
          builder: (context, state) => const MainLayout(hideHeader: true, child: CartScreen()),
        ),
        GoRoute(
          name: 'checkout',
          path: '/checkout',
          builder: (context, state) => const MainLayout(hideHeader: true, child: CheckoutPage()),
        ),
        GoRoute(
          name: 'lost-password',
          path: '/lost-password',
          builder: (context, state) => const MainLayout(child: LostPassword()),
        ),
        GoRoute(
          name: 'order-success',
          path: '/order-success',
          redirect: (context, state) {
            final extras = state.extra as Map?;

            if (extras == null ||
                extras['orderId'] == null ||
                extras['items'] == null ||
                extras['paymentMethod'] == null ||
                extras['shippingMethod'] == null ||
                extras['totals'] == null) {
              return '/';   // ✅ valid here
            }

            return null;   // allow navigation
          },
          builder: (context, state) {
            final extras = state.extra as Map;

            return MainLayout(
              child: OrderSuccessPage(
                orderId: extras['orderId'].toString(),
                items: extras['items'],
                paymentMethod: extras['paymentMethod'].toString(),
                shippingMethod: extras['shippingMethod'].toString(),
                totals: extras['totals'],
              ),
            );
          },
        )



      ],
    );
  }
}

// Create a single global instance to be used app-wide
// final myAppRouter = MyAppRouter();

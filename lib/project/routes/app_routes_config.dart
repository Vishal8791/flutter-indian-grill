import 'package:go_router/go_router.dart';
import 'package:indiangrill/front/aboutus.dart';
import 'package:indiangrill/front/banquet.dart';
import 'package:indiangrill/front/career.dart';
import 'package:indiangrill/front/catering_enquiry.dart';
import 'package:indiangrill/front/contactus.dart';
import 'package:indiangrill/front/gallery.dart';
import 'package:indiangrill/front/homepage.dart';
import 'package:indiangrill/front/mainlayout.dart';
import 'package:indiangrill/front/orderonline.dart';
import 'package:indiangrill/front/ourcakes.dart'; // Ensure this is included

class MyAppRouter {
  GoRouter get router => GoRouter(
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => MainLayout(child: HomePage()), // Home page
      ),
      GoRoute(
        name: 'order_online', // Ensure this name matches your context.go call
        path: '/order_online',
        builder: (context, state) {
         return MainLayout(child: OrderOnline()); // Ensure this is the correct widget
        },
      ),
      GoRoute(
        name: 'category_enquiry', // Ensure this name matches your context.go call
        path: '/category_enquiry',
        builder: (context, state) {
         return MainLayout(child: CateringEnquiry()); // Ensure this is the correct widget
        },
      ),
      GoRoute(
        name: 'banquet', // Ensure this name matches your context.go call
        path: '/banquet',
        builder: (context, state) {
         return MainLayout(child: Banquet()); // Ensure this is the correct widget
        },
      ),
      GoRoute(
        name: 'gallery', // Ensure this name matches your context.go call
        path: '/gallery',
        builder: (context, state) {
         return MainLayout(child: Gallery()); // Ensure this is the correct widget
        },
      ),
      GoRoute(
        name: 'contactus', // Ensure this name matches your context.go call
        path: '/contactus',
        builder: (context, state) {
         return MainLayout(child: Contactus()); // Ensure this is the correct widget
        },
      ),
      GoRoute(
        name: 'ourcakes', // Ensure this name matches your context.go call
        path: '/ourcakes',
        builder: (context, state) {
         return MainLayout(child: Ourcakes()); // Ensure this is the correct widget
        },
      ),
      GoRoute(
        name: 'career', // Ensure this name matches your context.go call
        path: '/career',
        builder: (context, state) {
         return MainLayout(child: Career()); // Ensure this is the correct widget
        },
      ),
      GoRoute(
        name: 'about-us', // Ensure this name matches your context.go call
        path: '/about-us',
        builder: (context, state) {
         return MainLayout(child: Aboutus()); // Ensure this is the correct widget
        },
      ),
      
    ],
  );
}

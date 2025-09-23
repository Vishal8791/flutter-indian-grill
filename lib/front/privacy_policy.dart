// privacy_policy.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicy extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: LayoutBuilder(builder: (context, Constraints) {
          double screenWidth = Constraints.maxWidth;
          if (kIsWeb) {
            if (screenWidth > 1024) {
              // print("Web/Desktop layout is being used");
              return buildDesktopLayout(); // Desktop layout for web
            } else if (screenWidth > 600) {
              // print("Web/Tablet layout is being used");
              return buildTabletLayout(); // Tablet layout for web
            } else {
              // print("Web/Mobile layout is being used");
              return buildMobileLayout(); // Mobile layout for web
            }
          } else {
            if (screenWidth > 1024) {
              // print("Web/Desktop layout is being used");
              return buildDesktopLayout(); // Desktop layout for web
            } else if (screenWidth > 600) {
              // print("Web/Tablet layout is being used");
              return buildTabletLayout(); // Tablet layout for web
            } else {
              // print("Web/Mobile layout is being used");
              return buildMobileLayout(); // Mobile layout for web
            }
          }
        }));
  }

  Widget buildDesktopLayout() {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(190, 40, 400, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WEBSITE PRIVACY PROTECTION STATEMENT',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'We stress the importance of privacy and are committed to earning your trust by adopting high standards for the protection of your personal information.\nThis policy applies to our website(s) and outlines the type of personal information we collect and receive, the circumstances in which we collect or receive personal information, the policies and procedures we have established outlining its use and storage, and for sharing certain types of personal information in certain limited circumstances, the procedures you should follow if you have any questions or requests in respect of your personal information or our policies and procedures and the person to whom such questions or requests should be directed, and the means by which to communicate with that person.\nWe do not control and are not responsible for the policies or actions of third parties linked from this site and you should check directly with them since their policies and terms will govern how they handle and treat personal information.\nIn this policy, ‘personal information’ or ‘personally identifiable information’ means information about you that is unique and would actually or potentially identify you as an individual, like your name, address, e-mail address or phone number, and that is not otherwise publicly available and is not part of your work identification and includes information you provide to us when you use our website to make or modify a reservation, establish a profile, communicate personal preferences, participate in, respond to or take advantage of special offers, or which you otherwise provide to us in the course of using of our website. Aggregate information or statistics, even if compiled or derived from your personal information and then aggregated and mingled with information of others, is not personal information since it does not identify you or any specific personally identifiable information about you. We use aggregate or statistical information to better serve our guests and customers generally, to enhance the performance of our website and to generally improve how we do business. We will provide you with opportunities to ‘unsubscribe’ and to correct or update your personal information and described these opportunities below, but you are responsible for ensuring the information you provide to us and that we maintain is complete, accurate and up to date. We cannot and will not be liable to you or any other party if, for any reason, you do not provide us with complete, accurate and current information or you fail to update such information in a timely manner.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'HOW YOU MAY PROVIDE US YOUR PERSONAL INFORMATION USING OUR WEBSITE',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '1. By making a reservation or by using the website.\n2. By communicating with us regarding service delivery including any profiles, preferences or special requests you may make.\n3. By participating in a marketing initiative, survey or responding to special offers we may send you from time to time.\n5. By registering or otherwise entering information on or through our website.\nBelow we will outline the type of information normally collected in each of these circumstances, the reasons for doing so, how we intend to use it and store it.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'MAKING A RESERVATION/COMPLETING FORMS',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'When making a reservation or using forms on the website it is necessary to have information in order to identify you, contact you and to process your purchase and requests. This usually includes your name, address, phone number, e-mail address, credit card number and expiration date, and language preference. It may also include, if you choose to share that information with us, your preferences regarding services we may offer, such as type of room, type of bed, and the like. From time to time, we also offer special discounts offers (for example, to seniors or for children) and we may require birth dates or other qualifying information to assess your eligibility and process your reservation or participation correctly. If you elect to participate or take advantage of a promotion, package or other service that involves third parties, your personal information will be shared with that third party to the extent necessary to participate, enroll or otherwise provide you with the service and process your purchase or request.\nWe may use the information you provide to send you offers and information about the hotel’s services and those of select third parties. Except as we have described in this policy, your personal information will not be given to these third parties.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'WE OFFER YOU THE ABILITY TO RECEIVE TARGETED, TIMELY NOTIFICATION OF TIME SENSITIVE OFFERS',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'To sign up for this service we require you to provide us with your e-mail address, first name, last name, and zip code. You may unsubscribe at any time using the link provided on every offer we send you. Of course, if you change your mind, you may subscribe again at any time in the future.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'BY VISITING OUR WEBSITE',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Our website does not collect personally identifiable information from you or your computer when you simply visit (e.g., browse) and unless you actually provide us with personally identifiable information, we will not know or collect your name, your e-mail address or any other personally identifiable information about you. When you a request or visit a page on our website, we do log certain communications, technical and operational information and aggregate it with other similar information in order to make our website function correctly, do capacity and other technical planning and generally make our website function properly and improve it where we can. We also use this information to better understand how visitors use our website and how we can better tailor our website, its contents and functionality to meet your needs.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'WHY WE COLLECT PERSONAL INFORMATION',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '1. To establish, maintain and honor our relationship with you and to provide you with our services and those of our third party suppliers and promotional partners.\n2. To understand and better attempt to fulfill your needs and preferences in providing services from us.\n3. To develop, enhance, market or provide products and services or offers we believe, based on the information you provide us, you may be interested in receiving.\n4. To manage and develop our business and operations and help us improve our services for you.\n5. To meet legal and regulatory requirements.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'WHEN DO WE DISCLOSE PERSONAL INFORMATION',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '1 Personal information may be shared internally, with corporate offices or sister properties so that they may provide the services you have reserved.m2. Personal information may be shared with a person who, in the reasonable judgment of the hotel, is acting on your behalf of or as your agent – for example, a travel agent, secretary or corporate travel department, making a reservation for you.\n3. Personal information may be shared with a third party involved in processing transactions you request and supplying you with services.\n4. Personal information may be shared with a third party to perform functions, process transactions or provide goods or services to you, such as reservations handling, data processing or storage, surveys or research, to evaluate a customer’s credit worthiness or in order to collect a customer’s account.\n5. Personal information may be shared with a public authority or official or those acting under government or judicial authority to protect the assets and operations of the hotel or if, in the reasonable judgment of the hotel, it appears that there may be danger to life, property or public safety which could be avoided or minimized by disclosure of the information, or which disclosure is required by law or regulation.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'PRINCIPLES',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '1. We will not collect, use or disclose your personal information for any other purpose than those identified above, except with your consent.\n2. We will safeguard your personal information from disclosure other than as identified above or with your consent.\n3. We will take steps to protect the confidentiality of your personal information when dealing with third parties, consistent with our policy and the laws and regulations that apply.\n4. We will strive to keep your personal information accurate and up to date and we will provide you with reasonable opportunities to access, correct and update your personal information. You are always free to refuse to provide personal information to us, recognizing that in some cases this may limit or make it impossible for us to agree to provide you with the services or goods you may request.\nYou may also withdraw your consent with respect to the use of your personal information for marketing purposes at any time, subject to legal or contractual restrictions and reasonable notice, when you access or visit our website or by separately e-mailing us utilizing the contact information provided on this site using “Unsubscribe” as the subject line, and providing us sufficient personal identifiers so we can act effectively on your request\nIf you have questions or concerns about our privacy practices or how we collect, handle or use your personal information, please contact us via the contact information provided on this site.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabletLayout() {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.white,
      padding: const EdgeInsets.all(50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WEBSITE PRIVACY PROTECTION STATEMENT',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'We stress the importance of privacy and are committed to earning your trust by adopting high standards for the protection of your personal information.\nThis policy applies to our website(s) and outlines the type of personal information we collect and receive, the circumstances in which we collect or receive personal information, the policies and procedures we have established outlining its use and storage, and for sharing certain types of personal information in certain limited circumstances, the procedures you should follow if you have any questions or requests in respect of your personal information or our policies and procedures and the person to whom such questions or requests should be directed, and the means by which to communicate with that person.\nWe do not control and are not responsible for the policies or actions of third parties linked from this site and you should check directly with them since their policies and terms will govern how they handle and treat personal information.\nIn this policy, ‘personal information’ or ‘personally identifiable information’ means information about you that is unique and would actually or potentially identify you as an individual, like your name, address, e-mail address or phone number, and that is not otherwise publicly available and is not part of your work identification and includes information you provide to us when you use our website to make or modify a reservation, establish a profile, communicate personal preferences, participate in, respond to or take advantage of special offers, or which you otherwise provide to us in the course of using of our website. Aggregate information or statistics, even if compiled or derived from your personal information and then aggregated and mingled with information of others, is not personal information since it does not identify you or any specific personally identifiable information about you. We use aggregate or statistical information to better serve our guests and customers generally, to enhance the performance of our website and to generally improve how we do business. We will provide you with opportunities to ‘unsubscribe’ and to correct or update your personal information and described these opportunities below, but you are responsible for ensuring the information you provide to us and that we maintain is complete, accurate and up to date. We cannot and will not be liable to you or any other party if, for any reason, you do not provide us with complete, accurate and current information or you fail to update such information in a timely manner.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'HOW YOU MAY PROVIDE US YOUR PERSONAL INFORMATION USING OUR WEBSITE',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '1. By making a reservation or by using the website.\n2. By communicating with us regarding service delivery including any profiles, preferences or special requests you may make.\n3. By participating in a marketing initiative, survey or responding to special offers we may send you from time to time.\n5. By registering or otherwise entering information on or through our website.\nBelow we will outline the type of information normally collected in each of these circumstances, the reasons for doing so, how we intend to use it and store it.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'MAKING A RESERVATION/COMPLETING FORMS',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'When making a reservation or using forms on the website it is necessary to have information in order to identify you, contact you and to process your purchase and requests. This usually includes your name, address, phone number, e-mail address, credit card number and expiration date, and language preference. It may also include, if you choose to share that information with us, your preferences regarding services we may offer, such as type of room, type of bed, and the like. From time to time, we also offer special discounts offers (for example, to seniors or for children) and we may require birth dates or other qualifying information to assess your eligibility and process your reservation or participation correctly. If you elect to participate or take advantage of a promotion, package or other service that involves third parties, your personal information will be shared with that third party to the extent necessary to participate, enroll or otherwise provide you with the service and process your purchase or request.\nWe may use the information you provide to send you offers and information about the hotel’s services and those of select third parties. Except as we have described in this policy, your personal information will not be given to these third parties.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'WE OFFER YOU THE ABILITY TO RECEIVE TARGETED, TIMELY NOTIFICATION OF TIME SENSITIVE OFFERS',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'To sign up for this service we require you to provide us with your e-mail address, first name, last name, and zip code. You may unsubscribe at any time using the link provided on every offer we send you. Of course, if you change your mind, you may subscribe again at any time in the future.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'BY VISITING OUR WEBSITE',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Our website does not collect personally identifiable information from you or your computer when you simply visit (e.g., browse) and unless you actually provide us with personally identifiable information, we will not know or collect your name, your e-mail address or any other personally identifiable information about you. When you a request or visit a page on our website, we do log certain communications, technical and operational information and aggregate it with other similar information in order to make our website function correctly, do capacity and other technical planning and generally make our website function properly and improve it where we can. We also use this information to better understand how visitors use our website and how we can better tailor our website, its contents and functionality to meet your needs.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'WHY WE COLLECT PERSONAL INFORMATION',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '1. To establish, maintain and honor our relationship with you and to provide you with our services and those of our third party suppliers and promotional partners.\n2. To understand and better attempt to fulfill your needs and preferences in providing services from us.\n3. To develop, enhance, market or provide products and services or offers we believe, based on the information you provide us, you may be interested in receiving.\n4. To manage and develop our business and operations and help us improve our services for you.\n5. To meet legal and regulatory requirements.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'WHEN DO WE DISCLOSE PERSONAL INFORMATION',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '1 Personal information may be shared internally, with corporate offices or sister properties so that they may provide the services you have reserved.m2. Personal information may be shared with a person who, in the reasonable judgment of the hotel, is acting on your behalf of or as your agent – for example, a travel agent, secretary or corporate travel department, making a reservation for you.\n3. Personal information may be shared with a third party involved in processing transactions you request and supplying you with services.\n4. Personal information may be shared with a third party to perform functions, process transactions or provide goods or services to you, such as reservations handling, data processing or storage, surveys or research, to evaluate a customer’s credit worthiness or in order to collect a customer’s account.\n5. Personal information may be shared with a public authority or official or those acting under government or judicial authority to protect the assets and operations of the hotel or if, in the reasonable judgment of the hotel, it appears that there may be danger to life, property or public safety which could be avoided or minimized by disclosure of the information, or which disclosure is required by law or regulation.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'PRINCIPLES',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '1. We will not collect, use or disclose your personal information for any other purpose than those identified above, except with your consent.\n2. We will safeguard your personal information from disclosure other than as identified above or with your consent.\n3. We will take steps to protect the confidentiality of your personal information when dealing with third parties, consistent with our policy and the laws and regulations that apply.\n4. We will strive to keep your personal information accurate and up to date and we will provide you with reasonable opportunities to access, correct and update your personal information. You are always free to refuse to provide personal information to us, recognizing that in some cases this may limit or make it impossible for us to agree to provide you with the services or goods you may request.\nYou may also withdraw your consent with respect to the use of your personal information for marketing purposes at any time, subject to legal or contractual restrictions and reasonable notice, when you access or visit our website or by separately e-mailing us utilizing the contact information provided on this site using “Unsubscribe” as the subject line, and providing us sufficient personal identifiers so we can act effectively on your request\nIf you have questions or concerns about our privacy practices or how we collect, handle or use your personal information, please contact us via the contact information provided on this site.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMobileLayout() {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WEBSITE PRIVACY PROTECTION STATEMENT',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            'We stress the importance of privacy and are committed to earning your trust by adopting high standards for the protection of your personal information.\nThis policy applies to our website(s) and outlines the type of personal information we collect and receive, the circumstances in which we collect or receive personal information, the policies and procedures we have established outlining its use and storage, and for sharing certain types of personal information in certain limited circumstances, the procedures you should follow if you have any questions or requests in respect of your personal information or our policies and procedures and the person to whom such questions or requests should be directed, and the means by which to communicate with that person.\nWe do not control and are not responsible for the policies or actions of third parties linked from this site and you should check directly with them since their policies and terms will govern how they handle and treat personal information.\nIn this policy, ‘personal information’ or ‘personally identifiable information’ means information about you that is unique and would actually or potentially identify you as an individual, like your name, address, e-mail address or phone number, and that is not otherwise publicly available and is not part of your work identification and includes information you provide to us when you use our website to make or modify a reservation, establish a profile, communicate personal preferences, participate in, respond to or take advantage of special offers, or which you otherwise provide to us in the course of using of our website. Aggregate information or statistics, even if compiled or derived from your personal information and then aggregated and mingled with information of others, is not personal information since it does not identify you or any specific personally identifiable information about you. We use aggregate or statistical information to better serve our guests and customers generally, to enhance the performance of our website and to generally improve how we do business. We will provide you with opportunities to ‘unsubscribe’ and to correct or update your personal information and described these opportunities below, but you are responsible for ensuring the information you provide to us and that we maintain is complete, accurate and up to date. We cannot and will not be liable to you or any other party if, for any reason, you do not provide us with complete, accurate and current information or you fail to update such information in a timely manner.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'HOW YOU MAY PROVIDE US YOUR PERSONAL INFORMATION USING OUR WEBSITE',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '1. By making a reservation or by using the website.\n2. By communicating with us regarding service delivery including any profiles, preferences or special requests you may make.\n3. By participating in a marketing initiative, survey or responding to special offers we may send you from time to time.\n5. By registering or otherwise entering information on or through our website.\nBelow we will outline the type of information normally collected in each of these circumstances, the reasons for doing so, how we intend to use it and store it.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'MAKING A RESERVATION/COMPLETING FORMS',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'When making a reservation or using forms on the website it is necessary to have information in order to identify you, contact you and to process your purchase and requests. This usually includes your name, address, phone number, e-mail address, credit card number and expiration date, and language preference. It may also include, if you choose to share that information with us, your preferences regarding services we may offer, such as type of room, type of bed, and the like. From time to time, we also offer special discounts offers (for example, to seniors or for children) and we may require birth dates or other qualifying information to assess your eligibility and process your reservation or participation correctly. If you elect to participate or take advantage of a promotion, package or other service that involves third parties, your personal information will be shared with that third party to the extent necessary to participate, enroll or otherwise provide you with the service and process your purchase or request.\nWe may use the information you provide to send you offers and information about the hotel’s services and those of select third parties. Except as we have described in this policy, your personal information will not be given to these third parties.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'WE OFFER YOU THE ABILITY TO RECEIVE TARGETED, TIMELY NOTIFICATION OF TIME SENSITIVE OFFERS',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'To sign up for this service we require you to provide us with your e-mail address, first name, last name, and zip code. You may unsubscribe at any time using the link provided on every offer we send you. Of course, if you change your mind, you may subscribe again at any time in the future.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'BY VISITING OUR WEBSITE',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Our website does not collect personally identifiable information from you or your computer when you simply visit (e.g., browse) and unless you actually provide us with personally identifiable information, we will not know or collect your name, your e-mail address or any other personally identifiable information about you. When you a request or visit a page on our website, we do log certain communications, technical and operational information and aggregate it with other similar information in order to make our website function correctly, do capacity and other technical planning and generally make our website function properly and improve it where we can. We also use this information to better understand how visitors use our website and how we can better tailor our website, its contents and functionality to meet your needs.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'WHY WE COLLECT PERSONAL INFORMATION',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '1. To establish, maintain and honor our relationship with you and to provide you with our services and those of our third party suppliers and promotional partners.\n2. To understand and better attempt to fulfill your needs and preferences in providing services from us.\n3. To develop, enhance, market or provide products and services or offers we believe, based on the information you provide us, you may be interested in receiving.\n4. To manage and develop our business and operations and help us improve our services for you.\n5. To meet legal and regulatory requirements.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'WHEN DO WE DISCLOSE PERSONAL INFORMATION',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '1 Personal information may be shared internally, with corporate offices or sister properties so that they may provide the services you have reserved.m2. Personal information may be shared with a person who, in the reasonable judgment of the hotel, is acting on your behalf of or as your agent – for example, a travel agent, secretary or corporate travel department, making a reservation for you.\n3. Personal information may be shared with a third party involved in processing transactions you request and supplying you with services.\n4. Personal information may be shared with a third party to perform functions, process transactions or provide goods or services to you, such as reservations handling, data processing or storage, surveys or research, to evaluate a customer’s credit worthiness or in order to collect a customer’s account.\n5. Personal information may be shared with a public authority or official or those acting under government or judicial authority to protect the assets and operations of the hotel or if, in the reasonable judgment of the hotel, it appears that there may be danger to life, property or public safety which could be avoided or minimized by disclosure of the information, or which disclosure is required by law or regulation.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'PRINCIPLES',
            style: GoogleFonts.raleway(
              fontSize: 16,
              color: const Color(0XFF666666),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '1. We will not collect, use or disclose your personal information for any other purpose than those identified above, except with your consent.\n2. We will safeguard your personal information from disclosure other than as identified above or with your consent.\n3. We will take steps to protect the confidentiality of your personal information when dealing with third parties, consistent with our policy and the laws and regulations that apply.\n4. We will strive to keep your personal information accurate and up to date and we will provide you with reasonable opportunities to access, correct and update your personal information. You are always free to refuse to provide personal information to us, recognizing that in some cases this may limit or make it impossible for us to agree to provide you with the services or goods you may request.\nYou may also withdraw your consent with respect to the use of your personal information for marketing purposes at any time, subject to legal or contractual restrictions and reasonable notice, when you access or visit our website or by separately e-mailing us utilizing the contact information provided on this site using “Unsubscribe” as the subject line, and providing us sufficient personal identifiers so we can act effectively on your request\nIf you have questions or concerns about our privacy practices or how we collect, handle or use your personal information, please contact us via the contact information provided on this site.',
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: const Color(0xff666666),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
 // await Get.putAsync(() => LocalStorage().init());
  
  // Configure routes
  AppRoutes.configureRoutes();
  
  runApp(const RentalApp());
}

class RentalApp extends StatelessWidget {
  const RentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RentEase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.initialRoute,
      getPages: AppRoutes.pages,
      unknownRoute: AppRoutes.unknownRoute,
      defaultTransition: Transition.fadeIn,
    );
  }
}

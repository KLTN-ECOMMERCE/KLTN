import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:store_app/notifications/notification_service.dart';
import 'package:store_app/screens/app.dart';
import 'package:store_app/screens/auth/login.dart';
import 'package:store_app/utils/constants.dart';

void main() async {
  await PersistentShoppingCart().init();

  configOneSignal();

  WidgetsFlutterBinding.ensureInitialized();
  NotificationService notificationService = NotificationService();
  notificationService.initialiseNotifications();
  await Hive.initFlutter();
  await Hive.openBox<String>('favorite_products');


  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

void configOneSignal() {
  OneSignal.initialize(addOneSignalId);
  OneSignal.Notifications.requestPermission(true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 122, 255),
          primary: const Color.fromARGB(255, 0, 122, 255),
          secondary: const Color.fromARGB(255, 103, 179, 255),
          surface: const Color.fromARGB(255, 238, 238, 238),
          error: const Color.fromARGB(255, 255, 0, 0),
          background: const Color.fromARGB(255, 225, 225, 225),
          onPrimary: const Color.fromARGB(255, 255, 255, 255),
          onSecondary: const Color.fromARGB(255, 255, 255, 255),
          onBackground: const Color.fromARGB(255, 0, 0, 0),
        ),
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.selected)) {
                return const TextStyle(
                  color: Color.fromARGB(255, 0, 122, 255),
                );
              }
              return const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
              );
            },
          ),
        ),
      ),
      home: const AppScreen(
        currentIndex: 0,
      ),
      //home: const LoginScreen(),
    );
  }
}

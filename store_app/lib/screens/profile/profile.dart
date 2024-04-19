import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:store_app/api/api_start.dart';
import 'package:store_app/screens/auth/login.dart';
import 'package:store_app/screens/notification/notifications.dart';
import 'package:store_app/screens/profile/my_profile.dart';
import 'package:store_app/screens/promotion/promotion.dart';
import 'package:store_app/screens/statistics/statistics.dart';
import 'package:store_app/widgets/profile/profile_menu.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiStart _apiStart = ApiStart();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileMenu(
                icon: 'assets/icons/User Icon.svg',
                text: 'My Account',
                onSelectMenu: (context) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyProfileScreen(),
                    ),
                  );
                },
              ),
              ProfileMenu(
                icon: 'assets/icons/Flash Icon.svg',
                text: 'Statistics',
                onSelectMenu: (context) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const StatisticsScreen(),
                    ),
                  );
                },
              ),
              ProfileMenu(
                icon: 'assets/icons/Gift Icon.svg',
                text: 'Promotions',
                onSelectMenu: (context) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PromotionScreen(),
                    ),
                  );
                },
              ),
              ProfileMenu(
                icon: 'assets/icons/Bell.svg',
                text: 'Notifications',
                onSelectMenu: (context) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
              ProfileMenu(
                icon: 'assets/icons/Log out.svg',
                text: 'Log Out',
                onSelectMenu: (context) async {
                  final logout = await showOkCancelAlertDialog(
                    context: context,
                    title: 'Are you sure?',
                    message: 'You will no longer be logged in',
                    okLabel: 'Log out',
                    defaultType: OkCancelAlertDefaultType.cancel,
                    isDestructiveAction: true,
                  );
                  if (logout == OkCancelResult.ok) {
                    try {
                      await _apiStart.logout();

                      if (!mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

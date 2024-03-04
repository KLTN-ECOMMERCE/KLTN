import 'package:flutter/material.dart';
import 'package:store_app/screens/profile/my_account.dart';
import 'package:store_app/widgets/profile/profile_menu.dart';
import 'package:store_app/widgets/profile/profile_pic.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ProfilePic(),
              const SizedBox(
                height: 20,
              ),
              ProfileMenu(
                icon: 'assets/icons/User Icon.svg',
                text: 'My Account',
                onSelectMenu: (context) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyAccountScreen(),
                    ),
                  );
                },
              ),
              ProfileMenu(
                icon: 'assets/icons/Bell.svg',
                text: 'Notifications',
                onSelectMenu: (context) {},
              ),
              ProfileMenu(
                icon: 'assets/icons/Log out.svg',
                text: 'Log Out',
                onSelectMenu: (context) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

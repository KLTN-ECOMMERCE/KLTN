import 'dart:io';

import 'package:flutter/material.dart';
import 'package:store_app/api/api_user.dart';
import 'package:store_app/screens/profile/change_email.dart';
import 'package:store_app/screens/profile/change_name.dart';
import 'package:store_app/screens/profile/change_password.dart';
import 'package:store_app/widgets/profile/my_profile.dart';
import 'package:store_app/widgets/profile/profile_pic.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({
    super.key,
  });
  @override
  State<MyProfileScreen> createState() {
    return _MyProfileState();
  }
}

class _MyProfileState extends State<MyProfileScreen> {
  final ApiUser _apiUser = ApiUser();
  dynamic _profile;

  Future<dynamic> _getUserProfile() async {
    try {
      final response = await _apiUser.getProfile();
      final profile = response['user'];
      _profile = profile;
      return profile;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
      throw HttpException(e.toString());
    }
  }

  void _selectName(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => ChangeNameScreen(
        email: _profile['email'],
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height / 1.2,
      ),
    );
  }

  void _selectEmail(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => ChangeEmailScreen(
        name: _profile['name'],
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height / 1.2,
      ),
    );
  }

  void _selectPassword(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => const ChangePasswordScreen(),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: (MediaQuery.of(context).size.height) / 1.2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Account',
        ),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Center(
                child: ProfilePic(),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: _getUserProfile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'Error: ${snapshot.error}',
                    );
                  } else {
                    final profile = snapshot.data;
                    return Column(
                      children: [
                        MyProfileWidget(
                          label: 'Name',
                          information: profile['name'],
                          onTap: _selectName,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        MyProfileWidget(
                          label: 'Email',
                          information: profile['email'],
                          onTap: _selectEmail,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        MyProfileWidget(
                          label: 'Password',
                          information: '*********************',
                          onTap: _selectPassword,
                        ),
                      ],
                    );
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

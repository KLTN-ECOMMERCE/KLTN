import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:store_app/notifications/notification_service.dart';
import 'package:store_app/widgets/profile/profile_pic.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationService notificationService = NotificationService();
  bool _isNotification = true;
  final storage = const FlutterSecureStorage();

  Future<dynamic> isRemind() async {
    final remind = await storage.read(key: 'remind');
    print(remind);

    setState(() {
      _isNotification = remind == 'false' ? false : true;
    });
  }

  @override
  void initState() {
    isRemind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isNotification) {
      notificationService.secheduleNotification(
        'You have not gone shopping for a long time, do you ?',
        'You have a new voucher, best sale ever, up sale to 10% if you go shopping today !!! And many best offers are waiting for you',
        'Remind back to shop payload !!!',
      );
    } else {
      notificationService.stopNotifications();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
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
              Container(
                color: Theme.of(context).colorScheme.surface,
                child: SwitchListTile(
                  thumbIcon: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return const Icon(Icons.check);
                    }
                    return const Icon(Icons.close);
                  }),
                  title: Text(
                    'Enable to remind me to shop !!!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  secondary: !_isNotification
                      ? const Icon(
                          Icons.notifications_active_outlined,
                        )
                      : const Icon(
                          Icons.notifications,
                          color: Colors.red,
                        ),
                  value: _isNotification,
                  onChanged: (value) async {
                    setState(() {
                      _isNotification = value;
                    });

                    await storage.delete(key: 'remind');

                    await storage.write(
                      key: 'remind',
                      value: value ? 'true' : 'false',
                    );

                    final remind = await storage.read(key: 'remind');
                    print(remind);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

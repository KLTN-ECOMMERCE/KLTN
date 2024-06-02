import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.icon,
    required this.text,
    required this.onSelectMenu,
  });

  final String text, icon;
  final void Function(BuildContext context) onSelectMenu;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        onPressed: () {
          onSelectMenu(context);
        },
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 22,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
            ),
          ],
        ),
      ),
    );
  }
}

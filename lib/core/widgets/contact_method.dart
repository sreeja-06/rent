import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';

class ContactMethod extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;

  const ContactMethod({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
  });

  @override 
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: UiSizes.spacingLarge),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              detail,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../config/colors.dart';

class PropertyFeature extends StatelessWidget {
  final IconData icon;
  final String text;

  const PropertyFeature({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.textMedium,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textMedium,
          ),
        ),
      ],
    );
  }
}

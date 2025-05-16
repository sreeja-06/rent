import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final DateTime timestamp;
  final bool isOwner;
  final Widget? avatar;

  const MessageBubble({
    super.key,
    required this.message,
    required this.timestamp,
    this.isOwner = false,
    this.avatar,
  });

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    }
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isOwner ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isOwner && avatar != null) ...[
          avatar!,
          const SizedBox(width: UiSizes.spacing),
        ],
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(UiSizes.spacingLarge),
            decoration: BoxDecoration(
              color: isOwner 
                  ? Theme.of(context).colorScheme.surface 
                  : AppColors.primary,
              borderRadius: BorderRadius.circular(UiSizes.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isOwner ? AppColors.textDark : Colors.white,
                  ),
                ),
                const SizedBox(height: UiSizes.spacing),
                Text(
                  _formatTimestamp(timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isOwner 
                        ? AppColors.textLight 
                        : Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isOwner) const SizedBox(width: 32),
      ],
    );
  }
}

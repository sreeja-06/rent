import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import '../../routes/app_routes.dart';
import '../../core/widgets/contact_method.dart';
import '../../core/utils/date_formatters.dart';
import '../../core/widgets/message_bubble.dart';
import '../../core/widgets/empty_state.dart';

// Temporary User, UserRole, and UserPreferences class definitions for this screen.
// Remove these if your '../../models/user_model.dart' already provides them.

enum UserRole { owner, customer }

class UserPreferences {
  // Add fields as needed
  const UserPreferences();
}

class User {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final UserRole role;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final UserPreferences preferences;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.role,
    this.profileImageUrl,
    required this.createdAt,
    required this.lastLoginAt,
    required this.preferences,
  });
}


class ContactOwnerScreen extends StatefulWidget {
  const ContactOwnerScreen({super.key});

  @override
  State<ContactOwnerScreen> createState() => _ContactOwnerScreenState();
}

class _ContactOwnerScreenState extends State<ContactOwnerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _messages = <Message>[].obs;
  final _isSending = false.obs;
  late final String ownerId;
  late final String? propertyId;

  // Sample owner data (would come from API/database in real app)
  final User _owner = User(
    id: 'owner1',
    name: 'Sarah Johnson',
    email: 'sarah.johnson@example.com',
    phoneNumber: '(555) 123-4567',
    role: UserRole.owner,
    profileImageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
    createdAt: DateTime.now().subtract(const Duration(days: 180)),
    lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
    preferences: UserPreferences(),
  );
  
  // Message history (would come from API/database in real app)
  final List<Message> _messageHistory = [
    Message(
      id: 'm1',
      senderId: 'owner1',
      receiverId: 'current_user',
      content: 'Thank you for your interest in my property. Feel free to ask any questions.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: true,
    ),
    Message(
      id: 'm2',
      senderId: 'current_user',
      receiverId: 'owner1',
      content: 'Is the property available for a 12-month lease starting next month?',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    Message(
      id: 'm3',
      senderId: 'owner1',
      receiverId: 'current_user',
      content: 'Yes, it is available. I can schedule a viewing for you this weekend if you\'re interested.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
    ),
  ];
  
  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    ownerId = args?['ownerId'] as String? ?? '';
    propertyId = args?['propertyId'] as String?;
    
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      _messages.value = _messageHistory;
    } catch (e) {
      AppRoutes.handleError('Failed to load messages');
    }
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
  
  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate()) return;
    
    try {
      _isSending.value = true;
      final message = _messageController.text.trim();
      
      // Add message to list
      _messages.add(Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'current_user',
        receiverId: _owner.id,
        content: message,
        timestamp: DateTime.now(),
        isRead: false,
      ));
      
      _messageController.clear();
      
    } catch (e) {
      AppRoutes.handleError('Failed to send message');
    } finally {
      _isSending.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Contact Owner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show owner info
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildOwnerInfoSheet(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Owner info card
          _buildOwnerCard(),
          
          // Message history
          Expanded(
            child: _messageHistory.isEmpty
                ? const EmptyState(
                    message: 'No messages yet',
                    icon: Icons.message_outlined,
                    title: 'No Messages Yet',
                    //description: 'Send a message to the property owner',
                  )
                : _buildMessageHistory(),
          ),
          
          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }
  
  Widget _buildOwnerCard() {
    return Container(
      padding: const EdgeInsets.all(UiSizes.spacingLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider,
          ),
        ),
      ),      child: Row(
        children: [
          // Owner image
          CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage(_owner.profileImageUrl ?? ''),
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: _owner.profileImageUrl == null
                ? const Icon(Icons.person, color: AppColors.primary)
                : null,
          ),
          
          const SizedBox(width: UiSizes.spacingLarge),
          
          // Owner info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _owner.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Property Owner',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ),
          
          // Call button
          OutlinedButton.icon(
            onPressed: () {
              // Call owner
            },
            icon: const Icon(Icons.phone),
            label: const Text('Call'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: UiSizes.spacingLarge,
                vertical: UiSizes.spacing,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMessageHistory() {
    return ListView.builder(
      padding: const EdgeInsets.all(UiSizes.spacingLarge),
      itemCount: _messageHistory.length,
      reverse: false,
      itemBuilder: (context, index) {
        final message = _messageHistory[index];
        final isOwnerMessage = message.senderId == _owner.id;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: UiSizes.spacingLarge),
          child: MessageBubble(
            message: message.content,
            timestamp: message.timestamp,
            isOwner: isOwnerMessage,
            avatar: isOwnerMessage ? CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(_owner.profileImageUrl ?? ''),
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: _owner.profileImageUrl == null
                  ? const Icon(Icons.person, color: AppColors.primary, size: 16)
                  : null,
            ) : null,
          ),
        );
      },
    );
  }
  
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(UiSizes.spacingLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.divider,
          ),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            // Message input
            Expanded(
              child: TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Type your message...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                minLines: 1,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
            ),
            
            const SizedBox(width: UiSizes.spacingLarge),
            
            // Send button
            IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send),
              color: AppColors.primary,
              iconSize: 28,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildOwnerInfoSheet() {
    return Container(
      padding: const EdgeInsets.all(UiSizes.spacingXLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Owner image
          CircleAvatar(
            radius: 48,
            backgroundImage: NetworkImage(_owner.profileImageUrl ?? ''),
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: _owner.profileImageUrl == null
                ? const Icon(Icons.person, color: AppColors.primary, size: 48)
                : null,
          ),
          
          const SizedBox(height: UiSizes.spacingXLarge),
          
          // Owner name
          Text(
            _owner.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: UiSizes.spacing),
          
          // Owner role
          Text(
            'Property Owner',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textMedium,
            ),
          ),
          
          const SizedBox(height: UiSizes.spacingXLarge),
          
          // Contact details
          ContactMethod(
            icon: Icons.email,
            title: 'Email',
            detail: _owner.email,
          ),
          const Divider(height: 32),
          ContactMethod(
            icon: Icons.phone,
            title: 'Phone',
            detail: _owner.phoneNumber ?? 'Not provided',
          ),
          const Divider(height: 32),
          ContactMethod(
            icon: Icons.calendar_today,
            title: 'Member Since',
            detail: DateFormatters.formatDate(_owner.createdAt),
          ),
          
          const SizedBox(height: UiSizes.spacingXXLarge),
          
          // Close button
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  
  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.isRead,
  });
}


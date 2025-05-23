// filepath: c:\Desktop\rent\lib\screens\owner\inquiries_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/colors.dart';
import '../../models/property_model.dart';

class InquiryController extends GetxController {
  // Observable properties
  final RxList<Inquiry> inquiries = <Inquiry>[].obs;
  final RxList<Inquiry> filteredInquiries = <Inquiry>[].obs;
  final RxString filterType = 'All'.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadInquiries();
  }
  
  void loadInquiries() {
    // In a real app, this would fetch inquiries from a database
    inquiries.value = [
      Inquiry(
        id: 'inq1',
        propertyId: 'prop1',
        propertyTitle: 'Modern Apartment with City View',
        propertyImage: 'assets/images/placeholder.png',
        customerName: 'John Smith',
        customerEmail: 'john@example.com',
        customerPhone: '555-123-4567',
        message: 'I am interested in viewing this apartment. Is it available this weekend for a tour?',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        status: InquiryStatus.new_,
      ),
      Inquiry(
        id: 'inq2',
        propertyId: 'prop2',
        propertyTitle: 'Cozy Studio Downtown',
        propertyImage: 'assets/images/placeholder.png',
        customerName: 'Emily Johnson',
        customerEmail: 'emily@example.com',
        customerPhone: '555-987-6543',
        message: 'Hello, I would like to know if utilities are included in the rent price?',
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: InquiryStatus.inProgress,
      ),
      Inquiry(
        id: 'inq3',
        propertyId: 'prop1',
        propertyTitle: 'Modern Apartment with City View',
        propertyImage: 'assets/images/placeholder.png',
        customerName: 'Michael Brown',
        customerEmail: 'michael@example.com',
        customerPhone: '555-456-7890',
        message: 'Is this property pet-friendly? I have a small dog.',
        date: DateTime.now().subtract(const Duration(days: 3)),
        status: InquiryStatus.resolved,
      ),
      Inquiry(
        id: 'inq4',
        propertyId: 'prop3',
        propertyTitle: 'Luxury Penthouse',
        propertyImage: 'assets/images/placeholder.png',
        customerName: 'Sarah Wilson',
        customerEmail: 'sarah@example.com',
        customerPhone: '555-789-0123',
        message: 'What is the minimum lease term for this property?',
        date: DateTime.now().subtract(const Duration(days: 5)),
        status: InquiryStatus.new_,
      ),
    ];
    
    filterInquiries(filterType.value);
  }
  
  void filterInquiries(String type) {
    filterType.value = type;
    
    switch (type) {
      case 'New':
        filteredInquiries.value = inquiries.where((i) => i.status == InquiryStatus.new_).toList();
        break;
      case 'In Progress':
        filteredInquiries.value = inquiries.where((i) => i.status == InquiryStatus.inProgress).toList();
        break;
      case 'Resolved':
        filteredInquiries.value = inquiries.where((i) => i.status == InquiryStatus.resolved).toList();
        break;
      case 'All':
      default:
        filteredInquiries.value = List.from(inquiries);
        break;
    }
  }
  
  void updateInquiryStatus(String inquiryId, InquiryStatus newStatus) {
    final index = inquiries.indexWhere((i) => i.id == inquiryId);
    if (index != -1) {
      final updatedInquiry = inquiries[index].copyWith(status: newStatus);
      inquiries[index] = updatedInquiry;
      filterInquiries(filterType.value);
      
      Get.snackbar(
        'Status Updated',
        'Inquiry status has been updated successfully',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  void replyToInquiry(String inquiryId, String message) {
    // In a real app, this would send a reply to the customer and update the database
    if (message.isNotEmpty) {
      final index = inquiries.indexWhere((i) => i.id == inquiryId);
      if (index != -1) {
        updateInquiryStatus(inquiryId, InquiryStatus.inProgress);
        
        Get.snackbar(
          'Reply Sent',
          'Your reply has been sent to the customer',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        'Please enter a reply message',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

class InquiriesScreen extends StatelessWidget {
  const InquiriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InquiryController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inquiries'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: _buildFilterTabs(controller),
        ),
      ),
      body: Obx(() {
        final inquiries = controller.filteredInquiries;
        
        if (inquiries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No ${controller.filterType.value.toLowerCase()} inquiries found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: inquiries.length,
          itemBuilder: (context, index) {
            return _buildInquiryCard(context, inquiries[index], controller);
          },
        );
      }),
    );
  }
  
  Widget _buildFilterTabs(InquiryController controller) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Obx(() => Row(
          children: [
            _buildFilterChip('All', controller),
            const SizedBox(width: 8),
            _buildFilterChip('New', controller),
            const SizedBox(width: 8),
            _buildFilterChip('In Progress', controller),
            const SizedBox(width: 8),
            _buildFilterChip('Resolved', controller),
          ],
        )),
      ),
    );
  }
  
  Widget _buildFilterChip(String label, InquiryController controller) {
    final isSelected = controller.filterType.value == label;
    
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      onSelected: (_) => controller.filterInquiries(label),
      backgroundColor: Colors.grey.shade100,
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
  
  Widget _buildInquiryCard(BuildContext context, Inquiry inquiry, InquiryController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInquiryHeader(inquiry),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        inquiry.propertyImage,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            inquiry.propertyTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'From: ${inquiry.customerName}',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDateTime(inquiry.date),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Message:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  inquiry.message,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                _buildContactInfo(inquiry),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showReplyDialog(context, inquiry, controller),
                        icon: const Icon(Icons.reply),
                        label: const Text('Reply'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showStatusUpdateDialog(context, inquiry, controller),
                        icon: const Icon(Icons.update),
                        label: const Text('Update Status'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInquiryHeader(Inquiry inquiry) {
    Color statusColor;
    String statusText;
    
    switch (inquiry.status) {
      case InquiryStatus.new_:
        statusColor = Colors.blue;
        statusText = 'New';
        break;
      case InquiryStatus.inProgress:
        statusColor = Colors.orange;
        statusText = 'In Progress';
        break;
      case InquiryStatus.resolved:
        statusColor = Colors.green;
        statusText = 'Resolved';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              statusText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Inquiry #${inquiry.id}',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactInfo(Inquiry inquiry) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.email, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  inquiry.customerEmail,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                inquiry.customerPhone,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
  
  void _showReplyDialog(BuildContext context, Inquiry inquiry, InquiryController controller) {
    final replyController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: const Text('Reply to Inquiry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To: ${inquiry.customerName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: replyController,
              decoration: const InputDecoration(
                hintText: 'Type your reply here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.replyToInquiry(inquiry.id, replyController.text);
            },
            child: const Text('Send Reply'),
          ),
        ],
      ),
    );
  }
  
  void _showStatusUpdateDialog(BuildContext context, Inquiry inquiry, InquiryController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Update Inquiry Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusOption(
              'New',
              InquiryStatus.new_,
              inquiry.status,
              inquiry.id,
              controller,
            ),
            _buildStatusOption(
              'In Progress',
              InquiryStatus.inProgress,
              inquiry.status,
              inquiry.id,
              controller,
            ),
            _buildStatusOption(
              'Resolved',
              InquiryStatus.resolved,
              inquiry.status,
              inquiry.id,
              controller,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatusOption(
    String label,
    InquiryStatus status,
    InquiryStatus currentStatus,
    String inquiryId,
    InquiryController controller,
  ) {
    return RadioListTile<InquiryStatus>(
      title: Text(label),
      value: status,
      groupValue: currentStatus,
      onChanged: (value) {
        Get.back();
        if (value != null && value != currentStatus) {
          controller.updateInquiryStatus(inquiryId, value);
        }
      },
    );
  }
}

enum InquiryStatus {
  new_,
  inProgress,
  resolved,
}

class Inquiry {
  final String id;
  final String propertyId;
  final String propertyTitle;
  final String propertyImage;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String message;
  final DateTime date;
  final InquiryStatus status;
  
  Inquiry({
    required this.id,
    required this.propertyId,
    required this.propertyTitle,
    required this.propertyImage,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.message,
    required this.date,
    required this.status,
  });
  
  Inquiry copyWith({
    String? id,
    String? propertyId,
    String? propertyTitle,
    String? propertyImage,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? message,
    DateTime? date,
    InquiryStatus? status,
  }) {
    return Inquiry(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      propertyTitle: propertyTitle ?? this.propertyTitle,
      propertyImage: propertyImage ?? this.propertyImage,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      message: message ?? this.message,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }
}


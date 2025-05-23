import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/colors.dart';
import '../../models/property_model.dart';

class EditPropertyController extends GetxController {
  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  final priceController = TextEditingController();
  final areaController = TextEditingController();
  final minDurationController = TextEditingController();
  final maxDurationController = TextEditingController();
  final securityDepositController = TextEditingController();
  
  // Observable properties
  final RxInt bedrooms = 1.obs;
  final RxInt bathrooms = 1.obs;
  final RxBool isPetFriendly = false.obs;
  final RxBool includesUtilities = false.obs;
  final RxList<String> additionalConditions = <String>[].obs;
  final RxList<String> selectedAmenities = <String>[].obs;
  final RxList<String> propertyImages = <String>[].obs;
  
  final amenities = PropertyAmenities.getAllAmenities();

  // Property being edited (would be filled with data in a real app)
  final Rx<Property?> property = Rx<Property?>(null);

  @override
  void onInit() {
    super.onInit();
    // In a real app, this would come from the database or be passed via Get.arguments
    // For demo purposes, we're creating a sample property
    loadProperty();
  }

  void loadProperty() {
    // Demo property
    final leaseTerms = LeaseTerms(
      minDuration: 12,
      maxDuration: 24,
      isPetFriendly: true,
      includesUtilities: false,
      securityDeposit: 1200,
      additionalConditions: ['No smoking', 'Background check required'],
    );
    
    property.value = Property(
      id: 'prop123',
      ownerId: 'owner123',
      title: 'Modern Apartment with City View',
      description: 'This beautiful modern apartment offers breathtaking city views and premium finishes throughout. The open concept living area features hardwood floors and large windows that flood the space with natural light.',
      address: '123 Main Street, Apt 4B, New York',
      price: 1200,
      bedrooms: 2,
      bathrooms: 2,
      area: 1200,      isAvailable: true,
      images: [
        'lib/assets/images/placeholder.png',
        'lib/assets/images/placeholder.png',
      ],
      amenities: [PropertyAmenities.wifi, PropertyAmenities.ac, PropertyAmenities.heating],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      leaseTerms: leaseTerms,
      location: GeoPoint(latitude: 40.712776, longitude: -74.005974),
    );

    // Fill form fields with property data
    titleController.text = property.value!.title;
    descriptionController.text = property.value!.description;
    addressController.text = property.value!.address;
    priceController.text = property.value!.price.toString();
    areaController.text = property.value!.area.toString();
    minDurationController.text = property.value!.leaseTerms.minDuration.toString();
    if (property.value!.leaseTerms.maxDuration != null) {
      maxDurationController.text = property.value!.leaseTerms.maxDuration.toString();
    }
    securityDepositController.text = property.value!.leaseTerms.securityDeposit.toString();
    
    bedrooms.value = property.value!.bedrooms;
    bathrooms.value = property.value!.bathrooms;
    isPetFriendly.value = property.value!.leaseTerms.isPetFriendly;
    includesUtilities.value = property.value!.leaseTerms.includesUtilities;
    propertyImages.value = List<String>.from(property.value!.images);
    selectedAmenities.value = List<String>.from(property.value!.amenities);
    additionalConditions.value = List<String>.from(property.value!.leaseTerms.additionalConditions);
  }

  void incrementBedrooms() {
    if (bedrooms.value < 10) bedrooms.value++;
  }

  void decrementBedrooms() {
    if (bedrooms.value > 1) bedrooms.value--;
  }

  void incrementBathrooms() {
    if (bathrooms.value < 10) bathrooms.value++;
  }

  void decrementBathrooms() {
    if (bathrooms.value > 1) bathrooms.value--;
  }

  void toggleAmenity(String amenity) {
    if (selectedAmenities.contains(amenity)) {
      selectedAmenities.remove(amenity);
    } else {
      selectedAmenities.add(amenity);
    }
  }

  void addImage(String imagePath) {
    propertyImages.add(imagePath);
  }

  void removeImage(int index) {
    if (index >= 0 && index < propertyImages.length) {
      propertyImages.removeAt(index);
    }
  }

  void addCondition(String condition) {
    if (condition.isNotEmpty && !additionalConditions.contains(condition)) {
      additionalConditions.add(condition);
    }
  }

  void removeCondition(int index) {
    if (index >= 0 && index < additionalConditions.length) {
      additionalConditions.removeAt(index);
    }
  }

  void saveProperty() {
    // Validation
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        addressController.text.isEmpty ||
        priceController.text.isEmpty ||
        areaController.text.isEmpty ||
        minDurationController.text.isEmpty ||
        securityDepositController.text.isEmpty ||
        propertyImages.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields and add at least one image.',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // In a real app, this would update the property in the database
    Get.snackbar(
      'Success',
      'Property updated successfully',
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      snackPosition: SnackPosition.BOTTOM,
    );
    
    // Navigate back to the owner dashboard
    Future.delayed(const Duration(seconds: 1), () {
      Get.back();
    });
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    priceController.dispose();
    areaController.dispose();
    minDurationController.dispose();
    maxDurationController.dispose();
    securityDepositController.dispose();
    super.onClose();
  }
}

class EditPropertyScreen extends StatelessWidget {
  const EditPropertyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditPropertyController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Property'),
        actions: [
          TextButton.icon(
            onPressed: controller.saveProperty,
            icon: const Icon(Icons.check, color: Colors.white),
            label: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.property.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return _buildForm(context, controller);
      }),
    );
  }

  Widget _buildForm(BuildContext context, EditPropertyController controller) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Property Images'),
            const SizedBox(height: 10),
            _buildImageSection(controller),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Basic Information'),
            const SizedBox(height: 10),
            _buildTextField(
              controller: controller.titleController,
              label: 'Property Title',
              hint: 'Enter property title',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.addressController,
              label: 'Address',
              hint: 'Enter property address',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.priceController,
              label: 'Monthly Rent',
              hint: 'Enter amount in dollars',
              keyboardType: TextInputType.number,
              prefix: '\$',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.areaController,
              label: 'Area (sq ft)',
              hint: 'Enter property area',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildCounterField(
                    label: 'Bedrooms',
                    value: controller.bedrooms.value,
                    onIncrement: controller.incrementBedrooms,
                    onDecrement: controller.decrementBedrooms,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCounterField(
                    label: 'Bathrooms',
                    value: controller.bathrooms.value,
                    onIncrement: controller.incrementBathrooms,
                    onDecrement: controller.decrementBathrooms,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Lease Terms'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: controller.minDurationController,
                    label: 'Min Duration (months)',
                    hint: 'e.g., 12',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: controller.maxDurationController,
                    label: 'Max Duration (optional)',
                    hint: 'e.g., 24',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.securityDepositController,
              label: 'Security Deposit',
              hint: 'Enter amount in dollars',
              keyboardType: TextInputType.number,
              prefix: '\$',
            ),
            const SizedBox(height: 16),
            _buildSwitchTile(
              label: 'Pet Friendly',
              value: controller.isPetFriendly.value,
              onChanged: (value) => controller.isPetFriendly.value = value,
            ),
            _buildSwitchTile(
              label: 'Utilities Included',
              value: controller.includesUtilities.value,
              onChanged: (value) => controller.includesUtilities.value = value,
            ),
            const SizedBox(height: 16),
            _buildConditionsSection(controller),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Amenities'),
            const SizedBox(height: 10),
            _buildAmenitiesGrid(controller),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Description'),
            const SizedBox(height: 10),
            _buildTextField(
              controller: controller.descriptionController,
              label: 'Property Description',
              hint: 'Describe your property',
              maxLines: 5,
            ),
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.saveProperty,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildImageSection(EditPropertyController controller) {
    return SizedBox(
      height: 120,
      child: Row(
        children: [
          // Add image button
          Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: InkWell(
              onTap: () {
                // In a real app, this would open image picker
                controller.addImage('assets/images/placeholder.png');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_photo_alternate, size: 32, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Add Photo', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          
          // Property images list
          Expanded(
            child: Obx(() => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.propertyImages.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                    image: DecorationImage(
                      image: AssetImage(controller.propertyImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 5,
                        right: 5,
                        child: InkWell(
                          onTap: () => controller.removeImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionsSection(EditPropertyController controller) {
    final conditionController = TextEditingController();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Conditions',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: conditionController,
                decoration: InputDecoration(
                  hintText: 'Add condition (e.g., No smoking)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                if (conditionController.text.isNotEmpty) {
                  controller.addCondition(conditionController.text);
                  conditionController.clear();
                }
              },
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.additionalConditions.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        controller.additionalConditions[index],
                      ),
                    ),
                    IconButton(
                      onPressed: () => controller.removeCondition(index),
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red,
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            );
          },
        )),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? prefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCounterField({
    required String label,
    required int value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: onDecrement,
                padding: const EdgeInsets.all(0),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: onIncrement,
                padding: const EdgeInsets.all(0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesGrid(EditPropertyController controller) {
    return Obx(() => Wrap(
      spacing: 10,
      runSpacing: 10,
      children: controller.amenities.map((amenity) {
        final isSelected = controller.selectedAmenities.contains(amenity);
        return InkWell(
          onTap: () => controller.toggleAmenity(amenity),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.shade300,
              ),
            ),
            child: Text(
              amenity,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade800,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    ));
  }
}


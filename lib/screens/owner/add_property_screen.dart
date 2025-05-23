import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/colors.dart';
import '../../config/constants.dart' hide PropertyTypes;
import '../../models/property_model.dart';
import '../../routes/app_routes.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();
  final _areaController = TextEditingController();
  
  int _bedrooms = 1;
  int _bathrooms = 1;
  List<String> _selectedAmenities = [];
  List<String> _images = [];
  
  // Lease terms
  int _minLeaseDuration = 6;
  int _maxLeaseDuration = 12;
  bool _isPetFriendly = false;
  bool _includesUtilities = false;
  final _securityDepositController = TextEditingController();
  final List<String> _additionalConditions = ['No smoking'];
  
  // Step tracking
  int _currentStep = 0;

  // Add proper state management
  final _isSaving = false.obs;
  final _selectedPropertyType = PropertyTypes.apartment.obs;
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    _securityDepositController.dispose();
    super.dispose();
  }
  
  void _addImage() {
    // In a real app, this would open an image picker
    setState(() {
      _images.add('https://images.unsplash.com/photo-1522708323590-d24dbb6b0267');
    });
  }
  
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }
  
  void _addCondition(String condition) {
    if (condition.isNotEmpty) {
      setState(() {
        _additionalConditions.add(condition);
      });
    }
  }
  
  void _removeCondition(int index) {
    setState(() {
      _additionalConditions.removeAt(index);
    });
  }
  
  Future<void> _saveProperty() async {
    if (!_formKey.currentState!.validate()) return;
    
    try {
      _isSaving.value = true;
      
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final area = double.tryParse(_areaController.text) ?? 0.0;
      final securityDeposit = double.tryParse(_securityDepositController.text) ?? price;
      
      final property = Property(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        ownerId: 'current_user',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: price,
        address: _addressController.text.trim(),
        images: _images.isEmpty ? ['assets/images/placeholder.jpg'] : _images,
        bedrooms: _bedrooms,
        bathrooms: _bathrooms,
        area: area,
        amenities: _selectedAmenities,
        isAvailable: true,
        createdAt: DateTime.now(),
        leaseTerms: LeaseTerms(
          minDuration: _minLeaseDuration,
          maxDuration: _maxLeaseDuration,
          isPetFriendly: _isPetFriendly,
          includesUtilities: _includesUtilities,
          securityDeposit: securityDeposit,
          additionalConditions: _additionalConditions,
        ),
        propertyType: _selectedPropertyType.value,
      );
      
      property.validate();
      AppRoutes.goBack(result: property);
      
    } catch (e) {
      AppRoutes.handleError('Failed to save property: $e');
    } finally {
      _isSaving.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Add New Property'),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: _currentStep == 3 ? _saveProperty : null,
            icon: const Icon(Icons.check),
            label: const Text('Save'),
            style: TextButton.styleFrom(
              foregroundColor: _currentStep == 3 
                  ? AppColors.primary 
                  : AppColors.textLight,
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 3) {
              setState(() {
                _currentStep++;
              });
            } else {
              _saveProperty();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            } else {
              Get.back(); // Use GetX for navigation
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: UiSizes.spacingXLarge),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(_currentStep < 3 ? 'Continue' : 'Save Property'),
                    ),
                  ),
                  const SizedBox(width: UiSizes.spacingLarge),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(_currentStep > 0 ? 'Back' : 'Cancel'),
                    ),
                  ),
                ],
              ),
            );
          },
          steps: [
            _buildBasicInfoStep(),
            _buildDetailsStep(),
            _buildAmenitiesStep(),
            _buildLeaseTermsStep(),
          ],
        ),
      ),
    );
  }
  
  Step _buildBasicInfoStep() {
    return Step(
      title: const Text('Basic Information'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Images
          Text(
            'Property Images',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: UiSizes.spacingLarge),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length + 1, // +1 for add button
              itemBuilder: (context, index) {
                if (index == _images.length) {
                  // Add image button
                  return InkWell(
                    onTap: _addImage,
                    borderRadius: BorderRadius.circular(UiSizes.cardRadius),
                    child: Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: UiSizes.spacing),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(UiSizes.cardRadius),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            color: AppColors.primary,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add Image',
                            style: TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Image preview
                  return Stack(
                    children: [
                      Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: UiSizes.spacing),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(UiSizes.cardRadius),
                          image: DecorationImage(
                            image: NetworkImage(_images[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4 + UiSizes.spacing,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          
          const SizedBox(height: UiSizes.spacingXLarge),
          
          // Title
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Property Title',
              hintText: 'e.g., Modern Downtown Apartment',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              if (value.length > ValidationRules.maxTitleLength) {
                return 'Title is too long';
              }
              return null;
            },
          ),
          
          const SizedBox(height: UiSizes.spacingLarge),
          
          // Description
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Describe your property...',
              alignLabelWithHint: true,
            ),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              if (value.length > ValidationRules.maxDescriptionLength) {
                return 'Description is too long';
              }
              return null;
            },
          ),
          
          const SizedBox(height: UiSizes.spacingLarge),
          
          // Price
          TextFormField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Monthly Rent',
              hintText: 'e.g., 1500',
              prefixText: '\$ ',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the monthly rent';
              }
              final price = double.tryParse(value);
              if (price == null) {
                return 'Please enter a valid number';
              }
              if (price < ValidationRules.minRentPrice || price > ValidationRules.maxRentPrice) {
                return 'Price must be between \$${ValidationRules.minRentPrice} and \$${ValidationRules.maxRentPrice}';
              }
              return null;
            },
          ),
          
          const SizedBox(height: UiSizes.spacingLarge),
          
          // Address
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              hintText: 'Full property address',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the property address';
              }
              return null;
            },
          ),
        ],
      ),
      isActive: _currentStep >= 0,
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
    );
  }
  
  Step _buildDetailsStep() {
    return Step(
      title: const Text('Property Details'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bedrooms
          Text(
            'Bedrooms',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: UiSizes.spacing),
          Row(
            children: [
              IconButton(
                onPressed: _bedrooms > 1 
                    ? () => setState(() => _bedrooms--) 
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
                color: _bedrooms > 1 ? AppColors.primary : AppColors.textLight,
              ),
              Expanded(
                child: Text(
                  '$_bedrooms ${_bedrooms == 1 ? 'Bedroom' : 'Bedrooms'}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _bedrooms++),
                icon: const Icon(Icons.add_circle_outline),
                color: AppColors.primary,
              ),
            ],
          ),
          
          const SizedBox(height: UiSizes.spacingXLarge),
          
          // Bathrooms
          Text(
            'Bathrooms',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: UiSizes.spacing),
          Row(
            children: [
              IconButton(
                onPressed: _bathrooms > 1 
                    ? () => setState(() => _bathrooms--) 
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
                color: _bathrooms > 1 ? AppColors.primary : AppColors.textLight,
              ),
              Expanded(
                child: Text(
                  '$_bathrooms ${_bathrooms == 1 ? 'Bathroom' : 'Bathrooms'}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _bathrooms++),
                icon: const Icon(Icons.add_circle_outline),
                color: AppColors.primary,
              ),
            ],
          ),
          
          const SizedBox(height: UiSizes.spacingXLarge),
          
          // Area
          TextFormField(
            controller: _areaController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Area',
              hintText: 'e.g., 1000',
              suffixText: 'sq ft',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the property area';
              }
              final area = double.tryParse(value);
              if (area == null || area <= 0) {
                return 'Please enter a valid area';
              }
              return null;
            },
          ),
          
          const SizedBox(height: UiSizes.spacingXLarge),
          
          // Property type
          Text(
            'Property Type',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: UiSizes.spacingLarge),
          Obx(() => DropdownButtonFormField<String>(
            value: _selectedPropertyType.value,
            decoration: const InputDecoration(
              hintText: 'Select property type',
            ),
            items: PropertyTypes.getAllTypes().map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                _selectedPropertyType.value = value;
              }
            },
          )),
        ],
      ),
      isActive: _currentStep >= 1,
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
    );
  }
  
  Step _buildAmenitiesStep() {
    return Step(
      title: const Text('Amenities'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Available Amenities',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: UiSizes.spacingLarge),
          Wrap(
            spacing: UiSizes.spacing,
            runSpacing: UiSizes.spacing,
            children: PropertyAmenities.getAllAmenities().map((amenity) {
              final isSelected = _selectedAmenities.contains(amenity);
              return FilterChip(
                label: Text(amenity),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedAmenities.add(amenity);
                    } else {
                      _selectedAmenities.remove(amenity);
                    }
                  });
                },
                backgroundColor: Theme.of(context).colorScheme.surface,
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(UiSizes.cardRadius),
                  side: BorderSide(
                    color: isSelected 
                        ? AppColors.primary
                        : AppColors.divider,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      isActive: _currentStep >= 2,
      state: _currentStep > 2 ? StepState.complete : StepState.indexed,
    );
  }
  
  Step _buildLeaseTermsStep() {
    final TextEditingController additionalConditionController = TextEditingController();
    
    return Step(
      title: const Text('Lease Terms'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lease duration
          Text(
            'Lease Duration',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: UiSizes.spacingLarge),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Minimum',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    DropdownButtonFormField<int>(
                      value: _minLeaseDuration,
                      decoration: const InputDecoration(
                        hintText: 'Minimum',
                        suffixText: 'months',
                      ),
                      items: List.generate(12, (index) => index + 1)
                          .map((duration) {
                        return DropdownMenuItem<int>(
                          value: duration,
                          child: Text('$duration'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _minLeaseDuration = value;
                            if (_maxLeaseDuration < value) {
                              _maxLeaseDuration = value;
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: UiSizes.spacingLarge),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Maximum',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    DropdownButtonFormField<int>(
                      value: _maxLeaseDuration,
                      decoration: const InputDecoration(
                        hintText: 'Maximum',
                        suffixText: 'months',
                      ),
                      items: List.generate(24, (index) => index + 1)
                          .map((duration) {
                        return DropdownMenuItem<int>(
                          value: duration,
                          child: Text('$duration'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _maxLeaseDuration = value;
                            if (_minLeaseDuration > value) {
                              _minLeaseDuration = value;
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: UiSizes.spacingXLarge),
          
          // Security deposit
          TextFormField(
            controller: _securityDepositController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Security Deposit',
              hintText: 'Same as monthly rent',
              prefixText: '\$ ',
              helperText: 'Leave empty to set same as monthly rent',
              suffixIcon: IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  // Show deposit info with GetX
                  Get.snackbar(
                    'Security Deposit',
                    'Security deposit is typically 1-2 months rent.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final deposit = double.tryParse(value);
                if (deposit == null || deposit < 0) {
                  return 'Please enter a valid amount';
                }
              }
              return null;
            },
          ),
          
          const SizedBox(height: UiSizes.spacingXLarge),
          
          // Pet policy & utilities
          Row(
            children: [
              Expanded(
                child: SwitchListTile(
                  title: const Text('Pet Friendly'),
                  value: _isPetFriendly,
                  onChanged: (value) {
                    setState(() {
                      _isPetFriendly = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Expanded(
                child: SwitchListTile(
                  title: const Text('Utilities Included'),
                  value: _includesUtilities,
                  onChanged: (value) {
                    setState(() {
                      _includesUtilities = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: UiSizes.spacingXLarge),
          
          // Additional conditions
          Text(
            'Additional Conditions',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: UiSizes.spacingLarge),
          
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: additionalConditionController,
                  decoration: const InputDecoration(
                    hintText: 'Add a condition...',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: AppColors.primary,
                onPressed: () {
                  _addCondition(additionalConditionController.text);
                  additionalConditionController.clear();
                },
              ),
            ],
          ),
          
          const SizedBox(height: UiSizes.spacingLarge),
          
          // List of conditions
          ..._additionalConditions.asMap().entries.map((entry) {
            final index = entry.key;
            final condition = entry.value;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(condition),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    iconSize: 18,
                    color: AppColors.error,
                    onPressed: () => _removeCondition(index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
      isActive: _currentStep >= 3,
      state: _currentStep == 3 ? StepState.indexed : StepState.indexed,
    );
  }
}


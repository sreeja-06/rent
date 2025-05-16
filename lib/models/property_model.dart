import 'package:flutter/material.dart';

// Mock class for UI display only, no backend interactions
class GeoPoint {
  final double latitude;
  final double longitude;

  GeoPoint({required this.latitude, required this.longitude});
}

// UI-only lease terms representation
class LeaseTerms {
  final int minDuration; // in months
  final int? maxDuration; // in months, null means no maximum
  final bool isPetFriendly;
  final bool includesUtilities;
  final double securityDeposit;
  final List<String> additionalConditions;
  
  LeaseTerms({
    required this.minDuration,
    this.maxDuration,
    required this.isPetFriendly,
    required this.includesUtilities,
    required this.securityDeposit,
    this.additionalConditions = const [],
  });

  LeaseTerms copyWith({
    int? minDuration,
    int? maxDuration,
    bool? isPetFriendly,
    bool? includesUtilities,
    double? securityDeposit,
    List<String>? additionalConditions,
  }) {
    return LeaseTerms(
      minDuration: minDuration ?? this.minDuration,
      maxDuration: maxDuration ?? this.maxDuration,
      isPetFriendly: isPetFriendly ?? this.isPetFriendly,
      includesUtilities: includesUtilities ?? this.includesUtilities,
      securityDeposit: securityDeposit ?? this.securityDeposit,
      additionalConditions: additionalConditions ?? this.additionalConditions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minDuration': minDuration,
      'maxDuration': maxDuration,
      'isPetFriendly': isPetFriendly,
      'includesUtilities': includesUtilities,
      'securityDeposit': securityDeposit,
      'additionalConditions': additionalConditions,
    };
  }

  factory LeaseTerms.fromJson(Map<String, dynamic> json) {
    return LeaseTerms(
      minDuration: json['minDuration'] as int,
      maxDuration: json['maxDuration'] as int?,
      isPetFriendly: json['isPetFriendly'] as bool,
      includesUtilities: json['includesUtilities'] as bool,
      securityDeposit: json['securityDeposit'] as double,
      additionalConditions: List<String>.from(json['additionalConditions'] ?? []),
    );
  }
}

// UI-only property model
class Property {
  final String id;
  final String ownerId;
  final String title;
  final String description;
  final double price;
  final String address;
  final List<String> images;
  final int bedrooms;
  final int bathrooms;
  final double area; // in sq. ft or sq. meters
  final List<String> amenities;
  final bool isAvailable;
  final DateTime createdAt;
  final LeaseTerms leaseTerms;
  final GeoPoint? location;
  final String propertyType;
  final String status; // 'available', 'rented', 'pending'
  final DateTime? lastUpdated;
  final bool isFeatured;
  final List<String> tags;

  Property({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.price,
    required this.address,
    required this.images,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.amenities,
    required this.isAvailable,
    required this.createdAt,
    required this.leaseTerms,
    required this.propertyType,
    this.location,
    this.status = 'available',
    this.lastUpdated,
    this.isFeatured = false,
    this.tags = const [],
  }) {
    validate(); // Validate on construction
  }

  Property copyWith({
    String? id,
    String? ownerId,
    String? title,
    String? description,
    double? price,
    String? address,
    List<String>? images,
    int? bedrooms,
    int? bathrooms,
    double? area,
    List<String>? amenities,
    bool? isAvailable,
    DateTime? createdAt,
    LeaseTerms? leaseTerms,
    GeoPoint? location,
    String? propertyType,
    String? status,
    DateTime? lastUpdated,
    bool? isFeatured,
    List<String>? tags,
  }) {
    return Property(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      address: address ?? this.address,
      images: images ?? this.images,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      area: area ?? this.area,
      amenities: amenities ?? this.amenities,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      leaseTerms: leaseTerms ?? this.leaseTerms,
      location: location ?? this.location,
      propertyType: propertyType ?? this.propertyType,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isFeatured: isFeatured ?? this.isFeatured,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'title': title,
      'description': description,
      'price': price,
      'address': address,
      'images': images,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'amenities': amenities,
      'isAvailable': isAvailable,
      'createdAt': createdAt.toIso8601String(),
      'leaseTerms': leaseTerms.toJson(),
      'location': location != null ? 
          {'latitude': location!.latitude, 'longitude': location!.longitude} : null,
      'propertyType': propertyType,
      'status': status,
      'lastUpdated': lastUpdated?.toIso8601String(),
      'isFeatured': isFeatured,
      'tags': tags,
    };
  }

  factory Property.fromJson(Map<String, dynamic> json) {
    try {
      return Property(
        id: json['id'] as String,
        ownerId: json['ownerId'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        price: json['price'] as double,
        address: json['address'] as String,
        images: List<String>.from(json['images']),
        bedrooms: json['bedrooms'] as int,
        bathrooms: json['bathrooms'] as int,
        area: json['area'] as double,
        amenities: List<String>.from(json['amenities']),
        isAvailable: json['isAvailable'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
        leaseTerms: LeaseTerms.fromJson(json['leaseTerms']),
        location: json['location'] != null ? GeoPoint(
          latitude: json['location']['latitude'] as double,
          longitude: json['location']['longitude'] as double,
        ) : null,
        propertyType: json['propertyType'] as String,
        status: json['status'] as String? ?? 'available',
        lastUpdated: json['lastUpdated'] != null 
            ? DateTime.parse(json['lastUpdated'] as String)
            : null,
        isFeatured: json['isFeatured'] as bool? ?? false,
        tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      );
    } catch (e) {
      throw FormatException('Error parsing Property JSON: $e');
    }
  }

  static List<Property> getSampleProperties() {
    return [
      Property(
        id: '1',
        ownerId: 'owner1',
        title: 'Modern Apartment Downtown',
        description: 'A beautiful apartment with city views.',
        price: 1500,
        address: '123 Main St, Downtown',
        images: ['assets/images/apartment1.jpg', 'assets/images/apartment2.jpg'],
        bedrooms: 2,
        bathrooms: 1,
        area: 850,
        amenities: [
          PropertyAmenities.parking,
          PropertyAmenities.gym,
          PropertyAmenities.pool
        ],
        isAvailable: true,
        createdAt: DateTime.now(),
        leaseTerms: LeaseTerms(
          minDuration: 12,
          maxDuration: 24,
          isPetFriendly: true,
          includesUtilities: false,
          securityDeposit: 1500,
          additionalConditions: ['No smoking', 'Background check required'],
        ),
        location: GeoPoint(latitude: 40.7128, longitude: -74.0060),
        propertyType: PropertyTypes.apartment,
        status: PropertyStatus.available,
        isFeatured: true,
        tags: ['city view', 'modern'],
      ),
      Property(
        id: '2',
        ownerId: 'owner2',
        title: 'Luxury Villa with Pool',
        description: 'Spacious villa in a quiet neighborhood.',
        price: 3500,
        address: '456 Palm Ave, Suburbs',
        images: ['assets/images/villa1.jpg', 'assets/images/villa2.jpg'],
        bedrooms: 4,
        bathrooms: 3,
        area: 2500,
        amenities: [
          PropertyAmenities.pool,
          PropertyAmenities.garden,
          PropertyAmenities.security,
          PropertyAmenities.parking
        ],
        isAvailable: true,
        createdAt: DateTime.now(),
        leaseTerms: LeaseTerms(
          minDuration: 12,
          maxDuration: null,
          isPetFriendly: true,
          includesUtilities: true,
          securityDeposit: 5000,
          additionalConditions: ['No parties', 'Quarterly maintenance included'],
        ),
        location: GeoPoint(latitude: 40.7124, longitude: -74.0080),
        propertyType: PropertyTypes.villa,
        status: PropertyStatus.available,
        tags: ['luxury', 'pool'],
      ),
    ];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Property &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          ownerId == other.ownerId;

  @override
  int get hashCode => id.hashCode ^ ownerId.hashCode;

  @override
  String toString() {
    return 'Property{id: $id, title: $title, price: $price}';
  }

  // Validation method
  void validate() {
    if (id.isEmpty) throw ArgumentError('Property ID cannot be empty');
    if (ownerId.isEmpty) throw ArgumentError('Owner ID cannot be empty');
    if (title.isEmpty) throw ArgumentError('Title cannot be empty');
    if (title.length > 100) throw ArgumentError('Title is too long');
    if (description.isEmpty) throw ArgumentError('Description cannot be empty');
    if (description.length > 2000) throw ArgumentError('Description is too long');
    if (price <= 0) throw ArgumentError('Price must be greater than 0');
    if (address.isEmpty) throw ArgumentError('Address cannot be empty');
    if (bedrooms < 0) throw ArgumentError('Bedrooms cannot be negative');
    if (bathrooms < 0) throw ArgumentError('Bathrooms cannot be negative');
    if (area <= 0) throw ArgumentError('Area must be greater than 0');
    if (!PropertyTypes.getAllTypes().contains(propertyType)) {
      throw ArgumentError('Invalid property type');
    }
  }

  bool get isRented => status == 'rented';
  bool get isPending => status == 'pending';
  bool get canBeRented => status == 'available' && isAvailable;

  List<String> get validImages {
    return images.where((url) => 
      url.startsWith('http') || url.startsWith('assets/')
    ).toList();
  }

  static int compareByPrice(Property a, Property b) => a.price.compareTo(b.price);
  static int compareByDate(Property a, Property b) => b.createdAt.compareTo(a.createdAt);

  bool matchesFilter(PropertyFilter filter) {
    if (filter.priceRange != null) {
      if (price < filter.priceRange!.start || price > filter.priceRange!.end) {
        return false;
      }
    }
    
    if (filter.minBedrooms != null && bedrooms < filter.minBedrooms!) {
      return false;
    }
    
    if (filter.minBathrooms != null && bathrooms < filter.minBathrooms!) {
      return false;
    }
    
    if (filter.isPetFriendly != null && leaseTerms.isPetFriendly != filter.isPetFriendly) {
      return false;
    }
    
    if (filter.requiredAmenities != null) {
      for (final amenity in filter.requiredAmenities!) {
        if (!amenities.contains(amenity)) {
          return false;
        }
      }
    }
    
    return true;
  }
}

// Property filtering options - UI only
class PropertyFilter {
  final RangeValues? priceRange;
  final int? minBedrooms;
  final int? minBathrooms;
  final RangeValues? areaRange;
  final bool? isPetFriendly;
  final int? minLeaseDuration;
  final int? maxLeaseDuration;
  final List<String>? requiredAmenities;
  final String? location; // Search query for location

  PropertyFilter({
    this.priceRange,
    this.minBedrooms,
    this.minBathrooms,
    this.areaRange,
    this.isPetFriendly,
    this.minLeaseDuration,
    this.maxLeaseDuration,
    this.requiredAmenities,
    this.location,
  });
}

// Sample amenities for consistent use across the app
class PropertyAmenities {
  static const String wifi = 'Wi-Fi';
  static const String ac = 'Air Conditioning';
  static const String heating = 'Heating';
  static const String laundry = 'In-unit Laundry';
  static const String parking = 'Parking';
  static const String pool = 'Swimming Pool';
  static const String gym = 'Gym';
  static const String balcony = 'Balcony';
  static const String securityCamera = 'Security Cameras';
  static const String furnished = 'Furnished';
  static const String dishwasher = 'Dishwasher';
  static const String petFriendly = 'Pet Friendly';
  static const String fireplace = 'Fireplace';
  static const String garden = 'Garden';
  static const String elevator = 'Elevator';
  static const String security = 'Security';

  static List<String> getAllAmenities() {
    return [
      wifi, ac, heating, laundry, parking, pool, gym, balcony,
      securityCamera, furnished, dishwasher, petFriendly, fireplace,
      garden, elevator, security
    ];
  }
}

// UI-only representation of a property inquiry
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
  final String status; // 'pending', 'responded', 'closed'

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
    String? status,
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

// Property types
class PropertyTypes {
  static const String apartment = 'Apartment';
  static const String house = 'House';
  static const String villa = 'Villa';
  static const String condo = 'Condo';
  static const String townhouse = 'Townhouse';
  static const String studio = 'Studio';
  static const String loft = 'Loft';
  
  static List<String> getAllTypes() {
    return [apartment, house, villa, condo, townhouse, studio, loft];
  }
}

// Property status
class PropertyStatus {
  static const String available = 'available';
  static const String rented = 'rented';
  static const String pending = 'pending';
  
  static List<String> values() => [available, rented, pending];
}


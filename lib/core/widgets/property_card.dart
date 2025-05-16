import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import '../../models/property_model.dart';
import 'property_feature.dart';
import 'property_tag.dart';
import '../../core/utils/date_formatters.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback onTap;

  const PropertyCard({
    super.key,
    required this.property,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: UiSizes.spacingLarge),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiSizes.cardRadius),
      ),
      elevation: 4,
      shadowColor: AppColors.shadow.withOpacity(0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UiSizes.cardRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageStack(context),
            _buildDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageStack(BuildContext context) {
    return Stack(
      children: [
        _buildImage(),
        _buildPriceTag(context),
        if (_isNewListing) _buildNewBadge(context),
        _buildFavoriteButton(),
      ],
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(UiSizes.cardRadius),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: property.images.isNotEmpty
            ? Image.network(
                property.images.first,
                fit: BoxFit.cover,
                errorBuilder: _buildErrorImage,
                loadingBuilder: _buildLoadingImage,
              )
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildErrorImage(BuildContext context, Object error, StackTrace? stackTrace) {
    return Container(
      color: AppColors.primary.withOpacity(0.1),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 48,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildLoadingImage(BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) return child;
    return Container(
      color: AppColors.primary.withOpacity(0.05),
      child: Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
              : null,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.primary.withOpacity(0.1),
      child: const Icon(
        Icons.image_not_supported_outlined,
        size: 48,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildPriceTag(BuildContext context) {
    return Positioned(
      top: UiSizes.spacing,
      left: UiSizes.spacing,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: UiSizes.spacing,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          '\$${property.price.toStringAsFixed(0)}/mo',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNewBadge(BuildContext context) {
    return Positioned(
      top: UiSizes.spacing,
      right: UiSizes.spacing + 40,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: UiSizes.spacing,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          'NEW',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Positioned(
      top: UiSizes.spacing,
      right: UiSizes.spacing,
      child: Material(
        elevation: 4,
        shadowColor: AppColors.shadow,
        shape: const CircleBorder(),
        color: Colors.white,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            // Toggle favorite functionality would go here
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.favorite_outline,
              color: AppColors.accent,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(UiSizes.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: UiSizes.spacing),
          _buildLocation(context),
          const SizedBox(height: UiSizes.spacingLarge),
          _buildFeatures(),
          const SizedBox(height: UiSizes.spacingLarge),
          _buildTags(),
        ],
      ),
    );
  }

  Widget _buildLocation(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 16,
          color: AppColors.textLight,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            property.address,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatures() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: UiSizes.spacing),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(UiSizes.cardRadius / 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PropertyFeature(
            icon: Icons.king_bed_outlined,
            text: '${property.bedrooms} ${property.bedrooms == 1 ? 'Bed' : 'Beds'}',
          ),
          _buildVerticalDivider(),
          PropertyFeature(
            icon: Icons.bathtub_outlined,
            text: '${property.bathrooms} ${property.bathrooms == 1 ? 'Bath' : 'Baths'}',
          ),
          _buildVerticalDivider(),
          PropertyFeature(
            icon: Icons.square_foot,
            text: '${property.area.toStringAsFixed(0)} ft²',
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 24,
      width: 1,
      color: AppColors.textLight.withOpacity(0.3),
    );
  }

  Widget _buildTags() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PropertyTag(
          icon: property.leaseTerms.isPetFriendly ? Icons.pets : Icons.do_not_disturb,
          text: property.leaseTerms.isPetFriendly ? 'Pet Friendly' : 'No Pets',
          color: property.leaseTerms.isPetFriendly ? Colors.green : Colors.redAccent,
        ),
        PropertyTag(
          icon: Icons.lightbulb_outline,
          text: property.leaseTerms.includesUtilities ? 'Utilities Included' : 'Utilities Extra',
          color: property.leaseTerms.includesUtilities ? Colors.green : Colors.orange,
        ),
      ],
    );
  }

  bool get _isNewListing => DateFormatters.isNew(property.createdAt);
}

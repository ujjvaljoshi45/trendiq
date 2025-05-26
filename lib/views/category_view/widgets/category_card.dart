import 'package:flutter/material.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/services/app_colors.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category Image
            Expanded(
              flex: 8,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14),
                      ),
                      color: Colors.grey.shade300.withOpacity(0.1),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14),
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                              color: appColors.primary,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: appColors.background,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Optional overlay gradient
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            appColors.primary.withOpacity(0.2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Category Name
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: appColors.background,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(14),
                  ),
                ),
                child: Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: commonTextStyle(
                      fontSize: 14,
                      fontFamily: Fonts.fontMedium,

                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:trendiq/constants/fonts.dart';

class EmptyBagView extends StatelessWidget {
  const EmptyBagView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 64,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: commonTextStyle(
                fontSize: 20,
                fontFamily: Fonts.fontMedium,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: commonTextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            if (onPressed != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.shopping_bag_outlined, size: 20),
                label: Text(
                  "Continue Shopping",
                  style: commonTextStyle(
                    fontSize: 16,
                    fontFamily: Fonts.fontSemiBold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

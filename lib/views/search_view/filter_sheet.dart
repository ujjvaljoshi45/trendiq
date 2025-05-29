import 'package:flutter/material.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/extensions.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> initialFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheet({
    super.key,
    required this.initialFilters,
    required this.onFiltersApplied,
  });

  static void show({
    required BuildContext context,
    required Map<String, dynamic> initialFilters,
    required Function(Map<String, dynamic>) onFiltersApplied,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterBottomSheet(
        initialFilters: initialFilters,
        onFiltersApplied: onFiltersApplied,
      ),
    );
  }


  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, dynamic> activeFilters;

  @override
  void initState() {
    super.initState();
    // Create a deep copy of initial filters
    activeFilters = Map<String, dynamic>.from(widget.initialFilters);

    // Ensure list filters are properly copied
    if (activeFilters['brands'] != null) {
      activeFilters['brands'] = List<String>.from(activeFilters['brands']);
    }
    if (activeFilters['sizes'] != null) {
      activeFilters['sizes'] = List<String>.from(activeFilters['sizes']);
    }
    if (activeFilters['colors'] != null) {
      activeFilters['colors'] = List<String>.from(activeFilters['colors']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeader(),
            16.sBh,
            Expanded(
              child: ListView(
                controller: scrollController,
                children: [
                  _buildFilterSection(
                    'Price Range',
                    _buildPriceRangeFilter(),
                  ),
                  16.sBh,
                  _buildFilterSection(
                    'Brand',
                    _buildBrandFilter(),
                  ),
                  16.sBh,
                  _buildFilterSection(
                    'Size',
                    _buildSizeFilter(),
                  ),
                  16.sBh,
                  _buildFilterSection(
                    'Color',
                    _buildColorFilter(),
                  ),
                  24.sBh, // Extra space at bottom
                ],
              ),
            ),
            16.sBh,
            _buildApplyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Filter',
          style: commonTextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            TextButton(
              onPressed: _clearAllFilters,
              child: Text(
                'Clear All',
                style: commonTextStyle(
                  color: appColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: commonTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        12.sBh,
        content,
      ],
    );
  }

  Widget _buildPriceRangeFilter() {
    RangeValues currentRange = RangeValues(
      activeFilters['minPrice']?.toDouble() ?? 0,
      activeFilters['maxPrice']?.toDouble() ?? 10000,
    );

    return Column(
      children: [
        RangeSlider(
          values: currentRange,
          min: 0,
          max: 10000,
          divisions: 100,
          activeColor: appColors.primary,
          inactiveColor: appColors.primary.withOpacity(0.3),
          labels: RangeLabels(
            '₹${currentRange.start.round()}',
            '₹${currentRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              activeFilters['minPrice'] = values.start.round();
              activeFilters['maxPrice'] = values.end.round();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: appColors.tertiaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '₹${currentRange.start.round()}',
                style: commonTextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: appColors.tertiaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '₹${currentRange.end.round()}',
                style: commonTextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBrandFilter() {
    final brands = [
      'Nike', 'Adidas', 'Puma', 'Reebok', 'Under Armour',
      'Vans', 'Converse', 'New Balance', 'ASICS', 'Jordan'
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: brands.map((brand) {
        final isSelected = (activeFilters['brands'] as List?)?.contains(brand) ?? false;
        return FilterChip(
          label: Text(
            brand,
            style: commonTextStyle(
              fontSize: 12,
              color: isSelected ? appColors.white : appColors.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          selected: isSelected,
          selectedColor: appColors.primary,
          backgroundColor: appColors.tertiaryContainer,
          checkmarkColor: appColors.white,
          side: BorderSide(
            color: isSelected ? appColors.primary : appColors.tertiaryContainer,
          ),
          onSelected: (selected) {
            setState(() {
              if (activeFilters['brands'] == null) {
                activeFilters['brands'] = <String>[];
              }
              if (selected) {
                (activeFilters['brands'] as List).add(brand);
              } else {
                (activeFilters['brands'] as List).remove(brand);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildSizeFilter() {
    final sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: sizes.map((size) {
        final isSelected = (activeFilters['sizes'] as List?)?.contains(size) ?? false;
        return FilterChip(
          label: Text(
            size,
            style: commonTextStyle(
              fontSize: 12,
              color: isSelected ? appColors.white : appColors.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          selected: isSelected,
          selectedColor: appColors.primary,
          backgroundColor: appColors.tertiaryContainer,
          checkmarkColor: appColors.white,
          side: BorderSide(
            color: isSelected ? appColors.primary : appColors.tertiaryContainer,
          ),
          onSelected: (selected) {
            setState(() {
              if (activeFilters['sizes'] == null) {
                activeFilters['sizes'] = <String>[];
              }
              if (selected) {
                (activeFilters['sizes'] as List).add(size);
              } else {
                (activeFilters['sizes'] as List).remove(size);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildColorFilter() {
    final colors = [
      {'name': 'Red', 'color': Colors.red},
      {'name': 'Blue', 'color': Colors.blue},
      {'name': 'Green', 'color': Colors.green},
      {'name': 'Black', 'color': Colors.black},
      {'name': 'White', 'color': Colors.white},
      {'name': 'Yellow', 'color': Colors.yellow},
      {'name': 'Pink', 'color': Colors.pink},
      {'name': 'Purple', 'color': Colors.purple},
      {'name': 'Orange', 'color': Colors.orange},
      {'name': 'Brown', 'color': Colors.brown},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors.map((colorData) {
        final colorName = colorData['name'] as String;
        final color = colorData['color'] as Color;
        final isSelected = (activeFilters['colors'] as List?)?.contains(colorName) ?? false;

        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color == Colors.white ? Colors.grey.shade400 : Colors.transparent,
                    width: 1,
                  ),
                ),
              ),
              6.sBw,
              Text(
                colorName,
                style: commonTextStyle(
                  fontSize: 12,
                  color: isSelected ? appColors.white : appColors.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
          selected: isSelected,
          selectedColor: appColors.primary,
          backgroundColor: appColors.tertiaryContainer,
          checkmarkColor: appColors.white,
          side: BorderSide(
            color: isSelected ? appColors.primary : appColors.tertiaryContainer,
          ),
          onSelected: (selected) {
            setState(() {
              if (activeFilters['colors'] == null) {
                activeFilters['colors'] = <String>[];
              }
              if (selected) {
                (activeFilters['colors'] as List).add(colorName);
              } else {
                (activeFilters['colors'] as List).remove(colorName);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildApplyButton() {
    final hasActiveFilters = _hasActiveFilters();

    return Row(
      children: [
        if (hasActiveFilters)
          Expanded(
            flex: 1,
            child: OutlinedButton(
              onPressed: _clearAllFilters,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: appColors.primary),
              ),
              child: Text(
                'Clear',
                style: commonTextStyle(
                  color: appColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        if (hasActiveFilters) 12.sBw,
        Expanded(
          flex: hasActiveFilters ? 2 : 1,
          child: ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: appColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              hasActiveFilters
                  ? 'Apply Filters (${_getActiveFilterCount()})'
                  : 'Apply Filters',
              style: commonTextStyle(
                color: appColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _clearAllFilters() {
    setState(() {
      activeFilters.clear();
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(activeFilters);
    Navigator.pop(context);
  }

  bool _hasActiveFilters() {
    return activeFilters.isNotEmpty && _getActiveFilterCount() > 0;
  }

  int _getActiveFilterCount() {
    int count = 0;
    activeFilters.forEach((key, value) {
      if (value is List && value.isNotEmpty) count++;
      if (value is num && (key == 'minPrice' || key == 'maxPrice')) {
        if (key == 'minPrice' && value > 0) count++;
        if (key == 'maxPrice' && value < 10000) count++;
      }
    });
    return count;
  }
}
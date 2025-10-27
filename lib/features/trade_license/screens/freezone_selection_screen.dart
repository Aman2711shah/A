import 'package:flutter/material.dart';
import '../models/freezone_model.dart';

class FreezoneSelectionScreen extends StatefulWidget {
  final FreezoneType? initialType;
  final Function(FreezoneModel) onFreezoneSelected;

  const FreezoneSelectionScreen({
    super.key,
    this.initialType,
    required this.onFreezoneSelected,
  });

  @override
  State<FreezoneSelectionScreen> createState() =>
      _FreezoneSelectionScreenState();
}

class _FreezoneSelectionScreenState extends State<FreezoneSelectionScreen> {
  late List<FreezoneModel> _allFreezones;
  late List<FreezoneModel> _filteredFreezones;
  String _searchQuery = '';
  FreezoneType? _selectedType;
  String? _selectedEmirate;
  FreezoneModel? _selectedFreezone;

  @override
  void initState() {
    super.initState();
    _allFreezones = FreezoneModel.getAllFreezones();
    _selectedType = widget.initialType;
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredFreezones = _allFreezones.where((fz) {
        // Type filter
        if (_selectedType != null && fz.type != _selectedType) {
          return false;
        }

        // Emirate filter
        if (_selectedEmirate != null && fz.emirate != _selectedEmirate) {
          return false;
        }

        // Search query
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          return fz.name.toLowerCase().contains(query) ||
              fz.emirate.toLowerCase().contains(query) ||
              fz.description.toLowerCase().contains(query);
        }

        return true;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _onTypeFilterChanged(FreezoneType? type) {
    setState(() {
      _selectedType = type;
      _selectedEmirate = null; // Reset emirate when type changes
    });
    _applyFilters();
  }

  void _onEmirateFilterChanged(String? emirate) {
    setState(() {
      _selectedEmirate = emirate;
    });
    _applyFilters();
  }

  void _selectFreezone(FreezoneModel freezone) {
    setState(() {
      _selectedFreezone = freezone;
    });
  }

  void _confirmSelection() {
    if (_selectedFreezone != null) {
      widget.onFreezoneSelected(_selectedFreezone!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Select Freezone or Mainland'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search freezones...',
                prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Type Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _selectedType == null,
                    onSelected: (_) => _onTypeFilterChanged(null),
                    selectedColor: colorScheme.primaryContainer,
                    checkmarkColor: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Free Zones'),
                    selected: _selectedType == FreezoneType.freeZone,
                    onSelected: (_) =>
                        _onTypeFilterChanged(FreezoneType.freeZone),
                    selectedColor: colorScheme.primaryContainer,
                    checkmarkColor: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Mainland (DED)'),
                    selected: _selectedType == FreezoneType.mainland,
                    onSelected: (_) =>
                        _onTypeFilterChanged(FreezoneType.mainland),
                    selectedColor: colorScheme.primaryContainer,
                    checkmarkColor: colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),

          // Emirate Filter
          if (_selectedType != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All Emirates'),
                      selected: _selectedEmirate == null,
                      onSelected: (_) => _onEmirateFilterChanged(null),
                      selectedColor: colorScheme.secondaryContainer,
                    ),
                    const SizedBox(width: 8),
                    ...FreezoneModel.getAllEmirates().map((emirate) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(emirate),
                          selected: _selectedEmirate == emirate,
                          onSelected: (_) => _onEmirateFilterChanged(emirate),
                          selectedColor: colorScheme.secondaryContainer,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

          // Results Count
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  '${_filteredFreezones.length} options found',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Freezone List
          Expanded(
            child: _filteredFreezones.isEmpty
                ? _buildEmptyState(colorScheme)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredFreezones.length,
                    itemBuilder: (context, index) {
                      final freezone = _filteredFreezones[index];
                      final isSelected = _selectedFreezone?.id == freezone.id;

                      return _buildFreezoneCard(
                        freezone,
                        isSelected,
                        colorScheme,
                        theme,
                      );
                    },
                  ),
          ),

          // Confirm Button
          if (_selectedFreezone != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _confirmSelection,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Continue with ${_selectedFreezone!.name}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFreezoneCard(
    FreezoneModel freezone,
    bool isSelected,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => _selectFreezone(freezone),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: freezone.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      freezone.icon,
                      color: freezone.color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title and Emirate
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          freezone.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                freezone.emirate,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: freezone.type == FreezoneType.freeZone
                                    ? colorScheme.secondaryContainer
                                    : colorScheme.tertiaryContainer,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                freezone.type == FreezoneType.freeZone
                                    ? 'Free Zone'
                                    : 'Mainland',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: freezone.type == FreezoneType.freeZone
                                      ? colorScheme.onSecondaryContainer
                                      : colorScheme.onTertiaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Selection Indicator
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                freezone.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 12),

              // Key Features
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: freezone.features.take(3).map((feature) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          feature,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No freezones found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

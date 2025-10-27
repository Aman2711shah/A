import 'package:equatable/equatable.dart';

/// Model for advanced application filtering
class ApplicationFilter extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? statuses;
  final List<String>? applicationTypes;
  final List<String>? freezones;
  final double? minPrice;
  final double? maxPrice;
  final String sortBy;
  final bool descending;
  final String? searchQuery;

  const ApplicationFilter({
    this.startDate,
    this.endDate,
    this.statuses,
    this.applicationTypes,
    this.freezones,
    this.minPrice,
    this.maxPrice,
    this.sortBy = 'submittedAt',
    this.descending = true,
    this.searchQuery,
  });

  /// Create empty filter
  factory ApplicationFilter.empty() {
    return const ApplicationFilter();
  }

  /// Check if filter is active (has any criteria)
  bool get isActive {
    return startDate != null ||
        endDate != null ||
        (statuses != null && statuses!.isNotEmpty) ||
        (applicationTypes != null && applicationTypes!.isNotEmpty) ||
        (freezones != null && freezones!.isNotEmpty) ||
        minPrice != null ||
        maxPrice != null ||
        (searchQuery != null && searchQuery!.isNotEmpty);
  }

  /// Count active filter criteria
  int get activeFilterCount {
    int count = 0;
    if (startDate != null || endDate != null) count++;
    if (statuses != null && statuses!.isNotEmpty) count++;
    if (applicationTypes != null && applicationTypes!.isNotEmpty) count++;
    if (freezones != null && freezones!.isNotEmpty) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (searchQuery != null && searchQuery!.isNotEmpty) count++;
    return count;
  }

  /// Copy with new values
  ApplicationFilter copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? statuses,
    List<String>? applicationTypes,
    List<String>? freezones,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    bool? descending,
    String? searchQuery,
    bool clearStartDate = false,
    bool clearEndDate = false,
    bool clearStatuses = false,
    bool clearApplicationTypes = false,
    bool clearFreezones = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearSearchQuery = false,
  }) {
    return ApplicationFilter(
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      statuses: clearStatuses ? null : (statuses ?? this.statuses),
      applicationTypes: clearApplicationTypes
          ? null
          : (applicationTypes ?? this.applicationTypes),
      freezones: clearFreezones ? null : (freezones ?? this.freezones),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      sortBy: sortBy ?? this.sortBy,
      descending: descending ?? this.descending,
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
    );
  }

  /// Clear all filters
  ApplicationFilter clearAll() {
    return ApplicationFilter.empty();
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'statuses': statuses,
      'applicationTypes': applicationTypes,
      'freezones': freezones,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'sortBy': sortBy,
      'descending': descending,
      'searchQuery': searchQuery,
    };
  }

  /// Create from JSON
  factory ApplicationFilter.fromJson(Map<String, dynamic> json) {
    return ApplicationFilter(
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      statuses:
          json['statuses'] != null ? List<String>.from(json['statuses']) : null,
      applicationTypes: json['applicationTypes'] != null
          ? List<String>.from(json['applicationTypes'])
          : null,
      freezones: json['freezones'] != null
          ? List<String>.from(json['freezones'])
          : null,
      minPrice: json['minPrice']?.toDouble(),
      maxPrice: json['maxPrice']?.toDouble(),
      sortBy: json['sortBy'] ?? 'submittedAt',
      descending: json['descending'] ?? true,
      searchQuery: json['searchQuery'],
    );
  }

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        statuses,
        applicationTypes,
        freezones,
        minPrice,
        maxPrice,
        sortBy,
        descending,
        searchQuery,
      ];

  @override
  String toString() {
    final criteria = <String>[];
    if (startDate != null) criteria.add('startDate: $startDate');
    if (endDate != null) criteria.add('endDate: $endDate');
    if (statuses != null && statuses!.isNotEmpty) {
      criteria.add('statuses: ${statuses!.join(", ")}');
    }
    if (applicationTypes != null && applicationTypes!.isNotEmpty) {
      criteria.add('types: ${applicationTypes!.join(", ")}');
    }
    if (freezones != null && freezones!.isNotEmpty) {
      criteria.add('freezones: ${freezones!.join(", ")}');
    }
    if (minPrice != null) criteria.add('minPrice: $minPrice');
    if (maxPrice != null) criteria.add('maxPrice: $maxPrice');
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      criteria.add('search: $searchQuery');
    }
    criteria.add('sortBy: $sortBy ${descending ? "DESC" : "ASC"}');
    return 'ApplicationFilter(${criteria.join(", ")})';
  }
}

/// Model for saved filter presets
class FilterPreset extends Equatable {
  final String id;
  final String name;
  final ApplicationFilter filter;
  final DateTime createdAt;
  final bool isPinned;

  const FilterPreset({
    required this.id,
    required this.name,
    required this.filter,
    required this.createdAt,
    this.isPinned = false,
  });

  /// Copy with new values
  FilterPreset copyWith({
    String? id,
    String? name,
    ApplicationFilter? filter,
    DateTime? createdAt,
    bool? isPinned,
  }) {
    return FilterPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      filter: filter ?? this.filter,
      createdAt: createdAt ?? this.createdAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'filter': filter.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'isPinned': isPinned,
    };
  }

  /// Create from JSON
  factory FilterPreset.fromJson(Map<String, dynamic> json) {
    return FilterPreset(
      id: json['id'],
      name: json['name'],
      filter: ApplicationFilter.fromJson(json['filter']),
      createdAt: DateTime.parse(json['createdAt']),
      isPinned: json['isPinned'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, name, filter, createdAt, isPinned];
}

/// Predefined common filters
class CommonFilters {
  static ApplicationFilter get thisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return ApplicationFilter(
      startDate: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
      endDate: now,
      sortBy: 'submittedAt',
      descending: true,
    );
  }

  static ApplicationFilter get thisMonth {
    final now = DateTime.now();
    return ApplicationFilter(
      startDate: DateTime(now.year, now.month, 1),
      endDate: now,
      sortBy: 'submittedAt',
      descending: true,
    );
  }

  static ApplicationFilter get lastMonth {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1, 1);
    final lastDay = DateTime(now.year, now.month, 0);
    return ApplicationFilter(
      startDate: lastMonth,
      endDate: lastDay,
      sortBy: 'submittedAt',
      descending: true,
    );
  }

  static ApplicationFilter get pending {
    return const ApplicationFilter(
      statuses: ['Submitted', 'In Review'],
      sortBy: 'submittedAt',
      descending: false, // Oldest first for pending
    );
  }

  static ApplicationFilter get approved {
    return const ApplicationFilter(
      statuses: ['Approved'],
      sortBy: 'submittedAt',
      descending: true,
    );
  }

  static ApplicationFilter get rejected {
    return const ApplicationFilter(
      statuses: ['Rejected'],
      sortBy: 'submittedAt',
      descending: true,
    );
  }

  static ApplicationFilter get tradeLicenses {
    return const ApplicationFilter(
      applicationTypes: ['Trade License'],
      sortBy: 'submittedAt',
      descending: true,
    );
  }

  static ApplicationFilter get visas {
    return const ApplicationFilter(
      applicationTypes: ['Visa'],
      sortBy: 'submittedAt',
      descending: true,
    );
  }

  static ApplicationFilter get companySetups {
    return const ApplicationFilter(
      applicationTypes: ['Company Setup'],
      sortBy: 'submittedAt',
      descending: true,
    );
  }

  static ApplicationFilter get highValue {
    return const ApplicationFilter(
      minPrice: 50000,
      sortBy: 'priceAED',
      descending: true,
    );
  }

  /// Get all common filters as presets
  static List<FilterPreset> get allPresets {
    final now = DateTime.now();
    return [
      FilterPreset(
        id: 'this_week',
        name: 'This Week',
        filter: thisWeek,
        createdAt: now,
        isPinned: true,
      ),
      FilterPreset(
        id: 'this_month',
        name: 'This Month',
        filter: thisMonth,
        createdAt: now,
        isPinned: true,
      ),
      FilterPreset(
        id: 'last_month',
        name: 'Last Month',
        filter: lastMonth,
        createdAt: now,
      ),
      FilterPreset(
        id: 'pending',
        name: 'Pending',
        filter: pending,
        createdAt: now,
        isPinned: true,
      ),
      FilterPreset(
        id: 'approved',
        name: 'Approved',
        filter: approved,
        createdAt: now,
      ),
      FilterPreset(
        id: 'rejected',
        name: 'Rejected',
        filter: rejected,
        createdAt: now,
      ),
      FilterPreset(
        id: 'trade_licenses',
        name: 'Trade Licenses',
        filter: tradeLicenses,
        createdAt: now,
      ),
      FilterPreset(
        id: 'visas',
        name: 'Visas',
        filter: visas,
        createdAt: now,
      ),
      FilterPreset(
        id: 'company_setups',
        name: 'Company Setups',
        filter: companySetups,
        createdAt: now,
      ),
      FilterPreset(
        id: 'high_value',
        name: 'High Value (>50K)',
        filter: highValue,
        createdAt: now,
      ),
    ];
  }
}

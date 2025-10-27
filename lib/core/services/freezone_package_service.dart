import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../features/trade_license/models/freezone_package_model.dart';

class FreezonePackageService {
  static FreezonePackageService? _instance;
  static FreezonePackageService get instance {
    _instance ??= FreezonePackageService._();
    return _instance!;
  }

  FreezonePackageService._();

  List<FreezonePackageModel> _allPackages = [];

  Future<List<FreezonePackageModel>> loadPackages() async {
    if (_allPackages.isNotEmpty) {
      return _allPackages;
    }

    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/freezone_packages.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      _allPackages =
          jsonList.map((json) => FreezonePackageModel.fromJson(json)).toList();

      debugPrint('Loaded \${_allPackages.length} freezone packages');
      return _allPackages;
    } catch (e) {
      debugPrint('Error loading freezone packages: \$e');
      return [];
    }
  }

  Future<List<FreezonePackageModel>> getPackagesByFreezone(
      String freezoneName) async {
    final allPackages = await loadPackages();
    return allPackages
        .where((package) =>
            package.freezoneName.toLowerCase() == freezoneName.toLowerCase())
        .toList();
  }

  Future<List<String>> getFreezoneNames() async {
    final allPackages = await loadPackages();
    final names =
        allPackages.map((package) => package.freezoneName).toSet().toList();
    names.sort();
    return names;
  }

  Future<Map<String, List<FreezonePackageModel>>>
      getPackagesGroupedByFreezone() async {
    final allPackages = await loadPackages();
    final Map<String, List<FreezonePackageModel>> grouped = {};

    for (var package in allPackages) {
      if (!grouped.containsKey(package.freezoneName)) {
        grouped[package.freezoneName] = [];
      }
      grouped[package.freezoneName]!.add(package);
    }

    return grouped;
  }

  Future<List<FreezonePackageModel>> getPackagesByTenure(
      String freezoneName, int tenure) async {
    final packages = await getPackagesByFreezone(freezoneName);
    return packages.where((p) => p.tenureYears == tenure).toList();
  }

  Future<FreezonePackageModel?> getCheapestPackage(String freezoneName) async {
    final packages = await getPackagesByFreezone(freezoneName);
    if (packages.isEmpty) return null;

    packages.sort((a, b) => a.priceAED.compareTo(b.priceAED));
    return packages.first;
  }

  Future<FreezonePackageModel?> getPackageWithMostVisas(
      String freezoneName) async {
    final packages = await getPackagesByFreezone(freezoneName);
    if (packages.isEmpty) return null;

    packages.sort((a, b) => b.visasIncluded.compareTo(a.visasIncluded));
    return packages.first;
  }

  Future<List<FreezonePackageModel>> searchPackages({
    String? freezoneName,
    int? minVisas,
    int? maxPrice,
    int? tenure,
  }) async {
    final allPackages = await loadPackages();

    return allPackages.where((package) {
      if (freezoneName != null &&
          !package.freezoneName
              .toLowerCase()
              .contains(freezoneName.toLowerCase())) {
        return false;
      }
      if (minVisas != null && package.visasIncluded < minVisas) {
        return false;
      }
      if (maxPrice != null && package.priceAED > maxPrice) {
        return false;
      }
      if (tenure != null && package.tenureYears != tenure) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<Map<String, double>> getPriceRange(String freezoneName) async {
    final packages = await getPackagesByFreezone(freezoneName);
    if (packages.isEmpty) {
      return {'min': 0, 'max': 0};
    }

    final prices = packages.map((p) => p.priceAED).toList();
    prices.sort();

    return {
      'min': prices.first,
      'max': prices.last,
    };
  }

  void clearCache() {
    _allPackages = [];
  }

  Future<List<String>> getPackageNamesByFreezone(String freezoneName) async {
    final packages = await getPackagesByFreezone(freezoneName);
    final names = packages.map((p) => p.packageName).toSet().toList();
    return names;
  }

  Future<List<int>> getTenureOptions(String freezoneName) async {
    final packages = await getPackagesByFreezone(freezoneName);
    final tenures = packages.map((p) => p.tenureYears).toSet().toList();
    tenures.sort();
    return tenures;
  }
}

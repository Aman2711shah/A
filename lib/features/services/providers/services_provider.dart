import 'package:flutter/material.dart';

import '../models/service_catalog.dart';
import '../repositories/service_catalog_repository.dart';

class ServicesProvider extends ChangeNotifier {
  ServicesProvider({
    ServiceCatalogRepository? repository,
  }) : _repository = repository ?? ServiceCatalogRepository() {
    _loadCatalog();
  }

  final ServiceCatalogRepository _repository;

  List<ServiceCategory> _categories = [];
  bool _loading = false;
  String? _error;

  int _step = 0;
  ServiceCategory? _selectedCategory;
  ServiceType? _selectedType;
  SubService? _selectedSubService;

  List<ServiceCategory> get categories => _categories;
  bool get isLoading => _loading;
  String? get error => _error;

  int get step => _step;
  ServiceCategory? get selectedCategory => _selectedCategory;
  ServiceType? get selectedType => _selectedType;
  SubService? get selectedSubService => _selectedSubService;

  bool get canProceed {
    switch (_step) {
      case 0:
        return _selectedCategory != null;
      case 1:
        return _selectedType != null;
      case 2:
        return _selectedSubService != null;
      default:
        return false;
    }
  }

  Future<void> refresh() async {
    await _loadCatalog(force: true);
  }

  void nextStep() {
    if (_step < 3) {
      _step += 1;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_step > 0) {
      _step -= 1;
      notifyListeners();
    }
  }

  void selectCategory(ServiceCategory category) {
    _selectedCategory = category;
    _selectedType = null;
    _selectedSubService = null;
    _step = 1;
    notifyListeners();
  }

  void selectType(ServiceType type) {
    _selectedType = type;
    _selectedSubService = null;
    _step = 2;
    notifyListeners();
  }

  void selectSubService(SubService subService) {
    _selectedSubService = subService;
    _step = 3;
    notifyListeners();
  }

  void resetSelections() {
    _step = 0;
    _selectedCategory = null;
    _selectedType = null;
    _selectedSubService = null;
    notifyListeners();
  }

  Future<void> _loadCatalog({bool force = false}) async {
    if (_categories.isNotEmpty && !force) return;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _categories = await _repository.fetchCatalog();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

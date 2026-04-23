import 'package:flutter/material.dart';
import '../models/group.dart';
import '../models/ad.dart';
import '../services/data_service.dart';

class DataProvider extends ChangeNotifier {
  final DataService _dataService = DataService();

  List<Group> _cityGroups = [];
  List<Group> _originCityGroups = [];
  List<Group> _universityGroups = [];
  List<Ad> _ads = [];

  bool _isLoading = false;

  List<Group> get cityGroups => _cityGroups;
  List<Group> get originCityGroups => _originCityGroups;
  List<Group> get universityGroups => _universityGroups;
  List<Ad> get ads => _ads;
  bool get isLoading => _isLoading;

  /// Loads all required application data using the DataService.
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _dataService.getCityGroups(),
        _dataService.getOriginCityGroups(),
        _dataService.getUniversityGroups(),
        _dataService.getAds(),
      ]);

      _cityGroups = results[0] as List<Group>;
      _originCityGroups = results[1] as List<Group>;
      _universityGroups = results[2] as List<Group>;
      _ads = results[3] as List<Ad>;
    } catch (e) {
      debugPrint("Error loading data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

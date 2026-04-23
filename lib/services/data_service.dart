import '../models/mock_data.dart';
import '../models/group.dart';
import '../models/ad.dart';

class DataService {
  /// Fetches city-based groups.
  Future<List<Group>> getCityGroups() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate backend request
    return MockData.cityGroups;
  }

  /// Fetches origin city groups.
  Future<List<Group>> getOriginCityGroups() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate backend request
    return MockData.originCityGroups;
  }

  /// Fetches university groups.
  Future<List<Group>> getUniversityGroups() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate backend request
    return MockData.universityGroups;
  }

  /// Fetches available ads.
  Future<List<Ad>> getAds() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network request
    return MockData.ads;
  }
}

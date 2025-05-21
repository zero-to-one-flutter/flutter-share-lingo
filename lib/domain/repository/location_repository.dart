abstract class LocationRepository {
  Future<String?> getDistrictByLocation(double latitude, double longitude);
}

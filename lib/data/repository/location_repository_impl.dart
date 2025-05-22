import '../../domain/repository/location_repository.dart';
import '../data_source/location_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource _locationDataSource;

  LocationRepositoryImpl(this._locationDataSource);

  @override
  Future<String?> getDistrictByLocation(double latitude, double longitude) {
    return _locationDataSource.getDistrictByCoordinates(latitude, longitude);
  }
}

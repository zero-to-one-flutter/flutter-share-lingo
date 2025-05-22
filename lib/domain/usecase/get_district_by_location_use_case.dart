import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/data_providers.dart';
import '../repository/location_repository.dart';

class GetDistrictByLocationUseCase {
  final LocationRepository _locationRepository;

  GetDistrictByLocationUseCase(this._locationRepository);

  Future<String?> execute(double latitude, double longitude) {
    return _locationRepository.getDistrictByLocation(latitude, longitude);
  }
}

final getDistrictByLocationUseCaseProvider = Provider<
  GetDistrictByLocationUseCase
>((ref) => GetDistrictByLocationUseCase(ref.read(locationRepositoryProvider)));

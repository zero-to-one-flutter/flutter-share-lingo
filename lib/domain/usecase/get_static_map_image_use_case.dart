import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_source/maps_data_source.dart';

class GetStaticMapUrlUseCase {
  String execute(GeoPoint? location) {
    return MapUrlUtil.getStaticMapUrl(location);
  }
}

final getStaticMapUrlUseCaseProvider = Provider<GetStaticMapUrlUseCase>(
      (ref) => GetStaticMapUrlUseCase(),
);
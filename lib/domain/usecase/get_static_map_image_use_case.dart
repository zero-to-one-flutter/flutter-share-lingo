import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/map_url_util.dart';

class GetStaticMapUrlUseCase {
  String execute(GeoPoint? location) {
    return MapUrlUtil.getStaticMapUrl(location);
  }
}

final getStaticMapUrlUseCaseProvider = Provider<GetStaticMapUrlUseCase>(
      (ref) => GetStaticMapUrlUseCase(),
);
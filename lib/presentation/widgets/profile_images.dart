import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecase/get_static_map_image_use_case.dart';
import 'app_cached_image.dart';

class ProfileImages extends ConsumerWidget {
  final String? profileImageUrl;
  final GeoPoint? geoPoint;
  final bool isEditable;
  final VoidCallback? onImageTap;
  final bool isLoading;

  const ProfileImages({
    super.key,
    required this.profileImageUrl,
    this.geoPoint,
    this.isEditable = false,
    this.onImageTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapUrl = ref.watch(getStaticMapUrlUseCaseProvider).execute(geoPoint);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: 170,
          width: double.infinity,
          child: AppCachedImage(
            imageUrl: mapUrl,
            fit: BoxFit.cover,
            errorAssetPath: 'assets/images/world_background.jpg',
          ),
        ),
        Positioned(
          bottom: -50,
          left: MediaQuery.of(context).size.width / 2 - 50,
          child: Stack(
            children: [
              ClipOval(
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child:
                      isLoading
                          ? const CupertinoActivityIndicator()
                          : ClipOval(
                            child: InkWell(
                              onTap:
                                  isEditable && !isLoading ? onImageTap : null,
                              child:
                                  profileImageUrl != null
                                      ? AppCachedImage(
                                        imageUrl: profileImageUrl!,
                                        width: 92,
                                        height: 92,
                                        fit: BoxFit.cover,
                                      )
                                      : Container(
                                        width: 92,
                                        height: 92,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          size: 50,
                                        ),
                                      ),
                            ),
                          ),
                ),
              ),
              if (isEditable)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

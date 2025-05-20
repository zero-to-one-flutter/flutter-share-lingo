import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/presentation/pages/onboarding/onboarding_view_model.dart';

class StepProgressHeader extends ConsumerWidget {
  const StepProgressHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.read(onboardingViewModelProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          currentPage == 0
              ? SizedBox(height: 48)
              : SizedBox(
                height: 48,
                width: 30,
                child: IconButton(
                  padding: EdgeInsets.all(0.0),
                  icon: const Icon(Icons.arrow_back_ios, size: 22),
                  onPressed:
                      ref
                          .read(onboardingViewModelProvider.notifier)
                          .previousPage,
                ),
              ),
          SizedBox(width: 5),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor:
                      (currentPage + 1) / OnboardingViewModel.totalPages,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

class VoteState {
  final Map<String, int> pollVotes; // index → count
  final int? selectedIndex;

  VoteState({required this.pollVotes, this.selectedIndex});

  VoteState copyWith({Map<String, int>? pollVotes, int? selectedIndex}) {
    return VoteState(
      pollVotes: pollVotes ?? this.pollVotes,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class VoteStateNotifier extends StateNotifier<Map<String, VoteState>> {
  VoteStateNotifier() : super({});

  void set(String postId, VoteState stateForPost) {
    state = {...state, postId: stateForPost};
  }

  VoteState? get(String postId) => state[postId];
  void reset(String postId) {
    state = {...state, postId: VoteState(pollVotes: {}, selectedIndex: null)};
  }
}

final voteStateProvider =
    StateNotifierProvider<VoteStateNotifier, Map<String, VoteState>>(
      (ref) => VoteStateNotifier(),
    );

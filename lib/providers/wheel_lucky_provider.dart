// State Notifier for managing wheel state and animation logic
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WheelNotifier extends StateNotifier<int> {
  WheelNotifier() : super(0);

  // Method to spin the wheel to a random index
  void spinWheel(int itemCount, FixedExtentScrollController controller) {
    final randomIndex = Random().nextInt(itemCount);
    controller.animateToItem(
      randomIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    state = randomIndex; // Update the state with the selected index
  }
}

// Providers for each wheel
final wheel1Provider =
    StateNotifierProvider<WheelNotifier, int>((ref) => WheelNotifier());
final wheel2Provider =
    StateNotifierProvider<WheelNotifier, int>((ref) => WheelNotifier());
final wheel3Provider =
    StateNotifierProvider<WheelNotifier, int>((ref) => WheelNotifier());

// Provider for managing the list of values
final valuesListProvider =
    Provider<List<String>>((ref) => ['🍎', '🍌', '🍇', '🍒', '🍍']);

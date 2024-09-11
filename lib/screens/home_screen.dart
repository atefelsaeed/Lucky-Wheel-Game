import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucky_draw/providers/wheel_lucky_provider.dart';

class LuckyDrawGame extends ConsumerWidget {
  const LuckyDrawGame({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valuesList = ref.watch(valuesListProvider);
    final wheel1Index = ref.watch(wheel1Provider);
    final wheel2Index = ref.watch(wheel2Provider);
    final wheel3Index = ref.watch(wheel3Provider);

    // Controllers for scrolling the wheels
    final controller1 = FixedExtentScrollController(initialItem: wheel1Index);
    final controller2 = FixedExtentScrollController(initialItem: wheel2Index);
    final controller3 = FixedExtentScrollController(initialItem: wheel3Index);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lucky Draw Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Spin the Wheel!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            // Display the three scrollable wheels
            Container(
              // padding: EdgeInsets.all(10),
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.black),
              //   borderRadius: BorderRadius.circular(20)
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildWheel(ref, wheel1Provider, controller1, valuesList),
                  const SizedBox(width: 20),
                  _buildWheel(ref, wheel2Provider, controller2, valuesList),
                  const SizedBox(width: 20),
                  _buildWheel(ref, wheel3Provider, controller3, valuesList),
                ],
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => _drawLuckyDraw(
                  ref, valuesList, controller1, controller2, controller3),
              child: const Text('Draw Now'),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build each wheel
  Widget _buildWheel(
      WidgetRef ref,
      StateNotifierProvider<WheelNotifier, int> provider,
      FixedExtentScrollController controller,
      List<String> valuesList,
      ) {
    return SizedBox(
      width: 70,
      height: 180,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 70,
        physics: const FixedExtentScrollPhysics(),
        overAndUnderCenterOpacity: 0.2,
        perspective: 0.005,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Center(
                child: Text(
                  valuesList[index],
                  style: const TextStyle(fontSize: 36),
                ),
              ),
            );
          },
          childCount: valuesList.length,
        ),
      ),
    );
  }

  void _drawLuckyDraw(
      WidgetRef ref,
      List<String> valuesList,
      FixedExtentScrollController controller1,
      FixedExtentScrollController controller2,
      FixedExtentScrollController controller3,
      ) {
    // Spin each wheel
    ref.read(wheel1Provider.notifier).spinWheel(valuesList.length, controller1);
    ref.read(wheel2Provider.notifier).spinWheel(valuesList.length, controller2);
    ref.read(wheel3Provider.notifier).spinWheel(valuesList.length, controller3);

    // Check result after a delay
    Future.delayed(const Duration(seconds: 1), () {
      final selectedValue1 = valuesList[ref.read(wheel1Provider)];
      final selectedValue2 = valuesList[ref.read(wheel2Provider)];
      final selectedValue3 = valuesList[ref.read(wheel3Provider)];

      if (selectedValue1 == selectedValue2 &&
          selectedValue2 == selectedValue3) {
        _showResultDialog(ref.context, 'Congratulations! You Win! 🎉');
      } else {
        _showResultDialog(ref.context, 'Try Again! 😞');
      }
    });
  }

  void _showResultDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Result'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
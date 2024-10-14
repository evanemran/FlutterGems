import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value); // Toggle the switch when tapped
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Smooth transition between states
        width: 60.0,
        height: 35.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: value ? Colors.blueGrey[800] : Colors.orange[300], // Background color
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Sun/Moon Images
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              left: value ? 30.0 : 0.0,
              right: value ? 0.0 : 30.0,
              child: Center( // Center the icon within the thumb
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: value
                      ? Container(
                    key: UniqueKey(),
                    width: 24, // Circular container size
                    height: 24,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueGrey, // Background color for moon
                    ),
                    child: const Icon(Icons.nightlight_round, color: Colors.white, size: 18), // Moon icon
                  )
                      : Container(
                    key: UniqueKey(),
                    width: 24, // Circular container size
                    height: 24,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange, // Background color for sun
                    ),
                    child: const Icon(Icons.wb_sunny, color: Colors.white, size: 18), // Sun icon
                  ), // Sun icon
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
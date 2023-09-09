import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CircularNumberProgressIndicator extends StatefulWidget {
  final int time;

  CircularNumberProgressIndicator({super.key, required this.time});
  @override
  // ignore: library_private_types_in_public_api
  _CircularNumberProgressIndicatorState createState() =>
      _CircularNumberProgressIndicatorState();
}

class _CircularNumberProgressIndicatorState
    extends State<CircularNumberProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.time), // Adjust the animation duration
    )..repeat(); // Continuous rotation

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Uncomment this line to reverse the animation for a different effect
    // _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = (_animation.value * 100).toInt();
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    strokeAlign: BorderSide.strokeAlignCenter,
                    strokeWidth: 8.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    backgroundColor: Colors.black,
                    value: _animation.value,
                  ),
                ),
                Text(
                  '$progress',
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

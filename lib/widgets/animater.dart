import 'package:flutter/material.dart';

class CircularNumberProgressIndicator extends StatefulWidget {
  final int time;

  CircularNumberProgressIndicator({Key? key, required this.time})
      : super(key: key);

  @override
  _CircularNumberProgressIndicatorState createState() =>
      _CircularNumberProgressIndicatorState();
}

class _CircularNumberProgressIndicatorState
    extends State<CircularNumberProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.time),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Start the animation when the widget is built
    _controller.forward();
    isAnimating = true;

    // Add a listener to restart the animation when it completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isAnimating) {
          _controller.stop();
        } else {
          _controller.repeat();
        }
        setState(() {
          isAnimating = !isAnimating;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: _animation,
            child: Container(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(
                strokeWidth: 8.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Colors.grey.withOpacity(0.5),
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

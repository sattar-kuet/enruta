import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

/*class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity").add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
      Track("translateY").add(Duration(milliseconds: 500), Tween(begin: -30.0, end: 0.0), curve: Curves.easeOut)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, dynamic animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(offset: Offset(0, animation["translateY"]), child: child),
      ),
    );
  }
}*/

class FadeAnimation extends StatelessWidget {
  const FadeAnimation(this.delay, this.child, {Key? key}) : super(key: key);

  final double delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final duration = Duration(milliseconds: (delay * 500).round());
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      builder: (_, tween, __) {
        return AnimatedOpacity(
          opacity: tween,
          duration: duration,
          child: child,
        );
      },
    );
  }
}

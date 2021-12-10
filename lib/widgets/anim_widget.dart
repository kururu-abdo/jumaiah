import 'package:flutter/material.dart';

class FadeAnimation extends StatefulWidget {
  final Widget child;

  const FadeAnimation({Key key, this.child}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _Fade();
}

class _Fade extends State<FadeAnimation> with TickerProviderStateMixin {
  AnimationController animation;
  Animation<double> _fadeInFadeOut;
  Animation<Offset> imageTranslation;
  Animation<double> controller;

  @override
  void initState() {
    super.initState();
    // animation = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 3),
    // );
    // _fadeInFadeOut = Tween<double>(begin: 0.0, end: 0.5).animate(animation);

    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     animation.reverse();
    //   } else if (status == AnimationStatus.dismissed) {
    //     animation.forward();
    //   }
    // });

    if (controller == null) {
      controller = ModalRoute.of(context).animation;
    }

    // animation.forward();

    imageTranslation = Tween(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.67, curve: Curves.fastOutSlowIn),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: imageTranslation.value,
      child: widget.child,
    );
    FadeTransition(
      opacity: _fadeInFadeOut,
      child: widget.child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jumaiah/utils/constants.dart';
import 'package:jumaiah/utils/exceptions.dart';
import 'package:lottie/lottie.dart';

class CustomErrorWidget extends StatefulWidget {
  final AppException error;
  final VoidCallback onPressBtn;

  CustomErrorWidget({Key key, this.error, this.onPressBtn}) : super(key: key);

  @override
  _ErrorWidgetState createState() => _ErrorWidgetState();
}

class _ErrorWidgetState extends State<CustomErrorWidget>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.repeat();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Lottie.asset(
          getLottieFile(widget.error),
          controller: _controller,
          width: 150,
          height: 150,
          onLoaded: (composition) {
            // Configure the AnimationController with the duration of the
            // Lottie file and start the animation.
            _controller.duration = composition.duration;
            _controller.forward();
          },
        ),
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            widget.onPressBtn();
          },
          child: Container(
            width: 180,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Center(
              child: Text("حاول مجددا",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        )
      ],
    ));
  }

  String getLottieFile(AppException exception) {
    if (exception is OdooServerException) {
      return SERVER;
    } else if (exception is MyTimeOutException) {
      return TIMEOUT;
    } else if (exception is ConnectionException) {
      return NOINTERNERT;
    } else {
      return UNKNOWN;
    }
  }
}

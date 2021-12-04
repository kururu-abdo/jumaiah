import 'package:flutter/material.dart';
import 'package:jumaiah/utils/theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key key}) : super(key: key);



//DualRing
//ThreeInOut
  @override
  Widget build(BuildContext context) {
  
    return Center(

      child: SpinKitFadingCube(color:AppTheme.primaryColor),
    );
  }
}
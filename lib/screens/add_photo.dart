import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jumaiah/controllers/add_photo_controller.dart';
import 'package:jumaiah/enums/widget_state.dart';
import 'package:jumaiah/utils/theme.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class AddPhoto extends StatefulWidget {
  final int propertyId;
  AddPhoto(this.propertyId, {Key key}) : super(key: key);

  @override
  _AddPhotoState createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  @override
  Widget build(BuildContext context) {
    //var controller = Provider.of<AddPhotoController>(context);

    return ViewModelBuilder<AddPhotoController>.reactive(
      viewModelBuilder: () => AddPhotoController(),
      builder: (context, controller, child) => Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
              child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: new Center(
                  child: new Text(
                'إضافة صور',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              )),

              backgroundColor: Colors.transparent, // status bar color
              elevation: 0.0,
              actions: [
                IconButton(
                    onPressed: () async {
                      await controller.picImage(widget.propertyId);
                    },
                    icon: Icon(Icons.add_a_photo, color: Colors.black))
              ],
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back, color: Colors.black),
              ),
              // status bar brightness
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.filesToShow.length,
                      itemBuilder: (BuildContext context, int index) {
                        return
                            //Container();
                            Stack(
                          children: [
                            Container(
                              child: Center(
                                child: Image.file(
                                  File(controller.filesToShow[index].path),
                                  height: 150,
                                  width: 150,
                                ),
                              ),
                            ),
                            Positioned(
                                right: 0.0,
                                top: 8,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      controller.deletImage(context, index);
                                    })),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  InkWell(
                    onTap: () async {
                      if (controller.photos.length > 0) {
                        await controller.uploadPhotos(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                            content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                              Text("الرجاء اختيار صورة"),
                              Container(
                                  decoration: BoxDecoration(
                                      // color: AppTheme.primaryColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: RaisedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    },
                                    child: Text("حسناً"),
                                  ))
                            ])));
                      }
                    },
                    child: Container(
                        width: 250,
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("رفع الصور",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            Visibility(
                                visible:
                                    controller.state == WidgetState.Loading,
                                child: CircularPercentIndicator(
                                  radius: 60.0,
                                  lineWidth: 5.0,
                                  percent: controller.percent / 100.0,
                                  center: new Text(
                                      "${controller.percent.round()}%"),
                                  progressColor: Colors.green,
                                )
                                //  LinearProgressIndicator(
                                //     value: controller.percent,
                                //     // strokeWidth: 1.5,

                                //     color: Colors.white)

                                )
                          ],
                        )),
                  )
                ],
              ),
            ),
          ))),
    );
  }
}

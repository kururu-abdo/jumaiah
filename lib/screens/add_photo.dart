import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animated_splash_screen/controllers/add_photo_controller.dart';
import 'package:provider/provider.dart';

class AddPhoto extends StatefulWidget {
  AddPhoto({Key key}) : super(key: key);

  @override
  _AddPhotoState createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {


  @override
  Widget build(BuildContext context) {
        var controller=  Provider.of<AddPhotoController>(context);

      return  Directionality(
      textDirection: TextDirection.rtl,
     
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: new Center(
                child:
                    new Text('إضافة صور', textAlign: TextAlign.center)),

            backgroundColor: Colors.amber, // status bar color
            brightness: Brightness.dark,
            actions: [
            IconButton(onPressed: ()async{

await controller.picImage(1);

            }, icon: Icon(Icons.add_a_photo))
            ],
            leading:  IconButton(onPressed: (){
              Navigator.of(context).pop();
            },
          
            icon: Icon(Icons.arrow_back  , color:Colors.black),
            ),
           // status bar brightness
          ),
          body:  ListView.builder(
            itemCount: controller.photos.length,
            itemBuilder: (BuildContext context, int index) {
              return     Image.file(File(controller.photos[index].image) ,   height:150 , width: 150,)   ;
            },
          ),

        )));
  }

  Widget addPhotoWidget(BuildContext context){
    var controller=  Provider.of<AddPhotoController>(context);
  }


}


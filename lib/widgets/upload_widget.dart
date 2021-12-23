import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class UploadWidget extends StatelessWidget {
  final VoidCallback onTap;
  const UploadWidget({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(20), //padding of outer Container
          child: DottedBorder(
            color: Colors.black, //color of dotted/dash line
            strokeWidth: 3, //thickness of dash/dots
            dashPattern: [10, 6],
            //dash patterns, 10 is dash width, 6 is space width
            child: Container(
              //inner container
              height: 216,
              width: 313 //height of inner container
              ,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.cloud_upload_outlined, size: 40),
                    Text(
                      "اضغط هنا لاختيار الملف",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ), //width to 100% match to parent container.
              //background color of inner container
            ),
          )),
    );
  }
}

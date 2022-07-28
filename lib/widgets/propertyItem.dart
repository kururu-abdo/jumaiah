import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jumaiah/models/property.dart';
import 'package:jumaiah/screens/details.dart';
import 'package:jumaiah/utils/constants.dart';
import 'package:jumaiah/utils/custom_transition.dart';
import 'package:jumaiah/utils/helpers.dart';
import 'package:mix/mix.dart';

class PropertyWidget extends StatefulWidget {
  final Property record;
  final bool isLoading;
  const PropertyWidget({Key key, this.record, this.isLoading = false})
      : super(key: key);

  @override
  _PropertyItemState createState() => _PropertyItemState();
}

class _PropertyItemState extends State<PropertyWidget> {



//    getImageUrl(Property record){
//         var unique = record.sLastUpdate as String;
//            unique = unique.replaceAll(RegExp(r'[^0-9]'), '');
//  final avatarUrl =
//         '${BASE_URL}/web/image?model=property.base&field=pt_image&id=${record.id}&unique=$unique';

//         return avatarUrl;
//    }




  @override
  Widget build(BuildContext context) {
    return
    ClipRect(

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20 ,sigmaY:20),
        child: Container(
          height: 150,
          margin: EdgeInsets.only(bottom: 8 , left: 5,right: 5),
   padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.05)
          ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/icon.png' , width:80 ,height: 80,) ,
          
            Column(children: [
               Text(widget.record.propertyName , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
          
              ,
               Row(mainAxisSize: MainAxisSize.min ,
              
              children: [
               Text(widget.record.ptLocation , style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),)
        ,SizedBox(width: 10,) ,
               Text(showStatsText(widget.record.propertyStatus) , style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),)
          
              ],
              
              )
           ,
          
        Row(mainAxisSize: MainAxisSize.min ,
              
              children: [
               Text(widget.record.date , style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),)
        ,SizedBox(width: 10,) ,
               Text(widget.record.id.toString() , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
          
              ],
              
              )
          
            ],) ,
          
            IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward))
          ],
        ),
        
        ),
      ),
    );
    
    
    
     InkWell(
        onTap: () {
          Navigator.push(
              context,
              CustomPageRoute(
                Details(widget.record.id,
                    image: widget.record.ptImage.toString(),
                    website: widget.record.website,
                    prop_lat: widget.record.propLat.toString ?? "",
                    pt_id: widget.record.id,
                    name: widget.record.propertyName,
                    location: widget.record.ptLocation,
                    certificate_no: widget.record.ptCertificteNo,
                    certificate_date: widget.record.ptCertificteDate.toString(),
                    owner: widget.record.owner,
                    ptLocation: widget.record.ptLocation,
                    property_status: widget.record.propertyStatus),
              ));
        },
        child: Container(
          height: 221,
          width: 194,
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: 
                // widget.record.ptImage.toString().trim() == "false" ||    widget.record.ptImage.toString().trim().length<7|| widget.record.ptImage.toString().trim()==''?  

                // AssetImage('assets/logo.png'):
                  MemoryImage(
                    base64Decode(
                        widget.record.ptImage.toString().trim() == "false"
                            ? DEFAULT_IMG
                            : widget.record.ptImage.toString()),



//  getImageUrl(widget.record)
                  ),
                  fit: BoxFit.cover)),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: 0.6,
              child: Container(
                width: double.infinity,
                height: 221 / 3,
                color: Colors.black,
                child: Column(
                  children: [
                    Flexible(
                      child: Text(
                        widget.record.propertyName.toString(),
                        softWrap: true,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        widget.record.ptLocation.toString(),
                        softWrap: true,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            CustomPageRoute(
              Details(widget.record.id,
                  image: widget.record.ptImage.toString(),
                  website: widget.record.website,
                  prop_lat: widget.record.propLat.toString ?? "",
                  pt_id: widget.record.id,
                  name: widget.record.propertyName,
                  location: widget.record.ptLocation,
                  certificate_no: widget.record.ptCertificteNo,
                  certificate_date: widget.record.ptCertificteDate.toString(),
                  owner: widget.record.owner,
                  property_status: widget.record.propertyStatus),
            ));
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 100.0,
                width: 100,
                child: Hero(
                    tag: widget.record.id.toString(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(
                          base64Decode(
                              widget.record.ptImage.toString().trim() == "false"
                                  ? DEFAULT_IMG
                                  : widget.record.ptImage.toString()),
                          fit: BoxFit.cover),
                    )),
              ),
            ),
            Container(
              width: 250,
              child: ListTile(
                  title: Text(
                      // "",
                      //  record.propertyName.toString(),

                      widget.record.propertyName.toString(),

                      // "",
                      //  record.propertyName.toString(),
                      // "",
                      //  record.propertyName.toString(),

// record.propertyName,

                      //       record.propertyName.last.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  subtitle: Text(
                      // "",
                      //  record.propertyName.toString(),

                      widget.record.ptLocation.toString(),

                      // "",
                      //  record.propertyName.toString(),
                      // "",
                      //  record.propertyName.toString(),

// record.propertyName,

                      //       record.propertyName.last.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black))),
            )
          ],
        ),
      ),
    );

    return Container(
      height: 150.0,
      child: Center(
        child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  CustomPageRoute(
                    Details(widget.record.id,
                        image: widget.record.ptImage.toString(),
                        website: widget.record.website,
                        prop_lat: widget.record.propLat.toString ?? "",
                        pt_id: widget.record.id,
                        name: widget.record.propertyName,
                        location: widget.record.ptLocation,
                        certificate_no: widget.record.ptCertificteNo,
                        certificate_date:
                            widget.record.ptCertificteDate.toString(),
                        owner: widget.record.owner,
                        property_status: widget.record.propertyStatus),
                  ));
            },
            horizontalTitleGap:
                16.0, // The horizontal gap between the titles and the leading/trailing widgets
            leading: SizedBox(
              width: 100.0,
              child: Hero(
                  tag: widget.record.id.toString(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                        base64Decode(
                            widget.record.ptImage.toString().trim() == "false"
                                ? DEFAULT_IMG
                                : widget.record.ptImage.toString()),
                        fit: BoxFit.cover),
                  )),
            ),
            title: Text(
                // "",
                //  record.propertyName.toString(),

                widget.record.propertyName.toString(),

                // "",
                //  record.propertyName.toString(),
                // "",
                //  record.propertyName.toString(),

// record.propertyName,

                //       record.propertyName.last.toString(),
                style: TextStyle(fontSize: 14, color: Colors.black)),
            subtitle: Text(
                // "",
                //  record.propertyName.toString(),

                widget.record.ptLocation.toString(),

                // "",
                //  record.propertyName.toString(),
                // "",
                //  record.propertyName.toString(),

// record.propertyName,

                //       record.propertyName.last.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black))),
      ),
    );

    return Container(
      //    elevation: 5.0,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
              tag: widget.record.id.toString(),
              child: Image.memory(
                  base64Decode(
                      widget.record.ptImage.toString().trim() == "false"
                          ? DEFAULT_IMG
                          : widget.record.ptImage.toString()),
                  fit: BoxFit.cover)),
          Positioned(
            bottom: 0,
            child: Container(
              height: 20,
              width: double.infinity,
              child: Text(
                  // "",
                  //  record.propertyName.toString(),

                  widget.record.propertyName.toString(),

                  // "",
                  //  record.propertyName.toString(),
                  // "",
                  //  record.propertyName.toString(),

// record.propertyName,

                  //       record.propertyName.last.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.black)),
            ),
          )
        ],
      ),
    );
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
      title: new Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: new Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.orange)),
          padding: EdgeInsets.all(1.0),
          margin: EdgeInsets.all(1.0),
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Hero(
                      tag: widget.record.id.toString(),
                      child: Image.memory(base64Decode(
                          widget.record.ptImage.toString().trim() == "false"
                              ? DEFAULT_IMG
                              : widget.record.ptImage.toString()))),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 10.0, // soften the shadow
                          spreadRadius: 10.0, //extend the shadow
                          offset: Offset(
                            3.0, // Move to right 10  horizontally
                            3.0, // Move to bottom 5 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Text(
                        // "",
                        //  record.propertyName.toString(),

                        widget.record.propertyName.toString(),

                        // "",
                        //  record.propertyName.toString(),
                        // "",
                        //  record.propertyName.toString(),

// record.propertyName,

                        //       record.propertyName.last.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            CustomPageRoute(
              Details(widget.record.id,
                  image: widget.record.ptImage.toString(),
                  website: widget.record.website,
                  prop_lat: widget.record.propLat.toString ?? "",
                  pt_id: widget.record.id,
                  name: widget.record.propertyName,
                  location: widget.record.ptLocation,
                  certificate_no: widget.record.ptCertificteNo,
                  certificate_date: widget.record.ptCertificteDate.toString(),
                  owner: widget.record.owner,
                  property_status: widget.record.propertyStatus),
            ));
      },
    );
  }
}

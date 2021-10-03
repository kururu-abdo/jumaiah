import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animated_splash_screen/screens/attachmentscreen.dart';
import 'package:flutter_animated_splash_screen/screens/searchview.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Details extends StatefulWidget {
  int use_id;
  final String image,
      name,
      location,
      owner,
      property_status,
      certificate_no,
      certificate_date;
  final int pt_id;

  Details(this.use_id,
      {Key key,
      @required this.image,
      this.location,
      this.name,
      this.certificate_date,
      this.certificate_no,
      this.owner,
      this.property_status,
      @required this.pt_id})
      : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return 
    Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
     body: CustomScrollView(
       
          slivers: <Widget>[
            SliverAppBar(
              snap: true,
              pinned: true,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(widget.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white)), //Text
                  background: 
                 Hero(
                tag: widget.use_id.toString().trim(),
                child: Image.memory(base64Decode(widget.image)   ,
                
                fit: BoxFit.cover,
                )
                
                ), //Images.network
                  ), //FlexibleSpaceBar
              expandedHeight: 230,
              backgroundColor: Colors.greenAccent[400],
              leading: IconButton(
            icon: Icon(Icons.arrow_back),
           color: Colors.white ,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ), //IconButton
    //<Widget>[]
            ),
            
   SliverFillRemaining(
          child:  SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('معلومات العقار',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.black)),
                SizedBox(height: 10.0),
                ListTile(
                  title: Text(
                    "اسم العقار",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    widget.name,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                ListTile(
                  title: Text(
                    "حالة العقار",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    widget.property_status,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                ListTile(
                  title: Text(
                    "المالك",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    widget.owner,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                ListTile(
                  title: Text(
                    "رقم الصك",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    widget.certificate_no,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                ListTile(
                  title: Text(
                    "تاريخ الصك",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    widget.certificate_date,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                ListTile(
                  title: Text(
                    "الموقع الجغرافي",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    widget.location,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.all(8.0),
                        width:double.infinity , 
                      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                        child: RaisedButton(
                          
                          onPressed: () {
          
          
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AttachScreen(pt_id: widget.pt_id.toString(),
                                     
                                      ),
                                ));
                          },
                          color: Colors.amber,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text("المرفقات" , style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),),
                        ),
                      ),
                  
              ],
            ),
          ),
        )  


           ] //SliverAppBar
     )
      ),
    );
    
    
    
    
    Scaffold(
        body:    
        
        
        SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Hero(


                tag: widget.name.toString().trim(),
                child: Image.memory(base64Decode(widget.image))),
              new Container(
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
                child: Text(widget.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 5.0),
          Column(
            children: <Widget>[
              Text('معلومات العقار',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black)),
              SizedBox(height: 10.0),
              ListTile(
                title: Text(
                  "اسم العقار",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  widget.name,
                  textDirection: TextDirection.rtl,
                ),
              ),
              ListTile(
                title: Text(
                  "حالة العقار",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  widget.property_status,
                  textDirection: TextDirection.rtl,
                ),
              ),
              ListTile(
                title: Text(
                  "المالك",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  widget.owner,
                  textDirection: TextDirection.rtl,
                ),
              ),
              ListTile(
                title: Text(
                  "رقم الصك",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  widget.certificate_no,
                  textDirection: TextDirection.rtl,
                ),
              ),
              ListTile(
                title: Text(
                  "تاريخ الصك",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  widget.certificate_date,
                  textDirection: TextDirection.rtl,
                ),
              ),
              ListTile(
                title: Text(
                  "الموقع الجغرافي",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  widget.location,
                  textDirection: TextDirection.rtl,
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.all(8.0),
                      width:double.infinity , 
                    decoration: BoxDecoration(
borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                      child: RaisedButton(
                        
                        onPressed: () {


                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AttachScreen(pt_id: widget.pt_id.toString(),
                                   
                                    ),
                              ));
                        },
                        color: Colors.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Text("المرفقات" , style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold),),
                      ),
                    ),
                
            ],
          ),
        ],
      ),
    ));
  }
}

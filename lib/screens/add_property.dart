import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animated_splash_screen/controllers/new_property_controller.dart';
import 'package:flutter_animated_splash_screen/enums/widget_state.dart';
import 'package:flutter_animated_splash_screen/models/owner.dart';
import 'package:flutter_animated_splash_screen/models/property_type.dart';
import 'package:flutter_animated_splash_screen/utils/exceptions.dart';
import 'package:flutter_animated_splash_screen/utils/loader.dart';
import 'package:flutter_animated_splash_screen/utils/theme.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hijri_picker/hijri_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
class AddProperyScreen extends StatefulWidget {
  final res_model, res_id, pt_id;

  AddProperyScreen({Key key, this.res_model, this.res_id, this.pt_id})
      : super(key: key);

  @override
  _AddProperyScreenState createState() => _AddProperyScreenState();
}

class _AddProperyScreenState extends State<AddProperyScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  var _formKey = GlobalKey<FormState>();

  TextEditingController nameController = new TextEditingController();
  TextEditingController _CityController = new TextEditingController();

  TextEditingController dateController = new TextEditingController();
  TextEditingController certificteDateController = new TextEditingController();

  TextEditingController certificteNoController = new TextEditingController();
  bool isShow = false;
  var nameFocus = FocusNode();
  bool isVisible =true;
  var cityFocus = FocusNode();
  var dateFocus = FocusNode();
  var certificateDateFocus = FocusNode();
  var certificateNoFocus = FocusNode();
  DateTime selectedDate = DateTime.now();
  HijriCalendar initDate = HijriCalendar.now();

    HijriCalendar selectedHijri;
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<NewPropertyController>().fetchPropertyTyps();

      await context.read<NewPropertyController>().fetchOnwers();
    });
  }

  File _image;


_selectDateHijri(BuildContext context)async{

 final HijriCalendar picked = await showHijriDatePicker(
       context: context,
       initialDate: initDate,
       lastDate: HijriCalendar()
         ..hYear = 1500
          ..hMonth = 12
         ..hDay = 25,
         
       firstDate: HijriCalendar()
         ..hYear = 1356
          ..hMonth = 9
         ..hDay = 25
         ,
       initialDatePickerMode: DatePickerMode.day,
     );
      if (picked != null){
          setState(() {
        selectedHijri = picked;
       var formattedDate = getFormattedHijriDateOfToday();

        certificteDateController.text = formattedDate;
      });
      }
}
  _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2050),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        var formattedDate = getFormattedHijriDateOfToday();
           var h_date = HijriCalendar.fromDate(selected);

        certificteDateController.text = formattedDate;
      });
  }

  void _showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            message,
            style: TextStyle(color: AppTheme.primaryColor, fontSize: 20),
          ),
          Icon(Icons.error_outline, color: AppTheme.primaryColor, size: 20)
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<NewPropertyController>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: 
      Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
Navigator.pop(context);

              },
              icon: Icon(Icons.arrow_back, color: Colors.white)),
          title: new Center(
              child: new Text('عقار جديد',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center)),
          actions: [
            IconButton(
                onPressed: () {
                  _formKey.currentState.reset();

                  model.updateFile(null);
                },
                icon: Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<NewPropertyController>(builder: (context, model, _) {
            if (model.state == WidgetState.Loading) {
               isVisible = false;

              return LoadingWidget();
            }
            if (model.state == WidgetState.Error) {
             isVisible =false;

              if (model.exception is OdooServerException) {
                return error(
                    context, model.exception.message, "assets/server.png");
              } else if (model.exception is ConnectionException) {
                return error(
                    context, model.exception.message, "assets/server.png");
              } else if (model.exception is MyTimeOutException) {
                return error(
                    context, model.exception.message, "assets/server.png");
              }
              return error(
                  context, model.exception.message, "assets/unknown.png");
            }
  if (model.state == WidgetState.Done) { 
 isVisible = false;

    return done(context);
  }
            return Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: model.file != null
                              ? FileImage(model.file)
                              : AssetImage("assets/add_pic2.png"),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller: nameController,
                      //  focusNode: nameFocus,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        filled: true,
                        suffixIcon: Icon(Icons.business),
                        // enabledBorder: UnderlineInputBorder(
                        //     borderSide: BorderSide(color: Colors.black)),
                        hintText: "اسم العقار",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onSaved: (val) {
                        // password = val;
                      },

                      validator: (val) {
                        if (val == null || val == "") {
                          return "هذا الحقل مطلوب";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller: _CityController,
                      //  focusNode: nameFocus,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        suffixIcon: Icon(Icons.location_on),

                        filled: true,
                        // enabledBorder: UnderlineInputBorder(
                        //     borderSide: BorderSide(color: Colors.black)),
                        hintText: "الموقع",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onSaved: (val) {
                        // password = val;
                      },

                      validator: (val) {
                        if (val == null || val == "") {
                          return "هذا الحقل مطلوب";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 5.0),
                    DropdownButtonFormField<int>(
                      items: model.owners.map((owner) {
                        return DropdownMenuItem<int>(
                          value: owner.id,
                          child: Text(owner.owner_name),
                        );
                      }).toList(),
                      onChanged: (owner) {
                        model.updateOwner(owner);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),

                        filled: true,
                        //  hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "المالك",
                        //  fillColor: Colors.blue[200]
                      ),
                      value: model.owner,
                    ),
                    SizedBox(height: 5.0),
                    DropdownButtonFormField<int>(
                      items: model.types.map((type) {
                        return DropdownMenuItem<int>(
                          value: type.id,
                          child: Text(type.property_type),
                        );
                      }).toList(),
                      onChanged: (property) {
                        model.updateProperty(property);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),

                        filled: true,
                        //  hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "نوع الملكية",
                        //  fillColor: Colors.blue[200]
                      ),
                      value: model.proprtyType,
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller: certificteNoController,
                      //   focusNode: certificateNoFocus,

                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        filled: true,
                        // enabledBorder: UnderlineInputBorder(
                        //     borderSide: BorderSide(color: Colors.black)),
                        hintText: "رقم الصك ",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onSaved: (val) {
                        // password = val;
                      },
                      validator: (val) {
                        if (val == null || val == "") {
                          return "هذا الحقل مطلوب";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      // enabled: false,
                      readOnly: true,
                      onTap: () async {
                       // await _selectDate(context);
                  await     _selectDateHijri(context);
                      },
                      controller: certificteDateController,
                      //  focusNode: certificateDateFocus,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        suffixIcon: Icon(Icons.calendar_today),

                        filled: true,
                        // enabledBorder: UnderlineInputBorder(
                        //     borderSide: BorderSide(color: Colors.black)),
                        hintText: "تاريخ الصك ",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onSaved: (val) {
                        // password = val;
                      },
                      validator: (val) {
                        if (val == null || val == "") {
                          return "هذا الحقل مطلوب";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 5.0),
                    DropdownButtonFormField<String>(
                      items: model.status.entries
                          .map<DropdownMenuItem<String>>((type) {
                        return DropdownMenuItem<String>(
                          value: type.key,
                          child: Text(type.value),
                        );
                      }).toList(),
                      onChanged: (property) {
                        print(property);
                        model.updateStatus(property);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),

                        filled: true,
                        //  hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "حالة العقار",
                        //  fillColor: Colors.blue[200]
                      ),
                      value: model.selectedStatus,
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      height: 50,
                      margin: EdgeInsets.all(8.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: RaisedButton(
                        onPressed: () async {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => AttachScreen(
                          //         pt_id: widget.pt_id.toString(),
                          //       ),
                          //     ));

                          if (_formKey.currentState.validate() &&
                              model.file != null) {
                            print("kdsjfkdsjfk");
                            var proprty_name = await model
                                .savePropertyName(nameController.text);

                            if (!proprty_name.error) {
                              await model.addPropery(
                                  proprty_name.data,
                                  model.owner,
                                  _CityController.text,
                                  model.selectedStatus,
                                  certificteNoController.text,
                                 selectedHijri,
                                  //  dateController.text,

                                  model.proprtyType,
                                  model.fileBytes2);
                            } else {}
                          } else {
                            if (model.file == null) {
                              _showScaffold("الرجاء إرفاق صورة");
                            }
                          }
                        },
                        color: Colors.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "إضافة",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                  //name

                  //owner   /drowpdown

                  //city  -- location

                  // date   08/24/2021

                  //type  dropdown

                  //status  dropdown

                  //pt_certificte_no  string

                  //pt_certificte_date
                ));
          }),
        ),
        floatingActionButton:  Visibility(
          visible: model.isShow,
          child: FloatingActionButton.extended(
              onPressed: () {
                model.openFileExplorer();
              },
              backgroundColor: AppTheme.primaryColor,
              icon: Icon(Icons.add_a_photo),
              label: Text('إدراج صورة'),
            ),
        ),
        ),
      
    );
  }

  Widget done(BuildContext context) {
    return Center(
      child: Column(
        //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/done.gif"),
          Text("تمت إضافة  عقار بنجاح"),
          // Spacer(),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              color: AppTheme.primaryColor,
            ),
            child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("تم")),
          )
        ],
      ),
    );
  }

  Widget error(BuildContext context, String message, String img) {
    var model = Provider.of<NewPropertyController>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(img),

          Text(message),

          // Spacer(),

          Container(
            // margin: EdgeInsets.all(10),

            width: double.infinity,

            child: FlatButton.icon(
                onPressed: () async {
                  await model.fetchOnwers();
                  await model.fetchPropertyTyps();
                },
                icon: Icon(Icons.refresh),
                label: Text("حاول مرة أخرى")),
          )
        ],
      ),
    );
  }

 String getFormattedDateOfToday(){
   return "";
 }
    String getFormattedHijriDateOfToday() {
    //DateTime now = DateTime.now();
            return  selectedHijri.toFormat("yyyy-MM-dd");
  
  }
}

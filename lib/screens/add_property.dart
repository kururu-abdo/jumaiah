import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jumaiah/controllers/new_property_controller.dart';
import 'package:jumaiah/enums/widget_state.dart';
import 'package:jumaiah/models/owner.dart';
import 'package:jumaiah/models/property_type.dart';
import 'package:jumaiah/utils/exceptions.dart';
import 'package:jumaiah/utils/loader.dart';
import 'package:jumaiah/utils/theme.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hijri_picker/hijri_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

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
  TextEditingController _CityController = new TextEditingController(text: "");
  TextEditingController _ownerController = new TextEditingController();
  TextEditingController _typeController = new TextEditingController(text: "");
  TextEditingController _websiteController =
      new TextEditingController(text: "");
  TextEditingController _geoLocationController =
      new TextEditingController(text: "");

  String owner;
  TextEditingController dateController = new TextEditingController();
  TextEditingController certificteDateController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();

  TextEditingController certificteNoController =
      new TextEditingController(text: "");
  bool isShow = false;
  var nameFocus = FocusNode();
  bool isVisible = true;
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
      // await context.read<NewPropertyController>().fetchPropertyTyps();

      // await context.read<NewPropertyController>().fetchOnwers();
    });
  }

  File _image;

  _selectDateHijri(BuildContext context) async {
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
        ..hDay = 25,
      initialDatePickerMode: DatePickerMode.day,
    );
    if (picked != null) {
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
    //var model = Provider.of<NewPropertyController>(context);

    return ViewModelBuilder<NewPropertyController>.reactive(
      viewModelBuilder: () => NewPropertyController(),
      onModelReady: (model) {},
      builder: (context, model, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent, elevation: 0.0,

            //AppTheme.primaryColor,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: Colors.black)),
            title: new Center(
                child: new Text('عقار جديد',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center)),
            actions: [
              IconButton(
                  onPressed: () {
                    _formKey.currentState.reset();
                    model.refresh();
                    model.updateFile(null);
                  },
                  icon: Icon(
                    Icons.refresh_rounded,
                    color: Colors.black,
                  ))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Consumer<NewPropertyController>(builder: (context, model, _) {
              if (model.state == WidgetState.Loading) {
                isVisible = false;

                return LoadingWidget();
              }
              if (model.state == WidgetState.Error) {
                isVisible = false;

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
                        //width: MediaQuery.of(context).size.width,
                        height: 180,
                        width: 180,
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
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.none))

                          // OutlineInputBorder(
                          //   borderRadius: const BorderRadius.all(
                          //     const Radius.circular(10.0),
                          //   ),

                          // )

                          ,
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
                        controller: _typeController,
                        //   focusNode: certificateNoFocus,

                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.none)),
                          filled: true,
                          // enabledBorder: UnderlineInputBorder(
                          //     borderSide: BorderSide(color: Colors.black)),
                          hintText: "نوع الملكية ",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        onSaved: (val) {
                          // password = val;
                        },
                        // validator: (val) {
                        //   if (val == null || val == "") {
                        //     return "هذا الحقل مطلوب";
                        //   }
                        //   return null;
                        // },
                      ),
                      SizedBox(height: 5.0),
                      TextFormField(
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        //   focusNode: certificateNoFocus,
                        controller: _ownerController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.none)),
                          filled: true,
                          suffixIcon: Icon(Icons.person),

                          // enabledBorder: UnderlineInputBorder(
                          //     borderSide: BorderSide(color: Colors.black)),
                          hintText: " اسم المالك ",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        onSaved: (str) {
                          setState(() {
                            owner = str;
                          });
                        },
                        onChanged: (str) {
                          setState(() {
                            owner = str;
                          });
                        },
                        validator: (val) {
                          if (val == null || val == "") {
                            return "هذا الحقل مطلوب";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 5.0),
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
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.none)),

                          filled: true,
                          //  hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "حالة العقار",
                          //  fillColor: Colors.blue[200]
                        ),
                        value: model.selectedStatus,
                      ),
                      SizedBox(height: 5.0),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: _CityController,
                        //  focusNode: nameFocus,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.none)),
                          suffixIcon: Icon(Icons.location_city),

                          filled: true,
                          // enabledBorder: UnderlineInputBorder(
                          //     borderSide: BorderSide(color: Colors.black)),
                          hintText: "المدينة",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        onSaved: (val) {
                          // password = val;
                        },

                        // validator: (val) {
                        //   if (val == null || val == "") {
                        //     return "هذا الحقل مطلوب";
                        //   }
                        //   return null;
                        // },
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
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.none)),
                          filled: true,
                          // enabledBorder: UnderlineInputBorder(
                          //     borderSide: BorderSide(color: Colors.black)),
                          hintText: "رقم الصك ",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        onSaved: (val) {
                          // password = val;
                        },
                        // validator: (val) {
                        //   if (val == null || val == "") {
                        //     return "هذا الحقل مطلوب";
                        //   }
                        //   return null;
                        // },
                      ),
                      SizedBox(height: 5.0),
                      TextFormField(
                        // onTap: () {
                        //   model.shaowHijriPicker(context).then((value) {
                        //     _dateController.text =
                        //         model.getFormatedHijri(value);
                        //   });
                        // },
                        //  readOnly: true,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: _dateController,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.none)),
                          suffixIcon: Icon(Icons.calendar_today),
                          filled: true,
                          labelText: "تاريخ الصك", //babel text
                          hintText: "مثال : 1441/2/30",
                          // hintText: "تاريخ الصك ",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        onSaved: (val) {
                          // password = val;
                        },
                      ),
                      SizedBox(height: 5.0),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: _geoLocationController,
                        //  focusNode: nameFocus,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.none)),
                          suffixIcon: Icon(Icons.location_on),

                          filled: true,
                          // enabledBorder: UnderlineInputBorder(
                          //     borderSide: BorderSide(color: Colors.black)),
                          hintText: "  رابط الموقع الجغرافي",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        onSaved: (val) {
                          // password = val;
                        },

                        // validator: (val) {
                        //   if (val == null || val == "") {
                        //     return "هذا الحقل مطلوب";
                        //   }
                        //   return null;
                        // },
                      ),
                      SizedBox(height: 5.0),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: _websiteController,
                        //  focusNode: nameFocus,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.none)),
                          suffixIcon: Icon(Icons.web_asset),

                          filled: true,
                          // enabledBorder: UnderlineInputBorder(
                          //     borderSide: BorderSide(color: Colors.black)),
                          hintText: "الموقع الإلكتروني",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        onSaved: (val) {
                          // password = val;
                        },

                        // validator: (val) {
                        //   if (val == null || val == "") {
                        //     return "هذا الحقل مطلوب";
                        //   }
                        //   return null;
                        // },
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        height: 50,
                        margin: EdgeInsets.all(8.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: RaisedButton(
                          onPressed: () async {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => AttachScreen(
                            //         pt_id: widget.pt_id.toString(),
                            //       ),
                            //     ));

                            if (_formKey.currentState.validate()

                                //  &&
                                //     model.file != null

                                ) {
                              _formKey.currentState.save();
                              print(owner);
                              var proprty_name = await model
                                  .savePropertyName(nameController.text);

                              if (!proprty_name.error) {
                                await model.addPropery(
                                    nameController.text,
                                    owner,
                                    _CityController.text,
                                    model.selectedStatus ?? "",
                                    certificteNoController.text,
                                    _typeController.text,
                                    model.fileBytes2,
                                    _dateController.text,
                                    _geoLocationController.text,
                                    _websiteController.text);
                              } else {}
                            }
                            // else {
                            //   if (model.file == null) {
                            //     _showScaffold("الرجاء إرفاق صورة");
                            //   }
                            // }
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
          floatingActionButton: Visibility(
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
                  model.refresh();
                },
                icon: Icon(Icons.refresh),
                label: Text("حاول مرة أخرى")),
          )
        ],
      ),
    );
  }

  String getFormattedDateOfToday() {
    return "";
  }

  String getFormattedHijriDateOfToday() {
    //DateTime now = DateTime.now();
    return selectedHijri.toFormat("yyyy-MM-dd");
  }
}

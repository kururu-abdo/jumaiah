import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import 'full_pdf_viewer_scaffold.dart';

class SearchView extends StatefulWidget {
  final String file, name, res_model, res_id, pt_id, blob, blobimage, main_id;

  SearchView({
    Key key,
    @required this.file,
    this.pt_id,
    this.res_id,
    this.name,
    this.blob,
    this.main_id,
    this.blobimage,
    this.res_model,
  }) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  //A controller for an editable text field.
  //Whenever the user modifies a text field with an associated
  //TextEditingController, the text field updates value and the
  //controller notifies its listeners.
  var _searchview = new TextEditingController();
  final orpc = OdooClient('http://142.93.55.190:8069');
  bool _firstSearch = true;
  String _query = "";

  List<String> _nebulae;
  List<String> _filterList;
  List<String> data;
  Future<dynamic> fetchContacts() async {
    await orpc.authenticate('Jumaiah', 'admin', 'bcool1984');

    var result = await orpc.callKw({
      'model': 'ir.attachment',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'domain': [
          ['res_id', '=', widget.pt_id]
        ],
        'fields': [],
        'limit': 80,
      },
    });
    print(result);
    return result;
  }

  @override
  void initState() {
    super.initState();
    _nebulae = new List<String>();
    _nebulae = [
      "Orion",
      "Boomerang",
      "Cat's Eye",
      "Pelican",
      "Ghost Head",
      "Witch Head",
      "Snake",
      "Ant",
      "Bernad 68",
      "Flame",
      "Eagle",
      "Horse Head",
      "Elephant's Trunk",
      "Butterfly"
    ];
    _nebulae.sort();
  }

  _SearchViewState() {
    //Register a closure to be called when the object changes.
    _searchview.addListener(() {
      if (_searchview.text.isEmpty) {
        //Notify the framework that the internal state of this object has changed.
        setState(() {
          _firstSearch = true;
          _query = "";
        });
      } else {
        setState(() {
          _firstSearch = false;
          _query = _searchview.text;
        });
      }
    });
  }
  Widget buildListItem(Map<String, dynamic> record) {
    var name = record['name'];
    var res_id = record['res_id'];
    var res_model = record['res_model'];
    var main_id = record['id'];

    final blob = record['datas'];
    final _byteImage = Base64Decoder().convert(blob);
    var blobimage = Image.memory(_byteImage);
    return ListTile(
      title: Text(name),
      leading: Icon(Icons.picture_as_pdf),
      // trailing: SizedBox(
      //   width: 120,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: <Widget>[
      //       Align(
      //         alignment: Alignment.bottomCenter,
      //         child: RaisedButton(
      //           onPressed: () {
      //             Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => FilePickerDemo(
      //                     pt_id: record['id'].toString(),
      //                     name: record['name'][1],
      //                     res_id: record['res_id'].toString(),
      //                     res_model: record['res_model'],
      //                   ),
      //                 ));
      //           },
      //           color: Colors.amber,
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(10)),
      //           child: Text("اضافة ملف"),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ViewPDF(blob: blob)));
      },
    );
  }

//Build our Home widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("SearchView ListView"),
      ),
      body: new Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: new Column(
          children: <Widget>[
            _createSearchView(),
            _firstSearch ? _createListView() : _performSearch()
          ],
        ),
      ),
    );
  }

  //Create a SearchView
  Widget _createSearchView() {
    return new Container(
      decoration: BoxDecoration(border: Border.all(width: 1.0)),
      child: new TextField(
        controller: _searchview,
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: new TextStyle(color: Colors.grey[300]),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  //Create a ListView widget
  Widget _createListView() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FutureBuilder(
            future: fetchContacts(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          final record =
                              snapshot.data[index] as Map<String, dynamic>;

                          return buildListItem(record);
                        }));
              } else {
                if (snapshot.hasError) return Text('Unable to fetch data');
                return CircularProgressIndicator();
              }
            }),
      ],
    );
  }

  //Perform actual search
  Widget _performSearch() {
    _filterList = new List<String>();
    for (int i = 0; i < data.length; i++) {
      var item = _nebulae[i];

      if (item.toLowerCase().contains(_query.toLowerCase())) {
        _filterList.add(item);
      }
    }
    return _createFilteredListView();
  }

  //Create the Filtered ListView
  Widget _createFilteredListView() {
    return new Flexible(
      child: new ListView.builder(
          itemCount: _filterList.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
              color: Colors.white,
              elevation: 5.0,
              child: new Container(
                margin: EdgeInsets.all(15.0),
                child: new Text("${_filterList[index]}"),
              ),
            );
          }),
    );
  }
}

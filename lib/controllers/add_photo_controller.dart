import 'package:flutter/material.dart';
import 'package:flutter_animated_splash_screen/enums/widget_state.dart';
import 'package:flutter_animated_splash_screen/main.dart';
import 'package:flutter_animated_splash_screen/models/photoItem.dart';
import 'package:flutter_animated_splash_screen/utils/constants.dart';
import 'package:flutter_animated_splash_screen/utils/exceptions.dart';
import 'package:flutter_animated_splash_screen/utils/shared_prefs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class AddPhotoController  extends ChangeNotifier{
    final orpc = OdooClient('http://142.93.55.190:8069/');
  static String baseUrl = 'http://142.93.55.190:8069/';
  static OdooClient client = OdooClient(baseUrl);
  var subscription = client.sessionStream.listen(sessionChanged);
  var loginSubscription = client.loginStream.listen(loginStateChanged);
  var inRequestSubscription = client.inRequestStream.listen(inRequestChanged);

  List<PhotoItem > _photos = [];

  List<PhotoItem > get photos => _photos;

_addPhoto(PhotoItem photo){
  _photos.add(photo);
  notifyListeners();
}

 

  WidgetState _state;
  WidgetState get state => _state;
  AppException _exception;

  AppException get exception => _exception;

  void _setException(AppException exception) {
    _exception = exception;
    notifyListeners();
  }

  void _setState(WidgetState state) {
    _state = state;
    notifyListeners();
  }

  Future<OdooSession> getClient() async {
    var session;
    //jumaiah!@##@!
    if (sharedPrefs.getUserType() == GUEST) {
      session = await client.authenticate(DEFAULT_DB2, 'admin', 'bcool1984');
    } else {
      session = await client.authenticate(DEFAULT_DB2,
          sharedPrefs.getEmail().trim(), sharedPrefs.getUserPassword().trim());
    }

    return session;
  }
  picImage(int id)async{
    final ImagePicker _picker = ImagePicker();

    final XFile image = await _picker.pickImage(source: ImageSource.gallery);


   var photo =PhotoItem(product_template_id:  id  , title: image.name ,description: image.name , image: image  );
  _addPhoto(photo);

   
  }
  uploadPhotos()async{
 
  }

}
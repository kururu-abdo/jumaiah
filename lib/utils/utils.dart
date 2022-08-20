import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:string_unescape/string_unescape.dart';

export 'loader.dart';
export 'theme.dart';


Uint8List convertBase64Image(String base64String) {

var decodeString = unescape(base64String.trim());   
RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
String s = base64String.toString().replaceAll(regex, '');
  // return Base64Decoder().convert(decodeString);
var last =s.split(',').last;
log(last);
  return base64.decode(s.trim().split(',').last);
}
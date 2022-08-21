import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';



export 'loader.dart';
export 'theme.dart';


Uint8List convertBase64Image(String base64String) {

// var decodeString = unescape(base64Stribase64Stringng.trim());   
// RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
// String s = base64String.toString().replaceAll(regex, '');
//   // return Base64Decoder().convert(decodeString);
// var last =s.split(',').last;
// log(last);
log(base64String);
// if (base64.toString()=="false") {
//   return base64.decode(DEFAULT_IMG);

// } else {
  return base64.decode(base64String.replaceAll(new RegExp(r"\s+"), "")
);
// }

return base64.decode("""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"""
     .replaceAll(new RegExp(r"\s+"), "")


);
  return base64.decode(base64String.trim());
}
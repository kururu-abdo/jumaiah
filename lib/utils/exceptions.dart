class AppException implements Exception {
  final message;
  final prefix;

  AppException([this.message, this.prefix]);

  String toString() {
    return "$message";
  }
}
class NoData404Exception extends AppException{
    NoData404Exception([String message]) : super("لا توجد بيانات", "No Data");

}
class ConnectionException extends AppException {
  ConnectionException([String message]) : super("لا يوجد اتصال بالانترنت", "No Internet");
}

class MyTimeOutException extends AppException {
  MyTimeOutException([String message]) : super("انتهت مهلة الاتصال بالخادم", "TimeOutException");
}

class OdooServerException extends AppException {
  OdooServerException([String message]) : super("خطأ في الخادم", "ServerException");
}
class FileException extends AppException {
  FileException([String message]) : super("خطأ أثناء تحميل الملف", "FileException");
}


class UnknownException extends AppException {
  UnknownException([String message]) : super("خطأ غير معروف", "ServerException");
}

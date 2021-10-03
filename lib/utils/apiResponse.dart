class APIrespnse<T> {
 T data;
bool error =false;
String errorMessage='';


APIrespnse({this.data ,  this.errorMessage ,  this.error});

}
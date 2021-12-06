// // class Proprty {
// //   int id;
// //   List  property_name;
// //   String pt_location;

// //   String pt_certificte_date;

// //   String property_status;
// //   String pt_certificte_no;
// //   String pt_image;
// //   List owner;
// //   dynamic property_type;
// //   Proprty(this.id, this.property_name  , this.property_type, this.pt_image , this.owner , this.property_status , this.pt_certificte_date , this.pt_certificte_no ,this.pt_location);

// //   Proprty.fromJson(Map<dynamic, dynamic> data) {
// //     this.id = data['id'];
// //     this.property_type = data['property_type'];
// //       this.property_name = data['property_name'];
// //     this.owner = data['owner'];
// //     this.pt_image  = data['pt_image'];
// //     this.property_status = data['property_status'];
// //     this.pt_certificte_date= data['pt_certificte_date'];

// //     this.pt_certificte_no = data['pt_certificte_no'];
// // this.pt_location=  data['pt_location'];
// //   }

// //   Map<dynamic, dynamic> toJson() =>
// //       {"id": this.id, "property_name": this.property_name  ,"property_type":this.property_type   , "pt_image":this.pt_image , "owner":this.owner , "property_status":this.property_status  , "pt_certificte_date":this.pt_certificte_date , "pt_certificte_no":this.pt_certificte_no  ,  "pt_location" :  this.pt_location };
// // }

// import 'dart:developer';

// class Property {
//   int id;
//   int galleryCount;
//   int invCount;
//   int contCount;
//   List<dynamic> propertyName;
//   String ptImage;
//   List<dynamic> propertyType;
//   String userName;
//   String name;
//   String date;
//   String ptLocation;
//   dynamic propLat;
//   List<dynamic> companyId;
//   List<dynamic> owner;
//   String ptCertificteNo;
//   String ptCertificteDate;
//   String state;
//   String propertyStatus;
//   List<dynamic> createUid;

//   Property(
//       {this.id,
//       this.galleryCount,
//       this.invCount,
//       this.contCount,
//       this.propertyName,
//       this.ptImage,
//       this.propertyType,
//       this.userName,
//       this.name,
//       this.date,
//       this.ptLocation,
//       this.propLat,
//       this.companyId,
//       this.owner,
//       this.ptCertificteNo,
//       this.ptCertificteDate,
//       this.state,
//       this.propertyStatus,
//       this.createUid});

//   Property.fromJson(Map<String, dynamic> json) {
//     log(json.toString());
//     id = json['id'];
//     galleryCount = json['gallery_count'];
//     invCount = json['inv_count'];
//     contCount = json['cont_count'];
//     propertyName = json['property_name'].cast<dynamic>();
//     ptImage = json['pt_image'];
//     propertyType = json['property_type'].cast<dynamic>();
//     userName = json['user_name'];
//     name = json['name'];
//     date = json['date'];
//     ptLocation = json['pt_location'];
//     propLat = json['prop_lat'];
//     companyId = json['company_id'].cast<dynamic>();
//     owner = json['owner'];
//     //.cast<dynamic>();
//     ptCertificteNo = json['pt_certificte_no'];
//     ptCertificteDate = json['pt_certificte_date'];
//     state = json['state'];
//     propertyStatus = json['property_status'];
//     createUid = json['create_uid'].cast<dynamic>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['gallery_count'] = this.galleryCount;
//     data['inv_count'] = this.invCount;
//     data['cont_count'] = this.contCount;
//     data['property_name'] = this.propertyName;
//     data['pt_image'] = this.ptImage;
//     data['property_type'] = this.propertyType;
//     data['user_name'] = this.userName;
//     data['name'] = this.name;
//     data['date'] = this.date;
//     data['pt_location'] = this.ptLocation;
//     data['prop_lat'] = this.propLat;
//     data['company_id'] = this.companyId;
//     data['owner'] = this.owner;
//     data['pt_certificte_no'] = this.ptCertificteNo;
//     data['pt_certificte_date'] = this.ptCertificteDate;
//     data['state'] = this.state;
//     data['property_status'] = this.propertyStatus;
//     data['create_uid'] = this.createUid;
//     return data;
//   }
// }
class Property {
  int id;
  dynamic gallery;
  dynamic website;
  int contCount;
  dynamic propertyName;
  dynamic ptImage;
  dynamic propertyType;
  String userName;
  String name;
  dynamic date;
  dynamic ptLocation;
  dynamic propLat;
  List<dynamic> companyId;
  dynamic owner;
  dynamic ptCertificteNo;
  dynamic ptCertificteDate;
  String state;
  String propertyStatus;
  List<dynamic> multiImages;
  List<dynamic> createUid;
  String createDate;
  List<dynamic> writeUid;
  String writeDate;
  int docCount;
  String displayName;
  String sLastUpdate;

  Property(
      {this.id,
      this.gallery,
      this.website,
      this.contCount,
      this.propertyName,
      this.ptImage,
      this.propertyType,
      this.userName,
      this.name,
      this.date,
      this.ptLocation,
      this.propLat,
      this.companyId,
      this.owner,
      this.ptCertificteNo,
      this.ptCertificteDate,
      this.state,
      this.propertyStatus,
      this.multiImages,
      this.createUid,
      this.createDate,
      this.writeUid,
      this.writeDate,
      this.docCount,
      this.displayName,
      this.sLastUpdate});

  Property.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gallery = json['gallery'];
    website = json['website'];
    contCount = json['cont_count'];
    propertyName = json['property_name'];
    ptImage = json['pt_image'];
    propertyType = json['property_type'];
    userName = json['user_name'];
    name = json['name'];
    date = json['date'];
    ptLocation = json['pt_location'];
    propLat = json['prop_lat'];
    companyId = json['company_id'];
    owner = json['owner'];
    ptCertificteNo = json['pt_certificte_no'];
    ptCertificteDate = json['pt_certificte_date'];
    state = json['state'];
    propertyStatus = json['property_status'];
    multiImages = json['multi_images'].cast<int>();
    createUid = json['create_uid'];
    createDate = json['create_date'];
    writeUid = json['write_uid'];
    writeDate = json['write_date'];
    docCount = json['doc_count'];
    displayName = json['display_name'];
    sLastUpdate = json['__last_update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['gallery'] = this.gallery;
    data['website'] = this.website;
    data['cont_count'] = this.contCount;
    data['property_name'] = this.propertyName;
    data['pt_image'] = this.ptImage;
    data['property_type'] = this.propertyType;
    data['user_name'] = this.userName;
    data['name'] = this.name;
    data['date'] = this.date;
    data['pt_location'] = this.ptLocation;
    data['prop_lat'] = this.propLat;
    data['company_id'] = this.companyId;
    data['owner'] = this.owner;
    data['pt_certificte_no'] = this.ptCertificteNo;
    data['pt_certificte_date'] = this.ptCertificteDate;
    data['state'] = this.state;
    data['property_status'] = this.propertyStatus;
    data['multi_images'] = this.multiImages;
    data['create_uid'] = this.createUid;
    data['create_date'] = this.createDate;
    data['write_uid'] = this.writeUid;
    data['write_date'] = this.writeDate;
    data['doc_count'] = this.docCount;
    data['display_name'] = this.displayName;
    data['__last_update'] = this.sLastUpdate;
    return data;
  }
}

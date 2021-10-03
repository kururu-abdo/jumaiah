class ProprtyType {
  int id;
  String property_type;

  ProprtyType(this.id, this.property_type);

  ProprtyType.fromJson(Map<dynamic, dynamic> data) {
    this.id = data['id'];
    this.property_type = data['property_type'];
  }

  Map<dynamic, dynamic> toJson() =>
      {"id": this.id, "property_type": this.property_type};
}

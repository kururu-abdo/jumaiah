class OdooUser {
  int id;
  dynamic tz;
  String login;
  String password;
  String name;
  String image;

  OdooUser(
      {this.id, this.tz, this.login, this.password, this.name, this.image});

  OdooUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tz = json['tz'];
    login = json['login'];
    password = json['password'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tz'] = this.tz;
    data['login'] = this.login;
    data['password'] = this.password;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

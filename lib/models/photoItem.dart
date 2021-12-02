class PhotoItem {
   int product_template_id;

  dynamic image;
String title;
String description;
  PhotoItem(
      {this.description , this.product_template_id ,this.title, this.image});

  PhotoItem.fromJson(Map<String, dynamic> json) {
  
    description = json['description'];
    product_template_id = json['product_template_id'];
    title = json['title'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['product_template_id'] = this.product_template_id;
    data['title'] = this.title;
  
    data['image'] = this.image;
    return data;
  }
}

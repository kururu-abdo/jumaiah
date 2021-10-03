class Owner {
   int id;
   String owner_name;

  Owner(this.id, this.owner_name);

Owner.fromJson(Map<dynamic ,dynamic> data){
  this.id= data['id'];
  this.owner_name =data['owner_name'];
}


Map<dynamic ,dynamic>  toJson()=>{

  "id": this.id
   , "owner_name":this.owner_name
};

}
class SearchModel{

  String email;
  String name;

  SearchModel({
    this.email,
    this.name
  });

  SearchModel.fromJson(Map<String ,dynamic> json){
    email = json['email'];
    name = json['name'];
  }

  Map<String, dynamic> toJson(){
    return{
      'email' : email,
      'name' : name
    };
  }
}
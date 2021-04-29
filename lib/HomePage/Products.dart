class Products{
  int product_id;
  String product_name;
  String brand_name;
  String subhead;
  String description;
  double avg_rating;
  int num_ratings;

  Products({this.product_id, this.product_name, this.brand_name, this.subhead,
    this.description, this.avg_rating, this.num_ratings});

  factory Products.fromJson(Map<String, dynamic> json){
    return Products(
      product_id: json["product_id"] as int,
      product_name: json["product_name"] as String,
      brand_name: json["brand_name"] as String,
      subhead: json["subhead"] as String,
      description: json["description"] as String,
      avg_rating: json["avg_rating"].toDouble() as double,
      num_ratings: json["num_ratings"] as int,
    );
  }


}
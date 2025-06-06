enum ActivityStatus { ongoing, done }

class Activity {
  String? name;
  String? image;
  String? id;
  String? city;
  double? price;
  ActivityStatus status;

  Activity({
    this.name,
    this.image,
    this.id,
    this.city,
    this.price,
    this.status = ActivityStatus.ongoing, // Valeur par défaut
  });
  Activity.fromJson(Map<String, dynamic> json)
    : id = json['_id'],
      name = json['name'],
      image = json['image'],
      city = json['city'],
      price = json['price'].toDouble(),
      status =
          json['status'] == 0 ? ActivityStatus.ongoing : ActivityStatus.done;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> value = {
      "name": name,
      "image": image,
      "city": city,
      "price": price,
      "status": status == ActivityStatus.ongoing ? 0 : 1,
    };

    if (id != null) {
      value["_id"] = id;
    }

    return value;
  }
}

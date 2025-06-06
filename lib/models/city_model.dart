import 'activity_model.dart';

class City {
  String? id; // Ajout de la propriété id
  String? image;
  String? name;
  List<Activity>? activities;

  City({this.id, this.image, this.name, this.activities});

  City.fromJson(Map<String, dynamic> json)
    : id = json['_id'],
      image = json['image'],
      name = json['name'],
      activities =
          json['activities'] != null
              ? (json['activities'] as List)
                  .map((activity) => Activity.fromJson(activity))
                  .toList()
              : null;
}

import 'activity_model.dart';

class Trip {
  String? city;
  List<Activity>? activities;
  DateTime? date;
  String? id;

  Trip({this.city, this.activities, this.date, this.id});

  Trip.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        city = json['city'],
        activities = json['activities'] != null
            ? (json['activities'] as List)
            .map((activityJson) => Activity.fromJson(activityJson))
            .toList()
            : [],
        date = json['date'] != null ? DateTime.parse(json['date']) : null;

  Map<String, dynamic> toJson() => {
    '_id': id,
    'city': city,
    'activities': activities?.map((activity) => activity.toJson()).toList(),
    'date': date?.toIso8601String(),
  };
}
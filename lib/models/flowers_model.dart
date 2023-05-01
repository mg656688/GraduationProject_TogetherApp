import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Flower {
 late String plantName;
 late String info;
 late List<String>? whenToPlant;
 late String lightNeed;
 late String lightDetails;
 late String wateringNeed;
 late String wateringDetails;
 late String fertlizeNeed;
 late String fertlizeDetails;
 late List<String>? diseases;
 late List<String>? diseasesDetails;
 late List<String>? treatment;

 Flower({
  required this.plantName,
  required this.info,
  required this.whenToPlant,
  required this.lightNeed,
  required this.lightDetails,
  required this.wateringNeed,
  required this.wateringDetails,
  required this.fertlizeNeed,
  required this.fertlizeDetails,
  required this.diseases,
  required this.diseasesDetails,
  required this.treatment

});

}


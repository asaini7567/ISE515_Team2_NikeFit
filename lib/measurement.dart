import 'package:hive/hive.dart';

part 'measurement.g.dart';

@HiveType(typeId: 0)
class Measurement extends HiveObject {
  @HiveField(0)
  String shoeName;

  @HiveField(1)
  String category;

  @HiveField(2)
  double shoeSize;

  @HiveField(3)
  double footLength;

  @HiveField(4)
  double footWidthHeel;

  @HiveField(5)
  double footWidthForefoot;

  @HiveField(6)
  double? toeBoxWidth;

  @HiveField(7)
  double? archLength;

  @HiveField(8)
  double? heelToToeDiagonal;

  @HiveField(9)
  final String imageUrl;

  @HiveField(10)
  final String link;

  Measurement({
    required this.shoeName,
    required this.category,
    required this.shoeSize,
    required this.footLength,
    required this.footWidthHeel,
    required this.footWidthForefoot,
    this.toeBoxWidth,
    this.archLength,
    this.heelToToeDiagonal,
    required this.imageUrl,
    required this.link,
  });

  // Copy method to create a new instance with the same values
  Measurement copy() {
    return Measurement(
      shoeName: shoeName,
      category: category,
      shoeSize: shoeSize,
      footLength: footLength,
      footWidthHeel: footWidthHeel,
      footWidthForefoot: footWidthForefoot,
      toeBoxWidth: toeBoxWidth,
      archLength: archLength,
      heelToToeDiagonal: heelToToeDiagonal,
      imageUrl: imageUrl,
      link: link,
    );
  }
}

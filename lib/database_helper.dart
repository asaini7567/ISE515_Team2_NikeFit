import 'package:hive/hive.dart';
import 'measurement.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static final _measurementBox = Hive.box<Measurement>('measurements');
  static final _searchBox = Hive.box<Measurement>('previous_searches');

  static late Box<Measurement> _searchedBox;

  // Private constructor
  DatabaseHelper._internal() {
    _initializeHardCodedData();
  }

  static Future<void> init() async {
    // Open the box for storing searched shoes
    _searchedBox = await Hive.openBox<Measurement>('searched_shoes');
  }

  // Initialize hard-coded data if the box is empty
  Future<void> _initializeHardCodedData() async {
    if (_measurementBox.isEmpty) {
      final hardCodedData = [
        Measurement(
          shoeName: 'Nike Dunk Low Retro',
          category: 'Casual',
          shoeSize: 8.5,
          footLength: 28,
          footWidthHeel: 7,
          footWidthForefoot: 9,
          toeBoxWidth: 10,
          archLength: 18,
          heelToToeDiagonal: 27.5,
          gender: 'Men', // Add gender to hard-coded data
        ),
        Measurement(
          shoeName: 'Nike Air Force 1',
          category: 'Casual',
          shoeSize: 8.5,
          footLength: 28.2,
          footWidthHeel: 7.7,
          footWidthForefoot: 8.9,
          toeBoxWidth: 10.1,
          archLength: 20.3,
          heelToToeDiagonal: 28.6,
          gender: 'Women', // Add gender to hard-coded data
        ),
        Measurement(
          shoeName: 'Nike Air Jordan 1',
          category: 'Sports',
          shoeSize: 8.5,
          footLength: 27,
          footWidthHeel: 6.4,
          footWidthForefoot: 8.5,
          toeBoxWidth: 9.5,
          archLength: 15.5,
          heelToToeDiagonal: 26.7,
          gender: 'Men', // Add gender to hard-coded data
        ),
        Measurement(
          shoeName: 'Nike Flyknit Air Max Multi-Color',
          category: 'Running',
          shoeSize: 8.5,
          footLength: 26.7,
          footWidthHeel: 8.9,
          footWidthForefoot: 8.6,
          toeBoxWidth: 7.6,
          archLength: 17.8,
          heelToToeDiagonal: 25.4,
          gender: 'Women', // Add gender to hard-coded data
        ),
        Measurement(
          shoeName: 'Nike React Infinity Run Flyknit',
          category: 'Running',
          shoeSize: 9,
          footLength: 27.9,
          footWidthHeel: 5.7,
          footWidthForefoot: 8.3,
          toeBoxWidth: 8.9,
          archLength: 19.1,
          heelToToeDiagonal: 28.7,
          gender: 'Men', // Add gender to hard-coded data
        ),
      ];

      // Add hard-coded data to the box
      for (var measurement in hardCodedData) {
        await _measurementBox.add(measurement);
      }
    }
  }

  // Insert a new measurement (if needed for additional data entry)
  Future<void> insertMeasurement(Measurement measurement) async {
    await _measurementBox.add(measurement);
  }

  // Retrieve all measurements
  List<Measurement> fetchAllMeasurements() {
    return _measurementBox.values.toList();
  }

  // Save a searched shoe to the searched_shoes box
  Future<void> saveSearchedShoe(Measurement shoe) async {
    debugPrint('Saving shoe: ${shoe.shoeName}');
    await _searchBox.add(shoe.copy());
  }

  // Fetch all searched shoes

  List<Measurement> fetchAllSearchedShoes() {
    debugPrint('Fetching all searched shoes. Total: ${_searchBox.length}');
    return _searchBox.values.toList();
  }

  // Delete a searched shoe by key
  Future<void> deleteSearchedShoe(int key) async {
    await _searchBox.delete(key);
  }

  Future<void> clearPreviousSearches() async {
    await _searchBox.clear();
  }

  // Search for a matching shoe
  Measurement? searchMeasurement({
    required String category,
    required double shoeSize,
    required double footLength,
    required double footWidthHeel,
    required double footWidthForefoot,
    required String gender,
  }) {
    debugPrint('Searching for:');
    debugPrint('Category: $category, Gender: $gender');
    debugPrint('Shoe Size: $shoeSize, Foot Length: $footLength');
    debugPrint(
        'Heel Width: $footWidthHeel, Forefoot Width: $footWidthForefoot');

    final measurements = fetchAllMeasurements();
    Measurement? closestMatch;
    double smallestDifference = double.infinity;

    for (var measurement in measurements) {
      if (measurement.category == category && measurement.gender == gender) {
        double difference = (measurement.shoeSize - shoeSize).abs() +
            (measurement.footLength - footLength).abs() +
            (measurement.footWidthHeel - footWidthHeel).abs() +
            (measurement.footWidthForefoot - footWidthForefoot).abs();

        if (difference < smallestDifference) {
          smallestDifference = difference;
          closestMatch = measurement;
        }
      }
    }

    debugPrint('Closest match found: ${closestMatch?.shoeName}');
    return closestMatch;
  }

  Future<void> deleteMeasurement(int key) async {
    await _measurementBox.delete(key);
  }

  // Close the database box
  Future<void> close() async {
    await _measurementBox.close();
  }
}

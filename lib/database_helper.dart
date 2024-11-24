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
          imageUrl: 'images/nike dunk low retro.jpg',
          link:
              'https://www.nike.com/t/dunk-low-retro-mens-shoes-5FQWGR/DD1391-103?nikemt=true&cp=28191740926_search_--x-21419615984---c-13382500-00195238789091&dplnk=member&gad_source=1&gbraid=0AAAAADy86kMcx1_qOmhB01gXaZIK-N2qP&gclid=Cj0KCQiAouG5BhDBARIsAOc08RRRxxMJeckQMr-IXDiBQOwCelqWPOtRZZwg9pYD75HXQk4lqFDLcwQaAua7EALw_wcB&gclsrc=aw.ds',
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
          imageUrl: 'images/nike air force 1.jpg',
          link:
              'https://www.nike.com/t/air-force-1-07-mens-shoes-jBrhbr/CW2288-111',
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
          imageUrl: 'images/nike air jordan 1.jpg',
          link:
              'https://www.nike.com/t/air-jordan-1-mid-se-mens-shoes-Zn07hL/HV0789-010',
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
          imageUrl: 'images/nike flyknit air max multi-color.jpg',
          link: 'https://stockx.com/nike-flyknit-air-max-multi-color',
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
          imageUrl: 'images/nike react infinity run flyknit.jpg',
          link:
              'https://www.nike.com/t/react-infinity-run-flyknit-3-mens-road-running-shoes-X4PKW0/FJ3994-100',
        ),
        Measurement(
          shoeName: 'Nike Rival Waffle 6',
          category: 'Running',
          shoeSize: 10.5,
          footLength: 28,
          footWidthHeel: 7,
          footWidthForefoot: 9,
          toeBoxWidth: 10,
          archLength: 16,
          heelToToeDiagonal: 28.5,
          imageUrl: 'images/nike rival waffle 6.jpg',
          link:
              'https://www.nike.com/t/rival-waffle-6-road-and-cross-country-racing-shoes-txWgQr/DX7998-701',
        ),
        Measurement(
          shoeName: 'Nike SFB Field 8" Leather Mens',
          category: 'Casual',
          shoeSize: 10,
          footLength: 29,
          footWidthHeel: 9,
          footWidthForefoot: 10,
          toeBoxWidth: 11,
          archLength: 18,
          heelToToeDiagonal: 30,
          imageUrl: 'images/nike sfb field 8 leather.jpg',
          link:
              'https://www.nike.com/t/sfb-field-2-8-leather-tactical-boots-HdQlt9',
        ),
        Measurement(
          shoeName: 'Nike Rival Waffle 6',
          category: 'Running',
          shoeSize: 6.5,
          footLength: 26,
          footWidthHeel: 6,
          footWidthForefoot: 8,
          toeBoxWidth: 9,
          archLength: 14,
          heelToToeDiagonal: 27,
          imageUrl: 'images/nike rival waffle 6.jpg',
          link:
              'https://www.nike.com/t/rival-waffle-6-road-and-cross-country-racing-shoes-txWgQr/DX7998-701',
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
    double? toeBoxWidth,
    double? archLength,
    double? heelToToeDiagonal,
  }) {
    // Validation for required inputs
    if (shoeSize < 0.1 || shoeSize > 200) {
      debugPrint('Error: Shoe size must be between 0.1 and 200.');
      return null;
    }
    if (footLength < 0.1 || footLength > 200) {
      debugPrint('Error: Foot length must be between 0.1 and 200.');
      return null;
    }
    if (footWidthHeel < 0.1 || footWidthHeel > 200) {
      debugPrint('Error: Foot width at the heel must be between 0.1 and 200.');
      return null;
    }
    if (footWidthForefoot < 0.1 || footWidthForefoot > 200) {
      debugPrint(
          'Error: Foot width at the forefoot must be between 0.1 and 200.');
      return null;
    }

    // Validation for optional inputs
    if (toeBoxWidth != null && (toeBoxWidth < 0.1 || toeBoxWidth > 200)) {
      debugPrint('Error: Toe box width must be between 0.1 and 200.');
      return null;
    }
    if (archLength != null && (archLength < 0.1 || archLength > 200)) {
      debugPrint('Error: Arch length must be between 0.1 and 200.');
      return null;
    }
    if (heelToToeDiagonal != null &&
        (heelToToeDiagonal < 0.1 || heelToToeDiagonal > 200)) {
      debugPrint('Error: Heel-to-toe diagonal must be between 0.1 and 200.');
      return null;
    }

    // Perform the search logic
    final measurements = fetchAllMeasurements();
    Measurement? bestMatch;
    double smallestDifference = double.infinity;

    for (var measurement in measurements) {
      if (measurement.category == category) {
        final shoeSizeError =
            (measurement.shoeSize - shoeSize).abs() / shoeSize;
        final footLengthError =
            (measurement.footLength - footLength).abs() / footLength;
        final footWidthHeelError =
            (measurement.footWidthHeel - footWidthHeel).abs() / footWidthHeel;
        final footWidthForefootError =
            (measurement.footWidthForefoot - footWidthForefoot).abs() /
                footWidthForefoot;

        final toeBoxWidthError =
            toeBoxWidth != null && measurement.toeBoxWidth != null
                ? (measurement.toeBoxWidth! - toeBoxWidth).abs() / toeBoxWidth
                : 0.0;
        final archLengthError =
            archLength != null && measurement.archLength != null
                ? (measurement.archLength! - archLength).abs() / archLength
                : 0.0;
        final heelToToeDiagonalError =
            heelToToeDiagonal != null && measurement.heelToToeDiagonal != null
                ? (measurement.heelToToeDiagonal! - heelToToeDiagonal).abs() /
                    heelToToeDiagonal
                : 0.0;

        if (shoeSizeError <= 0.15 &&
            footLengthError <= 0.15 &&
            footWidthHeelError <= 0.15 &&
            footWidthForefootError <= 0.15 &&
            (toeBoxWidth == null || toeBoxWidthError <= 0.15) &&
            (archLength == null || archLengthError <= 0.15) &&
            (heelToToeDiagonal == null || heelToToeDiagonalError <= 0.15)) {
          final totalDifference = shoeSizeError +
              footLengthError +
              footWidthHeelError +
              footWidthForefootError +
              toeBoxWidthError +
              archLengthError +
              heelToToeDiagonalError;

          if (totalDifference < smallestDifference) {
            smallestDifference = totalDifference;
            bestMatch = measurement;
          }
        }
      }
    }
    return bestMatch;
  }

  Future<void> deleteMeasurement(int key) async {
    await _measurementBox.delete(key);
  }

  // Close the database box
  Future<void> close() async {
    await _measurementBox.close();
  }
}

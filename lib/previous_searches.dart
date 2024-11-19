import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'measurement.dart';

class PreviousSearchesPage extends StatefulWidget {
  @override
  _PreviousSearchesPageState createState() => _PreviousSearchesPageState();
}

class _PreviousSearchesPageState extends State<PreviousSearchesPage> {
  List<Measurement> _previousSearches = [];

  @override
  void initState() {
    super.initState();
    _loadPreviousSearches();
  }

  // Load previous searches directly from the Hive box
  Future<void> _loadPreviousSearches() async {
    final box = await Hive.openBox<Measurement>('previous_searches');
    setState(() {
      _previousSearches = box.values.toList();
    });
  }

  // Delete a specific search entry directly from the Hive box
  Future<void> _deleteSearch(int index) async {
    final box = await Hive.openBox<Measurement>('previous_searches');
    await box.deleteAt(index);
    _loadPreviousSearches(); // Reload the list after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Searches'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _previousSearches.length,
          itemBuilder: (context, index) {
            final measurement = _previousSearches[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${measurement.shoeName}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Category: ${measurement.category}'),
                          Text('Gender: ${measurement.gender}'),
                          Text('Shoe Size: ${measurement.shoeSize} cm'),
                          Text('Foot Length: ${measurement.footLength} cm'),
                          Text(
                              'Foot Width Heel: ${measurement.footWidthHeel} cm'),
                          Text(
                              'Foot Width Forefoot: ${measurement.footWidthForefoot} cm'),
                          if (measurement.toeBoxWidth !=
                              null) // Optional display
                            Text(
                                'Toe Box Width: ${measurement.toeBoxWidth} cm'),
                          if (measurement.archLength !=
                              null) // Optional display
                            Text('Arch Length: ${measurement.archLength} cm'),
                          if (measurement.heelToToeDiagonal !=
                              null) // Optional display
                            Text(
                                'Heel-to-Toe Diagonal: ${measurement.heelToToeDiagonal} cm'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () => _deleteSearch(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

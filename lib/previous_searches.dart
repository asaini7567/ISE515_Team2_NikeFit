import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'measurement.dart';
import 'package:url_launcher/url_launcher.dart';

class PreviousSearchesPage extends StatefulWidget {
  const PreviousSearchesPage({Key? key}) : super(key: key);

  @override
  State<PreviousSearchesPage> createState() => _PreviousSearchesPageState();
}

class _PreviousSearchesPageState extends State<PreviousSearchesPage> {
  late Box<Measurement> _searchedBox;

  @override
  void initState() {
    super.initState();
    _searchedBox =
        Hive.box<Measurement>('previous_searches'); // Initialize Hive box
  }

  void _deleteShoe(int index) {
    try {
      setState(() {
        _searchedBox.deleteAt(index); // Delete the item at the specified index
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shoe deleted successfully')),
      );
    } catch (e) {
      debugPrint('Error deleting shoe: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting shoe')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Previous Searches',
          style: TextStyle(
              color: Colors.white, fontFamily: 'CustomFont', fontSize: 32),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: ValueListenableBuilder(
        valueListenable: _searchedBox.listenable(),
        builder: (context, Box<Measurement> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text('No previous searches found.'),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final measurement = box.getAt(index) as Measurement;

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              measurement.shoeName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Category: ${measurement.category}'),
                            Text('Shoe Size: ${measurement.shoeSize}'),
                            Text('Foot Length: ${measurement.footLength} cm'),
                            Text('Heel Width: ${measurement.footWidthHeel} cm'),
                            Text(
                                'Forefoot Width: ${measurement.footWidthForefoot} cm'),
                            if (measurement.toeBoxWidth != null)
                              Text(
                                  'Toe Box Width: ${measurement.toeBoxWidth} cm'),
                            if (measurement.archLength != null)
                              Text('Arch Length: ${measurement.archLength} cm'),
                            if (measurement.heelToToeDiagonal != null)
                              Text(
                                  'Heel-To-Toe Diagonal: ${measurement.heelToToeDiagonal} cm'),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteShoe(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

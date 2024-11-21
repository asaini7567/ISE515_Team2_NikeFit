import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'measurement.dart';
import 'package:url_launcher/url_launcher.dart';

class PreviousSearchesPage extends StatefulWidget {
  const PreviousSearchesPage({Key? key}) : super(key: key);
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

  void saveSearch(Measurement measurement) {
    final box = Hive.box<Measurement>('searchedShoes');
    //box.add(measurement);
    setState(() {
      _previousSearches = box.values.toList(); // Update the local list
    });
  }

  // Delete a search from Hive
  void deleteSearch(int index) {
    final box = Hive.box<Measurement>('searchedShoes');
    setState(() {
      box.deleteAt(index); // Remove from Hive
      _previousSearches.removeAt(index); // Update the local list
    });
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
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
          centerTitle: true,
          backgroundColor: Colors.blue,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: _previousSearches.length,
            itemBuilder: (context, index) {
              final measurement = _previousSearches[index];
              return Card(
                color: Colors.white,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: GestureDetector(
                    onTap: () => _launchURL(measurement.link),
                    child: Text(
                      measurement.shoeName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category: ${measurement.category}'),
                      Text('Shoe Size: ${measurement.shoeSize}'),
                      Text('Foot Length: ${measurement.footLength} cm'),
                      Text('Heel Width: ${measurement.footWidthHeel} cm'),
                      Text(
                          'Forefoot Width: ${measurement.footWidthForefoot} cm'),
                      if (measurement.toeBoxWidth != null)
                        Text('Toe Box Width: ${measurement.toeBoxWidth} cm'),
                      if (measurement.archLength != null)
                        Text('Arch Length: ${measurement.archLength} cm'),
                      if (measurement.heelToToeDiagonal != null)
                        Text(
                            'Heel-to-Toe Diagonal: ${measurement.heelToToeDiagonal} cm'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteSearch(measurement.key),
                  ),
                ),
              );
            },
          ),
        ));
  }
}

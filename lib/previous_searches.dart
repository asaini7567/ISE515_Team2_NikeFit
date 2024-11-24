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
          final shoes = box.values.toList();

          if (shoes.isEmpty) {
            return const Center(
              child: Text('No previous searches found.'),
            );
          }

          return ListView.builder(
            itemCount: shoes.length,
            itemBuilder: (context, index) {
              final shoe = shoes[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set background color to white
                    borderRadius:
                        BorderRadius.circular(8.0), // Optional: Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3), // Optional shadow
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: const Offset(0, 3), // Position of shadow
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse(shoe.link);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch ${shoe.link}';
                        }
                      },
                      child: Text(
                        shoe.shoeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Category: ${shoe.category}'),
                        Text('Shoe Size: ${shoe.shoeSize}'),
                        Text('Foot Length: ${shoe.footLength} cm'),
                        Text('Heel Width: ${shoe.footWidthHeel} cm'),
                        Text('Forefoot Width: ${shoe.footWidthForefoot} cm'),
                        if (shoe.toeBoxWidth != null)
                          Text('Toe Box Width: ${shoe.toeBoxWidth} cm'),
                        if (shoe.archLength != null)
                          Text('Arch Length: ${shoe.archLength} cm'),
                        if (shoe.heelToToeDiagonal != null)
                          Text(
                              'Heel-To-Toe Diagonal: ${shoe.heelToToeDiagonal} cm'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        box.deleteAt(index);
                      },
                    ),
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

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'measurement.dart';

class ShoeMatchScreen extends StatelessWidget {
  final List<Measurement> matches;

  const ShoeMatchScreen({Key? key, required this.matches}) : super(key: key);

  // Function to launch the URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shoe Matches',
          style: TextStyle(
              color: Colors.white, fontFamily: 'CustomFont', fontSize: 32),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: matches.isEmpty
          ? const Center(
              child: Text('No matches found.'),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Center left: Shoe stats
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.topLeft, // Align upward
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => _launchURL(matches.first.link),
                              child: Text(
                                matches.first.shoeName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text('Category: ${matches.first.category}'),
                            Text('Shoe Size: ${matches.first.shoeSize}'),
                            Text('Foot Length: ${matches.first.footLength} cm'),
                            Text(
                                'Heel Width: ${matches.first.footWidthHeel} cm'),
                            Text(
                                'Forefoot Width: ${matches.first.footWidthForefoot} cm'),
                            if (matches.first.toeBoxWidth != null)
                              Text(
                                  'Toe Box Width: ${matches.first.toeBoxWidth} cm'),
                            if (matches.first.archLength != null)
                              Text(
                                  'Arch Length: ${matches.first.archLength} cm'),
                            if (matches.first.heelToToeDiagonal != null)
                              Text(
                                  'Heel-To-Toe Diagonal: ${matches.first.heelToToeDiagonal} cm'),
                          ],
                        ),
                      ),
                    ),
                    // Center right: Shoe image as a square
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.all(20),
                        child: GestureDetector(
                          onTap: () => _launchURL(matches.first.link),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10), // Optional: Rounded corners
                            child: Image.asset(
                              matches.first.imageUrl,
                              width: 200, // Set a fixed width for square
                              height: 200, // Match height to width for square
                              fit: BoxFit
                                  .cover, // Ensures the image covers the box
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Runner-up shoes
                if (matches.length > 1)
                  Expanded(
                    child: ListView.builder(
                      itemCount: matches.length - 1,
                      itemBuilder: (context, index) {
                        final runnerUp = matches[index + 1];
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Set individual shoe background to white
                              borderRadius: BorderRadius.circular(
                                  10), // Optional: rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(
                                      0.5), // Optional: subtle shadow
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3), // Shadow position
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: GestureDetector(
                                onTap: () => _launchURL(runnerUp.link),
                                child: Text(
                                  runnerUp.shoeName,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Category: ${runnerUp.category}'),
                                  Text('Shoe Size: ${runnerUp.shoeSize}'),
                                  Text(
                                      'Foot Length: ${runnerUp.footLength} cm'),
                                  Text(
                                      'Heel Width: ${runnerUp.footWidthHeel} cm'),
                                  Text(
                                      'Forefoot Width: ${runnerUp.footWidthForefoot} cm'),
                                  if (runnerUp.toeBoxWidth != null)
                                    Text(
                                        'Toe Box Width: ${runnerUp.toeBoxWidth} cm'),
                                  if (runnerUp.archLength != null)
                                    Text(
                                        'Arch Length: ${runnerUp.archLength} cm'),
                                  if (runnerUp.heelToToeDiagonal != null)
                                    Text(
                                        'Heel-To-Toe Diagonal: ${runnerUp.heelToToeDiagonal} cm'),
                                ],
                              ),
                              trailing: GestureDetector(
                                onTap: () => _launchURL(runnerUp.link),
                                child: Image.asset(
                                  runnerUp.imageUrl,
                                  fit: BoxFit.cover,
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
    );
  }
}

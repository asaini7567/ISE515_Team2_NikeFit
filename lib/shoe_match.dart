import 'package:flutter/material.dart';
import 'measurement.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ShoeMatchScreen extends StatelessWidget {
  final Measurement matchingShoe;

  const ShoeMatchScreen({Key? key, required this.matchingShoe})
      : super(key: key);

  // Function to open the link
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
          'Matching Shoe',
          style: TextStyle(
              color: Colors.white, fontFamily: 'CustomFont', fontSize: 32),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Left side: Shoe details centered vertically
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${matchingShoe.shoeName}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text('Category: ${matchingShoe.category}'),
                    Text('Shoe Size: ${matchingShoe.shoeSize}'),
                    Text('Foot Length: ${matchingShoe.footLength} cm'),
                    Text('Foot Width (Heel): ${matchingShoe.footWidthHeel} cm'),
                    Text(
                        'Foot Width (Forefoot): ${matchingShoe.footWidthForefoot} cm'),
                    if (matchingShoe.toeBoxWidth != null)
                      Text('Toe Box Width: ${matchingShoe.toeBoxWidth} cm'),
                    if (matchingShoe.archLength != null)
                      Text('Arch Length: ${matchingShoe.archLength} cm'),
                    if (matchingShoe.heelToToeDiagonal != null)
                      Text(
                          'Heel-to-Toe Diagonal: ${matchingShoe.heelToToeDiagonal} cm'),
                  ],
                ),
              ),
            ),
          ),

          // Right: Shoe Image with Link
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () => _launchURL(matchingShoe.link),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  matchingShoe.imageUrl, // Use the image from pubspec.yaml
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, size: 50),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // Ensures the column takes minimal vertical space
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 200, // Set the desired button width
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Return to the Home page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Return to Home',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'measurement.dart';

class ShoeMatchScreen extends StatelessWidget {
  final Measurement matchingShoe;

  const ShoeMatchScreen({Key? key, required this.matchingShoe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shoe Match'),
        backgroundColor: Colors.blue,
      ),
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
                      'Shoe Name: ${matchingShoe.shoeName}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text('Category: ${matchingShoe.category}'),
                    Text('Gender: ${matchingShoe.gender}'),
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

          // Right side: Centered image
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  'images/shoe_image.jpg', // Replace with the actual path of your image
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Return to the Home page
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          child: const Text('Return to Home',
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'measurement.dart';

class ShoeCard extends StatelessWidget {
  final Measurement shoe;
  final VoidCallback onDelete; // Callback function to handle deletion

  const ShoeCard({Key? key, required this.shoe, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  shoe.shoeName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete, // Call the delete function
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Category: ${shoe.category}'),
            Text('Size: ${shoe.shoeSize}'),
            Text('Foot Length: ${shoe.footLength} cm'),
            Text('Heel Width: ${shoe.footWidthHeel} cm'),
            Text('Forefoot Width: ${shoe.footWidthForefoot} cm'),
            if (shoe.toeBoxWidth != null)
              Text('Toe Box Width: ${shoe.toeBoxWidth} cm'),
            if (shoe.archLength != null)
              Text('Arch Length: ${shoe.archLength} cm'),
            if (shoe.heelToToeDiagonal != null)
              Text('Heel-to-Toe Diagonal: ${shoe.heelToToeDiagonal} cm'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nike_fit_website/home.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Foot Measurement Tutorial',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue, // Set the AppBar color to blue
        iconTheme: const IconThemeData(
            color: Colors.white), // Set the arrow color to white
      ),
      backgroundColor: Colors.white, // Set the page background color to white
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left side: Image
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      'images/foot measuring.jpg', // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16), // Space between image and text

                  // Right side: Centered text
                  const Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Preparation:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Ensure you have a flat piece of white paper large enough to trace your entire foot.\n"
                          "Have a pen, pencil, or marker, and a measuring tape or ruler.\n"
                          "Remove any socks or footwear for accuracy.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Steps for Foot Measurement:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Foot Tracing:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "1. Stand or place your foot firmly on the paper.\n"
                          "2. Trace around your foot, keeping the pen/pencil as vertical as possible to minimize errors.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Notes:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Record all measurements in centimeters (cm).\n"
                          "For increased accuracy, repeat the measurements for the opposite foot as sizes may differ.\n"
                          "Additional measurements can be taken for more detailed analysis if desired.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom-centered button
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Set the button color to blue
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: const Text(
                'Return to Home',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/*
class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tutorial',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue, // Set the AppBar color to blue
        iconTheme: const IconThemeData(
            color: Colors.white), // Set the arrow color to white
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 20.0), // Move the button up by 20 pixels
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Set the button color to blue
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15), // Increase vertical padding
                ),
                child: const Text(
                  'Return to Home',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/
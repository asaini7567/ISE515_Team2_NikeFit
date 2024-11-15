import 'package:flutter/material.dart';
import 'package:nike_fit_website/home.dart';

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

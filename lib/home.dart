import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'database_helper.dart';
import 'tutorial.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = Auth().currentUser;

  // Controllers for each measurement field
  final TextEditingController _footLengthController = TextEditingController();
  final TextEditingController _footWidthHeelController =
      TextEditingController();
  final TextEditingController _footWidthForefootController =
      TextEditingController();
  final TextEditingController _toeBoxWidthController = TextEditingController();
  final TextEditingController _archLengthController = TextEditingController();
  final TextEditingController _heelToToeDiagonalController =
      TextEditingController();
  final TextEditingController _shoeSizeController =
      TextEditingController(); // New controller for shoe size

  String _selectedCategory = 'Casual'; // Default selected category
  final List<String> _categories = [
    'Casual',
    'Sports',
    'Running',
    'Formal'
  ]; // Categories list

  // Toggle button variables
  List<bool> _isSelected = [true, false]; // Default to "Men"
  String _gender = "Men"; // Holds the selected gender

  Future<void> signOut() async {
    await Auth().signOut();
  }

  // Function to save measurement to database
  Future<void> _saveMeasurement() async {
    // Check for empty required fields
    if (_selectedCategory.isEmpty ||
        _shoeSizeController.text.isEmpty ||
        _footLengthController.text.isEmpty ||
        _footWidthHeelController.text.isEmpty ||
        _footWidthForefootController.text.isEmpty) {
      // Show error message if any required field is blank
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
      return; // Exit the function without saving
    }

    // Proceed to save if all required fields are filled
    final measurement = {
      'name': 'Custom Measurement', // Set a name or get from user if needed
      'category': _selectedCategory,
      'shoe_size': double.tryParse(_shoeSizeController.text) ?? 0.0,
      'foot_length': double.tryParse(_footLengthController.text) ?? 0.0,
      'foot_width_heel': double.tryParse(_footWidthHeelController.text) ?? 0.0,
      'foot_width_forefoot':
          double.tryParse(_footWidthForefootController.text) ?? 0.0,
      'toe_box_width': double.tryParse(_toeBoxWidthController.text) ?? 0.0,
      'arch_length': double.tryParse(_archLengthController.text) ?? 0.0,
      'heel_to_toe_diagonal':
          double.tryParse(_heelToToeDiagonalController.text) ?? 0.0,
      'gender': _gender // Save the gender selection
    };

    await DatabaseHelper.instance.insertMeasurement(measurement);
    _clearFields();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Measurement saved to database')),
    );
  }

  // Clear all text fields
  void _clearFields() {
    _shoeSizeController.clear();
    _footLengthController.clear();
    _footWidthHeelController.clear();
    _footWidthForefootController.clear();
    _toeBoxWidthController.clear();
    _archLengthController.clear();
    _heelToToeDiagonalController.clear();
  }

  Widget _userID() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      onPressed: signOut,
      child: const Text(
        'Sign Out',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _tutorialButton(context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const TutorialScreen()));
      },
      child: const Text(
        'Tutorial',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Left side: Image
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'images/Foot Measurement Diagram.jpg', // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Right side: Measurements and fields
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // User ID and Sign Out Button
                  Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _userID(),
                        const SizedBox(height: 10),
                        _signOutButton(),
                        const SizedBox(height: 10),
                        _tutorialButton(context),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Dropdown for Category
                  const Text(
                    "Category",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 200, // Set a specific width for the dropdown menu
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                      dropdownColor: Colors.white,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor:
                            Colors.white, // Set the background color to white
                        border: OutlineInputBorder(),
                        labelText: "Select Category",
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Shoe Size Text Field with Gender Toggle Button
                  const Text(
                    "Shoe Size (US)",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _shoeSizeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Enter Shoe Size",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(
                          width:
                              10), // Space between text field and toggle button
                      Expanded(
                        flex: 1,
                        child: ToggleButtons(
                          fillColor: Colors.white,
                          selectedColor: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                          isSelected: _isSelected,
                          onPressed: (int index) {
                            setState(() {
                              // Toggle selection
                              for (int i = 0; i < _isSelected.length; i++) {
                                _isSelected[i] = i == index;
                              }
                              // Set gender based on selection
                              _gender = _isSelected[0] ? "Men" : "Women";
                            });
                          },
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Men"),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Women"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Measurements section
                  const Text(
                    "Measurements (in cm):",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Measurement 1
                  const Text(
                    "Foot Length",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _footLengthController,
                    decoration: const InputDecoration(
                      labelText: "Enter Foot Length (cm)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Measurement 2
                  const Text(
                    "Foot Width at the Heel",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _footWidthHeelController,
                    decoration: const InputDecoration(
                      labelText: "Enter Foot Width at the Heel (cm)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Measurement 3
                  const Text(
                    "Foot Width at the Forefoot",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _footWidthForefootController,
                    decoration: const InputDecoration(
                      labelText: "Enter Foot Width at the Forefoot (cm)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Additional measurement fields (optional)
                  const Text(
                    "Toe Box Width",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _toeBoxWidthController,
                    decoration: const InputDecoration(
                      labelText: "Enter Toe Box Width (cm)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Arch Length
                  const Text(
                    "Arch Length",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _archLengthController,
                    decoration: const InputDecoration(
                      labelText: "Enter Arch Length (cm)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Heel-to-Toe Diagonal
                  const Text(
                    "Heel-to-Toe Diagonal",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _heelToToeDiagonalController,
                    decoration: const InputDecoration(
                      labelText: "Enter Heel-to-Toe Diagonal (cm)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Save Button
                  ElevatedButton(
                    onPressed: _saveMeasurement,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Save Measurement',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}




/*
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _userID() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      onPressed: signOut,
      child: const Text(
        'Sign Out',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _tutorialButton(context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const TutorialScreen()));
      },
      child: const Text(
        'Tutorial',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Left side: Image
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'images/Foot Measurement Diagram.jpg', // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Right side: Measurements and fields
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // User ID and Sign Out Button
                  Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _userID(),
                        const SizedBox(height: 10),
                        _signOutButton(),
                        const SizedBox(height: 10),
                        _tutorialButton(context),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Measurements section
                  const Text(
                    "Measurements (in cm):",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Measurement 1
                  const Text(
                    "Foot Length - Measure the longest distance from the tip of the longest toe to the back of the heel on the outline.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: "Enter Foot Length (cm)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Measurement 2
                  const Text(
                    "Foot Width at the Heel - Measure the widest point at the heel.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: "Enter Foot Width at the Heel (cm)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Measurement 3
                  const Text(
                    "Foot Width at the Forefoot - Measure the widest point where the toes begin, across the ball of the foot.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: "Enter Foot Width at the Forefoot (cm)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Measurement 4
                  const Text(
                    "Toe Box Width - Measure across the widest part of the toe area (typically at the base of the big toe to the base of the pinky toe).",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: "Enter Toe Box Width (cm)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Measurement 5
                  const Text(
                    "Arch Length - Measure from the heel to the highest point of the arch (follow the natural curve).",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: "Enter Arch Length (cm)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Measurement 6
                  const Text(
                    "Heel-to-Toe Diagonal - Measure diagonally from the heel to the tip of the longest toe.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: "Enter Heel-to-Toe Diagonal (cm)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/


/*
class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _userID() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      onPressed: signOut,
      child: const Text(
        'Sign Out',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _tutorialButton(context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const TutorialScreen()));
      },
      child: const Text(
        'Tutorial',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _userID(),
              const SizedBox(height: 10),
              _signOutButton(),
              const SizedBox(height: 20),
              _tutorialButton(context),
            ],
          )),
    );
  }
}
*/
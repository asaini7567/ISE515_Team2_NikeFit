import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'database_helper.dart';
import 'tutorial.dart';
import 'measurement.dart';
import 'shoe_match.dart';
import 'previous_searches.dart';

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
    'Running'
  ]; // Categories list

  // Toggle button variables
  List<bool> _isSelected = [true, false]; // Default to "Men"
  String _gender = "Men"; // Holds the selected gender

  Future<void> signOut() async {
    await Auth().signOut();
  }

  String genderSelected = '';

  // Function to search shoe based on user input
  Future<void> _searchShoe() async {
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
      return; // Exit the function without searching
    }

    // Proceed to search if all required fields are filled
    final category = _selectedCategory;
    final shoeSize = double.tryParse(_shoeSizeController.text) ?? 0.0;
    final footLength = double.tryParse(_footLengthController.text) ?? 0.0;
    final footWidthHeel = double.tryParse(_footWidthHeelController.text) ?? 0.0;
    final footWidthForefoot =
        double.tryParse(_footWidthForefootController.text) ?? 0.0;

    final matchingShoe = DatabaseHelper.instance.searchMeasurement(
      category: category,
      shoeSize: shoeSize,
      footLength: footLength,
      footWidthHeel: footWidthHeel,
      footWidthForefoot: footWidthForefoot,
      gender: _gender,
    );

    if (matchingShoe != null) {
      await DatabaseHelper.instance.saveSearchedShoe(matchingShoe);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShoeMatchScreen(matchingShoe: matchingShoe),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No matching shoe found.')),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
              color: Colors.white, fontFamily: 'CustomFont', fontSize: 32),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side: Tutorial and Previous Searches buttons
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TutorialScreen()),
                        );
                      },
                      child: const Text(
                        'Tutorial',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10), // Space between buttons

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PreviousSearchesPage()),
                        );
                      },
                      child: const Text(
                        'Previous Searches',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                // Right side: User ID and Sign Out button
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _userID(),
                    const SizedBox(height: 10),
                    _signOutButton(),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                // Left side: Image
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset(
                      'images/Foot Measurement Diagram.jpg',
                      fit: BoxFit.contain,
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
                          width:
                              200, // Set a specific width for the dropdown menu
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
                              fillColor: Colors
                                  .white, // Set the background color to white
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

                        // Foot Length
                        const Text(
                          "Foot Length (Required)",
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

                        // Foot Width at the Heel
                        const Text(
                          "Foot Width at the Heel (Required)",
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

                        // Foot Width at the Forefoot
                        const Text(
                          "Foot Width at the Forefoot (Required)",
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

                        // Toe Box Width
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

                        // Search Shoe Button
                        ElevatedButton(
                          onPressed: _searchShoe,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                            'Search Shoe',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


/*
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
  final TextEditingController _shoeSizeController = TextEditingController();

  String _selectedCategory = 'Casual';
  final List<String> _categories = ['Casual', 'Sports', 'Running', 'Formal'];

  List<bool> _isSelected = [true, false];
  String _gender = "Men";

  @override
  void initState() {
    super.initState();
    debugPrint("HomeScreen initialized with current user: ${user?.email}");
  }

  Future<void> signOut() async {
    debugPrint("Sign out button pressed.");
    await Auth().signOut();
    debugPrint("User signed out.");
  }

  Widget _userID() {
    debugPrint("Displaying user ID: ${user?.email}");
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
        debugPrint("Tutorial button pressed.");
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
                'images/Foot Measurement Diagram.jpg',
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 200,
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
                        debugPrint("Category selected: $_selectedCategory");
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: "Select Category",
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Shoe Size Text Field with Gender Toggle Button
                  const Text(
                    "Shoe Size (US)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: ToggleButtons(
                          borderRadius: BorderRadius.circular(10),
                          isSelected: _isSelected,
                          onPressed: (int index) {
                            setState(() {
                              for (int i = 0; i < _isSelected.length; i++) {
                                _isSelected[i] = i == index;
                              }
                              _gender = _isSelected[0] ? "Men" : "Women";
                            });
                            debugPrint("Gender selected: $_gender");
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

                  // Measurement fields
                  const Text("Foot Length", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _footLengthController,
                    decoration: const InputDecoration(
                      labelText: "Enter Foot Length (cm)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text("Foot Width at the Heel",
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _footWidthHeelController,
                    decoration: const InputDecoration(
                      labelText: "Enter Foot Width at the Heel (cm)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text("Foot Width at the Forefoot",
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _footWidthForefootController,
                    decoration: const InputDecoration(
                      labelText: "Enter Foot Width at the Forefoot (cm)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text("Toe Box Width", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _toeBoxWidthController,
                    decoration: const InputDecoration(
                      labelText: "Enter Toe Box Width (cm)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text("Arch Length", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _archLengthController,
                    decoration: const InputDecoration(
                      labelText: "Enter Arch Length (cm)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text("Heel-to-Toe Diagonal",
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _heelToToeDiagonalController,
                    decoration: const InputDecoration(
                      labelText: "Enter Heel-to-Toe Diagonal (cm)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Search Shoe Button
                  ElevatedButton(
                    onPressed: () async {
                      debugPrint("Search Shoe button pressed.");

                      // Check for empty required fields
                      if (_selectedCategory.isEmpty ||
                          _shoeSizeController.text.isEmpty ||
                          _footLengthController.text.isEmpty ||
                          _footWidthHeelController.text.isEmpty ||
                          _footWidthForefootController.text.isEmpty) {
                        debugPrint("Required fields are missing.");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Please fill in all required fields.')),
                        );
                        return;
                      }

                      // Parse required inputs
                      final double shoeSize =
                          double.tryParse(_shoeSizeController.text) ?? 0.0;
                      final double footLength =
                          double.tryParse(_footLengthController.text) ?? 0.0;
                      final double footWidthHeel =
                          double.tryParse(_footWidthHeelController.text) ?? 0.0;
                      final double footWidthForefoot =
                          double.tryParse(_footWidthForefootController.text) ??
                              0.0;

                      debugPrint("Parsed required inputs:");
                      debugPrint("Category: $_selectedCategory");
                      debugPrint("Shoe Size: $shoeSize");
                      debugPrint("Foot Length: $footLength");
                      debugPrint("Foot Width Heel: $footWidthHeel");
                      debugPrint("Foot Width Forefoot: $footWidthForefoot");

                      // Parse optional inputs
                      final double? toeBoxWidth =
                          _toeBoxWidthController.text.isNotEmpty
                              ? double.tryParse(_toeBoxWidthController.text)
                              : null;
                      final double? archLength =
                          _archLengthController.text.isNotEmpty
                              ? double.tryParse(_archLengthController.text)
                              : null;
                      final double? heelToToeDiagonal =
                          _heelToToeDiagonalController.text.isNotEmpty
                              ? double.tryParse(
                                  _heelToToeDiagonalController.text)
                              : null;

                      if (toeBoxWidth != null)
                        debugPrint("Toe Box Width: $toeBoxWidth");
                      if (archLength != null)
                        debugPrint("Arch Length: $archLength");
                      if (heelToToeDiagonal != null)
                        debugPrint("Heel to Toe Diagonal: $heelToToeDiagonal");

                      // Search for the closest match
                      final result =
                          await DatabaseHelper.instance.searchMeasurement(
                        _selectedCategory,
                        shoeSize,
                        footLength,
                        footWidthHeel,
                        footWidthForefoot,
                        toeBoxWidth: toeBoxWidth,
                        archLength: archLength,
                        heelToToeDiagonal: heelToToeDiagonal,
                      );

                      debugPrint("Search result: $result");

                      if (result != null) {
                        debugPrint(
                            "Navigating to ShoeMatchScreen with result.");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ShoeMatchScreen(shoeData: result),
                          ),
                        );
                      } else {
                        debugPrint("No matching shoe found.");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('No matching shoe found.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Search Shoe',
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
*/
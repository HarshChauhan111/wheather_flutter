import 'package:flutter/material.dart';

class CitySearch extends StatefulWidget {
  final Function(String) onCitySelected;

  const CitySearch({super.key, required this.onCitySelected});

  @override
  CitySearchState createState() => CitySearchState();
}

class CitySearchState extends State<CitySearch> {
  TextEditingController controller = TextEditingController();
  List<String> _suggestions = [];

  void _getSuggestions(String query) {
    // Example static list of cities
    List<String> allCities = [
      'Rajkot',
      'Mumbai',
      'Delhi',
      'Bangalore',
      'Chennai',
      'Ahmedabad',
      'Hyderabad',
      'Kolkata',
      'Pune',
      'Jaipur',
      'Surat',
      'Lucknow',
      'Kanpur',
      'Nagpur',
      'Visakhapatnam',
      'Guwahati',
      'Coimbatore',
      'Mysore',
      'Vadodara',
      'Agra',
      'Nashik',
      'Faridabad',
      'Ghaziabad',
      'Noida',
      'Meerut',
      'Dehradun',
      'Ranchi',
      'Jamshedpur',
      'Vijayawada',
      'Kochi',
      'Kozhikode',
      'Tiruchirappalli',
      'Madurai',
      'Tirupati',
      'Amritsar',
      'Ludhiana',
      'Jalandhar',
      'Patiala',
      'Srinagar',
      'Shimla',
      'Mussoorie',
      'Nainital',
      'Rishikesh',
      'Haridwar',
      'Udaipur',
      'Ajmer',
      'Jodhpur',
      'Bikaner',
      'Chandigarh',
      'Ambala',
      'Kurukshetra',
      'Sonipat',
      'Panipat',
      'Rohtak',
      'Hisar',
      'Fatehabad',
      'Sirsa',
      'Bhiwani',
      'Jhajjar',
      'Rewari',
      'Mewat',
      'Gurgaon',
      'Palwal',
      'Yamunanagar',
      'Karnal',
      'Kaithal',
    ];

    setState(() {
      _suggestions = allCities
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });

    // Debugging: Print the suggestions
    print('Suggestions: $_suggestions');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, // Increased height for better visibility
      child: Column(
        children: [
          TextField(
  controller: controller,
  onChanged: (value) {
    _getSuggestions(value);
  },
  decoration: InputDecoration(
    hintText: 'Search for a city',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0), // Set the border radius
      borderSide: BorderSide(color: Colors.grey), // Optional: Set border color
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0), // Set the border radius for enabled state
      borderSide: BorderSide(color: Colors.grey), // Optional: Set border color
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0), // Set the border radius for focused state
      borderSide: BorderSide(color: Colors.blue), // Optional: Set border color when focused
    ),
    prefixIcon: Icon(Icons.search), // Add search icon
  ),
),
          Expanded(
            child: ListView.builder(
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_suggestions[index]),
                  onTap: () {
                    widget.onCitySelected(_suggestions[index]); // Call the callback
                    controller.text = _suggestions[index]; // Update TextField
                    _suggestions.clear(); // Clear suggestions
                    setState(() {}); // Trigger a rebuild to clear the list
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
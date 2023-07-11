import 'package:flutter/material.dart';

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  double _distanceValue = 20.0;
  double _durationValue = 30.0;
  bool _outdoor = false;

  List<String> activity = [
    'Outdoor',
    'Indoor',
    'Watersport',
    'Camping',
    'Travel groups'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, size: 28)),
        title: const Text('Configure your suggestions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('Location', style: TextStyle(fontSize: 20)),
            subtitle: Slider(
              value: _distanceValue,
              min: 0.0,
              max: 100.0,
              divisions: 5,
              activeColor: Colors.deepPurple,
              onChanged: (value) {
                setState(() {
                  _distanceValue = value;
                });
              },
            ),
            trailing: Text('${_distanceValue.toInt()} km'),
          ),
          const SizedBox(height: 15),
          const Text('Select your prefered activities',
              style: TextStyle(fontSize: 20)),
          const SizedBox(height: 15),

          Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: activity.map((tag) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 7.0, horizontal: 10.0),
                  child: Text(tag),
                ),
              );
            }).toList(),
          ),
          // Add more preferences as needed
        ],
      ),
    );
  }
}

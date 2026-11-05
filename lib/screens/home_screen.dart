import 'package:flutter/material.dart';
import 'form_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State variables for Section D
  bool _isAccessibilityMode = false;
  String _statusMessage = "Standard Grip Mode Active";

  void _toggleMode() {
    setState(() {
      _isAccessibilityMode = !_isAccessibilityMode;
      
      // Real decision using if/else (Section D requirement)
      if (_isAccessibilityMode) {
        _statusMessage = "Enhanced One-Handed & Accessibility Grip Enabled!";
      } else {
        _statusMessage = "Standard Grip Mode Active";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MagiPage Book Holder'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome to MagiPage!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'The ultimate magnetic book holder designed for paperback lovers and readers with accessibility needs.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            
            // State display box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isAccessibilityMode ? Colors.indigo.shade50 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: Column(
                children: [
                  Text(_statusMessage, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _toggleMode,
                    child: const Text('Toggle Grip Mode'),
                  ),
                ],
              ),
            ),
            
            const Spacer(),

            // Navigation to Form Screen (Section C)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
              icon: const Icon(Icons.edit),
              label: const Text('Check Book Compatibility Form'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            // Navigation to List/Detail Screen (Section E)
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: Colors.indigo),
              icon: const Icon(Icons.list),
              label: const Text('View Compatible Paperback Genres'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DetailScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
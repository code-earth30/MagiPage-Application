import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  // TextEditingController required by Section C
  final TextEditingController _bookController = TextEditingController();

  @override
  void dispose() {
    // Proper disposal required by Section C to prevent memory leaks
    _bookController.dispose();
    super.dispose();
  }

  void _submitBook() {
    if (_bookController.text.trim().isEmpty) {
      // Empty input check showing a SnackBar (Section C requirement)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a book title first!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Success! "${_bookController.text}" is compatible with MagiPage.'),
          backgroundColor: Colors.green,
        ),
      );
      _bookController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compatibility Checker'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Check Your Paperback Size',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Type your paperback novel title below to verify magnetic holder fit:'),
            const SizedBox(height: 20),
            TextField(
              controller: _bookController,
              decoration: const InputDecoration(
                labelText: 'Book Title & Author',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                onPressed: _submitBook,
                child: const Text('Verify Fit'),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// lib/screens/detail_screen.dart
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  final List<String> genres = const [
    'Classic Paperbacks',
    'Pocket Thrillers',
    'Sci-Fi & Fantasy Novels',
    'Historical Fiction',
    'Poetry Collections'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paperback Genres'),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        itemCount: genres.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.bookmark, color: Colors.indigo),
              title: Text(genres[index]),
              subtitle: const Text('Optimized for magnetic holding strength'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenreDetailView(genreName: genres[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class GenreDetailView extends StatelessWidget {
  final String genreName;

  const GenreDetailView({super.key, required this.genreName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(genreName),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Category: $genreName',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 15),
            const Text(
              'The MagiPage magnetic clips are specially calibrated to hold this book category securely without damaging the spine or pages, making hands-free reading seamless for users with limited mobility.',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Genres'),
            ),
          ],
        ),
      ),
    );
  }
}
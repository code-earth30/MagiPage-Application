import 'package:flutter/material.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final List<Map<String, String>> _weeklyBooks = [
    {'title': 'The Great Gatsby', 'genre': 'Classic Paperback', 'pages': '180 pages'},
    {'title': 'Dune (Paperback Edition)', 'genre': 'Sci-Fi', 'pages': '412 pages'},
  ];

  void _showBookDialog({Map<String, String>? existingBook, int? index}) {
    final titleController = TextEditingController(text: existingBook?['title'] ?? '');
    final genreController = TextEditingController(text: existingBook?['genre'] ?? '');
    final pagesController = TextEditingController(text: existingBook?['pages'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existingBook == null ? 'Add New Paperback' : 'Edit Paperback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Book Title')),
            TextField(controller: genreController, decoration: const InputDecoration(labelText: 'Genre')),
            TextField(controller: pagesController, decoration: const InputDecoration(labelText: 'Pages')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                setState(() {
                  if (existingBook == null) {
                    _weeklyBooks.add({
                      'title': titleController.text,
                      'genre': genreController.text.isEmpty ? 'Paperback' : genreController.text,
                      'pages': pagesController.text.isEmpty ? '200 pages' : pagesController.text,
                    });
                  } else {
                    _weeklyBooks[index!] = {
                      'title': titleController.text,
                      'genre': genreController.text,
                      'pages': pagesController.text,
                    };
                  }
                });
                Navigator.pop(context);
              }
            },
            child: Text(existingBook == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _deleteBook(int index) {
    setState(() {
      _weeklyBooks.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Paperback removed from queue'), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Queue & CRUD Manager'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Book',
            onPressed: () => _showBookDialog(),
          ),
        ],
      ),
      body: _weeklyBooks.isEmpty
          ? const Center(child: Text('No books in queue. Tap + to add one!'))
          : ListView.builder(
              itemCount: _weeklyBooks.length,
              itemBuilder: (context, index) {
                final book = _weeklyBooks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.menu_book, color: Colors.orange),
                    title: Text(book['title']!),
                    subtitle: Text('${book['genre']} • ${book['pages']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                          onPressed: () => _showBookDialog(existingBook: book, index: index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                          onPressed: () => _deleteBook(index),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailView(
                            bookTitle: book['title']!,
                            genre: book['genre']!,
                            pages: book['pages']!,
                          ),
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

class BookDetailView extends StatelessWidget {
  final String bookTitle;
  final String genre;
  final String pages;

  const BookDetailView({super.key, required this.bookTitle, required this.genre, required this.pages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bookTitle),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bookTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 10),
            Text('Genre: $genre', style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 5),
            Text('Length: $pages', style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),
            const Text(
              'Mounted securely on your MagiPage magnetic book holder for effortless, hands-free reading.',
              style: TextStyle(fontSize: 15, height: 1.4),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Tracker'),
            ),
          ],
        ),
      ),
    );
  }
}
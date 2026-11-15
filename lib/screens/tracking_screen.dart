import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  List<Map<String, String>> _readingQueue = [];

  @override
  void initState() {
    super.initState();
    _loadQueue();
  }

  Future<void> _loadQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final String? queueString = prefs.getString('magipage_reading_queue');
    
    if (queueString != null) {
      final List<dynamic> decodedList = jsonDecode(queueString);
      setState(() {
        _readingQueue = decodedList.map((item) => Map<String, String>.from(item)).toList();
      });
    }
  }

  Future<void> _saveQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(_readingQueue);
    await prefs.setString('magipage_reading_queue', encodedList);
  }

  void _showBookDialog({Map<String, String>? existingBook, int? index}) {
    final titleController = TextEditingController(text: existingBook?['title'] ?? '');
    final genreController = TextEditingController(text: existingBook?['genre'] ?? '');
    final pagesController = TextEditingController(text: existingBook?['pages'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existingBook == null ? 'Add Book to Queue' : 'Edit Book Details', style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Book Title & Author', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: genreController, decoration: const InputDecoration(labelText: 'Genre / Category', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: pagesController, decoration: const InputDecoration(labelText: 'Page Count', border: OutlineInputBorder())),
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
                    _readingQueue.add({
                      'title': titleController.text,
                      'genre': genreController.text.isEmpty ? 'Paperback' : genreController.text,
                      'pages': pagesController.text.isEmpty ? '200 pages' : pagesController.text,
                    });
                  } else {
                    _readingQueue[index!] = {
                      'title': titleController.text,
                      'genre': genreController.text,
                      'pages': pagesController.text,
                    };
                  }
                });
                _saveQueue();
                Navigator.pop(context);
              }
            },
            child: Text(existingBook == null ? 'Add Book' : 'Save Changes'),
          ),
        ],
      ),
    );
  }

  void _deleteBook(int index) {
    setState(() {
      _readingQueue.removeAt(index);
    });
    _saveQueue();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Book removed from queue'), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Reading Queue', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _readingQueue.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.menu_book, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('Your reading queue is empty.', style: GoogleFonts.roboto(fontSize: 18, color: Colors.grey[700])),
                  const SizedBox(height: 8),
                  const Text('Tap the + button below to add your first book!', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _readingQueue.length,
              itemBuilder: (context, index) {
                final book = _readingQueue[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.book, color: Colors.white),
                    ),
                    title: Text(book['title']!, style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text('${book['genre']} • ${book['pages']}', style: TextStyle(color: Colors.grey[600])),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showBookDialog(existingBook: book, index: index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        onPressed: () => _showBookDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Book'),
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
        title: Text(bookTitle, style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bookTitle,
              style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange.shade800),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(label: Text(genre)),
                const SizedBox(width: 8),
                Chip(label: Text(pages)),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Mounted securely on your MagiPage magnetic book holder for effortless, hands-free reading.',
              style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, padding: const EdgeInsets.all(14)),
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Reading Queue', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
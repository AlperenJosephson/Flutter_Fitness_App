
import 'package:flutter/material.dart';
import '../database_helper.dart';


class FavoritesScreen extends StatefulWidget {
  final String userEmail;

  const FavoritesScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _dbHelper.getUserFavorites(widget.userEmail);
    setState(() {
      _favorites = favorites;
    });
  }

  Future<void> _deleteFavorite(int id) async {
    await _dbHelper.deleteFavoriteExercise(id);
    _loadFavorites(); // Listeyi güncelle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favori Egzersizler'),
      ),
      body: _favorites.isEmpty
          ? const Center(child: Text('Henüz favori eklenmedi!'))
          : ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final exercise = _favorites[index];
                return Card(
                  child: ListTile(
                    title: Text(exercise['exercise_name']),
                    subtitle: Text('Kas: ${exercise['muscle']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteFavorite(exercise['id']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

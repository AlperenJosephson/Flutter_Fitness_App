//import 'package:flutter/material.dart'; // temel widget özelliklerini kullanabilmek için yazıldı

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final String apiUrl = "https://api.api-ninjas.com/v1/exercises";
  final String apiKey = "dqOSOqDyEDvX/mjtOSnamw==9CWVoGJdRSiPYYDm";

  List<dynamic> exercises = [];
  bool isLoading = true;

  // Talimat görünürlüğü için state
  final Map<int, bool> _showInstructions = {};

  @override
  void initState() {
    super.initState();
    fetchExercises();
  }

  Future<void> fetchExercises() async {
    setState(() => isLoading = true);

    try {
      final bicepsResponse = await http.get(
        Uri.parse('$apiUrl?muscle=biceps'),
        headers: {'X-Api-Key': apiKey},
      );

      final chestResponse = await http.get(
        Uri.parse('$apiUrl?muscle=chest'),
        headers: {'X-Api-Key': apiKey},
      );

      if (bicepsResponse.statusCode == 200 && chestResponse.statusCode == 200) {
        setState(() {
          exercises = [
            ...jsonDecode(bicepsResponse.body),
            ...jsonDecode(chestResponse.body),
          ];
          for (int i = 0; i < exercises.length; i++) {
            _showInstructions[i] = false;
          }
        });
      } else {
        throw Exception('API Hatası');
      }
    } catch (e) {
      print("Hata: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Görsel yolu oluşturma (dinamik isim eşleştirme)
  String getImagePath(String name) {
    final formattedName = name.toLowerCase().replaceAll(' ', '-');
    return 'lib/screens/assets/images/$formattedName.gif';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Egzersizler"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                final exerciseName = exercise['name'] ?? 'Bilinmeyen Egzersiz';
                final instructions = exercise['instructions'] ?? 'Talimat mevcut değil';

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Image.asset(
                          getImagePath(exerciseName),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported, size: 60);
                          },
                        ),
                        title: Text(exerciseName),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showInstructions[index] = !_showInstructions[index]!;
                          });
                        },
                        child: Text(
                          _showInstructions[index]! ? "Talimatları Gizle" : "Talimatları Göster",
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                      if (_showInstructions[index]!)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            instructions,
                            style: const TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}




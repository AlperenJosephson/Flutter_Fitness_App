import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  final String email;

  const HomeScreen({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pages = [
      {
        'title': 'Egzersizler',
        'icon': Icons.fitness_center,
        'route': '/exercises',
      },
      {
        'title': 'Beslenme Desteği',
        'icon': Icons.restaurant_menu,
        'route': '/nutrition',
      },
      {
        'title': 'Favoriler',
        'icon': Icons.favorite,
        'route': '/favorites',
      },
      {
        'title': 'Kişisel Bilgiler',
        'icon': Icons.person,
        'route': '/profile',
      },
      {
        'title': 'Kalori Hesaplama',
        'icon': Icons.local_dining,
        'route': '/calorie',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Çıkış Yap
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(username),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  username[0].toUpperCase(),
                  style: const TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ...pages.map(
              (page) => ListTile(
                leading: Icon(page['icon']),
                title: Text(page['title']),
                onTap: () {
                  Navigator.pushNamed(context, page['route']);
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Her satırda 2 sütun
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: pages.length,
          itemBuilder: (context, index) {
            final page = pages[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, page['route']);
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(page['icon'], size: 48.0, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      page['title'],
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}




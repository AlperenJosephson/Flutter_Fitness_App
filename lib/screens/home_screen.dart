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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa' /*, style: const TextStyle(backgroundColor: Color.fromARGB(100, 51, 153, 255))*/),
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
          padding:  EdgeInsets.zero,
          children: [
            // Drawer başlığı
            UserAccountsDrawerHeader(accountName: Text(username), accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  username[0].toUpperCase(),
                  style: const TextStyle(fontSize: 40.0),
                ),
              ),
            ),

            // Menü öğeleri
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Egzerizler'),
              onTap: (){
                // egzersiz ekranına yönlendir
                Navigator.pushNamed(context, '/exercises');
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('Beslenme Alanı'),
              onTap: (){
                // egzersiz ekranına yönlendir
                Navigator.pushNamed(context, '/nutrition');
              },
            ),

            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favoriler'),
              onTap: () {
                // Favoriler ekranına yönlendir
                Navigator.pushNamed(context, '/favorites');
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Kişisel Bilgiler'),
              onTap: () {
                // Kişisel Bilgiler ekranına yönlendir
                Navigator.pushNamed(context, '/profile');
              },
            ),

            ListTile(
              leading: const Icon(Icons.local_dining),
              title: const Text('Kalori Hesaplama'),
              onTap: () {
                Navigator.pushNamed(context, '/calorie');
              },
            ),
          ],
        ),
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hoşgeldin, $username!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),            
          ],
        ),
      ),
    );
  }
}

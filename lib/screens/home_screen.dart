import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  final String email;

  const HomeScreen({
    Key? key,
    required this.username,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Geri giriş ekranına dön
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $username!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Örnek veri sayısı
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Task ${index + 1}'),
                    subtitle: Text('Details for task ${index + 1}'),
                    leading: Icon(Icons.task),
                    trailing: Icon(Icons.chevron_right),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

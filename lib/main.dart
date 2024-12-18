import 'package:flutter/material.dart'; // temel widget özelliklerini kullanabilmek için yazıldı
import 'package:flutter_project_1/screens/calori_screen.dart';
import 'package:flutter_project_1/screens/favorites_screen.dart';
import 'package:flutter_project_1/screens/nutrition_screen.dart';
import 'package:flutter_project_1/screens/profile_screen.dart';
import 'screens/login_screen.dart'; // Login ekranını içe aktar
import 'package:flutter_project_1/screens/home_screen.dart';  // /home rotası tamamlanınca home_screen e gitmeye yarar
import 'screens/exercise_screen.dart';
import 'screens/user_session.dart';

void main() {
  runApp(const MyApp());  // runApp uygulamayı başlatan temel fonksiyon     MyApp kök widget
}

class MyApp extends StatelessWidget { // stateless widgetlar burada olacaklar
  const MyApp({super.key});   // MyApp'in constructoru

  @override
  Widget build(BuildContext context) {  // build metodu burada override ediliyor
    return MaterialApp(   // Uygulamanın kök widgeti ve ui nin temelini oluşturur
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      
      theme: ThemeData(   // tema alanı (burayı geliştir)
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',   // uygulama ilk başladığında nereden başlıcağını belirtir
      routes: {   // rota burada belirtlir
        '/login': (context) => const LoginScreen(),   // /Login rotasında LoginScreen widgetı oluşturulur
        '/home': (context) => const HomeScreen(username: 'TestUser', email: 'test@example.com'), // Dummy data
        '/exercises': (context) => const ExerciseScreen(),
        '/favorites': (context) => FavoritesScreen(userEmail: userSession.email!),
        '/nutrition': (context) => const NutritionScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/calorie': (context) => const CalorieScreen(),
      },
    );
  }
}

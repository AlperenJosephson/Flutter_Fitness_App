import 'package:flutter/material.dart'; // temel widget özelliklerini kullanabilmek için yazıldı
import 'screens/login_screen.dart'; // Login ekranını içe aktar
import 'package:flutter_project_1/screens/home_screen.dart';  // /home rotası tamamlanınca home_screen e gitmeye yarar

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
        //'/exercises': (context) => const ExercisesScreen(),
        //'/meal_plan': (context) => const MealPlanScreen(),
        //'/favorites': (context) => const FavoritesScreen(),
        //'/profile': (context) => const ProfileScreen(),




      },
    
    );
  }
}

import 'package:flutter/material.dart';
import 'register_screen.dart';
import '/database_helper.dart';
import 'package:flutter_project_1/screens/home_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();  // Form widgetının durumunu kontrol eder
  final TextEditingController _emailController = TextEditingController();   // email verisini tutar
  final TextEditingController _passwordController = TextEditingController();  // şifreyi tutar
  final DatabaseHelper _dbHelper = DatabaseHelper();



  void _login() async{ // giriş yapma işlemi 
    if (_formKey.currentState!.validate()) {  // tüm validator işlemleri doğruysa işlemlere başla
      final email = _emailController.text;  // girilen mail adresini değişkene atar
      final password = _passwordController.text;  // girilen şifre değerini değişkene atar

      // Kullanıcı doğrulama
      bool isAuthenticated = await _dbHelper.authenticateUser(email, password); // gelen verileri doğrulamaya gönderir

        if (isAuthenticated) {  // eğer doğru ise
        try {
        // Kullanıcı bilgilerini al
        final users = await _dbHelper.getAllUsers();
        final user = users.firstWhere((u) => u['email'] == email);

        // Ana sayfaya yönlendir ve kullanıcı bilgilerini gönder
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              username: user['username'],
              email: user['email'],
            ),
          ),
        );
        } catch (e) { // Eğer kullanıcı bulunamazsa, hata yakalanır
        
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kullanıcı Kayıtlı Değil.')),
          );
        }
      } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Geçersiz Mail veya Şifre')),
        );
      }
    }
  }

  void _goToRegister() {  // Register ekranına yönlendir 
    Navigator.push( // navigator ile manuel olarak register_screene gönderir
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override // build metodu override edilerek tekrardan kullanılır
  Widget build(BuildContext context) {  // Ui oluşturma işlemi burada gerçekleşir buildin içinde
    return Scaffold(  // temel ekran yapısı
      appBar: AppBar( // başlık çubuğu
        title: const Text('Giriş Alani'),
      ),
      body: Padding(  // bodydeki boşlukları belirtir
        padding: const EdgeInsets.all(16.0),
        child: Form(  // giriş bilgilerini doğrulamak için kullanılır
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(  // kullanıcı mail ve şifresini almak için
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {    // kullanıcı girişini kontrol eder
                  if (value == null || value.isEmpty) {   // eğer boşsa veya nullsa
                    return 'Lütfen Mail adresinizi girin';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {  // mail adresinin şeklini inceler
                    return 'Geçerli bir mail adresi girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen Şifrenizi girin';
                  }
                  if (value.length < 4) {
                    return 'Şifre en az 4 karakterden oluşmalıdır';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(     
                onPressed: _login,  // basıldığında _login metodunu çağırır
                child: const Text('Login'),
              ),
              TextButton(   // yazı şeklinde buton
                onPressed: _goToRegister, // basıldığında register sayfasına yönlendiren metodu çağırır
                child: const Text('Hesabınız yok mu? Kayıt Ol!!!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

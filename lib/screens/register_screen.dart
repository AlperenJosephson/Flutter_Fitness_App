import 'package:flutter/material.dart';
import 'package:flutter_project_1/database_helper.dart'; // Database helper'ı içe aktar
import 'package:flutter_project_1/screens/login_screen.dart'; // Login ekranını içe aktar

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState(); // kullanıcıdan gelen veriler işleceneceği için state yönetimi lazım
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();    // form widgetinin durumunu kontrol eder
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _register() async {  // kullanıcı kayıt işlemi
    if (_formKey.currentState!.validate()) {  // eğer tüm form verileri tamsa çalışır
      Map<String, dynamic> user = {   // kullanıcıdan alınan veriler bir map nesnesine dönüştürülür
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      };

      try {
        await _dbHelper.insertUser(user);   // databaseye kullanıcı eklenir
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kayıt Başarılı!')),
        );

        // Başarılı kayıt sonrası giriş ekranına yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()), // loginscreene yönlendirir
        );
      } catch (e) {
        if (e.toString().contains('UNIQUE constraint failed: users.email')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mail zaten kayıtlı Lütfen Giriş Yapın')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kayıt Başarısız.')),
          );
        }
      }
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(), // Kenarlık tüm TextFormField'lara uygulanır
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Kullanıcı Adı',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen Kullanıcı adınızı Giriniz';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen Mail Adresinizi Giriniz';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Geçerli bir mail adresi giriniz';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen Şifrenizi Giriniz';
                    }
                    if (value.length < 4) {
                      return 'Şifre en az 4 karakterden oluşmalıdır!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Şifrenizi Doğrulayın',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen Şifrenizi Doğrulayın';
                    }
                    if (value != _passwordController.text) {
                      return 'Şifreleriniz Uyuşmuyor';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _register,
                  child: const Text('Kayıt Ol ve Giriş Yap'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}

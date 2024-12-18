import 'package:flutter/material.dart';
import '../database_helper.dart';
import 'user_session.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _exerciseDurationController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();

  List<Map<String, dynamic>> _healthData = [];

  @override
  void initState() {
    super.initState();
    _loadHealthData();
  }

  Future<void> _loadHealthData() async {
    if (userSession.email != null) {
      final data = await _dbHelper.getHealthData(userSession.email!);
      setState(() {
        _healthData = data;
      });
    }
  }

  Future<void> _saveHealthData() async {
    if (_formKey.currentState!.validate() && userSession.email != null) {
      final height = double.parse(_heightController.text);
      final weight = double.parse(_weightController.text);
      final exerciseDuration = int.parse(_exerciseDurationController.text);
      final steps = int.parse(_stepsController.text);

      // Veriyi veritabanına ekle
      await _dbHelper.insertHealthData(userSession.email!, {
        'height': height,
        'weight': weight,
        'exercise_duration': exerciseDuration,
        'steps': steps,
      });

      // BMI hesapla ve bildirimi göster
      final bmiStatus = calculateBMI(height, weight);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veriler Kaydedildi! BMI Durumu: $bmiStatus')),
      );

      // Formu temizle ve verileri yenile
      _heightController.clear();
      _weightController.clear();
      _exerciseDurationController.clear();
      _stepsController.clear();
      _loadHealthData();
    }
  }

  String calculateBMI(double height, double weight) {
    final bmi = weight / ((height / 100) * (height / 100)); // Boyu metreye çevir
    if (bmi < 18.5) {
      return 'Zayıf';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Normal';
    } else if (bmi >= 25 && bmi < 29.9) {
      return 'Fazla Kilolu';
    } else {
      return 'Obez';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kişisel Sağlık Verileri'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Boy (cm)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Boy bilgisi zorunludur';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Kilo (kg)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kilo bilgisi zorunludur';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _exerciseDurationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Egzersiz Süresi (dk)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Egzersiz süresi zorunludur';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _stepsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Adım Sayısı'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Adım sayısı zorunludur';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveHealthData,
                    child: const Text('Kaydet'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _healthData.isEmpty
                  ? const Center(child: Text('Henüz veri bulunmuyor.'))
                  : ListView.builder(
                      itemCount: _healthData.length,
                      itemBuilder: (context, index) {
                        final data = _healthData[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                                'Tarih: ${DateTime.parse(data['entry_date']).toLocal()}'),
                            subtitle: Text(
                              'Boy: ${data['height']} cm\n'
                              'Kilo: ${data['weight']} kg\n'
                              'Egzersiz: ${data['exercise_duration']} dk\n'
                              'Adım: ${data['steps']}',
                            ),
                          ),
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

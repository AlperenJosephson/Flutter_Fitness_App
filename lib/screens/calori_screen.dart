import 'package:flutter/material.dart';

class CalorieScreen extends StatefulWidget {
  const CalorieScreen({Key? key}) : super(key: key);

  @override
  _CalorieScreenState createState() => _CalorieScreenState();
}

class _CalorieScreenState extends State<CalorieScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = 'Erkek';
  String _selectedActivityLevel = 'Hareketsiz';
  double? _calorieRequirement;

  final List<Map<String, String>> calorieList = [
    {'name': 'Elma', 'calories': '52'},
    {'name': 'Muz', 'calories': '89'},
    {'name': 'Tavuk Göğsü (100 gr)', 'calories': '165'},
    {'name': 'Beyaz Ekmek (1 dilim)', 'calories': '79'},
    {'name': 'Süt (1 su bardağı)', 'calories': '103'},
    {'name': 'Cips (1 küçük paket)', 'calories': '152'},
    {'name': 'Çikolata (100 gr)', 'calories': '545'},
    {'name': 'Hamburger', 'calories': '295'},
    {'name': 'Pizza (1 dilim)', 'calories': '285'},
    {'name': 'Yoğurt (1 su bardağı)', 'calories': '59'},
    {'name': 'Pirinç Pilavı (100 gr)', 'calories': '130'},
    {'name': 'Kola (1 kutu)', 'calories': '139'},
  ];

  double calculateCalories(String gender, double weight, double height, int age, String activityLevel) {
    double bmr;

    if (gender == 'Erkek') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    switch (activityLevel) {
      case 'Hareketsiz':
        return bmr * 1.2;
      case 'Hafif Aktif':
        return bmr * 1.375;
      case 'Orta Aktif':
        return bmr * 1.55;
      case 'Çok Aktif':
        return bmr * 1.725;
      case 'Aşırı Aktif':
        return bmr * 1.9;
      default:
        return bmr;
    }
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final weight = double.parse(_weightController.text);
      final height = double.parse(_heightController.text);
      final age = int.parse(_ageController.text);

      setState(() {
        _calorieRequirement = calculateCalories(_selectedGender, weight, height, age, _selectedActivityLevel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalori Hesaplama'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
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
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Yaş'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Yaş bilgisi zorunludur';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(value: 'Erkek', child: Text('Erkek')),
                        DropdownMenuItem(value: 'Kadın', child: Text('Kadın')),
                      ],
                      decoration: const InputDecoration(labelText: 'Cinsiyet'),
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedActivityLevel,
                      onChanged: (value) {
                        setState(() {
                          _selectedActivityLevel = value!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(value: 'Hareketsiz', child: Text('Hareketsiz')),
                        DropdownMenuItem(value: 'Hafif Aktif', child: Text('Hafif Aktif')),
                        DropdownMenuItem(value: 'Orta Aktif', child: Text('Orta Aktif')),
                        DropdownMenuItem(value: 'Çok Aktif', child: Text('Çok Aktif')),
                        DropdownMenuItem(value: 'Aşırı Aktif', child: Text('Aşırı Aktif')),
                      ],
                      decoration: const InputDecoration(labelText: 'Aktivite Düzeyi'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _calculate,
                      child: const Text('Hesapla'),
                    ),
                    if (_calorieRequirement != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Günlük Kalori İhtiyacı: ${_calorieRequirement!.toStringAsFixed(2)} kcal',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Besin Kalori Listesi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: calorieList.length,
                itemBuilder: (context, index) {
                  final item = calorieList[index];
                  return ListTile(
                    title: Text(item['name']!),
                    trailing: Text('${item['calories']} kcal'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

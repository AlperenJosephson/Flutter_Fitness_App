import 'package:flutter/material.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({Key? key}) : super(key: key);

  @override
  _NutritionScreenState createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  // Yemek tariflerini tutacak liste
  final List<Map<String, String>> _recipes = [
    {
      'name': 'Avokadolu Yumurta',
      'description': 'Protein ve sağlıklı yağ kaynağı!',
      'details':
          'Malzemeler:\n- 2 dilim tam buğday ekmeği\n- 1 adet avokado\n- 2 adet haşlanmış yumurta\n- Tuz, karabiber, pul biber\n\nHazırlanışı:\nAvokadoyu ezin ve ekmek üzerine sürün. Üzerine dilimlenmiş haşlanmış yumurta ekleyin. Tuz, karabiber ve pul biber serpin.',
      'imagePath': 'lib/screens/assets/images/avokadolu-yumurta.jpg'
    },
    {
      'name': 'Smoothie Bowl',
      'description': 'Lezzetli ve vitamin dolu bir başlangıç.',
      'details':
          'Malzemeler:\n- 1 adet muz\n- 1/2 su bardağı yulaf\n- 1 su bardağı süt\n- 1 yemek kaşığı fıstık ezmesi\n- Üzeri için: çilek, yaban mersini, ceviz\n\nHazırlanışı:\nTüm malzemeleri blenderda karıştırın. Kaseye dökün ve üzerini meyveler ve cevizle süsleyin.',
      'imagePath': 'lib/screens/assets/images/smoothie-bowl.jpg'
    },
    {
      'name': 'Tavuklu Kinoa Salatası',
      'description': 'Düşük kalorili ve doyurucu bir öğün.',
      'details':
          'Malzemeler:\n- 1 su bardağı haşlanmış kinoa\n- 100 gr ızgara tavuk\n- 1 adet salatalık\n- 1 adet domates\n- Zeytinyağı, limon suyu, tuz\n\nHazırlanışı:\nTüm malzemeleri küp küp doğrayın ve haşlanmış kinoayla karıştırın. Zeytinyağı, limon suyu ve tuz ekleyerek servis yapın.',
      'imagePath': 'lib/screens/assets/images/tavuklu-kinoa-salata.jpg'
    },
  ];

  // Tarif detaylarının görünürlük durumu
  final Map<int, bool> _showDetails = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _recipes.length; i++) {
      _showDetails[i] = false; // Başlangıçta tüm detaylar gizli
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beslenme Desteği'),
      ),
      body: ListView.builder(
        itemCount: _recipes.length,
        itemBuilder: (context, index) {
          final recipe = _recipes[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Image.asset(
                    recipe['imagePath']!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, size: 60);
                    },
                  ),
                  title: Text(recipe['name']!),
                  subtitle: Text(recipe['description']!),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showDetails[index] = !_showDetails[index]!;
                        });
                      },
                      child: Text(
                        _showDetails[index]!
                            ? "Detayları Gizle"
                            : "Detayları Göster",
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                if (_showDetails[index]!)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      recipe['details']!,
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

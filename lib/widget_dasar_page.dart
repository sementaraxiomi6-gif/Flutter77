
import 'dart:async';
import 'package:flutter/material.dart';

// 1. StatelessWidget
class WidgetDasarPage extends StatefulWidget {
  const WidgetDasarPage({super.key});

  @override
  State<WidgetDasarPage> createState() => _WidgetDasarPageState();
}

class _WidgetDasarPageState extends State<WidgetDasarPage>
    with SingleTickerProviderStateMixin {
  // 2. StatefulWidget
  int jumlahKlik = 0;
  bool tampilDetail = false;
  bool kotakBesar = false;
  String kategori = 'Semua';

  final TextEditingController pencarianController =
      TextEditingController();

  late final AnimationController animationController;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();

    // 6. Animation
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(
      begin: 0.7,
      end: 1.2,
    ).animate(animationController);

    animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();
    pencarianController.dispose();
    super.dispose();
  }

  // 9. FutureBuilder
  Future<String> ambilData() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Data Food Store berhasil dimuat!';
  }

  // 9. StreamBuilder
  Stream<int> hitungWaktu() {
    return Stream.periodic(
      const Duration(seconds: 1),
      (angka) => angka + 1,
    ).take(100);
  }

  @override
  Widget build(BuildContext context) {
    final daftarProduk = [
      'Nasi Goreng',
      'Mie Ayam',
      'Bakso',
      'Es Teh',
    ];

    return Scaffold(
      // 5. Material Components
      appBar: AppBar(
        title: const Text('Praktik Dasar Widget'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wrap with Row - sesuai PDF 6
            Row(
              children: [
                const Text(
                  'Materi Dasar Widget Flutter',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 3. Layout Widgets: Row dan Column
            const Text(
              '1. Layout Widgets',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.restaurant, size: 35, color: Colors.blue),
                Icon(Icons.local_drink, size: 35, color: Colors.green),
                Icon(Icons.fastfood, size: 35, color: Colors.orange),
              ],
            ),

            const SizedBox(height: 12),

            // GridView
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.5,
              children: daftarProduk.map((produk) {
                return Card(
                  child: Row(
                    children: [
                      Center(child: Text(produk)),
                    ],
                  ),
                );
              }).toList(),
            ),

            const Divider(height: 30),

            // 4. Input Widgets
            const Text(
              '2. Input Widgets',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            TextField(
              controller: pencarianController,
              decoration: const InputDecoration(
                labelText: 'Cari makanan',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Pencarian: ${pencarianController.text}',
                    ),
                  ),
                );
              },
              child: const Text('Cari Produk'),
            ),

            const Divider(height: 30),

            // 5. Material Components
            const Text(
              '3. Material Components',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Card(
              elevation: 4,
              child: const ListTile(
                leading: Icon(Icons.fastfood, color: Colors.blue),
                title: Text('Nasi Goreng'),
                subtitle: Text('Contoh penggunaan Card dan ListTile'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),

            const Divider(height: 30),

            // 2. StatefulWidget
            const Text(
              '4. StatefulWidget dan Interaction',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              'Jumlah Klik: $jumlahKlik',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      jumlahKlik++;
                    });
                  },
                  child: const Text('Tambah'),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      jumlahKlik = 0;
                    });
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),

            GestureDetector(
              onTap: () {
                setState(() {
                  tampilDetail = !tampilDetail;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                color: Colors.blue.shade100,
                child: const Text(
                  'Ketuk di sini untuk melihat detail produk',
                ),
              ),
            ),

            if (tampilDetail)
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text('Detail: Makanan tersedia di Food Store.'),
              ),

            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('InkWell berhasil diklik!'),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Klik teks ini menggunakan InkWell',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),

            const Divider(height: 30),

            // 6. Animation and Motion Widgets
            const Text(
              '5. Animation and Motion Widgets',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Center(
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: animation.value,
                    child: const Icon(
                      Icons.favorite,
                      size: 50,
                      color: Colors.red,
                    ),
                  );
                },
              ),
            ),

            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: kotakBesar ? 200 : 100,
                height: 70,
                decoration: BoxDecoration(
                  color: kotakBesar ? Colors.green : Colors.blue,
                  borderRadius: BorderRadius.circular(
                    kotakBesar ? 30 : 8,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'AnimatedContainer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                setState(() {
                  kotakBesar = !kotakBesar;
                });
              },
              child: const Text('Ubah Animasi'),
            ),

            // Hero
            Hero(
              tag: 'food-store-hero',
              child: const Icon(
                Icons.restaurant_menu,
                size: 45,
                color: Colors.orange,
              ),
            ),

            const Divider(height: 30),

            // 8. Styling Widgets
            const Text(
              '6. Styling dan MediaQuery',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              'Lebar layar: ${MediaQuery.of(context).size.width.toStringAsFixed(0)} px',
            ),

            DropdownButton<String>(
              value: kategori,
              items: ['Semua', 'Makanan', 'Minuman', 'Snack']
                  .map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    kategori = value;
                  });
                }
              },
            ),

            Text('Kategori dipilih: $kategori'),

            const Divider(height: 30),

            // 9. Async Widgets
            const Text(
              '7. Async Widgets',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            FutureBuilder<String>(
              future: ambilData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return const Text(
                    'Terjadi kesalahan saat mengambil data',
                  );
                }

                return Text(snapshot.data ?? 'Tidak ada data');
              },
            ),

            const SizedBox(height: 15),

            StreamBuilder<int>(
              stream: hitungWaktu(),
              builder: (context, snapshot) {
                return Text(
                  'Penghitung waktu: ${snapshot.data ?? 0} detik',
                );
              },
            ),

            const SizedBox(height: 30),

            const Center(
              child: Text(
                'Praktik Dasar Widget Food Store',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

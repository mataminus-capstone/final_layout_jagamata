import 'package:flutter/material.dart';
import 'package:jagamata/services/api_service.dart';

class Obat extends StatefulWidget {
  const Obat({super.key});

  @override
  State<Obat> createState() => _ObatState();
}

class _ObatState extends State<Obat> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _medicines = [];
  bool _isLoading = true;
  String _errorMessage = '';
  List<String> _categories = [];
  String? _selectedCategory;

  // Brand Colors
  final Color kDarkBlue = const Color(0xFF11417f);
  final Color kLightBlue = const Color(0xFF14b4ef);
  final Color kTosca = const Color(0xFFa2c38e);

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchMedicines();
  }

  Future<void> _fetchCategories() async {
    try {
      final result = await ApiService.getCategories();
      if (result['success']) {
        final data = result['data'] as List;
        setState(() {
          _categories = data.map((e) => e['name'].toString()).toList();
        });
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> _fetchMedicines() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await ApiService.getMedicines(
        category: _selectedCategory,
        perPage: 50, // Get enough items
      );

      if (result['success']) {
        setState(() {
          _medicines = result['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Gagal memuat data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Rekomendasi Obat", style: TextStyle(color: kDarkBlue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: kDarkBlue),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Daftar Rekomendasi Obat Mata',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kDarkBlue,
              ),
            ),
          ),

          // Search / Filter
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              onChanged: (value) {
                // Implement search if needed, currently API filters by category
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari Obat Mata...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                icon: Icon(Icons.search, color: Colors.grey[400]),
                suffixIcon: PopupMenuButton<String>(
                  icon: Icon(Icons.filter_alt, color: kDarkBlue),
                  onSelected: (value) {
                    setState(() {
                      if (value == 'All') {
                        _selectedCategory = null;
                      } else {
                        _selectedCategory = value;
                      }
                    });
                    _fetchMedicines();
                  },
                  itemBuilder: (context) {
                    List<PopupMenuEntry<String>> items = [
                      PopupMenuItem(value: 'All', child: Text('Semua')),
                    ];
                    for (var cat in _categories) {
                      items.add(PopupMenuItem(value: cat, child: Text(cat)));
                    }
                    return items;
                  },
                ),
              ),
            ),
          ),

          // Tips Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: kLightBlue),
                SizedBox(width: 6),
                Text(
                  'Tips Kesehatan Mata',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[700]),
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kLightBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kLightBlue.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• Hindari menyentuh mata dengan tangan kotor',
                  style: TextStyle(fontSize: 12, color: kDarkBlue),
                ),
                SizedBox(height: 4),
                Text(
                  '• Jika iritasi berlanjut, segera konsultasi dokter',
                  style: TextStyle(fontSize: 12, color: kDarkBlue),
                ),
              ],
            ),
          ),

          // List Content
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: kDarkBlue))
                : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage))
                    : _medicines.isEmpty
                        ? Center(child: Text("Tidak ada data obat"))
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                            child: ListView.builder(
                              itemCount: _medicines.length + 1,
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                if (index == _medicines.length) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                    child: Center(child: Text("Akhir daftar obat", style: TextStyle(color: Colors.grey))),
                                  );
                                }

                                final obat = _medicines[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.grey[100]!),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          obat['image_url'] ?? '',
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 80, 
                                              height: 80, 
                                              color: Colors.grey[200], 
                                              child: Icon(Icons.image_not_supported, color: Colors.grey),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              obat['name'] ?? 'Tanpa Nama',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: kDarkBlue,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              obat['description'] ?? 'Tidak ada deskripsi',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[600],
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 6),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: kLightBlue.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                obat['category'] ?? 'Umum',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                  color: kDarkBlue,
                                                ),
                                              ),
                                            ),
                                            if (obat['price'] != null)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: Text(
                                                  "Rp ${obat['price']}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.orange[800]
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

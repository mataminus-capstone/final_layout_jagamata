import 'package:flutter/material.dart';
import 'package:jagamata/services/api_service.dart';

class KlinikMata extends StatefulWidget {
  const KlinikMata({super.key});

  @override
  State<KlinikMata> createState() => _KlinikMataState();
}

class _KlinikMataState extends State<KlinikMata> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> klinikList = [];
  bool isLoading = true;
  String errorMessage = '';

  // Brand Colors
  final Color kDarkBlue = const Color(0xFF11417f);
  final Color kLightBlue = const Color(0xFF14b4ef);
  final Color kTosca = const Color(0xFFa2c38e);

  @override
  void initState() {
    super.initState();
    _fetchClinics();
  }

  Future<void> _fetchClinics() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final result = await ApiService.getClinics();

    if (result['success']) {
      setState(() {
        klinikList = result['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        errorMessage = result['message'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Rekomendasi Klinik', style: TextStyle(color: kDarkBlue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: kDarkBlue),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Daftar Rekomendasi Klinik Mata',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kDarkBlue,
                ),
              ),
            ),
            
            // Search Bar (Visual consistency)
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Cari Klinik...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  icon: Icon(Icons.search, color: Colors.grey[400]),
                ),
              ),
            ),

            if (isLoading)
              Expanded(child: Center(child: CircularProgressIndicator(color: kDarkBlue)))
            else if (errorMessage.isNotEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(errorMessage),
                      ElevatedButton(
                        onPressed: _fetchClinics,
                        style: ElevatedButton.styleFrom(backgroundColor: kDarkBlue),
                        child: const Text('Coba Lagi'),
                      )
                    ],
                  ),
                ),
              )
            else if (klinikList.isEmpty)
              Expanded(
                child: Center(
                  child: Text('Tidak ada klinik ditemukan untuk lokasi Anda', style: TextStyle(color: Colors.grey)),
                ),
              )
            else
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ListView.builder(
                    itemCount: klinikList.length + 1,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      // Footer
                      if (index == klinikList.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            children: [
                              const Text(
                                "Anda telah mencapai page akhir nih",
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 10),
                              InkWell(
                                onTap: () {
                                  _scrollController.animateTo(
                                    0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOut,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: kDarkBlue,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_upward_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final klinik = klinikList[index];
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Gambar Check
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: klinik['image_url'] != null
                                  ? Image.network(
                                      klinik['image_url'],
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.image_not_supported),
                                      ),
                                    )
                                  : Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image),
                                    ),
                            ),
                            const SizedBox(width: 16),

                            // Text Area
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    klinik['name'] ?? 'Klinik',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: kDarkBlue,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.location_on, size: 14, color: Colors.grey[400]),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          klinik['address'] ?? '-',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.phone,
                                        color: Colors.green,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        klinik['phone_number'] ?? '-',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
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
      ),
    );
  }
}

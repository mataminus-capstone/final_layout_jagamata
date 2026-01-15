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
      appBar: AppBar(
        title: const Text('Rekomendasi Klinik'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Daftar Rekomendasi Klinik Mata',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
            ),

            if (isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
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
                        child: const Text('Coba Lagi'),
                      )
                    ],
                  ),
                ),
              )
            else if (klinikList.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('Tidak ada klinik ditemukan untuk lokasi Anda'),
                ),
              )
            else
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                    color: Colors.blue,
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Gambar Check
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
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
                                const SizedBox(width: 12),

                                // Text Area
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        klinik['name'] ?? 'Klinik',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        klinik['address'] ?? '-',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.phone,
                                            color: Colors.green,
                                            size: 14,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            klinik['phone_number'] ?? '-',
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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

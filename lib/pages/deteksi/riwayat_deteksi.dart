import 'package:flutter/material.dart';
import 'package:jagamata/services/api_service.dart';

class RiwayatDeteksi extends StatefulWidget {
  const RiwayatDeteksi({super.key});

  @override
  State<RiwayatDeteksi> createState() => _RiwayatDeteksiState();
}

class _RiwayatDeteksiState extends State<RiwayatDeteksi> {
  List<dynamic> historyList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  void fetchHistory() async {
    final result = await ApiService.getDetectionHistory();
    if (mounted) {
      setState(() {
        if (result['success']) {
          historyList = result['data'];
        }
        isLoading = false;
      });
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Info Riwayat Deteksi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : historyList.isEmpty
              ? Center(child: Text("Belum ada riwayat deteksi"))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    final item = historyList[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header: Name & Date (Simulated Name)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                    children : [
                                        Text(
                                            ApiService.userData?['username'] ?? 'User',
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                    ]
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.star_border, size: 16, color: Colors.orange),
                                        Icon(Icons.star_border, size: 16, color: Colors.orange),
                                        Icon(Icons.star_border, size: 16, color: Colors.orange),
                                        Icon(Icons.star_border, size: 16, color: Colors.orange),
                                        Icon(Icons.star_border, size: 16, color: Colors.orange),
                                      ],
                                    ),
                                    Text(
                                      _formatDate(item['created_at']),
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Divider(thickness: 1, color: Colors.blue),
                            SizedBox(height: 8),

                            // Diagnosis
                            _buildInfoRow(
                              Icons.health_and_safety,
                              "Diagnosa",
                              item['diagnosis'],
                              isTitle: true,
                            ),
                            
                            // Image Preview (Optional)
                            if (item['image_url'] != null)
                             Padding(
                               padding: const EdgeInsets.only(left: 28, top: 4, bottom: 8),
                               child: ClipRRect(
                                 borderRadius: BorderRadius.circular(8),
                                 child: Image.network(
                                   item['image_url'], 
                                   height: 100, 
                                   width: 100, 
                                   fit: BoxFit.cover,
                                   errorBuilder: (_,__,___) => SizedBox(),
                                 ),
                               ),
                             ),

                            // Handling (Terapi Obat / Penanganan)
                            _buildInfoRow(
                              Icons.medication,
                              "Penanganan & Obat",
                              item['handling'] ?? '-',
                            ),

                            // Solution (Solusi / Terapi Non Obat)
                            _buildInfoRow(
                              Icons.healing,
                              "Solusi & Edukasi",
                              item['solution'] ?? '-',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String content, {bool isTitle = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                SizedBox(height: 2),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14, 
                    color: Colors.grey[700],
                    fontWeight: isTitle ? FontWeight.w600 : FontWeight.normal
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

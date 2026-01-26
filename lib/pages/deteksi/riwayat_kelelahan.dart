import 'package:flutter/material.dart';
import 'package:jagamata/services/api_service.dart';
import 'package:jagamata/utils/label_utils.dart';

class RiwayatKelelahan extends StatefulWidget {
  const RiwayatKelelahan({super.key});

  @override
  State<RiwayatKelelahan> createState() => _RiwayatKelelahanState();
}

class _RiwayatKelelahanState extends State<RiwayatKelelahan> {
  List<dynamic> historyList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  void fetchHistory() async {
    final result = await ApiService.getDrowsinessHistory();
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
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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
          'Riwayat Kelelahan',
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
          ? Center(child: Text("Belum ada riwayat kelelahan"))
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
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDate(item['created_at']),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: (item['confidence'] ?? 0) > 0.7
                                    ? Colors.green[100]
                                    : Colors.orange[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${((item['confidence'] ?? 0) * 100).toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: (item['confidence'] ?? 0) > 0.7
                                      ? Colors.green[800]
                                      : Colors.orange[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(height: 8),

                        // Content Row
                        Row(
                          children: [
                            // Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item['image_url'] ?? '',
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 80,
                                  width: 80,
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            // Text Data
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Indikasi Kelelahan:",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    translateDrowsinessLabel(item['label']),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

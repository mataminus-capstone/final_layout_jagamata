import 'package:flutter/material.dart';
import 'package:jagamata/services/api_service.dart';
import 'package:intl/intl.dart';

class HistoryDetectionPage extends StatefulWidget {
  const HistoryDetectionPage({super.key});

  @override
  State<HistoryDetectionPage> createState() => _HistoryDetectionPageState();
}

class _HistoryDetectionPageState extends State<HistoryDetectionPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> historyList = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final result = await ApiService.getDetectionHistory();
    if (mounted) {
      setState(() {
        if (result['success']) {
          historyList = List<Map<String, dynamic>>.from(result['data']);
        }
        isLoading = false;
      });
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('HH:mm').format(date);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Riwayat Deteksi", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[500],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Background similar to reference (Blue top)
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
            decoration: BoxDecoration(
              color: Colors.blue[500],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Info Riwayat Deteksi",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Daftar riwayat pemeriksaan mata Anda",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : historyList.isEmpty
                    ? Center(child: Text("Belum ada riwayat deteksi"))
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: historyList.length,
                        itemBuilder: (context, index) {
                          final item = historyList[index];
                          return _buildHistoryCard(item);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.blue.withOpacity(0.3), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pemeriksaan Mata", // Or "Slerok" equivalent
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatDate(item['created_at']),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      _formatTime(item['created_at']),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Card Body
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Diagnosa
                _buildInfoSection(
                  icon: Icons.medical_services_outlined,
                  title: "Hasil Deteksi",
                  content: item['diagnosis'] ?? 'Tidak diketahui',
                  isBoldContent: true,
                ),
                SizedBox(height: 12),
                
                // Confidence / Tingkat Kepercayaan
                _buildInfoSection(
                  icon: Icons.analytics_outlined,
                  title: "Tingkat Kepercayaan",
                  content: "${((item['confidence'] ?? 0) * 100).toStringAsFixed(1)}%",
                ),
                 SizedBox(height: 12),

                // Image Preview (Optional but useful)
                if (item['image_url'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 28),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item['image_url'],
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => SizedBox.shrink(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Blue bottom bar accent
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.blue[500],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String content,
    bool isBoldContent = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blue[700]),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 2),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: isBoldContent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

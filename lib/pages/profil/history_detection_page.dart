import 'package:flutter/material.dart';
import 'package:jagamata/services/api_service.dart';
import 'package:intl/intl.dart';

class HistoryDetectionPage extends StatefulWidget {
  const HistoryDetectionPage({super.key});

  @override
  State<HistoryDetectionPage> createState() => _HistoryDetectionPageState();
}

class _HistoryDetectionPageState extends State<HistoryDetectionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool isLoadingDisease = true;
  bool isLoadingDrowsiness = true;
  List<Map<String, dynamic>> diseaseHistoryList = [];
  List<Map<String, dynamic>> drowsinessHistoryList = [];

  final Color kDarkBlue = const Color(0xFF11417f);
  final Color kLightBlue = const Color(0xFF14b4ef);
  final Color kTosca = const Color(0xFFa2c38e);
  final Color kOrange = const Color(0xFFff7043);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchDiseaseHistory();
    _fetchDrowsinessHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchDiseaseHistory() async {
    final result = await ApiService.getDetectionHistory();
    if (mounted) {
      setState(() {
        if (result['success']) {
          diseaseHistoryList = List<Map<String, dynamic>>.from(result['data']);
        }
        isLoadingDisease = false;
      });
    }
  }

  Future<void> _fetchDrowsinessHistory() async {
    final result = await ApiService.getDrowsinessHistory();
    if (mounted) {
      setState(() {
        if (result['success']) {
          drowsinessHistoryList = List<Map<String, dynamic>>.from(
            result['data'],
          );
        }
        isLoadingDrowsiness = false;
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
        title: Text(
          "Riwayat Deteksi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: kDarkBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: kDarkBlue,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(
                  icon: Icon(Icons.health_and_safety, size: 20),
                  text: "Potensi Penyakit",
                ),
                Tab(
                  icon: Icon(Icons.remove_red_eye, size: 20),
                  text: "Kelelahan Mata",
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Disease Detection History
          _buildDiseaseHistoryTab(),

          // Tab 2: Drowsiness Detection History
          _buildDrowsinessHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildDiseaseHistoryTab() {
    return Column(
      children: [
        // Header Background
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kDarkBlue, kLightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.health_and_safety,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Riwayat Deteksi Potensi Penyakit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Katarak, Glaukoma, dan kondisi mata lainnya",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${diseaseHistoryList.length} data",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: isLoadingDisease
              ? Center(child: CircularProgressIndicator(color: kDarkBlue))
              : diseaseHistoryList.isEmpty
              ? _buildEmptyState(
                  icon: Icons.health_and_safety_outlined,
                  title: "Belum Ada Riwayat",
                  subtitle:
                      "Anda belum pernah melakukan deteksi potensi penyakit mata",
                  color: kDarkBlue,
                )
              : RefreshIndicator(
                  onRefresh: _fetchDiseaseHistory,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: diseaseHistoryList.length,
                    itemBuilder: (context, index) {
                      final item = diseaseHistoryList[index];
                      return _buildDiseaseHistoryCard(item);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildDrowsinessHistoryTab() {
    return Column(
      children: [
        // Header Background
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kTosca, kLightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.remove_red_eye,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Riwayat Deteksi Kelelahan Mata",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Analisis kantuk dan kelelahan mata",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${drowsinessHistoryList.length} data",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: isLoadingDrowsiness
              ? Center(child: CircularProgressIndicator(color: kTosca))
              : drowsinessHistoryList.isEmpty
              ? _buildEmptyState(
                  icon: Icons.remove_red_eye_outlined,
                  title: "Belum Ada Riwayat",
                  subtitle:
                      "Anda belum pernah melakukan deteksi kelelahan mata",
                  color: kTosca,
                )
              : RefreshIndicator(
                  onRefresh: _fetchDrowsinessHistory,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: drowsinessHistoryList.length,
                    itemBuilder: (context, index) {
                      final item = drowsinessHistoryList[index];
                      return _buildDrowsinessHistoryCard(item);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 50, color: color),
            ),
            SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/deteksi'),
              icon: Icon(Icons.add, color: Colors.white),
              label: Text(
                "Mulai Deteksi",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseHistoryCard(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
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
                bottom: BorderSide(color: kDarkBlue.withOpacity(0.2), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.health_and_safety, size: 18, color: kDarkBlue),
                    SizedBox(width: 8),
                    Text(
                      "Deteksi Potensi Penyakit",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: kDarkBlue,
                      ),
                    ),
                  ],
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
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Card Body
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                if (item['image_url'] != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item['image_url'],
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        icon: Icons.medical_services_outlined,
                        title: "Hasil Deteksi",
                        content: item['diagnosis'] ?? 'Tidak diketahui',
                        isBold: true,
                        color: kDarkBlue,
                      ),
                      SizedBox(height: 10),
                      _buildInfoRow(
                        icon: Icons.analytics_outlined,
                        title: "Confidence",
                        content:
                            "${((item['confidence'] ?? 0) * 100).toStringAsFixed(1)}%",
                        color: kDarkBlue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Blue bottom bar accent
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: kDarkBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrowsinessHistoryCard(Map<String, dynamic> item) {
    final String label = (item['label'] ?? '').toString().toLowerCase();
    final bool isFatigued =
        (label.contains('drowsy') ||
            label.contains('fatigue') ||
            label.contains('tired') ||
            label.contains('lelah')) &&
        !label.contains('non') &&
        !label.contains('not') &&
        !label.contains('awake');

    final Color statusColor = isFatigued ? kOrange : kTosca;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
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
                bottom: BorderSide(
                  color: statusColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isFatigued
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle,
                      size: 18,
                      color: statusColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Deteksi Kelelahan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: statusColor,
                      ),
                    ),
                  ],
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
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Card Body
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                if (item['image_url'] != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item['image_url'],
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status with badge
                      Row(
                        children: [
                          Icon(Icons.face, size: 16, color: statusColor),
                          SizedBox(width: 6),
                          Text(
                            "Status:",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: statusColor.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          item['label'] ?? 'Tidak diketahui',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: statusColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildInfoRow(
                        icon: Icons.analytics_outlined,
                        title: "Confidence",
                        content:
                            "${((item['confidence'] ?? 0) * 100).toStringAsFixed(1)}%",
                        color: statusColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom bar accent with status color
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String content,
    bool isBold = false,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
              Text(
                content,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

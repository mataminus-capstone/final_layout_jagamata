import 'package:flutter/material.dart';

class Rekomendasi extends StatelessWidget {
  const Rekomendasi({super.key});

  final Color kDarkBlue = const Color(0xFF11417f);
  final Color kLightBlue = const Color(0xFF14b4ef);
  final Color kTosca = const Color(0xFFa2c38e);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kDarkBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Rekomendasi",
          style: TextStyle(color: kDarkBlue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Center Image
            Center(
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[100],
                  border: Border.all(color: kLightBlue.withOpacity(0.3), width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'images/rekomen.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Icon(Icons.medication_outlined, size: 60, color: kLightBlue),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              "Rekomendasi Kesehatan",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kDarkBlue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
             Text(
              "Temukan klinik mata terpercaya dan rekomendasi obat yang tepat untuk anda.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),

            // Selection Options
            _buildOptionCard(
              context,
              title: "Klinik Mata",
              description: "Temukan klinik mata terdekat dan terpercaya.",
              icon: Icons.local_hospital_rounded,
              color: kDarkBlue,
              onTap: () => Navigator.pushNamed(context, '/klinik'),
            ),
            
            const SizedBox(height: 20),
            
            _buildOptionCard(
              context,
              title: "Obat Mata",
              description: "Daftar obat yang direkomendasikan untuk keluhan ringan.",
              icon: Icons.medication_liquid_rounded,
              color: kTosca,
              onTap: () => Navigator.pushNamed(context, '/obat'),
            ),

            const SizedBox(height: 40),

            // Info Note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_rounded, color: kDarkBlue),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Catatan Penting",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kDarkBlue,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Jika keluhan berlanjut, segera hubungi dokter spesialis.",
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kDarkBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

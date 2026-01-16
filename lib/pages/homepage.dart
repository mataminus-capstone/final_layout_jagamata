import 'package:flutter/material.dart';
import 'package:jagamata/services/api_service.dart';

class Homopage extends StatefulWidget {
  const Homopage({super.key});

  @override
  State<Homopage> createState() => _HomopageState();
}

class _HomopageState extends State<Homopage> {
  List<Map<String, dynamic>> artikelList = [];
  bool isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  // Brand Colors
  final Color kDarkBlue = const Color(0xFF11417f);
  final Color kLightBlue = const Color(0xFF14b4ef);
  final Color kTosca = const Color(0xFFa2c38e);

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  void fetchArticles() async {
    final result = await ApiService.getArticles(page: 1, perPage: 3);
    if (mounted) {
      setState(() {
        if (result['success']) {
          artikelList = List<Map<String, dynamic>>.from(result['data']);
        }
        isLoading = false;
      });
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Baru';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} menit lalu';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} jam lalu';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} hari lalu';
      } else {
        final months = [
          'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
          'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
        ];
        return '${date.day} ${months[date.month - 1]}';
      }
    } catch (e) {
      return 'Baru';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get user name safely
    String userName = "User";
    String? profilePicUrl;
    if (ApiService.userData != null) {
      userName = ApiService.userData!['username'] ?? "User";
      profilePicUrl = ApiService.userData!['profile_picture'];
    }

    return Scaffold(

      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kDarkBlue,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/profil'),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: profilePicUrl != null
                          ? NetworkImage(profilePicUrl)
                          : null,
                      backgroundColor: Colors.grey[200],
                      child: profilePicUrl == null
                          ? Icon(Icons.person, color: kDarkBlue)
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 2. Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      Navigator.pushNamed(context, '/search_results', arguments: value);
                    }
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search medical...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    icon: Icon(Icons.search, color: Colors.grey[400]),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Services Section
              Text(
                "Layanan",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kDarkBlue,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   _buildServiceIcon(
                    context,
                    title: "Deteksi",
                    icon: Icons.remove_red_eye_rounded,
                    color: kDarkBlue.withOpacity(0.1),
                    iconColor: kDarkBlue,
                    onTap: () => Navigator.pushNamed(context, '/deteksi'),
                  ),
                  _buildServiceIcon(
                    context,
                    title: "Rekomendasi",
                    icon: Icons.medication_rounded,
                    color: Colors.orange.withOpacity(0.1),
                    iconColor: Colors.orange,
                    onTap: () => Navigator.pushNamed(context, '/rekomendasi'), 
                  ),
                   _buildServiceIcon(
                    context,
                    title: "Treatment",
                    icon: Icons.health_and_safety_rounded,
                    color: kLightBlue.withOpacity(0.1),
                    iconColor: kLightBlue,
                    onTap: () => Navigator.pushNamed(context, '/treatment'),
                  ),
                  _buildServiceIcon(
                    context,
                    title: "Chatbot",
                    icon: Icons.chat_bubble_rounded,
                    color: kTosca.withOpacity(0.2),
                    iconColor: Colors.green,
                    onTap: () => Navigator.pushNamed(context, '/chatbot'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 4. Banner Section
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [kLightBlue.withOpacity(0.2), kDarkBlue.withOpacity(0.1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 20,
                      top: 30,
                      bottom: 30,
                      right: 140, // Leave space for image
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Text(
                            "Layanan Terbaik\nuntuk Mata Anda",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kDarkBlue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Membantu menjaga kesehatan mata anda.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 0,
                      child: Image.asset(
                        'images/docter.png',
                        height: 160,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (context, error, stackTrace) {
                           return const Icon(Icons.person, size: 80, color: Colors.grey);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 5. Articles Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    "Artikel Terbaru",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kDarkBlue,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/artikelnew'),
                    child: Text(
                      "Lihat Semua",
                      style: TextStyle(
                        color: kLightBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (artikelList.isEmpty)
                const Center(child: Text("Belum ada artikel"))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: artikelList.length,
                  itemBuilder: (context, index) {
                    final artikel = artikelList[index];
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
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: artikel['image_url'] != null
                                ? Image.network(
                                    artikel['image_url'],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) => Container(
                                      width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.image),
                                    ),
                                  )
                                : Container(
                                    width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.image),
                                  ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  artikel['title'] ?? 'No Title',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: kDarkBlue,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatDate(artikel['created_at']),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[400],
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceIcon(BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              size: 28,
              color: iconColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

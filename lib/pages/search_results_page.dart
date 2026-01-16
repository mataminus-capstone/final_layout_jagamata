import 'package:flutter/material.dart';
import 'package:jagamata/services/api_service.dart';

class SearchResultsPage extends StatefulWidget {
  final String searchQuery;

  const SearchResultsPage({super.key, required this.searchQuery});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<Map<String, dynamic>> artikelList = [];
  bool isLoading = true;
  String _currentQuery = "";
  final TextEditingController _searchController = TextEditingController();

  // Brand Colors
  final Color kDarkBlue = const Color(0xFF11417f);
  final Color kLightBlue = const Color(0xFF14b4ef);
  final Color kTosca = const Color(0xFFa2c38e);

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.searchQuery;
    _searchController.text = widget.searchQuery;
    fetchArticles();
  }

  void fetchArticles() async {
    // Determine how many to fetch. Fetching a decent amount to ensure search hits something.
    // Ideally backend supports search. Since not, fetching more or just first page.
    final result = await ApiService.getArticles(page: 1, perPage: 20);
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
    final List<Map<String, dynamic>> allServices = [
      {
        "title": "Deteksi",
        "icon": Icons.remove_red_eye_rounded,
        "color": kDarkBlue.withOpacity(0.1),
        "iconColor": kDarkBlue,
        "onTap": () => Navigator.pushNamed(context, '/deteksi'),
      },
      {
        "title": "Rekomendasi",
        "icon": Icons.medication_rounded,
        "color": Colors.orange.withOpacity(0.1),
        "iconColor": Colors.orange,
        "onTap": () => Navigator.pushNamed(context, '/rekomendasi'),
      },
      {
        "title": "Treatment",
        "icon": Icons.health_and_safety_rounded,
        "color": kLightBlue.withOpacity(0.1),
        "iconColor": kLightBlue,
        "onTap": () => Navigator.pushNamed(context, '/treatment'),
      },
      {
        "title": "Chatbot",
        "icon": Icons.chat_bubble_rounded,
        "color": kTosca.withOpacity(0.2),
        "iconColor": Colors.green,
        "onTap": () => Navigator.pushNamed(context, '/chatbot'),
      },
    ];

    final filteredServices = allServices
        .where((service) =>
            service['title'].toString().toLowerCase().contains(_currentQuery.toLowerCase()))
        .toList();

    final filteredArticles = artikelList
        .where((article) => (article['title'] ?? '')
            .toString()
            .toLowerCase()
            .contains(_currentQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              setState(() {
                _currentQuery = value;
              });
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              border: InputBorder.none,
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                color: Colors.grey,
                onPressed: () {
                   setState(() {
                    _currentQuery = _searchController.text;
                  });
                },
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_currentQuery.isNotEmpty) ...[
               Text(
                'Hasil pencarian untuk "$_currentQuery"',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),
            ],
           
            // Services Results
            if (filteredServices.isNotEmpty) ...[
              Text(
                "Layanan",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kDarkBlue,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: filteredServices.map((service) {
                  return _buildServiceIcon(
                    context,
                    title: service['title'],
                    icon: service['icon'],
                    color: service['color'],
                    iconColor: service['iconColor'],
                    onTap: service['onTap'],
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Articles Results
             Text(
              "Artikel",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kDarkBlue,
              ),
            ),
             const SizedBox(height: 16),
             if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (filteredArticles.isEmpty)
                const Center(child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text("Tidak ada artikel ditemukan"),
                ))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredArticles.length,
                  itemBuilder: (context, index) {
                    final artikel = filteredArticles[index];
                    return _buildArticleCard(artikel);
                  },
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> artikel) {
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

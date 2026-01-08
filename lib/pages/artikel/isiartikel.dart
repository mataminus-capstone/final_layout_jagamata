import 'package:flutter/material.dart';
import 'package:jagamata/services/api_service.dart';

class Isiartikel extends StatefulWidget {
  const Isiartikel({super.key});

  @override
  State<Isiartikel> createState() => _IsiartikelState();
}

class _IsiartikelState extends State<Isiartikel> {
  Map<String, dynamic>? articleData;
  bool isLoading = true;
  List<Map<String, dynamic>> relatedArticles = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final articleId = ModalRoute.of(context)?.settings.arguments as int?;
      if (articleId != null) {
        fetchArticleDetail(articleId);
        fetchRelatedArticles();
      }
    });
  }

  void fetchArticleDetail(int articleId) async {
    final result = await ApiService.getArticleDetail(articleId);
    setState(() {
      if (result['success']) {
        articleData = result['data'];
      }
      isLoading = false;
    });
  }

  void fetchRelatedArticles() async {
    final result = await ApiService.getArticles(page: 1, perPage: 5);
    setState(() {
      if (result['success']) {
        relatedArticles = List<Map<String, dynamic>>.from(result['data'] ?? [])
            .where((article) => article['id'] != articleData?['id'])
            .toList()
            .take(5)
            .toList();
      }
    });
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown date';
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return 'Unknown date';
    }
  }

  String _getAuthorUsername() {
    final author = articleData?['author'];
    if (author is Map) {
      return author['username'] ?? 'Unknown';
    } else if (author is String) {
      return author;
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A77A1)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 220,
                        color: Color(0xFF80AFCC),
                        child: Image.asset(
                          'images/maskot.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: 220,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.blue.withOpacity(1),
                              Colors.blue.withOpacity(0.5),
                              Colors.white.withOpacity(0.5),
                              Colors.white.withOpacity(1),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              articleData?['title'] ?? 'No Title',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      size: 15,
                                      color: Colors.white70,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'by ${_getAuthorUsername()}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    const Icon(
                                      Icons.schedule,
                                      size: 15,
                                      color: Colors.white70,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '5 menit baca',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month_outlined,
                                      size: 15,
                                      color: Colors.white70,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _formatDate(articleData?['created_at']),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          articleData?['content'] ?? 'No content available',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.7,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Untuk informasi lebih lanjut, silakan konsultasikan dengan profesional kesehatan.',
                            style: TextStyle(fontSize: 14, height: 1.6),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (relatedArticles.isNotEmpty) ...[
                          const Row(
                            children: [
                              Text(
                                "Artikel Terkait",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                relatedArticles.length,
                                (index) {
                                  final article = relatedArticles[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/isiartikel',
                                        arguments: article['id'],
                                      );
                                    },
                                    child: Container(
                                      width: 200,
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.blue,
                                            Colors.blue[200]!,
                                            Colors.blue[50]!,
                                            Colors.white,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              color: Color(0xFF80AFCC),
                                              child: Image.asset(
                                                'images/maskot.png',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            article['title'] ?? 'No Title',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.person,
                                                size: 12,
                                                color: Colors.white70,
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Builder(
                                                  builder: (context) {
                                                    final author = article['author'];
                                                    String authorName = 'Unknown';
                                                    if (author is Map) {
                                                      authorName = author['username'] ?? 'Unknown';
                                                    } else if (author is String) {
                                                      authorName = author;
                                                    }
                                                    return Text(
                                                      authorName,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white,
                                                      ),
                                                    );
                                                  },
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
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

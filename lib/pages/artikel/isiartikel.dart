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

  // Brand Colors
  final Color kDarkBlue = const Color(0xFF11417f);
  final Color kLightBlue = const Color(0xFF14b4ef);
  final Color kTosca = const Color(0xFFa2c38e);

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
    if (mounted) {
      setState(() {
        if (result['success']) {
          articleData = result['data'];
        }
        isLoading = false;
      });
    }
  }

  void fetchRelatedArticles() async {
    final result = await ApiService.getArticles(page: 1, perPage: 5);
    if (mounted) {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kDarkBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Detail Artikel",
          style: TextStyle(color: kDarkBlue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: kLightBlue))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Article Image
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: articleData?['image_url'] != null
                          ? Image.network(
                              articleData!['image_url'],
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) =>
                                  Container(color: Colors.grey[200], child: const Icon(Icons.broken_image)),
                            )
                          : Container(color: Colors.grey[200], child: const Icon(Icons.image, size: 50)),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Category/Tag (Optional filler if not available)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: kLightBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Kesehatan Mata",
                      style: TextStyle(
                        color: kLightBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    articleData?['title'] ?? 'No Title',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kDarkBlue,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Meta Info (Author & Date)
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey[200],
                        child: Icon(Icons.person, size: 16, color: kDarkBlue),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getAuthorUsername(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: kDarkBlue,
                            ),
                          ),
                          Text(
                            _formatDate(articleData?['created_at']),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Optional: Share/Bookmark Icon
                      IconButton(
                        icon: Icon(Icons.bookmark_border, color: kDarkBlue),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  // Content
                  Text(
                    articleData?['content'] ?? 'No content available',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.8,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 40),

                  // Related Articles Section
                  if (relatedArticles.isNotEmpty) ...[
                    Text(
                      "Artikel Terkait",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kDarkBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: relatedArticles.map((article) {
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
                              margin: const EdgeInsets.only(right: 16),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                    child: article['image_url'] != null
                                        ? Image.network(
                                            article['image_url'],
                                            height: 120,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (ctx, err, stack) =>
                                                Container(height: 120, color: Colors.grey[200], child: const Icon(Icons.image)),
                                          )
                                        : Container(
                                            height: 120, width: double.infinity, color: Colors.grey[200], child: const Icon(Icons.image)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          article['title'] ?? 'No Title',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: kDarkBlue,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _formatDate(article['created_at']),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ],
              ),
            ),
    );
  }
}

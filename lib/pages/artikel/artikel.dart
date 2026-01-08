import 'package:flutter/material.dart';
import 'package:jagamata/services/api_service.dart';

class Artikel extends StatefulWidget {
  const Artikel({super.key});

  @override
  State<Artikel> createState() => _ArtikelState();
}

class _ArtikelState extends State<Artikel> {
  List<Map<String, dynamic>> artikelList = [];
  bool isLoading = true;
  int currentPage = 1;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  void fetchArticles({int page = 1}) async {
    setState(() => isLoading = true);
    
    final result = await ApiService.getArticles(page: page);
    
    if (mounted) {
      setState(() {
        if (result['success']) {
          artikelList = List<Map<String, dynamic>>.from(result['data'] ?? []);
          final pagination = result['pagination'];
          if (pagination != null) {
            totalPages = (pagination['pages'] ?? 1) as int;
            currentPage = page;
          }
          print('[v0] Loaded ${artikelList.length} articles successfully');
        } else {
          print('[v0] Failed to load articles: ${result['message']}');
          artikelList = [];
        }
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Artikel',
          style: TextStyle(
            color: Color(0xFF4A77A1),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : artikelList.isEmpty
              ? const Center(
                  child: Text('Tidak ada artikel tersedia'),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: artikelList.length,
                        itemBuilder: (context, index) {
                          final artikel = artikelList[index];
                          final content = artikel['content'] as String? ?? '';
                          final preview = content.length > 100 
                              ? '${content.substring(0, 100)}...' 
                              : content;
                          
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12, left: 8, right: 8, top: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(1, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  artikel['title'] ?? 'No Title',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  preview,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'by ${artikel['author'] ?? 'Unknown'}',
                                      style: const TextStyle(
                                        color: Colors.black45,
                                        fontSize: 12,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/isiartikel',
                                          arguments: artikel['id'],
                                        );
                                      },
                                      child: const Text(
                                        'Baca selengkapnya...',
                                        style: TextStyle(
                                          color: Color(0xFF2F6F7E),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    if (totalPages > 1)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (currentPage > 1)
                              ElevatedButton(
                                onPressed: () {
                                  fetchArticles(page: currentPage - 1);
                                },
                                child: const Text('Previous'),
                              ),
                            const SizedBox(width: 16),
                            Text('Page $currentPage of $totalPages'),
                            const SizedBox(width: 16),
                            if (currentPage < totalPages)
                              ElevatedButton(
                                onPressed: () {
                                  fetchArticles(page: currentPage + 1);
                                },
                                child: const Text('Next'),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
    );
  }
}

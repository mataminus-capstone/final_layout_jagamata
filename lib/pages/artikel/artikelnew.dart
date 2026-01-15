import 'package:flutter/material.dart';
import 'package:jagamata/services/api_service.dart';

class Artikelnew extends StatefulWidget {
  const Artikelnew({super.key});

  @override
  State<Artikelnew> createState() => _ArtikelnewState();
}

class _ArtikelnewState extends State<Artikelnew> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> artikelList = [];
  bool isLoading = false;
  int currentPage = 1;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    fetchArticles();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        if (hasMore && !isLoading) {
          fetchArticles();
        }
      }
    });
  }

  Future<void> fetchArticles() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      final result = await ApiService.getArticles(page: currentPage, perPage: 10);
      
      if (mounted) {
        setState(() {
          isLoading = false;
          if (result['success']) {
            final newArticles = List<Map<String, dynamic>>.from(result['data']);
            if (newArticles.isEmpty) {
              hasMore = false;
            } else {
              artikelList.addAll(newArticles);
              currentPage++;
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
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
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return 'Baru';
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, title: Text('Semua Artikel', style: TextStyle(color: Colors.black)), iconTheme: IconThemeData(color: Colors.black), elevation: 0),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            // Search Bar (Visual Only for now)
            Container(
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari Artikel...',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[100],
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // List Articles
            Expanded(
              child: artikelList.isEmpty && isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                  itemCount: artikelList.length + (hasMore ? 1 : 0),
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    if (index == artikelList.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final artikel = artikelList[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(-4, 8),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                           Navigator.pushNamed(
                            context,
                            '/isiartikel',
                            arguments: artikel['id'],
                          );
                        },
                        child: Row(
                          children: [
                            // IMAGE
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[200],
                                child: artikel['image_url'] != null
                                    ? Image.network(
                                        artikel['image_url'],
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'images/maskot.png',
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        'images/maskot.png',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),

                            SizedBox(width: 12),

                            // TEXT
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    artikel['title'] ?? 'No Title',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),

                                  SizedBox(height: 6),

                                  Text(
                                    artikel['content'] ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),

                                  SizedBox(height: 8),

                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Artikel',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        _formatDate(artikel['created_at']),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ),
          ],
        ),
      ),
    );
  }
}

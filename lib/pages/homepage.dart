import 'package:flutter/material.dart';
import 'package:jagamata/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class Homopage extends StatefulWidget {
  const Homopage({super.key});

  @override
  State<Homopage> createState() => _HomopageState();
}

class _HomopageState extends State<Homopage> {
  List<Map<String, String>> artikelList = [];
  bool isLoading = true;

  final List<Map<String, String>> fiturList = const [
    {
      'title': 'Deteksi',
      'desc': 'Cek kesehatan mata secara otomatis',
      'img': 'images/maskot.png',
    },
    {
      'title': 'Rekomendasi',
      'desc': 'Gerakan relaksasi untuk menjaga kesehatan mata',
      'img': 'images/maskot.png',
    },
    {
      'title': 'Treatment',
      'desc': 'Dapatkan tips menjaga mata tetap segar',
      'img': 'images/maskot.png',
    },
    {
      'title': 'Chatbot',
      'desc': 'Ingatkan untuk istirahat dari layar',
      'img': 'images/maskot.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  void fetchArticles() async {
    final result = await ApiService.getArticles();
    setState(() {
      if (result['success']) {
        artikelList = List<Map<String, String>>.from(result['data']);
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'JagaMata',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A77A1),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/notif');
                        },
                        child: Icon(Icons.notifications, color: Colors.black54),
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/profil');
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person_outline,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),

              Container(
                height: 180,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(1, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'images/maskot.png',
                      height: 150,
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jaga Mata Kalian 👀',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A7AA3),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Aplikasi ini dapat membantu kalian merilekskan mata dan mendeteksi penyakit mata yang di derita.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 16),

              GridView.builder(
                itemCount: fiturList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.9,
                ),
                itemBuilder: (context, index) {
                  final item = fiturList[index];
                  return InkWell(
                    onTap: () {
                      switch (item['title']) {
                        case 'Deteksi':
                          Navigator.pushNamed(context, '/deteksi');
                          break;
                        case 'Rekomendasi':
                          Navigator.pushNamed(context, '/rekomendasi');
                          break;
                        case 'Treatment':
                          Navigator.pushNamed(context, '/treatment');
                          break;
                        case 'Chatbot':
                          Navigator.pushNamed(context, '/chatbot');
                          break;
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF80AFCC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  item['desc']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image.asset(
                            item['img']!,
                            height: 60,
                            width: 40,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 16),

              Text(
                'Artikel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A77A1),
                ),
              ),
              SizedBox(height: 8),

              if (isLoading)
                Center(child: CircularProgressIndicator())
              else
                Column(
                  children: List.generate(
                    artikelList.length > 3 ? 3 : artikelList.length,
                    (index) {
                      final artikel = artikelList[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(8),
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
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                artikel['gambar']!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    artikel['judul']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    artikel['ringkasan']!,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  InkWell(
                                    onTap: () {
                                      if (artikel.containsKey('url')) {
                                        launchUrl(Uri.parse(artikel['url']!));
                                      }
                                    },
                                    child: Text(
                                      'Baca selengkapnya...',
                                      style: TextStyle(
                                        color: Color(0xFF2F6F7E),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              SizedBox(height: 15),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/artikel');
                  },
                  child: Text(
                    "Lihat selengkapnya",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

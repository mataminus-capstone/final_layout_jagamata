import 'package:flutter/material.dart';

class Isiartikel extends StatefulWidget {
  const Isiartikel({super.key});

  @override
  State<Isiartikel> createState() => _IsiartikelState();
}

class _IsiartikelState extends State<Isiartikel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= IMAGE =================
            Stack(
              children: [
                Image.asset(
                  'images/maskot.png',
                  width: double.infinity,
                  height: 220,
                  // fit: BoxFit.cover,
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
                        '5 Buah yang Baik untuk\nKesehatan Mata',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.label,
                                size: 15,
                                color: Colors.white70,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Tips Mata ',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 20),
                              Icon(
                                Icons.schedule,
                                size: 15,
                                color: Colors.white70,
                              ),
                              SizedBox(width: 6),
                              Text(
                                '3 menit baca',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                size: 15,
                                color: Colors.white70,
                              ),
                              SizedBox(width: 6),
                              Text(
                                '24 Juni 2025',
                                style: TextStyle(
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

            SizedBox(height: 16),

            /// ================= TITLE =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                children: [
                  /// ================= INTRO =================
                  Text(
                    'Buah-buahan yang kaya akan vitamin A dan antioksidan '
                    'memiliki peran penting dalam menjaga kesehatan mata '
                    'serta mencegah berbagai gangguan penglihatan.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.grey[800],
                    ),
                  ),

                  SizedBox(height: 20),

                  /// ================= CONTENT =================
                  Text(
                    '1. Wortel\n'
                    'Wortel dikenal sebagai sumber vitamin A yang sangat baik. '
                    'Vitamin A membantu menjaga kesehatan retina dan mencegah '
                    'rabun senja.\n\n'
                    '2. Jeruk\n'
                    'Jeruk mengandung vitamin C yang berperan sebagai antioksidan '
                    'untuk melindungi mata dari kerusakan akibat radikal bebas.\n\n'
                    '3. Alpukat\n'
                    'Alpukat kaya akan lutein yang membantu melindungi mata dari '
                    'paparan cahaya biru berlebih.\n\n',
                    // '4. Pepaya\n'
                    // 'Pepaya mengandung vitamin A dan vitamin C yang berfungsi '
                    // 'sebagai antioksidan untuk melindungi mata dari penuaan dini '
                    // 'dan menjaga kesehatan sel mata.\n\n'
                    // '5. Tomat\n'
                    // 'Tomat kaya akan likopen dan vitamin A yang membantu '
                    // 'melindungi mata dari kerusakan akibat paparan cahaya dan '
                    // 'menjaga fungsi penglihatan tetap optimal.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.7,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 15),

                  /// ================= CONCLUSION =================
                  Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Kesimpulan:\n\n'
                      'Mengonsumsi buah-buahan secara rutin dapat membantu '
                      'menjaga kesehatan mata dan meningkatkan kualitas penglihatan '
                      'dalam jangka panjang.',
                      style: TextStyle(fontSize: 14, height: 1.6),
                    ),
                  ),
                  SizedBox(height: 20),
                  // ARTIKEL LAINNYA CARD HORIZONTAL
                  Row(
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
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          width: 200,
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(12),
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
                                child: Image.asset(
                                  'images/maskot.png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Indonesia Emas 2045 ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Icon(
                                    Icons.label,
                                    size: 15,
                                    color: Colors.white70,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Indonesia',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: 200,
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(12),
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
                                child: Image.asset(
                                  'images/maskot.png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Indonesia Emas 2045 ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.label,
                                    size: 15,
                                    color: Colors.white70,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Indonesia',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 200,
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(12),
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
                                child: Image.asset(
                                  'images/maskot.png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Indonesia Emas 2045 ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Icon(
                                    Icons.label,
                                    size: 15,
                                    color: Colors.white70,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Indonesia',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 200,
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(12),
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
                                child: Image.asset(
                                  'images/maskot.png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Indonesia Emas 2045 ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Icon(
                                    Icons.label,
                                    size: 15,
                                    color: Colors.white70,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Indonesia',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 200,
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(12),
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
                                child: Image.asset(
                                  'images/maskot.png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Indonesia Emas 2045 ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Icon(
                                    Icons.label,
                                    size: 15,
                                    color: Colors.white70,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Indonesia',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 200,
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(12),
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
                                child: Image.asset(
                                  'images/maskot.png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Indonesia Emas 2045 ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Icon(
                                    Icons.label,
                                    size: 15,
                                    color: Colors.white70,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Indonesia',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),

            SizedBox(height: 8),

            /// ================= META INFO =================
          ],
        ),
      ),
    );
  }
}

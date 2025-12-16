import 'package:flutter/material.dart';

class Notifikasi extends StatelessWidget {
  const Notifikasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Notifikasi',
              style: TextStyle(
                color: Color(0xFF4A77A1),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(width: 20),
            Icon(Icons.notifications, color: Color(0xFF4A77A1)),
          ],
        ),

        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Text(
                  "Reminder",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 450,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 238, 248, 255),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/treatment");
                  },
                  child:Row(
                  children: [
                    Icon(Icons.alarm, size: 30, color: Colors.blue),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Treatment",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "30m ago",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(height: 1),
                          Text(
                            "Jangan lupa lakukan treatment hari ini",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
               ,
                )
                
                ,SizedBox(height: 25),
                
                Row(
                  children: [
                    Icon(
                      Icons.remove_red_eye_outlined,
                      size: 30,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Eye Care",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "9m ago",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(height: 1),
                          Text(
                            // teks eye care bertujuan agar user peduli jaga mata
                            "ingat! mata sehat adalah investasi masa depan",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          Divider(
            color: Colors.grey, // warna garis
            thickness: 2, // ketebalan garis
            endIndent: 30,
            indent: 30,
          ),

          //
          
          Container(
            padding: EdgeInsets.only(top: 20),
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Text(
                  "Update",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 450,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 238, 248, 255),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.article_sharp, size: 32, color: Colors.blue),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Artikel ",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "3m ago",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(height: 1),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Beberapa Buah yang Baik untuk Kesehatan Mata...",
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/artikel');
                                },
                                child: Text(
                                  "Baca Sekarang",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.article_sharp, size: 32, color: Colors.blue),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "oArtikel ",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "3m ago",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(height: 1),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Beberapa Buah yang Baik untuk Kesehatan Mata...",
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/artikel');
                                },
                                child: Text(
                                  "Baca Sekarang",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Divider(
            color: Colors.grey, // warna garis
            thickness: 2, // ketebalan garis
            endIndent: 30,
            indent: 30,
          ),

          // Container(
          //   width: 450,
          //   padding: EdgeInsets.all(15),
          //   decoration: BoxDecoration(
          //     color: Color(0xFF80AFCC),
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       SizedBox(width: 15),
          //       Flexible(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               "Senam Mata",
          //               style: TextStyle(
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: 20,
          //               ),
          //             ),
          //             SizedBox(height: 7),
          //             Text(
          //               "Perlu dicek Rutin setiap hari, "
          //               "Lakukan senam maata pada jam 19.90 "
          //               " ",
          //               style: TextStyle(color: Colors.black),
          //             ),
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.end,
          //               children: [Text("19.99"), SizedBox(width: 15)],
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 15),
          // Divider(
          //   color: Colors.grey, // warna garis
          //   thickness: 2, // ketebalan garis
          //   endIndent: 30,
          //   indent: 30,
          // ),

          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 30),
          //   child: Row(
          //     children: [
          //       Text(
          //         "Kemarin",
          //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          //       ),
          //     ],
          //   ),
          // ),

          // Container(
          //   width: 450,
          //   padding: EdgeInsets.all(15),
          //   decoration: BoxDecoration(
          //     color: Color(0xFF80AFCC),
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       SizedBox(width: 15),
          //       Flexible(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               "Senam Mata",
          //               style: TextStyle(
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: 20,
          //               ),
          //             ),
          //             SizedBox(height: 7),
          //             Text(
          //               "Perlu dicek Rutin setiap hari, "
          //               "Lakukan senam maata pada jam 19.90 "
          //               " ",
          //               style: TextStyle(color: Colors.black),
          //             ),
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.end,
          //               children: [Text("19.99"), SizedBox(width: 15)],
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 15),
          // Divider(
          //   color: Colors.grey, // warna garis
          //   thickness: 2, // ketebalan garis
          //   endIndent: 30,
          //   indent: 30,
          // ),
        ],
      ),
    );
  }
}

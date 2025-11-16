import 'package:flutter/material.dart';

class Notifikasi extends StatelessWidget {
  const Notifikasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifikasi',
          style: TextStyle(color: Color(0xFF4A77A1), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Text(
                    "Hari Ini",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            Container(
              width: 450,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFF80AFCC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //gambar
                  Container(
                    margin: EdgeInsets.all(10),
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPtCRyWlWl3c1WyAbhz5oMSGFSFTUrd82JaA&s',
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Udin",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          "Perlu dicek Rutin setiap hari, "
                          "Perlu dicek Rutin setiap hari, "
                          "Perlu dicek Rutin setiap hari, ",
                          style: TextStyle(color: Colors.black),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Text("19.99"), SizedBox(width: 15)],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Divider(
              color: Colors.grey, // warna garis
              thickness: 2, // ketebalan garis
              endIndent: 30,
              indent: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Text(
                    "Kemarin",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            Container(
              width: 450,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFF80AFCC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPtCRyWlWl3c1WyAbhz5oMSGFSFTUrd82JaA&s',
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Udin",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          "Perlu dicek Rutin setiap hari, "
                          "Perlu dicek Rutin setiap hari, "
                          "Perlu dicek Rutin setiap hari, ",
                          style: TextStyle(color: Colors.black),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Text("19.99"), SizedBox(width: 15)],
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
}

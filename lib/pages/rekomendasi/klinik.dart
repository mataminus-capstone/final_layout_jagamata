import 'package:flutter/material.dart';

class KlinikMata extends StatelessWidget {
  const KlinikMata({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text(
              'Daftar Rekomendasi Klinik Mata',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),

            //search
            Container(
              width: 350,
              margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hint: Text('Cari Klinik Mata Terdekat'),
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/cobain');
                    },
                    child: Icon(Icons.filter_alt, color: Colors.grey),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterChip(label: Text("Terdekat"), onSelected: (_) {}),
                FilterChip(label: Text("Terbaik"), onSelected: (_) {}),
                FilterChip(label: Text("Buka Sekarang"), onSelected: (_) {}),
              ],
            ),

            Container(
              width: 350,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFF80AFCC),
              ),
              child: ListTile(
                onTap: () {},
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "KLinik A",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Jalan Merdeka No.1"),
                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 18,
                            ),
                            Text("1.2 km"),
                            SizedBox(width: 15),
                            Icon(
                              Icons.access_time_rounded,
                              color: Colors.black,
                              size: 18,
                            ),
                            Text("19.16"),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.blue[800],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.call, color: Colors.white, size: 15),
                              SizedBox(width: 6),
                              Text(
                                'Telepon',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Container(
              width: 350,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFF80AFCC),
              ),
              child: ListTile(
                onTap: () {},
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "KLinik B",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Jalan Ga Merdeka No.99"),
                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 18,
                            ),
                            Text("9 km"),
                            SizedBox(width: 15),
                            Icon(
                              Icons.access_time_rounded,
                              color: Colors.black,
                              size: 18,
                            ),
                            Text("19.16"),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.blue[800],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.call, color: Colors.white, size: 15),
                              SizedBox(width: 6),
                              Text(
                                'Telepon',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Container(
              width: 350,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFF80AFCC),
              ),
              child: ListTile(
                onTap: () {},
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "KLinik C",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Jalan Hampir Merdeka No.1/5"),
                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 18,
                            ),
                            Text("4 km"),
                            SizedBox(width: 15),
                            Icon(
                              Icons.access_time_rounded,
                              color: Colors.black,
                              size: 18,
                            ),
                            Text("19.16"),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.blue[800],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.call, color: Colors.white, size: 15),
                              SizedBox(width: 6),
                              Text(
                                'Telepon',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
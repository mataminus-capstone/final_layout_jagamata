import 'package:flutter/material.dart';

class Rekomendasi extends StatelessWidget {
  const Rekomendasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rekomendasi',
          style: TextStyle(color: Color(0xFF4A77A1), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text('Rekomendasi Untuk Anda', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold ),),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('Berdasarkan deteksi mata anda,'
                  'berikut beberapa rekomendasi yang mungkin bermanfaat.', style: TextStyle(fontSize: 14),),
                ),
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
            child: 
            ListTile(onTap: () {
              Navigator.pushNamed(context, '/klinik');
            },
            title:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("KLinik Mata", style: TextStyle(fontSize: 18, color: Colors.blue[900], fontWeight: FontWeight.bold)), 
                SizedBox(height:10,),
                Text("Ada beberapa rekomendasi klinik yang dapat menanganin masalah penyakit mata."),
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
            child: 
            ListTile(onTap: () {
              
            },
            title:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Obat Mata", style: TextStyle(fontSize: 18, color: Colors.blue[900], fontWeight: FontWeight.bold)), 
                SizedBox(height:10,),
                Text("Ada beberapa rekomendasi obat terkait permasalahan mata ringan"),
              ],
            ),
          
            ),
          )
          ],
          
        ),
      ),
    );
  }
}
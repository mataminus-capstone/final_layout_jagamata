import 'package:flutter/material.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('aset/image.jpg'),
                      ),
                      SizedBox(width: 15),
                      Text("ChatBot AI"),
                    ],
                  ),
                  Icon(Icons.more_vert),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            
            width: 502,
            decoration: BoxDecoration(color: Colors.blue[50]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      
                      margin: EdgeInsets.only(top:20, left: 10),
                      padding: EdgeInsets.symmetric(horizontal:10),
                      width: 250,
                      // panjang maxs dari kata nihhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
                      constraints: BoxConstraints(
                        minHeight: 40,
                        maxWidth: 1000
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue[200],
                      ),
                      child: Row(
                        children: [Flexible(child: Text("hayy apakah ada yang bisa saya bantu?", softWrap: true,),),]),
                    ),
                  ],
                ),      
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top:20, right: 10),
                      padding: EdgeInsets.symmetric(horizontal:10),
                      width: 250,
                      // panjang maxs dari kata nihhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
                      constraints: BoxConstraints(
                        minHeight: 40,
                        maxWidth: 1000
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue[200],
                      ),
                      child: Row(
                        children: [Flexible(child: Text("gimna cara dapetin kraken siiiii", softWrap: true,))]),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top:20, left: 10),
                      padding: EdgeInsets.symmetric(horizontal:10),
                      width: 250,
                      // panjang maxs dari kata nihhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
                      constraints: BoxConstraints(
                        minHeight: 40,
                        maxWidth: 1000
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue[200],
                      ),
                      child: Row(
                        children: [Flexible(child: Text("yahahaha", softWrap: true,))]),
                    ),
                  ],
                ),

              ],
            ),
        
          ),
          // text field di bagian bawah
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Ketik pesan...",
                  suffixIcon: Icon(Icons.send_sharp),

                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
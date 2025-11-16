import 'dart:math';

import 'package:flutter/material.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String get $user => 'Rhiki';
  String get $username => '@riki123';
  String get $fullname => 'Rhiki Sulistiyo';
  String get $email => 'rhikisulistiyo@gmail.com';
  String? get $notelp => '0895339162828';
  String? get $alamat => 'JL. Merpati No. 23, Surabaya';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  $user,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/setting');
              },
              child: Icon(Icons.settings),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              children: [
                // Foto profil
                SizedBox(height: 20),
                Stack(
                  children: [
                    // Avatar utama
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[500],
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),

                    // Ikon kamera di pojok kanan bawah
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),

                // Nama dan info lainnya
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(top: 40, bottom: 20),
                  width: 400,
                  decoration: BoxDecoration(
                    color: Color(0xFF80AFCC),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(-10, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 10),
                          Text("Data Pengguna"),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text("Username", style: TextStyle(fontSize: 15)),
                          TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: $username,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("Fullname", style: TextStyle(fontSize: 15)),
                          TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: $fullname,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("Email", style: TextStyle(fontSize: 15)),
                          TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: $email,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("No.HP", style: TextStyle(fontSize: 15)),
                          TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: $notelp,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("Alamat", style: TextStyle(fontSize: 15)),
                          TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: $alamat,
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                      // Button Edit
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.blue),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Text(
                                "Edit Profile",
                                textAlign: TextAlign.center,
                              ),
                              content: Container(
                                width: 350,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        labelText: 'Fullname',
                                        hintText: $fullname,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        hintText: $notelp,
                                        labelText: 'No.HP',
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        hintText: $alamat,
                                        labelText: 'Alamat',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Batal"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Lanjutkan"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit, color: Colors.black),
                            SizedBox(width: 15),
                            Text("Ubah Profil"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),

                // Password
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(vertical: 20),
                  width: 400,
                  decoration: BoxDecoration(
                    color: Color(0xFF80AFCC),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(-10, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lock),
                          SizedBox(width: 10),
                          Text("Password "),
                        ],
                      ),
                      SizedBox(height: 10),

                      SizedBox(
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: '*',
                            hintStyle: TextStyle(color: Colors.grey),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shadowColor: Colors.grey,
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [Text("Ubah Password Now")],
                                    ),
                                    content: Container(
                                      width: 350,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              hintText: 'Masukan password Lama',
                                              labelText: 'Password Lama',
                                            ),
                                          ),
                                          SizedBox(height: 20),

                                          TextField(
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              hintText: 'Masukan password Baru',
                                              labelText: 'Password Baru',
                                            ),
                                          ),
                                          SizedBox(height: 20),

                                          TextField(
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              hintText:
                                                  'Masukan Ulang Password',
                                              labelText: 'Password Baru',
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Batal"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Lanjutkan"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Icon(Icons.edit_square),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),

                // button log-out
                SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.logout_rounded, color: Colors.red),
                  label: Text("Logout", style: TextStyle(color: Colors.red)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

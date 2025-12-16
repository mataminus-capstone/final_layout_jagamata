import 'package:flutter/material.dart';

class Profil1 extends StatefulWidget {
  const Profil1({super.key});

  @override
  State<Profil1> createState() => _Profil1State();
}

class _Profil1State extends State<Profil1> {
  String get $user => 'Rhiki';
  String get $username => '@riki123';
  String get $fullname => 'Rhiki Sulistiyo';
  String get $email => 'rhikisulistiyo@gmail.com';
  String? get $notelp => '0895339162828';
  String? get $alamat => 'JL. Merpati No. 23, Surabaya';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Profil",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/setting');
              },
              child: Icon(Icons.settings),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // ===== BACKGROUND BIRU =====
            Container(
              height: 280,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Color.fromARGB(255, 24, 102, 167)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),

            // ===== TEXT DATA DIRI =====
            Container(
              margin: EdgeInsets.only(top: 380),
              padding: EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        " Data Diri ",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.person, size: 30),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      // ===== EMAIL =====
                      Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: Icon(Icons.email),
                          title: Text('Email'),
                          subtitle: Text($email),
                        ),
                      ),

                      // ===== TELEPON =====
                      Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: Icon(Icons.phone),
                          title: Text('No. Telepon'),
                          subtitle: Text($notelp!),
                        ),
                      ),

                      // ===== ALAMAT =====
                      Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: Icon(Icons.home),
                          title: Text('Alamat'),
                          subtitle: Text($alamat!),
                        ),
                      ),

                      SizedBox(height: 10),
                      // ===== BUTTON EDIT =====
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            side: BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                              Icon(Icons.edit, color: Colors.white),
                              SizedBox(width: 15),
                              Text(
                                "Ubah Profil",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // ===== TEXT PASS =====
            Container(
              margin: EdgeInsets.only(top: 750),
              padding: EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Password & Security",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.security, size: 30),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
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
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shadowColor: Colors.grey,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Ubah Password Now"),
                                            ],
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
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    hintText:
                                                        'Masukan password Lama',
                                                    labelText: 'Password Lama',
                                                  ),
                                                ),
                                                SizedBox(height: 20),

                                                TextField(
                                                  obscureText: true,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    hintText:
                                                        'Masukan password Baru',
                                                    labelText: 'Password Baru',
                                                  ),
                                                ),
                                                SizedBox(height: 20),

                                                TextField(
                                                  obscureText: true,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
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

                      SizedBox(height: 30),
                    ],
                  ),
                ],
              ),
            ),

            // ===== BUTTON LOGOUT =====
            Container(
              margin: EdgeInsets.only(top: 950, bottom: 20),
              padding: EdgeInsets.only(left: 20),
              width: MediaQuery.of(context).size.width * 0.8,

              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.logout_rounded, color: Colors.white),
                label: Text("Logout", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  side: BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            
            // ===== KONTEN PUTIH =====
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.only(top: 150),
              padding: EdgeInsets.only(top: 60, bottom: 50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    $fullname,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    $username,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // ===== FOTO PROFIL (TENGAH BIRU & PUTIH) =====
            Positioned(
              top: 50,
              child: CircleAvatar(
                radius: 75,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey,
                  // backgroundImage: NetworkImage(profileImage),
                ),
              ),
            ),

            Positioned(
              top: 150,
              right: 170,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(6),
                child: InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

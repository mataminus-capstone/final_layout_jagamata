import 'package:flutter/material.dart';
import 'package:jagamata/services/api_service.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  bool isLoading = true;
  Map<String, dynamic>? userData;

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() => isLoading = true);
    final result = await ApiService.getCurrentUser();
    if (result['success']) {
      setState(() {
        userData = result['data'];
        _addressController.text = userData?['address'] ?? '';
        _phoneController.text = userData?['phone_number'] ?? '';
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Gagal memuat profil')),
        );
      }
    }
  }

  Future<void> _updateProfile() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    final result = await ApiService.updateProfile(
      address: _addressController.text,
      phoneNumber: _phoneController.text,
    );

    if (mounted) Navigator.pop(context); // Close loading

    if (result['success']) {
      setState(() {
        userData?['address'] = _addressController.text;
        userData?['phone_number'] = _phoneController.text;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil berhasil diperbarui')),
        );
        Navigator.pop(context); // Close edit dialog
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Gagal memperbarui profil')),
        );
      }
    }
  }

  void _showEditDialog() {
    _addressController.text = userData?['address'] ?? '';
    _phoneController.text = userData?['phone_number'] ?? '';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Profil"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: "Alamat",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: "Nomor Telepon",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: _updateProfile,
            child: Text("Simpan"),
          ),
        ],
      ),
    );
  }
  
  void _logout() {
     ApiService.logout();
     Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    final email = userData?['email'] ?? '-';
    final userFullname = userData?['username'] ?? 'User'; // Adjust if you have a fullname field
    final userUsername = userData?['username'] != null ? '@${userData!['username']}' : ''; 
    final phone = userData?['phone_number'] ?? '-';
    final address = userData?['address'] ?? '-';
    final profilePic = userData?['profile_picture'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Profil",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/setting');
              },
              child: Icon(Icons.settings, color: Colors.white),
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
                          subtitle: Text(email),
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
                          subtitle: Text(phone),
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
                          subtitle: Text(address),
                        ),
                      ),

                      SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/history_detection');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.history, color: Colors.blue),
                              SizedBox(width: 15),
                              Text(
                                "Riwayat Deteksi",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),

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
                          onPressed: _showEditDialog,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                      
                      // Spacing instead of password section
                      SizedBox(height: 30),
                      
                      // ===== BUTTON LOGOUT =====
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.only(bottom: 40),
                        child: ElevatedButton.icon(
                          onPressed: _logout,
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
                    ],
                  ),
                ],
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
                    userFullname,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userUsername,
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
                  backgroundImage: (profilePic != null && profilePic.isNotEmpty) 
                      ? NetworkImage(profilePic) 
                      : null,
                  child: (profilePic == null || profilePic.isEmpty) 
                      ? Icon(Icons.person, size: 60, color: Colors.white) 
                      : null,
                ),
              ),
            ),

            Positioned(
              top: 150,
              right: MediaQuery.of(context).size.width/2 - 90, // Approximate positioning, originally hardcoded right: 170
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

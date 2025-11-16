import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String get $user => 'Rhiki';
  String get $username => '@riki123';
  String get $fullname => 'Rhiki Sulistiyo';
  String get $email => 'rhikisulistiyo@gmail.com';
  String? get $notelp => '0895339162828';
  String? get $alamat => 'JL. Merpati No. 23, Surabaya';

  String? _selectedItem;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pengaturan")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          //  Preferensi
          Text(
            "Preferensi",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.language, color: Colors.blue),
                  title: Text("Bahasa"),
                  trailing: DropdownButton(
                    value: "Indonesia",
                    items: ["Indonesia", "English"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {},
                  ),
                ),
                SwitchListTile(
                  secondary: Icon(Icons.notifications, color: Colors.blue),
                  title: Text("Notifikasi"),
                  value: true,
                  onChanged: (value) {},
                ),
                // SwitchListTile(
                //   secondary: Icon(Icons.call, color: Colors.blue),
                //   title: Text("Telepon"),
                //   value: false,
                //   onChanged: (value) {},
                // ),
              ],
            ),
          ),

          SizedBox(height: 20),

          //  Privasi
          Text(
            "Privasi",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined, color: Colors.blue),
                  title: Text("Kebijakan Privasi"),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.article_outlined, color: Colors.blue),
                  title: Text("Syarat & Ketentuan"),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          //  Tentang
          Text(
            "Tentang",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline, color: Colors.blue),
                  title: Text("Tentang Aplikasi"),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: "EyeCare App",
                      applicationVersion: "v1.0.0",
                      children: [
                        Text(
                          "Aplikasi untuk membantu pemantauan kesehatan mata.",
                        ),
                      ],
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.phone, color: Colors.blue),
                  title: Text("Hubungi Kami"),
                  subtitle: Text("support@eyecare.id"),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
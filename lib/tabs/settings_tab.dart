import 'package:flutter/material.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingsCategory('Account', [
            _buildSettingTile(Icons.person, Colors.purple, 'Your Profile'),
            _buildSettingTile(Icons.security, Colors.red, 'Security'),
            _buildSettingTile(Icons.language, Colors.green, 'Language'),
          ]),
          const SizedBox(height: 20),
          _buildSettingsCategory('Preferences', [
            _buildSettingTile(Icons.notifications_active, Colors.orange, 'Notifications'),
            _buildSettingTile(Icons.dark_mode, Colors.indigo, 'Appearance'),
            _buildSettingTile(Icons.privacy_tip, Colors.teal, 'Privacy'),
          ]),
          const SizedBox(height: 20),
          _buildSettingsCategory('Support', [
            _buildSettingTile(Icons.help_outline, Colors.blue, 'Help Center'),
            _buildSettingTile(Icons.feedback, Colors.amber, 'Send Feedback'),
            _buildSettingTile(Icons.info_outline, Colors.cyan, 'About'),
          ]),
          const SizedBox(height: 40),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text('Log Out', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCategory(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingTile(IconData icon, Color color, String title) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}

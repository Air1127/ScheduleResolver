import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


/// A screen that displays and lets a new user set up their profile information.
class ProfileScreen extends StatefulWidget {
  final String displayName;

  const ProfileScreen({super.key, required this.displayName});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _bio;
  String? _city;
  String? _about;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your profile')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeader(),
            _buildNameAndSetupPrompt(),
            const Divider(thickness: 1.0),
            _buildSetupActions(),
            const Divider(thickness: 1.0),
            _buildAboutPreview(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return SizedBox(
      height: 240,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Container(
              color: const Color(0xFFE4E6EB),
              child: const Center(
                child: Text(
                  'Add cover photo',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 140,
            child: GestureDetector(
              onTap: () async {
                final picked = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (picked != null) {
                  setState(() {
                    _profileImage = File(picked.path);
                  });
                }
              },
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : null,
                child: _profileImage == null
                    ? const Icon(
                  Icons.camera_alt,
                  size: 32,
                  color: Colors.black54,
                )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameAndSetupPrompt() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.displayName.isEmpty
                ? 'New Facebook User'
                : widget.displayName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            _bio == null || _bio!.isEmpty
                ? 'Let your friends know it\'s you by completing your profile.'
                : _bio!,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set up your profile',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildSetupCard(
            icon: Icons.camera_alt,
            title: 'Add profile picture',
            subtitle: 'People are more likely to recognize you.',
          ),
          _buildSetupCard(
            icon: Icons.edit,
            title: 'Add a bio',
            subtitle: 'Share a few words about yourself.',
            onTap: () => _editField(
              title: 'Bio',
              initial: _bio,
              onSaved: (value) {
                setState(() {
                  _bio = value;
                });
              },
            ),
          ),
          _buildSetupCard(
            icon: Icons.home,
            title: 'Add your current city',
            subtitle: 'Let friends know where you live now.',
            onTap: () => _editField(
              title: 'Current city',
              initial: _city,
              onSaved: (value) {
                setState(() {
                  _city = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE7F3FF),
          child: Icon(icon, color: const Color(0xFF1777F2)),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildAboutPreview() {
    final String aboutText = _about == null || _about!.isEmpty
        ? 'Add details like your work, school, and relationship status so friends can learn more about you.'
        : _about!;

    final String cityText = _city == null || _city!.isEmpty
        ? 'Current city: not set'
        : 'Current city: $_city';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            aboutText,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            cityText,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _editField(
              title: 'About',
              initial: _about,
              onSaved: (value) {
                setState(() {
                  _about = value;
                });
              },
            ),
            child: const Text('Edit about info'),
          ),
        ],
      ),
    );
  }

  Future<void> _editField({
    required String title,
    String? initial,
    required ValueChanged<String> onSaved,
  }) async {
    final controller = TextEditingController(text: initial ?? '');

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(hintText: title),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      onSaved(result);
    }
  }
}

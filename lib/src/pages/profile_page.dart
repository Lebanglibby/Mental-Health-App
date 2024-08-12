// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';

  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _email;
  String? _phone;
  String? _age;
  String? _selectedGender;
  String? _selectedCountry;
  String? _selectedMaritalStatus;
  File? _profileImage;
  bool _isEditing = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _countries = [
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
    'Zimbabwe'
  ];
  final List<String> _maritalStatuses = ['Single', 'Married', 'Divorced', 'Widowed'];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _email = user.email;
      });

      try {
        DocumentSnapshot snapshot = await _firestore.collection('users').doc(user.uid).get();

        if (snapshot.exists) {
          print('Document data: ${snapshot.data()}'); // Debugging line
          setState(() {
            _phone = snapshot.get('phone') ?? '';
            _age = snapshot.get('age') ?? '';
            _selectedGender = snapshot.get('gender') ?? '';
            _selectedCountry = snapshot.get('country') ?? '';
            _selectedMaritalStatus = snapshot.get('maritalStatus') ?? '';
          });

          // Load profile picture
          String? photoUrl = user.photoURL;
          if (photoUrl != null) {
            _profileImage = await _downloadImage(photoUrl);
          }
        } else {
          print('Document does not exist for user UID: ${user.uid}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data not found!')),
          );
        }
      } catch (e) {
        print('Error loading user data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading user data!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user is currently logged in!')),
      );
    }
  }

  Future<File?> _downloadImage(String imageUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      final data = await ref.getData();
      if (data != null) {
        final tempDir = Directory.systemTemp;
        final file = File('${tempDir.path}/profile_image.jpg');
        await file.writeAsBytes(data);
        return file;
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
    return null;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _removeImage() async {
    setState(() {
      _profileImage = null;
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      User? user = _auth.currentUser;
      if (user != null) {
        try {
          String? photoUrl;
          if (_profileImage != null) {
            final ref = _storage.ref().child('profile_images/${user.uid}.jpg');
            await ref.putFile(_profileImage!);
            photoUrl = await ref.getDownloadURL();
          }

          await user.updateProfile(photoURL: photoUrl);

          await _firestore.collection('users').doc(user.uid).update({
            'phone': _phone,
            'age': _age,
            'gender': _selectedGender,
            'country': _selectedCountry,
            'maritalStatus': _selectedMaritalStatus,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );

          setState(() {
            _isEditing = false;
          });
        } catch (e) {
          print('Error updating profile: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error updating profile!')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Profile' : 'Profile'),
        backgroundColor: const Color(0xFF1b263b),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: _isEditing
              ? _buildEditForm()
              : _buildProfileView(),
        ),
      ),
    );
  }

  Widget _buildProfileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: const Color(0xFF5c677d),
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : const AssetImage('assets/default_profile.png') as ImageProvider,
              ),
              if (_profileImage != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: _removeImage,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text('Email: $_email', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 16),
        Text('Phone: $_phone', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 16),
        Text('Age: $_age', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 16),
        Text('Gender: $_selectedGender', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 16),
        Text('Country: $_selectedCountry', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 16),
        Text('Marital Status: $_selectedMaritalStatus', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5c677d),
          ),
          child: const Text('Edit Profile'),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: const Color(0xFF5c677d),
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : const AssetImage('assets/default_profile.png') as ImageProvider,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField('Phone', _phone, (value) => _phone = value),
          const SizedBox(height: 16),
          _buildTextField('Age', _age, (value) => _age = value),
          const SizedBox(height: 16),
          _buildDropdown('Gender', _genders, _selectedGender, (value) => _selectedGender = value),
          const SizedBox(height: 16),
          _buildDropdown('Country', _countries, _selectedCountry, (value) => _selectedCountry = value),
          const SizedBox(height: 16),
          _buildDropdown('Marital Status', _maritalStatuses, _selectedMaritalStatus, (value) => _selectedMaritalStatus = value),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5c677d),
              ),
              child: const Text('Save'),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isEditing = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String? initialValue, FormFieldSetter<String> onSaved) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label),
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown(String label, List<String> options, String? selectedValue, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      items: options.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList(),
      decoration: InputDecoration(labelText: label),
      onChanged: (value) {
        setState(() {
          onChanged(value);
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your $label';
        }
        return null;
      },
    );
  }
}


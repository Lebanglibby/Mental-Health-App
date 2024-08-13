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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
          _scaffoldKey.currentState?.showSnackBar(
            const SnackBar(content: Text('User data not found!')),
          );
        }
      } catch (e) {
        _scaffoldKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Error loading user data!')),
        );
      }
    } else {
      _scaffoldKey.currentState?.showSnackBar(
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

          _scaffoldKey.currentState?.showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );

          setState(() {
            _isEditing = false;
          });
        } catch (e) {
          print('Error updating profile: $e');
          _scaffoldKey.currentState?.showSnackBar(
            const SnackBar(content: Text('Error updating profile!')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Profile' : 'Profile'),
        backgroundColor:const Color.fromARGB(255, 2, 61, 171),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: _isEditing
                    ? _buildEditForm()
                    : _buildProfileView(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.blueGrey),
              onPressed: () {
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
            IconButton(
              icon: const Icon(Icons.chat, color: Colors.blueGrey),
              onPressed: () {
                Navigator.pushNamed(context, '/chat');
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.blueGrey),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            IconButton(
              icon: const Icon(Icons.local_hospital, color: Colors.blueGrey),
              onPressed: () {
                Navigator.pushNamed(context, '/emergency_support');
              },
            ),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.blueGrey),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF1b263b),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.track_changes),
              title: const Text('Appointments'),
              onTap: () {
                 Navigator.pushNamed(context, '/Appointments');
              },
            ),
            ListTile(
              leading: const Icon(Icons.library_books),
              title: const Text('Resource Library'),
              onTap: () {
                Navigator.pushNamed(context, '/resource_library');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
             ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sign Out'),
            onTap: () async {
              Navigator.pushReplacementNamed(context, '/login'); 
            },
          ),
          ],
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
              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  onPressed: _pickImage,
                  tooltip: 'Change profile picture',
                  color: const Color(0xFF5c677d),
                ),
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
        const SizedBox(height: 16),
        _buildProfileInfo('Email', _email),
        _buildProfileInfo('Phone', _phone),
        _buildProfileInfo('Age', _age),
        _buildProfileInfo('Gender', _selectedGender),
        _buildProfileInfo('Country', _selectedCountry),
        _buildProfileInfo('Marital Status', _selectedMaritalStatus),
        const SizedBox(height: 32),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
            child: Text(_isEditing ? 'Cancel' : 'Edit Profile'),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(child: Text('$label:')),
          Expanded(
            child: Text(
              value ?? 'Not provided',
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileImagePicker(),
          const SizedBox(height: 16),
          _buildTextField('Phone', _phone, (value) => _phone = value),
          _buildTextField('Age', _age, (value) => _age = value),
          _buildDropdown('Gender', _selectedGender, _genders, (value) => _selectedGender = value),
          _buildDropdown('Country', _selectedCountry, _countries, (value) => _selectedCountry = value),
          _buildDropdown('Marital Status', _selectedMaritalStatus, _maritalStatuses, (value) => _selectedMaritalStatus = value),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImagePicker() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: const Color(0xFF5c677d),
            backgroundImage: _profileImage != null
                ? FileImage(_profileImage!)
                : const AssetImage('assets/default_profile.png') as ImageProvider,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              onPressed: _pickImage,
              tooltip: 'Change profile picture',
              color: const Color(0xFF5c677d),
            ),
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
    );
  }

  Widget _buildTextField(String label, String? initialValue, FormFieldSetter<String> onSaved) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.text,
      onSaved: onSaved,
    );
  }

  Widget _buildDropdown(String label, String? selectedValue, List<String> options, FormFieldSetter<String> onSaved) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: selectedValue,
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedValue = newValue;
        });
      },
      onSaved: onSaved,
    );
  }
}

extension on ScaffoldState? {
  void showSnackBar(SnackBar snackBar) {}
}








import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Homepage.dart';

class SetContactsDetails extends StatefulWidget {
  const SetContactsDetails({super.key});

  @override
  State<SetContactsDetails> createState() => _SetContactsDetailsState();
}

class _SetContactsDetailsState extends State<SetContactsDetails> {
  final _formKey = GlobalKey<FormState>();
  final _contact1NameController = TextEditingController();
  final _contact1MobileController = TextEditingController();
  final _contact2NameController = TextEditingController();
  final _contact2MobileController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitContacts() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final details = {
        'Contact1': {
          'name': _contact1NameController.text,
          'mobile': _contact1MobileController.text,
        },
        'Contact2': {
          'name': _contact2NameController.text,
          'mobile': _contact2MobileController.text,
        }
      };

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .update(details);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildContactSection(String title, TextEditingController nameController,
      TextEditingController mobileController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        _buildInputField(
          controller: nameController,
          hint: "Name",
        ),
        _buildInputField(
          controller: mobileController,
          hint: "Phone Number",
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hint';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        'Enter contact details',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  _buildContactSection(
                    'Contact 1:',
                    _contact1NameController,
                    _contact1MobileController,
                  ),
                  _buildContactSection(
                    'Contact 2:',
                    _contact2NameController,
                    _contact2MobileController,
                  ),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: _submitContacts,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Submit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _contact1NameController.dispose();
    _contact2NameController.dispose();
    _contact1MobileController.dispose();
    _contact2MobileController.dispose();
    super.dispose();
  }
}

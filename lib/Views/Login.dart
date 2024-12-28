import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/user_model.dart';
import 'Homepage.dart';
import 'Registration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isProgressing = false;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    // Add your notification permission logic here
  }

  Future<void> _login(String email, String password) async {
    try {
      setState(() => isProgressing = true);
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.email)
            .get();

        if (snapshot.exists) {
          final userData = snapshot.data()!;
          final currentUser = UserModel(
            name: userData['name'],
            mobile: userData['mobile'],
            email: userData['email'],
            contacts: {
              'Contact1': userData['Contact1'],
              'Contact2': userData['Contact2'],
            },
          );

          // Navigate to home page
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        }
      }
    } catch (error) {
      setState(() => errorMsg = error.toString());
    } finally {
      if (mounted) setState(() => isProgressing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'सुरक्षा Suraksha',
                    style: TextStyle(
                      fontSize: 70,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                _buildInputField(
                  controller: _emailController,
                  hint: "Username",
                ),
                _buildInputField(
                  controller: _passwordController,
                  hint: "Password",
                  isPassword: true,
                ),
                _buildLoginButton(),
                if (isProgressing)
                  const Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                _buildRegisterLink(),
                if (errorMsg != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Center(
                      child: Text(
                        errorMsg!,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: hint,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.green,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            if (_emailController.text.isNotEmpty &&
                _passwordController.text.isNotEmpty) {
              _login(_emailController.text, _passwordController.text);
            }
          },
          child: const Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RegisterPage()),
        );
      },
      child: const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'Don\'t have account? Click to Sign Up',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

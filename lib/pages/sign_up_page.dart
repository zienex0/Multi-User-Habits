import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiuser_habits/pages/habits_page.dart';
import 'package:multiuser_habits/services/db_users_service.dart';
import 'package:multiuser_habits/services/form_validator.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final dbUsers = DbUsers();

  final _signUpFormKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _displayNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    if (_signUpFormKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim());

        User? user = userCredential.user;
        if (user != null) {
          await user.updateDisplayName(_displayNameController.text.trim());
          await dbUsers.addCustomUser(
              uid: user.uid,
              displayName: _displayNameController.text.trim(),
              email: _emailController.text.trim(),
              photoUrl: '');

          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const HabitsPage(),
              ),
              (route) => false,
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        print(
            'FirebaseAuthException when creating user with email and password: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _displayNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _displayNameFocus.unfocus();
            _emailFocus.unfocus();
            _passwordFocus.unfocus();
          });
        },
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 20, left: 20, top: 200, bottom: 100),
              child: Form(
                key: _signUpFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // display name field
                    TextFormField(
                      controller: _displayNameController,
                      focusNode: _displayNameFocus,
                      decoration: const InputDecoration(
                        labelText: 'Display name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => FormValidator.validateRequired(
                          'Display name', value!),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    // email field
                    TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => FormValidator.validateEmail(value!),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // password field
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) =>
                          FormValidator.validatePassword(value!),
                    ),

                    const Spacer(),
                    ElevatedButton(
                      onPressed: _signUp,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Sign Up'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

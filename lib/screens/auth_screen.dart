import 'package:flutter/material.dart';
import 'package:my_shop/providers/auth.dart';
import 'package:my_shop/screens/home_screen.dart';
import 'package:provider/provider.dart';

import '../services/http_exception.dart';

// ignore: constant_identifier_names
enum AuthMode { Register, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final _passwordController = TextEditingController();
  var _loading = false;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Xatolik'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Okay!'),
              ),
            ],
          );
        });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _loading = true;
      });
      try {
        if (_authMode == AuthMode.Login) {
          await Provider.of<Auth>(context, listen: false).signup(
            _authData['email']!,
            _authData['password']!,
          );
        } else {
          await Provider.of<Auth>(context, listen: false).signup(
            _authData['email']!,
            _authData['password']!,
          );
        }
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      } on HttpException catch (error) {
        var errorMessage = "Xatolik sodir bo'ldi";
        if (error.message.contains('EMAIL_EXISTS')) {
          errorMessage = "Email band";
        } else if (error.message.contains('INVALID_EMAIL')) {
          errorMessage = "To'g'ri email kiriting";
        } else if (error.message.contains('WEAK_PASSWORD')) {
          errorMessage = "Juda oson password";
        } else if (error.message.contains('EMAIL_NOT_FOUND')) {
          errorMessage = "Bu email bilan foydalanuvchi topilmadi";
        } else if (error.message.contains('INVALID_PASSWORD')) {
          errorMessage = "Parol noto'g'ri";
        }
        _showErrorDialog(errorMessage);
      } catch (e) {
        var errorMessage =
            "Kechirasiz xatolik sodir bo'ldi. Qaytadan o'rinib ko'ring";
        _showErrorDialog(errorMessage);
      }
    }
    setState(() {
      _loading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Register;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.jpg',
                    fit: BoxFit.cover,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email manzil',
                    ),
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return "Iltimos, email manzil kiriting";
                      } else if (!email.contains('@')) {
                        return "Iltimos, to'g'ri email kiriting";
                      }
                    },
                    onSaved: (email) {
                      _authData['email'] = email!;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Parol',
                    ),
                    controller: _passwordController,
                    validator: (parol) {
                      if (parol == null || parol.isEmpty) {
                        return "Iltimos, parolni kiriting";
                      } else if (parol.length < 6) {
                        return "Parol juda oson";
                      }
                    },
                    onSaved: (password) {
                      _authData['password'] = password!;
                    },
                    obscureText: true,
                  ),
                  if (_authMode == AuthMode.Register)
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Parolni tasdiqlang',
                          ),
                          obscureText: true,
                          validator: (confirmedPassword) {
                            if (_passwordController.text != confirmedPassword) {
                              return 'Parollar bir biriga mos kelmadi';
                            }
                          },
                        ),
                      ],
                    ),
                  const SizedBox(height: 60),
                  _loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(
                            _authMode == AuthMode.Login
                                ? 'Kirish'
                                : "Ro'yhatdan o'tish",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                  const SizedBox(height: 40),
                  TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                      _authMode == AuthMode.Login
                          ? "Ro'yhatdan o'tish"
                          : 'Kirish',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

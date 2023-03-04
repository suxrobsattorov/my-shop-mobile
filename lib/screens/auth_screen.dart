import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../services/http_exception.dart';

enum AuthMode { Register, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
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
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Okay!'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      // save form
      _formKey.currentState!.save();

      setState(() {
        _loading = true;
      });
      try {
        if (_authMode == AuthMode.Login) {
          await Provider.of<Auth>(context, listen: false).login(
            _authData['email']!,
            _authData['password']!,
          );
        } else {
          await Provider.of<Auth>(context, listen: false).signup(
            _authData['email']!,
            _authData['password']!,
          );
        }

        //  Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      } on HttpException catch (error) {
        var errorMessage = 'Xatolik sodir bo\'ldi.';
        if (error.message.contains('EMAIL_EXISTS')) {
          errorMessage = 'Email band.';
        } else if (error.message.contains('INVALID_EMAIL')) {
          errorMessage = 'To\'g\'ri email kiriting.';
        } else if (error.message.contains('WEAK_PASSWORD')) {
          errorMessage = 'Juda oson parol';
        } else if (error.message.contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Bu email bilan foydalanuvchi topilmadi.';
        } else if (error.message.contains('INVALID_PASSWORD')) {
          errorMessage = 'Parol noto\'g\'ri.';
        }
        _showErrorDialog(errorMessage);
      } catch (e) {
        var errorMessage =
            'Kechirasiz xatolik sodir bo\'ldi. Qaytadan o\'rinib ko\'ring.';
        _showErrorDialog(errorMessage);
      }
      setState(() {
        _loading = false;
      });
    }
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
          padding: const EdgeInsets.all(40.0),
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
                      return 'Iltimos, email manzil kiriting.';
                    } else if (!email.contains('@')) {
                      return 'Iltimos, to\'g\'ri email kiriting.';
                    }
                  },
                  onSaved: (email) {
                    _authData['email'] = email!;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Parol',
                  ),
                  controller: _passwordController,
                  obscureText: true,
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return 'Iltimos, parolni kiriting.';
                    } else if (password.length < 6) {
                      return 'Parol juda oson.';
                    }
                  },
                  onSaved: (password) {
                    _authData['password'] = password!;
                  },
                ),
                if (_authMode == AuthMode.Register)
                  Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
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
                const SizedBox(
                  height: 60,
                ),
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        child: Text(
                          _authMode == AuthMode.Login
                              ? 'KIRISH'
                              : 'RO\'YXATDAN O\'TISH',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                const SizedBox(
                  height: 40,
                ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    _authMode == AuthMode.Login
                        ? 'Ro\'yxatdan o\'tish'
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
    );
  }
}

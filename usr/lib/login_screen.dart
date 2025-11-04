import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _createDefaultAdmin();
  }

  Future<void> _createDefaultAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList('users') ?? [];
    if (usersJson.isEmpty) {
      final admin = User(username: 'admin', password: 'admin123', role: 'admin');
      usersJson.add(jsonEncode(admin.toJson()));
      await prefs.setStringList('users', usersJson);
    }
  }

  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList('users') ?? [];
    final users = usersJson.map((e) => User.fromJson(jsonDecode(e))).toList();

    final user = users.firstWhere(
      (u) => u.username == _usernameController.text && u.password == _passwordController.text,
      orElse: () => User(username: '', password: '', role: ''),
    );

    if (user.username.isNotEmpty) {
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userRole', user.role);
      await prefs.setString('currentUser', user.username);
      Navigator.of(context).pushReplacementNamed(user.role == 'admin' ? '/admin' : '/user');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales inválidas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
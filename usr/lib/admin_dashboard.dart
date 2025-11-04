import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'main.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList('users') ?? [];
    setState(() {
      _users = usersJson.map((e) => User.fromJson(jsonDecode(e))).toList();
    });
  }

  Future<void> _createUser() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) return;

    final newUser = User(
      username: _usernameController.text,
      password: _passwordController.text,
      role: 'user',
    );

    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList('users') ?? [];
    usersJson.add(jsonEncode(newUser.toJson()));
    await prefs.setStringList('users', usersJson);

    _usernameController.clear();
    _passwordController.clear();
    _loadUsers();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario creado exitosamente')),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userRole');
    await prefs.remove('currentUser');
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Administrador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Crear Nuevo Usuario', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _createUser,
              child: const Text('Crear Usuario'),
            ),
            const SizedBox(height: 20),
            const Text('Usuarios Existentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return ListTile(
                    title: Text(user.username),
                    subtitle: Text('Rol: ${user.role}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  Future<void> _logout(BuildContext context) async {
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
        title: const Text('Panel de Usuario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamed('/form'),
          child: const Text('Llenar Plantilla'),
        ),
      ),
    );
  }
}
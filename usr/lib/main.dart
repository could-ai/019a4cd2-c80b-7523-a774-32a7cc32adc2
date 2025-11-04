import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const PanelOrganizativoApp());
}

class PanelOrganizativoApp extends StatelessWidget {
  const PanelOrganizativoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Panel Organizativo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/admin': (context) => const AdminDashboard(),
        '/user': (context) => const UserDashboard(),
        '/form': (context) => const FormScreen(),
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoggedIn = false;
  String _userRole = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;
    final role = prefs.getString('userRole') ?? '';
    setState(() {
      _isLoggedIn = loggedIn;
      _userRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return _userRole == 'admin' ? const AdminDashboard() : const UserDashboard();
    } else {
      return const LoginScreen();
    }
  }
}

class User {
  String username;
  String password;
  String role;

  User({required this.username, required this.password, required this.role});

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'role': role,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    username: json['username'],
    password: json['password'],
    role: json['role'],
  );
}

class FormData {
  String nombre;
  String cedula;
  String direccion;
  String tipoMoneda;
  String cuantoCambio;

  FormData({
    required this.nombre,
    required this.cedula,
    required this.direccion,
    required this.tipoMoneda,
    required this.cuantoCambio,
  });

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'cedula': cedula,
    'direccion': direccion,
    'tipoMoneda': tipoMoneda,
    'cuantoCambio': cuantoCambio,
  };

  factory FormData.fromJson(Map<String, dynamic> json) => FormData(
    nombre: json['nombre'],
    cedula: json['cedula'],
    direccion: json['direccion'],
    tipoMoneda: json['tipoMoneda'],
    cuantoCambio: json['cuantoCambio'],
  );
}
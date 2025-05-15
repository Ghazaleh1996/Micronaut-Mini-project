import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({Key? key}) : super(key: key);

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  String? username;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchCustomerProfile();
  }

  Future<void> fetchCustomerProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.get(
      Uri.parse('http://localhost:8080/whoami'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        username = response.body;
      });
    } else {
      setState(() {
        error = 'Failed to fetch profile.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customer Dashboard')),
      body: Center(
        child: error != null
            ? Text(error!, style: TextStyle(color: Colors.red))
            : username != null
            ? Text("Welcome, $username!", style: TextStyle(fontSize: 24))
            : CircularProgressIndicator(),
      ),
    );
  }
}

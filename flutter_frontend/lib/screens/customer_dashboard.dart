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
  Map<String, dynamic>? customerData;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchCustomerInfo();
  }

  Future<void> fetchCustomerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      setState(() => error = "No JWT token found.");
      return;
    }

    final response = await http.get(
      Uri.parse('http://localhost:8080/customer-area/customer-info'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        customerData = json.decode(response.body);
      });
    } else {
      setState(() {
        error = 'Failed to fetch customer info: ${response.statusCode}';
      });
    }
  }

  Widget buildProfileCard(String label, String value, IconData icon) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(label),
        subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.deepPurple;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Dashboard'),
        backgroundColor: themeColor,
      ),
      backgroundColor: const Color(0xFFF8F6FC),
      body: error != null
          ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
          : customerData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 45,
              backgroundColor: themeColor,
              child: Text(
                customerData!['name'][0],
                style: const TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Welcome, ${customerData!['name']} ${customerData!['surname']}!",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            buildProfileCard("Username", customerData!['username'], Icons.person),
            buildProfileCard("Points", customerData!['points'].toString(), Icons.star),
            if (customerData!['birthday'] != null)
              buildProfileCard("Birthday", customerData!['birthday'], Icons.cake),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

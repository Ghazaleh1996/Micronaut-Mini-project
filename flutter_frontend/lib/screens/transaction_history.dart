import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  List<dynamic> transactions = [];
  String? error;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/login2', (route) => false);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/customer-area/history'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          transactions = json.decode(response.body);
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        setState(() {
          error = 'Error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Network error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
          : transactions.isEmpty
          ? const Center(child: Text('No transactions found.'))
          : ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          var tx = transactions[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: ListTile(
              leading: const Icon(Icons.monetization_on, color: Colors.deepPurple),
              title: Text("Points: ${tx['points'] ?? 'N/A'}"),
              subtitle: Text("Date: ${tx['timestamp'] ?? 'N/A'}"),
            ),
          );
        },
      ),
    );
  }
}

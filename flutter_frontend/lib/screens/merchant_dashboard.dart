import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MerchantDashboard extends StatefulWidget {
  const MerchantDashboard({Key? key}) : super(key: key);

  @override
  State<MerchantDashboard> createState() => _MerchantDashboardState();
}

class _MerchantDashboardState extends State<MerchantDashboard> {
  String? merchantName;
  String? error;
  int? totalCustomers;
  int? totalPoints;
  List<dynamic> customers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }

    try {
      final profileRes = await http.get(
        Uri.parse('http://localhost:8080/whoami'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final summaryRes = await http.get(
        Uri.parse('http://localhost:8080/merchant-area/summary'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final customerRes = await http.get(
        Uri.parse('http://localhost:8080/merchant-area/customers'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (profileRes.statusCode == 200 &&
          summaryRes.statusCode == 200 &&
          customerRes.statusCode == 200) {
        setState(() {
          merchantName = profileRes.body;
          var summaryData = json.decode(summaryRes.body);
          totalCustomers = summaryData['customerCount'];
          totalPoints = summaryData['totalPoints'];
          customers = json.decode(customerRes.body);
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to fetch dashboard data.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error occurred: $e';
        isLoading = false;
      });
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _viewCustomerInfo(int id) async {
    final token = (await SharedPreferences.getInstance()).getString('jwt_token');
    final response = await http.get(
      Uri.parse('http://localhost:8080/merchant-area/customers/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final customer = json.decode(response.body);
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Customer Info'),
          content: Text('Name: ${customer['name']} ${customer['surname']}\n'
              'Username: ${customer['username']}\n'
              'Points: ${customer['points']}'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
        ),
      );
    }
  }

  void _editCustomer(int id, String currentName, String currentSurname) {
    final nameController = TextEditingController(text: currentName);
    final surnameController = TextEditingController(text: currentSurname);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Customer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: surnameController, decoration: const InputDecoration(labelText: 'Surname')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final token = (await SharedPreferences.getInstance()).getString('jwt_token');
              final response = await http.post(
                Uri.parse('http://localhost:8080/merchant-area/customers/$id'),
                headers: {
                  'Authorization': 'Bearer $token',
                  'Content-Type': 'application/json',
                },
                body: json.encode({
                  'name': nameController.text.trim(),
                  'surname': surnameController.text.trim(),
                }),
              );
              Navigator.pop(context);
              if (response.statusCode == 200 && context.mounted) {
                fetchDashboardData(); // reload changes
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Customer updated successfully")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to update customer")),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }


  void _updatePoints(int id) {
    final pointsController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add / Remove Points'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Enter a positive number to add, or negative to remove points."),
            const SizedBox(height: 8),
            TextField(
              controller: pointsController,
              decoration: const InputDecoration(labelText: 'Points (e.g., 10 or -5)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final token = (await SharedPreferences.getInstance()).getString('jwt_token');
              final int points = int.tryParse(pointsController.text.trim()) ?? 0;

              final response = await http.post(
                Uri.parse('http://localhost:8080/merchant-area/customers/$id/points'),
                headers: {
                  'Authorization': 'Bearer $token',
                  'Content-Type': 'application/json',
                },
                body: json.encode({'points': points}),
              );

              Navigator.pop(context);
              if (response.statusCode == 200 && context.mounted) {
                fetchDashboardData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Points ${points > 0 ? "added" : "removed"} successfully.')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to update points")),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }


  void _viewTransactions(int id) async {
    final token = (await SharedPreferences.getInstance()).getString('jwt_token');
    final response = await http.get(
      Uri.parse('http://localhost:8080/merchant-area/customers/$id/transactions'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200 && context.mounted) {
      final transactions = json.decode(response.body);
      await showModalBottomSheet(
        context: context,
        builder: (_) => transactions.isEmpty
            ? const Padding(
          padding: EdgeInsets.all(20),
          child: Text('No transactions found.'),
        )
            : ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final tx = transactions[index];
            return ListTile(
              leading: const Icon(Icons.monetization_on),
              title: Text("Points: ${tx['points']}"),
              subtitle: Text("Date: ${tx['timestamp'] ?? 'N/A'}"),
            );
          },
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchant Dashboard'),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text('Merchant Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Customer List'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: logout,
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $merchantName!',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.group, color: Colors.deepPurple),
                  title: const Text('Total Customers'),
                  trailing: Text(totalCustomers?.toString() ?? '0'),
                ),
              ),
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.stars, color: Colors.deepPurple),
                  title: const Text('Total Points Circulating'),
                  trailing: Text(totalPoints?.toString() ?? '0'),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Customer List',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  var c = customers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text('${c['name']} ${c['surname']}'),
                      subtitle: Text('Username: ${c['username']} • Points: ${c['points']}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'view') {
                            _viewCustomerInfo(c['id']);
                          } else if (value == 'edit') {
                            _editCustomer(c['id'], c['name'], c['surname']);
                          } else if (value == 'points') {
                            _updatePoints(c['id']);
                          } else if (value == 'transactions') {
                            _viewTransactions(c['id']);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'view', child: Text('View Info')),
                          const PopupMenuItem(value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(value: 'points', child: Text('Add/Remove Points')),
                          const PopupMenuItem(value: 'transactions', child: Text('Transactions')),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MerchantDashboard extends StatelessWidget {
  const MerchantDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Merchant Dashboard')),
      body: Center(
        child: Text("Welcome, Merchant!", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

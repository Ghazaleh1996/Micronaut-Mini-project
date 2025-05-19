import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/customer_home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'customer_dashboard.dart';
import 'merchant_dashboard.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<void> login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final url = Uri.parse('http://localhost:8080/login2');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json','Accept': 'application/json',},
        body: json.encode({
          "username": usernameController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['access_token'];
        final roles = data['roles'] as List<dynamic>?;

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);

          print('Login Success: $data');

          if (roles != null && roles.contains('ROLE_CUSTOMER')) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CustomerHomeScreen()),
            );
          } else if (roles != null && roles.contains('ROLE_MERCHANT')) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MerchantDashboard()),
            );
          } else {
            setState(() {
              errorMessage = "Unrecognized role in token.";
            });
          }
        } else {
          setState(() {
            errorMessage = "No token received.";
          });
        }
      } else {
        print('Login failed: ${response.body}');
        setState(() {
          errorMessage = 'Login failed';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed')),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Container(
              height: 500,
              width: 400,
              decoration: BoxDecoration(
                color: Colors.purple[50],
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(3, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (errorMessage != null)
                      Text(errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 16)),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: 'username',
                          labelText: 'username',
                          prefixIcon:
                          Icon(Icons.person, color: Colors.pink[200]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'password',
                          labelText: 'password',
                          prefixIcon:
                          Icon(Icons.lock, color: Colors.pink[200]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: isLoading
                                ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : const Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 22),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          ' Don’t have an account? Sign Up ',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ),
      ),
      );
    }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formkey = GlobalKey<FormState>();
  String name = '';
  String surname = '';
  String email = '';
  String username = '';
  String password = '';
  String selectedRole = 'customer';
  bool isLoading = false;

  Future<void> _submitForm() async {
    if (!_formkey.currentState!.validate()) return;
    _formkey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    final url = selectedRole == 'customer'
        ? 'http://localhost:8080/customer-area/Sign-Up'
        : 'http://localhost:8080/merchant-area/Sign-Up';

    final body = {
      'name': name,
      'email': email,
      'username': username,
      'password': password,
    };

    if (selectedRole == 'customer') {
      body['surname'] = surname;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        await Future.delayed(Duration(milliseconds: 300));

        final loginResponse = await http.post(
          Uri.parse('http://localhost:8080/login2'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'username': username.trim(),
            'password': password.trim(),
          }),
        );

        if (loginResponse.statusCode == 200) {

          final data = json.decode(loginResponse.body);

          // Support either a string token or wrapped response body
          final token = data['access_token'];
          final roles = data['roles'] as List<dynamic>?;
          print('Login response: ${loginResponse.body}');


          if (token != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('jwt_token', token);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration & login successful')),
            );

            if (selectedRole == 'customer') {
              Navigator.pushReplacementNamed(context, '/customer_dashboard');
            } else {
              Navigator.pushReplacementNamed(context, '/merchant_dashboard');
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login failed after registration')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed: ${response.body}')),
          );
        }
      }
      } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Container(
              height: 750,
              width: 400,
              decoration: BoxDecoration(
                color: Colors.purple[50],
                border: Border.all(color: Colors.orange, width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.grey, offset: Offset(3, 3), blurRadius: 6),
                ],
              ),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter Full Name',
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value!.isEmpty ? 'Enter name' : null,
                        onSaved: (value) => name = value!,
                      ),
                    ),
                    if (selectedRole == 'customer')
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter your surname',
                            labelText: 'Surname',
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value!.isEmpty ? 'Enter surname' : null,
                          onSaved: (value) => surname = value!,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value!.isEmpty ? 'Enter email' : null,
                        onSaved: (value) => email = value!,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Username',
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.account_circle),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value!.isEmpty ? 'Enter username' : null,
                        onSaved: (value) => username = value!,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value!.isEmpty ? 'Enter password' : null,
                        onSaved: (value) => password = value!,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedRole,
                        items: const [
                          DropdownMenuItem(value: 'customer', child: Text('Customer')),
                          DropdownMenuItem(value: 'merchant', child: Text('Merchant')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value!;
                          });
                        },
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                              'Register',
                              style: TextStyle(color: Colors.white, fontSize: 22),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Already have an account? Sign in',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
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

import 'package:flutter/material.dart';
import 'Register.dart';
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child:Center(
          child:Container(
          height: 500,
          width: 400,
          decoration: BoxDecoration(
          color: Colors.purple[50],
          border: Border.all(color: Colors.orange,width: 2),
          boxShadow: [
            BoxShadow(
            color: Colors.grey,
            offset: Offset(3, 3),
            blurRadius: 6,

    ),
    ],

    ),

          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // First Name
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter First Name',
                      labelText: 'First Name',
                      prefixIcon: Icon(Icons.person, color: Colors.pink[200]),
                      errorStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(9.0)),
                      ),
                    ),
                  ),
                ),

                // Last Name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter Last Name',
                      labelText: 'Last Name',
                      prefixIcon: Icon(Icons.person, color: Colors.pink[200]),
                      errorStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(9.0)),
                      ),
                    ),
                  ),
                ),

                // Email
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Colors.pink[200]),
                      errorStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(9.0)),
                      ),
                    ),
                  ),
                ),

                // Register Button
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            print('Submitted');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                ),

                // Divider text
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      ' Sign in ',
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

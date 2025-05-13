import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      //Scrollable
      body: SingleChildScrollView(
        //child is how you nest widgets inside one another to build the UI layout in Flutte
        child: Padding(padding: const EdgeInsets.all(12.0),
          child:Center(
          child:Container(
            height: 500,
            width: 400,
            decoration: BoxDecoration(

              color: Colors.purple[50],
              border: Border.all(color: Colors.orange,width: 2),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(3,3),
                  blurRadius: 6,
                ),
              ],
            ),
          //spacing around the form
          padding: const EdgeInsets.all(12.0),
          //This holds the form fields and enables validation using the _formkey
          child: Form(
            key: _formkey,
            //The Column (which contains all form inputs) is its child
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              //lays out all form fields vertically
              //It contains multiple children like Padding, each of which wraps a TextFormField
              children: <Widget>[
                // First Name
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'username',
                      labelText: 'username',
                      prefixIcon: Icon(Icons.person, color: Colors.pink[200]),
                      errorStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(9.0)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'password',
                      labelText: 'password',
                      prefixIcon: Icon(Icons.password, color: Colors.pink[200]),
                      errorStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(9.0)),
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
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            print('Logged in');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Login',
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
                      ' Do not have an account? Sign Up ',
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

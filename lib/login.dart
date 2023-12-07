import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

class LoginTab extends StatelessWidget {
  LoginTab({Key? key}) : super(key: key);

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObscure = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextFormField(
          controller: _usernameController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: "Username",
          ),
        ),
        TextFormField(
          controller: _passwordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: isObscure,
          decoration: InputDecoration(
            labelText: "Password",
            suffixIcon: IconButton(
              icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                isObscure = !isObscure;
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () async {
                //TODO Implement
                // Check for internet connection
                var connectivityResult =
                    await Connectivity().checkConnectivity();
                if (connectivityResult == ConnectivityResult.none) {
                  // No internet connection, show SnackBar
                  _showNoInternetSnackBar(context);
                } else {
                  // Internet connection is available, proceed with login logic
                  _performLogin(context);
                }
              },
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text('Login'),
                ),
              )),
        )
      ],
    );
  }

  void _performLogin(BuildContext context) async {
    // Get the username and password from the controllers
    String username = _usernameController.text;
    String password = _passwordController.text;

    // construct the request body
    Map<String, String> requestBody = {
      "username": username,
      "password": password,
    };

    // make the HTTP POST request
    final response = await http.post(
      Uri.parse('https://potatotech.mocklab.io.potato-co.com/api/login'),
      body: requestBody,
    );

    // check the response status code
    if (response.statusCode == 200) {
      // Parse the JSON response
      Map<String, dynamic> responseData = json.decode(response.body);

      // check the 'status' field in the response
      if (responseData['status'] == 1) {
        // login successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message']),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to the next screen or perform any other actions after successful login
      } else {
        // Login failed, this is the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Handle other HTTP status codes (for example display a generic error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Unfortunally An error occurred during login. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showNoInternetSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No internet connection'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

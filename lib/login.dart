import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

class LoginTab extends StatefulWidget {
  const LoginTab({Key? key}) : super(key: key);

  @override
  _LoginTabState createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return TextFormField(
              controller: _usernameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: "Username",
              ),
            );
          },
        ),
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: isObscure,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  icon:
                      Icon(isObscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    // Update the state to toggle password visibility
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                ),
              ),
            );
          },
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
    try {
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
        if (responseData.containsKey('status')) {
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
          // Unexpected response format
          _showErrorSnackBar(context, 'Invalid response format');
        }
      } else {
        // Handle other HTTP status codes (for example, display a generic error message)
        _showErrorSnackBar(context, 'HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other exceptions (e.g., network errors)
      _showErrorSnackBar(context, 'An error occurred: $error');
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

  void _showErrorSnackBar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }
}

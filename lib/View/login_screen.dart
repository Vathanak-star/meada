import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 42.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/app_logo.png', scale: 3),
              SizedBox(height: 12),
              Text(
                'LOGIN TO MEADA',
                style: TextStyle(fontFamily: 'poppins', fontSize: 20),
              ),
              SizedBox(height: 12),
              Text(
                'Discover healthy lifestyle',
                style: TextStyle(fontFamily: 'poppins'),
              ),
              SizedBox(height: 24),

              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'Email address',
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),

              SizedBox(height: 16),

              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () => context.go('home'),
                    padding: const EdgeInsets.all(0.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0),
                    ),
                    child: Ink(
                      decoration: const BoxDecoration(
                        // gradient: LinearGradient(
                        //   colors: [Color(0xFFBCADE5), Color(0xFF468F9A)],
                        // ),
                        color: Color(0xFFB76E79),
                        borderRadius: BorderRadius.all(Radius.circular(80)),
                      ),
                      child: Container(
                        width: 230,
                        height: 50,
                        // constraints: const BoxConstraints(minWidth: 80.0, minHeight: 36.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            color: Color(0xFFFBF8F5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              //Switch Page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(fontFamily: 'poppins'),
                  ),
                  SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => context.go('/register'),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

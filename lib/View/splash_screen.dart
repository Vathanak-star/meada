import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //App Title
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       "MEADA",
            //       style: TextStyle(
            //         fontFamily: 'Poppins',
            //         fontWeight: FontWeight.w600,
            //         fontSize: 30,
            //         color: Color(0xFFB76E79),
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 30),

            //App Logo
            Image.asset(
              'assets/images/app_logo.png',
              width: 200,
              height: 100,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 0),

            //Animated Text
            // SizedBox(
            //   height: 50,
            //   child:  DefaultTextStyle(
            //     style: const TextStyle(fontSize: 25.0, fontFamily: 'Poppins',fontWeight: FontWeight.w600),
            //     child: AnimatedTextKit(
            //       pause: Duration(milliseconds: 300),
            //       repeatForever: true,
            //       animatedTexts: [
            //         RotateAnimatedText('SMART CARE',textStyle: TextStyle(color: Color(0xFF6B7280))),
            //         RotateAnimatedText('HEALTHY MOTHER',textStyle: TextStyle(color: Color(0xFF97C1A4))),
            //         RotateAnimatedText('BRIGHTER FUTURE',textStyle: TextStyle(color: Color(0xFF6B7280))),
            //         RotateAnimatedText('BEST CHOICE',textStyle: TextStyle(color: Color(0xFF97C1A4))),
            //       ],
            //       onTap: () {
            //
            //       },
            //     ),
            //   ),
            // ),
            SizedBox(height: 40),

            //Button to next screen
            MaterialButton(
              onPressed: () => context.go('/login'),
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
                    'Welcome to Meada',
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
      ),
    );
  }
}

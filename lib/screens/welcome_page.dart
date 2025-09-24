import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFB3E5FC), Colors.white],
                ),
              ),
            ),
          ),
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFB3E5FC), Colors.white],
                ),
              ),
            ),
          ),

          // Bubble acak
          Positioned(top: 40, left: 20, child: _buildBubble(100, Colors.white)),
          Positioned(
            top: 120,
            right: 50,
            child: _buildBubble(60, Color(0xFFB3E5FC)),
          ),
          Positioned(
            top: 200,
            left: 100,
            child: _buildBubble(80, Colors.white),
          ),
          Positioned(
            top: 320,
            right: 30,
            child: _buildBubble(50, Colors.white),
          ),
          Positioned(
            top: 400,
            left: 60,
            child: _buildBubble(70, Color(0xFFB3E5FC)),
          ),
          Positioned(
            bottom: 320,
            right: 100,
            child: _buildBubble(90, Colors.white),
          ),
          Positioned(
            bottom: 260,
            left: 30,
            child: _buildBubble(60, Colors.white),
          ),
          Positioned(
            bottom: 180,
            right: 60,
            child: _buildBubble(110, Color(0xFFB3E5FC)),
          ),
          Positioned(
            bottom: 100,
            left: 90,
            child: _buildBubble(70, Colors.white),
          ),
          Positioned(
            bottom: 40,
            right: 40,
            child: _buildBubble(50, Colors.white),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/image/logo_berlian.png",
                            height: 200,
                          ),
                          const SizedBox(height: 1),
                          const Text(
                            "Be Brilliant",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bagian bawah dengan tombol
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Tombol Sign In
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D47A1),
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              shadowColor: Colors.black45,
                              elevation: 5,
                            ),
                            child: const Text("Sign In"),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Tombol Sign Up
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUpPage(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF0D47A1)),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(12),
                            ),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(color: Color(0xFF0D47A1)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.90),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(2, 4),
          ),
        ],
      ),
    );
  }
}

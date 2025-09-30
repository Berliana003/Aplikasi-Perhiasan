import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';
import 'signup_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  late List<double> _randomLeft; // simpan posisi horizontal
  late List<double> _randomSize; // simpan ukuran icon
  final int _iconCount = 25; //jumlah love

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // generate posisi horizontal random
    _randomLeft = List.generate(
      _iconCount,
      (_) => _random.nextDouble() * screenWidth,
    );
    _randomSize = List.generate(
      _iconCount,
      (_) => 24 + _random.nextDouble() * 20,
    );

    return Scaffold(
      body: Stack(
        children: [
          // background gradient
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

          // animasi love
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final height = MediaQuery.of(context).size.height;
              final progress = _controller.value;

              return Stack(
                children: List.generate(_iconCount, (index) {
                  // posisi horizontal random
                  final dy =
                      height - (progress * height + index * 100) % height;

                  return Positioned(
                    left: _randomLeft[index] % screenWidth,
                    top: dy,
                    child: Icon(
                      Icons.favorite,
                      color: index.isEven
                          ? const Color(0xFF90CAF9)
                          : Colors.white,
                      size: _randomSize[index],
                    ),
                  );
                }),
              );
            },
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
                          Text(
                            "Brilliant",
                            style: GoogleFonts.cinzel(
                              fontSize: 50,
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
                        Text(
                          "Welcome",
                          style: GoogleFonts.youngSerif(
                            fontSize: 35,
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
                            child: Text(
                              "Sign In",
                              style: GoogleFonts.cinzel(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                            child: Text(
                              "Sign Up",
                              style: GoogleFonts.cinzel(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D47A1),
                              ),
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
}

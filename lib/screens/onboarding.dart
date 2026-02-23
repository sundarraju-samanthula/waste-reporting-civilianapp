import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  int _index = 0;

  final List<Map<String, dynamic>> pages = [
    {
      'icon': Icons.camera_alt_outlined,
      'title': 'Report Waste Easily',
      'desc': 'Capture waste with photos and location instantly.',
    },

    {
      'icon': Icons.location_city_outlined,
      'title': 'Help Authorities',
      'desc': 'Your reports help cities stay clean.',
    },

    {
      'icon': Icons.auto_graph,
      'title': 'Smart Waste Management',
      'desc': 'AI-powered analysis prioritizes cleanup.',
    },
  ];

  //-------------------------------- FINISH

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('onboarding_done', true);

    Get.offAllNamed('/login');
  }

  Widget background() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 39, 75, 207),
            Color.fromARGB(255, 29, 163, 26),
            Color.fromARGB(255, 12, 81, 9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget pageCard(int i) {
    return Padding(
      padding: const EdgeInsets.all(24),

      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),

          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),

            child: Container(
              padding: const EdgeInsets.all(30),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),

                color: Colors.white.withOpacity(.15),

                border: Border.all(color: Colors.white.withOpacity(.25)),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: Colors.white.withOpacity(.2),
                    ),

                    child: Icon(
                      pages[i]['icon'],
                      size: 60,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    pages[i]['title'],

                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      fontSize: 26,

                      fontWeight: FontWeight.bold,

                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    pages[i]['desc'],

                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      fontSize: 16,

                      color: Colors.white70,

                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget indicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: List.generate(
        pages.length,

        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),

          margin: const EdgeInsets.all(4),

          height: 8,

          width: _index == i ? 26 : 8,

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget button() {
    return GestureDetector(
      onTap: _index == pages.length - 1
          ? _finishOnboarding
          : () => _controller.nextPage(
              duration: const Duration(milliseconds: 400),

              curve: Curves.easeInOut,
            ),

      child: Container(
        height: 55,

        margin: const EdgeInsets.symmetric(horizontal: 25),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),

          gradient: const LinearGradient(
            colors: [Color(0xff5A67D8), Color(0xff7F9CF5)],
          ),
        ),

        child: Center(
          child: Text(
            _index == pages.length - 1 ? "Get Started" : "Next",

            style: const TextStyle(
              fontSize: 16,

              color: Colors.white,

              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          background(),

          SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,

                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _controller,

                        onPageChanged: (i) {
                          setState(() {
                            _index = i;
                          });
                        },

                        itemCount: pages.length,

                        itemBuilder: (context, i) {
                          return pageCard(i);
                        },
                      ),
                    ),

                    indicator(),

                    const SizedBox(height: 20),

                    button(),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/config.dart';


class SplashScreen extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final List<bool> indicators;
  final Widget nextScreen; // 👈 New parameter to handle navigation

  const SplashScreen({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.indicators,
    required this.nextScreen, // 👈 Required next screen
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🦒 Background Image
          Positioned.fill(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),

          /// 📦 Bottom White Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 335,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// 🔵 Page Indicators
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: indicators.map((isActive) => _buildIndicator(isActive)).toList(),
                  ),
                  SizedBox(height: 25),

                  /// 📝 Text
                  Text.rich(
                    TextSpan(
                      text: "Bienvenue sur ",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: title,
                          style: TextStyle(color: greenColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),

                  /// ✅ Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => nextScreen), // 👈 Navigate to the next screen
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        "Suivant",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
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

  /// 🟢 Page Indicator Dot Widget
  Widget _buildIndicator(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 16 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? greenColor : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../../../appcolor.dart';
import '../controller/landingpage_controller.dart';

class LandingPageView extends GetView<LandingPageController>{
  const LandingPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
        body: SafeArea(
          child:SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Get.height * 0.09),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            controller.onOptionTag("Charging Stations");
                          },
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFE1ECFD),
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Text('Charging Stations',
                                    style:TextStyle(
                                        fontFamily: 'popregular',
                                        fontSize: 15,
                                        color: Colors.blue
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Image.asset(
                                    'images/chargingstation.png',
                                    // Replace with your asset path
                                    height: 40, // Adjust the size as needed
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            controller.onOptionTag("User");
                          },
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFE1ECFD),
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Text('User',
                                    style:TextStyle(
                                        fontFamily: 'popregular',
                                        fontSize: 15,
                                        color: Colors.blue
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Image.asset(
                                    'images/profilev.png',
                                    // Replace with your asset path
                                    height: 40, // Adjust the size as needed
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: Get.height * 0.09),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            controller.onOptionTag("NEW SALE");
                          },
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFE1ECFD),
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Text('ADD PRODUCT',
                                    style:TextStyle(
                                        fontFamily: 'popregular',
                                        fontSize: 15,
                                        color: Colors.blue
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Image.asset(
                                    'images/chargingstation.png',
                                    // Replace with your asset path
                                    height: 40, // Adjust the size as needed
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            controller.onOptionTag("ADD PRODUCT");
                          },
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFE1ECFD),
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Text('User',
                                    style:TextStyle(
                                        fontFamily: 'popregular',
                                        fontSize: 15,
                                        color: Colors.blue
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Image.asset(
                                    'images/profilev.png',
                                    // Replace with your asset path
                                    height: 40, // Adjust the size as needed
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: Get.height * 0.09),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            controller.onOptionTag("PRODUCT");
                          },
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFE1ECFD),
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Text('PRODUCT LIST',
                                    style:TextStyle(
                                        fontFamily: 'popregular',
                                        fontSize: 15,
                                        color: Colors.blue
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Image.asset(
                                    'images/chargingstation.png',
                                    // Replace with your asset path
                                    height: 40, // Adjust the size as needed
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            controller.onOptionTag("REPORT");
                          },
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFE1ECFD),
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Text('REPORT',
                                    style:TextStyle(
                                        fontFamily: 'popregular',
                                        fontSize: 15,
                                        color: Colors.blue
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Image.asset(
                                    'images/profilev.png',
                                    // Replace with your asset path
                                    height: 40, // Adjust the size as needed
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: Get.height * 0.09),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            controller.onOptionTag("ADD LEGER");
                          },
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFE1ECFD),
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Text('ADD LEGER',
                                    style:TextStyle(
                                        fontFamily: 'popregular',
                                        fontSize: 15,
                                        color: Colors.blue
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Image.asset(
                                    'images/chargingstation.png',
                                    // Replace with your asset path
                                    height: 40, // Adjust the size as needed
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            controller.onOptionTag("REPORT");
                          },
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFE1ECFD),
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Text('LEGER',
                                    style:TextStyle(
                                        fontFamily: 'popregular',
                                        fontSize: 15,
                                        color: Colors.blue
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Image.asset(
                                    'images/profilev.png',
                                    // Replace with your asset path
                                    height: 40, // Adjust the size as needed
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                 /* Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                    child: Center(
                      child: Image.asset(
                        'images/evlogo1.png',
                        height: Get.height / 4,
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.1),
                  LoginButton(title: 'Charging Stations', onPressed: controller.click),
                  SizedBox(height: Get.height * 0.02),
                  LoginButton(title: 'USER', onPressed: controller.performURLCheck),*/

                ],
              ),
            ),
          ),
        )
    );
  }

}

class LoginButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const LoginButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: AppColors.app_color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
        ),
        child: Text(title, style: const TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
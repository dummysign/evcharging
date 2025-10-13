

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../../../appcolor.dart';
import '../../../../common/api/storage/storage.dart';
import '../../../route/app_pages.dart';
import '../controller/splash_controller.dart';

class SplashView extends GetView<SplashController>{
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: AppColors.gray_text,
     body: AnimatedSplashScreen(),
   );
  }

}

class AnimatedSplashScreen extends StatefulWidget{
  @override
  _AnimatedSplashScreenState createState() => _AnimatedSplashScreenState();
}
class _AnimatedSplashScreenState  extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and animation
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Define the scaling animation
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start the animation
    _controller.forward();

    // Navigate to the next screen after the animation
    Future.delayed(const Duration(seconds: 3), () {
      _navigateBasedOnUserDetails();
    });
  }

  /// Verifies Storage.userDetails and navigates to the appropriate screen
  void _navigateBasedOnUserDetails() {
    Get.offAllNamed(Routes.HOMEPAGE);
   /* if (Storage.userDetails != null) {
      debugPrint('User details found: ${Storage.userDetails}');
      Get.offAllNamed(Routes.HOME); // Navigate to home if user details exist
    } else {
      debugPrint('No user details found. Navigating to login...');
      Get.offAllNamed(Routes.LANDINGPAGE); // Navigate to login if user details are null
    }*/
  }

  @override
  void dispose() {
    // Dispose the animation controller
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.splashscreen_color, // Customize the background color
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(
            'images/evlogo1.png',
          ),
        ),
      ),
    );
  }

}
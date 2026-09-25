import 'package:chat_app/core/components/my_button.dart';
import 'package:chat_app/core/components/my_textfield.dart';
import 'package:chat_app/services/chat/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController controller2;

  late Animation<double> fadeOutAnimation;
  late Animation<Offset> slideOutAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..forward();
    controller2 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..forward();
    fadeOutAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    );
    slideOutAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: controller2, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    controller.dispose();
    controller2.dispose();

    super.dispose();
  }

  //email and password controllers
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  void logIn(BuildContext context) async {
    final _authService = AuthServices();
    try {
      await _authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),

              Text(e.toString().replaceFirst("Exception:", "")),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginTheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(
                  scale: controller.value,
                  child: FadeTransition(
                    opacity: fadeOutAnimation,
                    child: Column(
                      children: [
                        Icon(
                          Icons.message,
                          size: 60.sp,
                          color: loginTheme.primary,
                        ),
                        Text(
                          "Welcome Back!",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: loginTheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 30.h),
            SlideTransition(
              position: slideOutAnimation,
              child: Container(
                padding: EdgeInsets.all(15.w),

                margin: EdgeInsets.symmetric(horizontal: 10.w),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.only(
                //     topLeft: Radius.circular(30.r),
                //     topRight: Radius.circular(30.r),
                //   ),
                //   border: Border(
                //     top: BorderSide(color: Colors.grey, width: 2),
                //     left: BorderSide(color: Colors.grey, width: 2),
                //     right: BorderSide(color: Colors.grey, width: 2),
                //   ),
                // ),
                child: Column(
                  children: [
                    MyTextfield(
                      hintText: 'Email',
                      obscureText: false,
                      controller: _emailController,
                    ),
                    SizedBox(height: 10.h),

                    MyTextfield(
                      hintText: 'Password',
                      obscureText: true,
                      controller: _passwordController,
                    ),
                    SizedBox(height: 20.h),
                    MyButton(
                      text: 'Login',
                      onTap: () {
                        logIn(context);
                      },
                    ),
                    SizedBox(height: 20.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: loginTheme.primary),
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            "Sign Up!!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: loginTheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

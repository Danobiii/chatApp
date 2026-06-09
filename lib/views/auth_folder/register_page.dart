import 'package:chat_app/core/components/my_button.dart';
import 'package:chat_app/core/components/my_textfield.dart';
import 'package:chat_app/views/auth_folder/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //email and password controllers
  bool passwordMatch = false;
  bool isUserTyping = false;
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerTheme = Theme.of(context).colorScheme;
    bool passwordConfirmed() {
      if (_passwordController.text.trim() ==
          _confirmPasswordController.text.trim()) {
        return true;
      } else {
        return false;
      }
    }

    final _authService = AuthServices();
    Future signUp(BuildContext context) async {
      if (passwordConfirmed()) {
        try {
          await _authService.signUpWithEmailPassword(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
        } catch (e) {
          print(e);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(content: Text(e.toString()));
            },
          );
        }
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.message, size: 60.sp, color: registerTheme.primary),
            Text(
              "Hi, Create an Account",
              style: TextStyle(
                fontSize: 16.sp,
                color: registerTheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30.h),
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
            MyTextfield(
              onChanged: (value) {
                isUserTyping = true;
                setState(() {
                  passwordMatch =
                      _passwordController.text.trim() ==
                      _confirmPasswordController.text.trim();
                });
                print(_passwordController.text);
                print(_confirmPasswordController.text);
                print(passwordMatch);
              },
              hintText: 'Confirm password',
              obscureText: true,
              controller: _confirmPasswordController,
            ),
            SizedBox(height: 10.h),
            if (!isUserTyping)
              const SizedBox()
            else
              Text(
                passwordMatch ? "Password Match" : "Password Mismatch",
                style: TextStyle(
                  color: passwordMatch ? Colors.green : Colors.red,
                ),
              ),
            // isUserTyping
            //     ? SizedBox()
            //     : Text(
            //         passwordMatch ? "Password match" : "Password mismatch",
            //         style: TextStyle(
            //           color: passwordMatch ? Colors.green : Colors.red,
            //         ),
            //       ),
            SizedBox(height: 20.h),

            MyButton(
              text: 'Sign up',
              onTap: () {
                signUp(context);
              },
            ),
            SizedBox(height: 20.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(color: registerTheme.primary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    " Log in.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: registerTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

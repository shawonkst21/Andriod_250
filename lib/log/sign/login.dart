import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blood_donar/log/sign/register_page.dart';
import 'package:blood_donar/screenFunction/bottomNavigatorBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  //! here match that account have or not
  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Bottomnavigatorbar()),
      );
      //! add snackbar here ........................................
      // var snackBar2 = SnackBar(
      //   elevation: 0,
      //   behavior: SnackBarBehavior.floating,
      //   backgroundColor: Colors.transparent,
      //   content: AwesomeSnackbarContent(
      //     title: 'Success!',
      //     titleTextStyle: GoogleFonts.poppins(
      //       fontSize: 20,
      //       fontWeight: FontWeight.bold,
      //       color: Colors.white,
      //     ),
      //     message: 'Login Successful 🎉',
      //     contentType: ContentType.success,
      //   ),
      // );
      // final snackBar = snackBar2;

      // ScaffoldMessenger.of(context)
      //   ..hideCurrentSnackBar()
      //   ..showSnackBar(snackBar);

      // ⏳ Delay a bit so user sees the snackbar
      // await Future.delayed(const Duration(seconds: 1));
      //! Navigate only if login succeeds
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Login failed";

      if (e.code == 'wrong-password') {
        errorMessage = "Incorrect password. Please try again.";
      } else if (e.code == 'user-not-found') {
        errorMessage = "No user found for this email.";
      } else {
        errorMessage = e.message ?? "An unknown error occurred.";
      }

      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: "Error",
        desc: errorMessage,
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

//!# here dispose the controller
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 80),

                  //! Lottie Animation
                  Lottie.asset(
                    'assets/blood.json',
                    height: 105,
                  ),

                  //! Title
                  Text(
                    "Life drop!",
                    style: GoogleFonts.bebasNeue(
                        fontSize: 52,
                        color: const Color.fromARGB(213, 231, 4, 4)),
                  ),

                  //! Welcome Text
                  Text(
                    "Welcome back, you've been missed!",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color.fromARGB(185, 43, 42, 42)),
                  ),

                  const SizedBox(height: 50),

                  //! Animated Email Field
                  FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(
                              color: const Color.fromARGB(218, 222, 66, 66)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  //! Animated Password Field
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(
                              color: const Color.fromARGB(218, 222, 66, 66)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? CupertinoIcons.eye
                                      : CupertinoIcons.eye_slash,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1400),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Forgot password? ",
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color.fromARGB(164, 0, 0, 0)),
                            ),
                          ]),
                    ),
                  ),
                  const SizedBox(height: 20),

                  //! Animated Sign-in Button
                  FadeInUp(
                    duration: const Duration(milliseconds: 1200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: GestureDetector(
                        onTap: signIn,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(170, 231, 4, 4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text("Sign in",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  //! Animated Sign-up Text
                  FadeInUp(
                    duration: const Duration(milliseconds: 1400),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Not a member? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()),
                            );
                          },
                          child: const Text(
                            "Register Now",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    duration: const Duration(milliseconds: 2000),
                    child: const Center(
                        child: Text(
                      '- OR Continue with -',
                      style: TextStyle(color: Colors.grey),
                    )),
                  ),
                  const SizedBox(height: 20),
                  //! 3 icons for optional login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeInUp(
                        duration: const Duration(milliseconds: 2200),
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.mail_outline_outlined),
                            iconSize: 30,
                            color: Colors.red),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 2400),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.facebook),
                          color: Colors.blue,
                          iconSize: 30,
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 2600),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.apple),
                          iconSize: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

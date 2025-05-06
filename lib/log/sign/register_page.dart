import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blood_donar/log/sign/login.dart';
import 'package:blood_donar/profile/profilepage1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //! Controllers for the registration form
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

//! here create an account using gmail and also check here that email is varified or not !
  Future signUp() async {
//! check here password is matching or not
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: "Error",
        desc: "Passwords don't match",
        btnOkOnPress: () {},
      ).show();
      return;
    }

    try {
      //! create user here and add in firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      //! send verification email to the user
      await userCredential.user!.sendEmailVerification();

      //! dialoge box to show the user that email is sent to the user
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        title: "Verify your email",
        desc:
            "A verification link has been sent to your email. After verifying, click below.",
        btnOkText: "I've Verified",
        btnOkOnPress: () async {
          await FirebaseAuth.instance.currentUser
              ?.reload(); // RELOAD latest user
          User? user = FirebaseAuth.instance.currentUser; // GET updated user

          if (user != null && user.emailVerified) {
            // ✅ Only add if verified
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({'email': user.email});

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage1()),
            );
          } else {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              title: "Not Verified",
              desc: "Email is not verified yet. Please check again.",
              btnOkOnPress: () {},
            ).show();
          }
        },
      ).show();
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: "Registration Failed",
        desc: e.toString(),
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 90),
                Lottie.asset(
                  'assets/blood.json',
                  height: 105,
                ),

                //! Title
                Text(
                  "HELLO THERE!",
                  style: GoogleFonts.bebasNeue(
                    fontSize: 52,
                    color: const Color.fromARGB(213, 231, 4, 4),
                  ),
                ),

                //! Register Text
                Text(
                  "Create an account to get started!",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: const Color.fromARGB(185, 43, 42, 42),
                  ),
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
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                //! Animated Confirm Password Field
                FadeInUp(
                  duration: const Duration(milliseconds: 1200),
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
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Confirm Password",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Animated Sign-up Button
                FadeInUp(
                  duration: const Duration(milliseconds: 1400),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: signUp,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(170, 231, 4, 4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text("Sign Up",
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

                // Animated Login Text
                FadeInUp(
                  duration: const Duration(milliseconds: 1400),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already a member? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          "Login Now",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                FadeInUp(
                  duration: const Duration(milliseconds: 2000),
                  child: const Center(
                      child: Text(
                    '- OR SignUp with -',
                    style: TextStyle(color: Colors.grey),
                  )),
                ),
                const SizedBox(height: 15),
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
    );
  }
}

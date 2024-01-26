import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/color_utils.dart';
import 'package:login_page/home_screen.dart';
import 'package:login_page/reusable_widget.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _userNameController),
                const SizedBox(height: 20),
                reusableTextField("Enter Email Id", Icons.person_outline, false,
                    _emailController),
                const SizedBox(height: 20),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    _passwordController),
                const SizedBox(height: 20),
                firebaseUIButton(context, "Sign Up", () {
                  signUp(context);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUp(BuildContext context) async {
    try {
      final String email = _emailController.text;
      final String password = _passwordController.text;

      if (!isValidEmail(email)) {
        showSnackBar(context, "Geçerli bir e-posta adresi giriniz.");
        return;
      }

      if (password.length < 6) {
        showSnackBar(context, "Şifre en az 6 karakter olmalıdır.");
        return;
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("Created New Account");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (error) {
      print("Error: $error");
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  bool isValidEmail(String email) {
    // E-posta adresi geçerliliğini kontrol etmek için uygun bir yöntem kullanabilirsiniz.
    // Bu örnekte basit bir kontrol uygulandı, gerçek bir doğrulama fonksiyonu kullanmanız önerilir.
    return email.contains("@") && email.contains(".");
  }
}

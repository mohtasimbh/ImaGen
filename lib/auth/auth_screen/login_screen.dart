import 'package:flutter/material.dart';
import 'package:imagen/auth/auth_controller/auth.dart';
import 'package:imagen/auth/auth_screen/signin_screen.dart';
import 'package:imagen/auth/widget/text_field.dart';
import 'package:imagen/auth/widget/utils.dart';
import 'package:imagen/features/home/view/home_view.dart';
import 'package:imagen/features/home/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoding = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    // set loading to true
    setState(() {
      _isLoding = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoding = false;
       
      });
       Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (context) => HomeViewModel(),
              child: const HomeView(),
            ),
          ),
        );
    } else {
      setState(() {
        _isLoding = false;
      });
      // show the error
      showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => HomeViewModel(),
                        child: const HomeView(),
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
              Flexible(flex: 2, child: Container()),
              Image.asset(
                'images/light_icon.png',
                color: Colors.white,
                height: 64,
              ),
              const SizedBox(height: 40),
              TextFieldInput(
                hintText: "Enter Your Email",
                textEditingController: _emailController,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              TextFieldInput(
                hintText: "Enter Your Password",
                textEditingController: _passwordController,
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: loginUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    color: Colors.blue,
                  ),
                  child: _isLoding
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Colors.white,
                        ))
                      : const Text(
                          'Login',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(flex: 2, child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white),
                      )),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignupScreen()));
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          " Sign Up",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

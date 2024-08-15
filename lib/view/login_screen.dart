import 'package:toolvio/utils/routes/routes_name.dart';
import 'package:toolvio/utils/utils.dart';
import 'package:toolvio/res/widgets/button_primary.dart';
import 'package:toolvio/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final loginViewModel = Provider.of<LoginViewModel>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFEDF9FF),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/toolivo_icon.png',
                    width: 147,
                    height: 112,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 35, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.login, // "Login",
                    style: GoogleFonts.spaceGrotesk(
                      textStyle: const TextStyle(
                        color: Color(0xFF040404),
                        fontWeight: FontWeight.bold,
                        fontSize: 48,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: screenWidth * 0.8,
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: TextField(
                focusNode: emailFocus,
                controller: usernameController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  hintText: AppLocalizations.of(context)!.user, //'User',
                ),
                onSubmitted: (value) {
                  Utils.focusChange(context, emailFocus, passwordFocus);
                },
              ),
            ),
            Container(
              width: screenWidth * 0.8,
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: TextField(
                focusNode: passwordFocus,
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: loginViewModel.isPasswordVisible,
                obscuringCharacter: "*",
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  hintText:
                      AppLocalizations.of(context)!.password, //'Password',
                  suffixIcon: InkWell(
                    onTap: () {
                      loginViewModel.togglePasswordVisible();
                    },
                    child: Icon(loginViewModel.isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ButtonPrimary(
                screenWidth: screenWidth,
                loading: false,
                text: loginViewModel.loggingIn
                    ? AppLocalizations.of(context)!.loggingIn
                    : AppLocalizations.of(context)!.login,
                onTap: () {
                  loginViewModel
                      .loginWithEmailAndPassword(
                          usernameController.text, passwordController.text)
                      .then((value) {
                    if (value) {
                      Utils.toastMessage(
                          AppLocalizations.of(context)!.loggedInSuccessfully);
                      Navigator.of(context).popAndPushNamed(RoutesName.home);
                    }
                  });
                },
                image: null,
                mainAxisAlignment: MainAxisAlignment.center,
                color: const Color(0xFF2D75B6),
              ),
            )
          ],
        ),
      ),
    );
  }
}

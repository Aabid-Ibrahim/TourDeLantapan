import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/form/form-theme.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  Function goToLogIn;
  SignUp({Key? key, required this.goToLogIn}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool showPasswordA = false;
  bool showPasswordB = false;

  Map<String, dynamic> payload = {"fullName": "", "email": "", "password": ""};

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: colorBG1,
      body: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              padding: EdgeInsets.only(
                  top: height * .15,
                  bottom: 15,
                  right: isMobile(context) ? 0 : width * .3,
                  left: isMobile(context) ? 0 : width * .3),
              children: [
                if (userProvider.loading == "signup")
                  const LinearProgressIndicator(),
                const SizedBox(height: 15),
                TextFormField(
                    onChanged: (e) =>
                        setState(() => payload["fullName"] = e.trim()),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "This field is required";
                      }
                    },
                    style: TextStyle(color: textColor2),
                    decoration: textFieldStyle(
                      label: "Full Name",
                      prefixIcon: const Icon(
                        Icons.key_rounded,
                        color: Colors.white,
                      ),
                    )),
                const SizedBox(height: 15),
                TextFormField(
                    onChanged: (e) =>
                        setState(() => payload["email"] = e.trim()),
                    style: TextStyle(color: textColor2),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "This field is required";
                      }
                      if (!EmailValidator.validate(val)) {
                        return "Email invalid";
                      }
                    },
                    decoration: textFieldStyle(
                      label: "Email",
                      prefixIcon: const Icon(
                        Icons.key_rounded,
                        color: Colors.white,
                      ),
                    )),
                const SizedBox(height: 15),
                TextFormField(
                    onChanged: (e) => setState(() => payload["password"] = e),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "This field is required";
                      }
                    },
                    obscureText: !showPasswordA,
                    style: TextStyle(color: textColor2),
                    decoration: textFieldStyle(
                        label: "Password",
                        prefixIcon: const Icon(
                          Icons.key_rounded,
                          color: Colors.white,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => showPasswordA = !showPasswordA),
                            icon: Icon(
                              Icons.remove_red_eye_rounded,
                              color: !showPasswordA
                                  ? Colors.white54
                                  : Colors.amber,
                            )))),
                const SizedBox(height: 15),
                TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "This field is required";
                      }
                      if (payload["password"] != val) {
                        return "Passwords don't match";
                      }
                    },
                    obscureText: !showPasswordB,
                    style: TextStyle(color: textColor2),
                    decoration: textFieldStyle(
                        label: "Confirm Password",
                        prefixIcon: const Icon(
                          Icons.key_rounded,
                          color: Colors.white,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => showPasswordB = !showPasswordB),
                            icon: Icon(
                              Icons.remove_red_eye_rounded,
                              color: !showPasswordB ? Colors.grey : Colors.red,
                            )))),
                const SizedBox(height: 15),
                Button(
                    label: "Sign Up",
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        Provider.of<UserProvider>(context, listen: false)
                            .signup(
                                payload: payload,
                                callback: (code, message) {
                                  if (code != 200) {
                                    launchSnackbar(
                                        context: context,
                                        mode: "ERROR",
                                        message: message ?? "Error!");
                                    return;
                                  }
                                  _formKey.currentState!.reset();
                                  launchSnackbar(
                                      context: context,
                                      mode: "SUCCESS",
                                      message: message ?? "Success!");
                                  widget.goToLogIn();
                                });
                      }
                    },
                    padding: const EdgeInsets.symmetric(vertical: 15))
              ],
            ),
          )),
    );
  }
}

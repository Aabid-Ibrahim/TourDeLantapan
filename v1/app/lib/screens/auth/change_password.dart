import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/form/form-theme.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _SignUpState();
}

class _SignUpState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  bool showPasswordA = false;
  bool showPasswordB = false;
  bool showPasswordC = false;

  Map<String, dynamic> payload = {
    "oldPassword": "",
    "newPassword": "",
    "confirmPassword": ""
  };

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBG2,
        foregroundColor: textColor2,
        elevation: 0,
        title: const Text("Change Password"),
      ),
      body: Container(
        color: colorBG1,
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView(
                padding: EdgeInsets.only(
                    top: height * .15,
                    bottom: 15,
                    right: isMobile(context) ? 0 : width * .3,
                    left: isMobile(context) ? 0 : width * .3),
                children: [
                  TextFormField(
                      onChanged: (e) =>
                          setState(() => payload["oldPassword"] = e),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "This field is required";
                        }
                      },
                      style: TextStyle(color: textColor2),
                      obscureText: !showPasswordA,
                      decoration: textFieldStyle(
                          label: "Old Password",
                          prefixIcon: const Icon(
                            Icons.key_rounded,
                            color: Colors.white,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () => setState(
                                  () => showPasswordA = !showPasswordA),
                              icon: Icon(
                                Icons.remove_red_eye_rounded,
                                color: !showPasswordA
                                    ? Colors.white54
                                    : Colors.amber,
                              )))),
                  const SizedBox(height: 35),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                      onChanged: (e) =>
                          setState(() => payload["newPassword"] = e),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "This field is required";
                        }
                      },
                      style: TextStyle(color: textColor2),
                      obscureText: !showPasswordB,
                      decoration: textFieldStyle(
                          label: "New Password",
                          prefixIcon: const Icon(
                            Icons.key_rounded,
                            color: Colors.white,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () => setState(
                                  () => showPasswordB = !showPasswordB),
                              icon: Icon(
                                Icons.remove_red_eye_rounded,
                                color: !showPasswordB
                                    ? Colors.white54
                                    : Colors.amber,
                              )))),
                  const SizedBox(height: 15),
                  TextFormField(
                      onChanged: (e) =>
                          setState(() => payload["confirmPassword"] = e),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "This field is required";
                        }
                        if (payload["newPassword"] != val) {
                          return "Passwords don't match";
                        }
                      },
                      style: TextStyle(color: textColor2),
                      obscureText: !showPasswordC,
                      decoration: textFieldStyle(
                          label: "Confirm Password",
                          prefixIcon: const Icon(
                            Icons.key_rounded,
                            color: Colors.white,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () => setState(
                                  () => showPasswordC = !showPasswordC),
                              icon: Icon(
                                Icons.remove_red_eye_rounded,
                                color: !showPasswordC
                                    ? Colors.white54
                                    : Colors.amber,
                              )))),
                  const SizedBox(height: 15),
                  Button(
                      label: "Change Password",
                      isLoading: userProvider.loading == "password-change",
                      backgroundColor: Colors.red[900]!.withOpacity(.6),
                      borderColor: Colors.transparent,
                      onPress: () {
                        if (_formKey.currentState!.validate()) {
                          Provider.of<UserProvider>(context, listen: false)
                              .changePassword(
                                  payload: payload,
                                  callback: (code, message) {
                                    launchSnackbar(
                                        context: context,
                                        mode: code == 200 ? "SUCCESS" : "ERROR",
                                        message: message ?? "Error!");

                                    if (code != 200) return;

                                    userProvider.signOut();
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, '/guest', (route) => false);
                                  });
                        }
                      },
                      padding: const EdgeInsets.symmetric(vertical: 15))
                ],
              ),
            )),
      ),
    );
  }
}

import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/utilities/shared_preferences.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminLogin extends StatefulWidget {
  AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _formKey = GlobalKey<FormState>();

  bool showPassword = false;
  Map<String, dynamic> payload = {"email": "", "password": ""};

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(
              left: 15,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          height: MediaQuery.of(context).size.height * .08,
                          width: MediaQuery.of(context).size.height * .08,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: Image(
                            image: const AssetImage(
                                'assets/images/lantapan_seal.png'),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: Image(
                              image: const AssetImage(
                                  'assets/images/tour_office.png'),
                              height: MediaQuery.of(context).size.height * .07,
                              width: MediaQuery.of(context).size.height * .07),
                        ),
                      ]),
                ),
                Expanded(
                  child: Row(
                    children: [
                      if (!isMobile(context))
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100)),
                            child: Image(
                                image:
                                    const AssetImage('assets/images/admin.png'),
                                height: MediaQuery.of(context).size.height * .5,
                                width: MediaQuery.of(context).size.height * .5),
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: customSize(width, {
                            "400": 20,
                            "800": 20,
                            "1080": width * .20,
                            "1400": width * .20,
                            "1800": width * .20,
                            "2400": width * .20
                          })),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (BUILD_MODE == "ADMIN")
                                  IconText(
                                    label: "Tour de Lantapan\nAdmin Login",
                                    fontWeight: FontWeight.bold,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue: payload["email"],
                                  onChanged: (e) => setState(
                                      () => payload["email"] = e.trim()),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "This field is required";
                                    }

                                    if (!EmailValidator.validate(val)) {
                                      return "Email Invalid.";
                                    }
                                  },
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Email",
                                      prefixIcon: Icon(Icons.email)),
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue: payload["password"],
                                  onChanged: (e) =>
                                      setState(() => payload["password"] = e),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "This field is required";
                                    }
                                  },
                                  obscureText: !showPassword,
                                  decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: "Password",
                                      prefixIcon: const Icon(Icons.key_rounded),
                                      suffixIcon: IconButton(
                                          onPressed: () => setState(() =>
                                              showPassword = !showPassword),
                                          icon: Icon(
                                            Icons.remove_red_eye_rounded,
                                            color: !showPassword
                                                ? Colors.grey
                                                : Colors.red,
                                          ))),
                                ),
                                const SizedBox(height: 15),
                                Button(
                                    label: "Log In",
                                    isLoading: userProvider.loading == "login",
                                    onPress: () {
                                      if (_formKey.currentState!.validate()) {
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .login(
                                                payload: payload,
                                                callback:
                                                    (code, message, scope) {
                                                  if (code != 200) {
                                                    launchSnackbar(
                                                        context: context,
                                                        mode: "ERROR",
                                                        message: message ??
                                                            "Error!");
                                                    return;
                                                  }
                                                  if (!scope
                                                          .contains('ADMIN') &&
                                                      BUILD_MODE == "ADMIN") {
                                                    launchSnackbar(
                                                        context: context,
                                                        mode: "ERROR",
                                                        message:
                                                            "This user is not an admin account");
                                                    return;
                                                  }

                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          BUILD_MODE == "ADMIN"
                                                              ? "/admin"
                                                              : "/guest",
                                                          (route) => false);
                                                  return;
                                                });
                                      }
                                    },
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15)),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextButton(
                                    onPressed: () => Navigator.pushNamed(
                                        context, '/auth/password/reset'),
                                    child: IconText(
                                        color: Colors.red,
                                        label: "Forgot Password?"))
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

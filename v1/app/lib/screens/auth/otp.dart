import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/widgets/icon_loaders.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OneTimePin extends StatefulWidget {
  OneTimePin({Key? key}) : super(key: key);

  @override
  State<OneTimePin> createState() => _OneTimePinState();
}

class _OneTimePinState extends State<OneTimePin> {
  String pinInput = "";

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: textColor2,
          foregroundColor: Colors.black,
          elevation: 0,
          actions: [
            if (["confirm-otp", "generate-otp"].contains(userProvider.loading))
              showDoubleBounce(size: 20),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(100)),
                    child: Icon(
                      Icons.email_rounded,
                      color: Colors.blue[900],
                      size: 40,
                    )),
                const SizedBox(height: 20),
                IconText(
                    mainAxisAlignment: MainAxisAlignment.center,
                    color: Colors.black,
                    label: "An email has been sent to"),
                IconText(
                    mainAxisAlignment: MainAxisAlignment.center,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    label: userProvider.currentUser!.email),
                const SizedBox(height: 70),
                TextFormField(
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    onChanged: (e) => setState(() => pinInput = e),
                    decoration: InputDecoration(
                        suffixIcon: Material(
                          child: IconButton(
                              onPressed: userProvider.loading == "confirm-otp"
                                  ? null
                                  : () {
                                      if (pinInput.isEmpty) {
                                        launchSnackbar(
                                            context: context,
                                            mode: "ERROR",
                                            message: "Please enter OTP");
                                        return;
                                      }

                                      userProvider.confirmPin(
                                          query: {
                                            "pin": pinInput,
                                            "email":
                                                userProvider.currentUser!.email,
                                          },
                                          callback: (code, message, profile) {
                                            if (code == 200) {
                                              userProvider
                                                  .setCurrentUser(profile);
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  '/guest',
                                                  (route) => false);
                                              return;
                                            } else {
                                              launchSnackbar(
                                                  context: context,
                                                  mode: "ERROR",
                                                  message: message);
                                            }
                                          });
                                    },
                              icon: const Icon(Icons.send_rounded)),
                        ),
                        label: const Text(
                          "6-Digit One Time Pin.",
                          textAlign: TextAlign.center,
                        ))),
                const SizedBox(height: 100),
                IconText(
                    mainAxisAlignment: MainAxisAlignment.center,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    label: "Didn't receive an email?"),
                TextButton(
                    onPressed: () {
                      userProvider.generatePin(
                          query: {
                            "email": userProvider.currentUser!.email,
                            "recipient_name": userProvider.currentUser!.fullName
                          },
                          callback: (code, message) {
                            launchSnackbar(
                                context: context,
                                mode: code == 200 ? "SUCCESS" : "ERROR",
                                message: message);
                          });
                    },
                    child: IconText(
                        mainAxisAlignment: MainAxisAlignment.center,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        label: "Try again."))
              ]),
        ));
  }
}

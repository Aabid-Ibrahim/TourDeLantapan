import 'dart:io';

import 'package:app/models/user_model.dart';
import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/form/form-theme.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  bool showPasswordA = false;
  bool showPasswordB = false;
  CroppedFile? croppedImage;
  Map<String, dynamic> payload = {"_id": "", "fullName": "", "email": ""};

  @override
  void initState() {
    payload =
        Provider.of<UserProvider>(context, listen: false).currentUser!.toJson();
    payload.removeWhere((key, value) => [
          "password",
          "photo",
          "emailVerification",
          "scope",
          "createdAt",
          "updatedAt"
        ].contains(key));
    super.initState();
  }

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
        title: const Text("Edit Profile"),
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
                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: croppedImage == null
                            ? Image.network(
                                userProvider.currentUser?.photo?.small ??
                                    placeholderImage,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Container(
                                          width: 150,
                                          height: 150,
                                          color: Colors.grey,
                                        )))
                            : Image.file(
                                File(croppedImage!.path),
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              )),
                  ),
                  TextButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        CroppedFile? croppedImage =
                            await ImageCropper.platform.cropImage(
                          sourcePath: image!.path,
                        );
                        setState(() {
                          this.croppedImage = croppedImage;
                        });
                      },
                      child: IconText(
                        label: "Change Photo",
                        color: textColor1,
                        fontWeight: FontWeight.bold,
                        mainAxisAlignment: MainAxisAlignment.center,
                        icon: Icons.photo_size_select_actual_rounded,
                      )),
                  if (userProvider.loading == "signup")
                    const LinearProgressIndicator(),
                  const SizedBox(height: 15),
                  TextFormField(
                    initialValue: userProvider.currentUser!.fullName,
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
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                        )),
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    initialValue: userProvider.currentUser!.email,
                    onChanged: (e) =>
                        setState(() => payload["email"] = e.trim()),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "This field is required";
                      }
                      if (!EmailValidator.validate(val)) {
                        return "Email invalid";
                      }
                    },
                    readOnly: true,
                    style: TextStyle(color: textColor2),
                    decoration: textFieldStyle(
                        label: "Email (Not changeable)",
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.white,
                        )),
                  ),
                  const SizedBox(height: 25),
                  Button(
                      isLoading: userProvider.loading == "profile-edit",
                      label: "Save Changes",
                      backgroundColor: Colors.red[900]!.withOpacity(.9),
                      borderColor: Colors.transparent,
                      onPress: () async {
                        if (_formKey.currentState!.validate()) {
                          Provider.of<UserProvider>(context, listen: false)
                              .editProfile(
                                  payload: payload,
                                  photo: croppedImage == null
                                      ? null
                                      : PlatformFile(
                                          path: croppedImage!.path,
                                          name:
                                              path.basename(croppedImage!.path),
                                          size: File(croppedImage!.path)
                                              .lengthSync()),
                                  callback: (code, message) {
                                    launchSnackbar(
                                        context: context,
                                        mode: code == 200 ? "SUCCESS" : "ERROR",
                                        message: message);

                                    if (code == 200) {
                                      Navigator.pop(context);
                                      return;
                                    }
                                  });
                        }
                      },
                      padding: const EdgeInsets.symmetric(vertical: 15)),
                  const SizedBox(height: 15),
                  Divider(
                    color: textColor1,
                  ),
                  TextButton(
                      onPressed: () async {
                        Navigator.pushNamed(
                            context, '/user/profile/change-password');
                      },
                      child: IconText(
                        label: "Change Password",
                        color: textColor2,
                        fontWeight: FontWeight.bold,
                        icon: Icons.key_rounded,
                      )),
                ],
              ),
            )),
      ),
    );
  }
}

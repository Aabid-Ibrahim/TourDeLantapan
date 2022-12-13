import 'dart:convert';

import 'package:app/provider/place_provider.dart';
import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/widgets/StructuredAddress.dart';
import 'package:app/widgets/bottom_modal.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/form/number_picker.dart';
import 'package:app/widgets/privacy_policy.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/form/date_picker.dart';
import 'package:provider/provider.dart';

class VisitorForm extends StatefulWidget {
  VisitorForm({Key? key}) : super(key: key);

  @override
  State<VisitorForm> createState() => _VisitorFormState();
}

class _VisitorFormState extends State<VisitorForm> {
  bool policyAgreed = false;
  final _formKey = GlobalKey<FormState>();
  var addressController = TextEditingController();
  Map<String, dynamic> payload = {
    "fullName": "",
    "contactNumber": "",
    "dateOfVisit": "",
    "homeAddress": "",
    "numberOfVisitors": 1,
    "address": {}
  };

  @override
  void initState() {
    payload["dateOfVisit"] = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    PlaceProvider placeProvider = context.watch<PlaceProvider>();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: textColor2,
        title: const Text("Visitor Form"),
        actions: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          placeProvider.placeInfo.photos.isNotEmpty
                              ? placeProvider.placeInfo.photos[0].small!
                              : placeholderImage))),
            ),
            Text(placeProvider.placeInfo.name),
            const SizedBox(width: 15)
          ]),
        ],
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              if (userProvider.loading == "visitor-form")
                const LinearProgressIndicator(),
              Expanded(
                child: ListView(
                    padding: EdgeInsets.symmetric(
                        horizontal: isMobile(context)
                            ? 15
                            : MediaQuery.of(context).size.width * .3),
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * .1),
                      DateChooser(
                        label: "Date of Visit",
                        firstDate: DateTime(DateTime.now().year - 3),
                        lastDate: DateTime(DateTime.now().year + 1),
                        format: "MMMM dd, yyyy",
                        initialDate: payload["dateOfVisit"] ?? DateTime.now(),
                        onDone: (e) =>
                            setState(() => payload["dateOfVisit"] = e),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        onChanged: (e) =>
                            setState(() => payload["fullName"] = e.trim()),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "This field is required";
                          }
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Full Name"),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        onChanged: (e) =>
                            setState(() => payload["contactNumber"] = e.trim()),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "This field is required";
                          }
                          if (val.length != 10) {
                            return "Invalid number.";
                          }
                        },
                        maxLength: 10,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Contact Number",
                            prefixText: "+63"),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: addressController,
                        readOnly: true,
                        onChanged: (e) =>
                            setState(() => payload["homeAddress"] = e.trim()),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "This field is required";
                          }
                        },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isDismissible: false,
                                      enableDrag: false,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) {
                                        return StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter setModalState) {
                                          return Modal(
                                              title: "Your home address",
                                              heightInPercentage: .9,
                                              content: StructuredAddress(
                                                  onSave: (address) {
                                                setState(() =>
                                                    payload["address"] =
                                                        address);
                                                addressController.text =
                                                    "${address['cityMunicipality']}${address['cityMunicipality']?.isNotEmpty ? ", " : ""}${address['province']}${address['province']?.isNotEmpty ? ", " : ""}${address['region']}";
                                                Navigator.pop(context);
                                              }));
                                        });
                                      });
                                },
                                icon: const Icon(
                                  Icons.list_alt_rounded,
                                  color: Colors.red,
                                )),
                            border: const OutlineInputBorder(),
                            labelText: "Home Address"),
                      ),
                      const SizedBox(height: 15),
                      NumberChooser(
                          label: "No. of People Who Visit",
                          min: 1,
                          max: 100,
                          disabled: false,
                          value: payload["numberOfVisitors"],
                          onChange: (e) =>
                              setState(() => payload["numberOfVisitors"] = e)),
                      const SizedBox(height: 10),
                      Row(children: [
                        Checkbox(
                            value: policyAgreed,
                            onChanged: (val) {
                              setState(() => policyAgreed = val!);
                            }),
                        const Text("I have read the "),
                        Button(
                            label: "Privacy Policy",
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            backgroundColor: Colors.transparent,
                            borderColor: Colors.transparent,
                            textColor: Colors.red,
                            onPress: () {
                              showModalBottomSheet(
                                  context: context,
                                  isDismissible: false,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setModalState) {
                                      return Modal(
                                          heightInPercentage: .7,
                                          title:
                                              "Tour de Lantapan Privacy Policy",
                                          content: const PrivacyPolicy());
                                    });
                                  });
                            })
                      ]),
                      const SizedBox(height: 40),
                      const Text(
                        "This form is intended for the tourism office in monitoring visitor and for further research. Your privacy is safe.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "(Kini nga impormasyon ginagamit alang sa pag monitor sa mga katawhan nga ga bisita niining lugara/laaganan. Kini nga impormasyon kay pribado og safety)",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 40),
                      Button(
                          label: "Submit",
                          onPress: userProvider.loading == "visitor-form"
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    if (!policyAgreed) {
                                      launchSnackbar(
                                          context: context,
                                          mode: "ERROR",
                                          message:
                                              "Please read the privacy policy first.");
                                      return;
                                    }

                                    userProvider.submitVisitorForm(
                                        payload: {
                                          ...payload,
                                          "address":
                                              jsonEncode(payload["address"]),
                                          "placeId": placeProvider.placeInfo.id,
                                          "dateOfVisit": payload["dateOfVisit"]
                                              .toIso8601String()
                                        },
                                        callback: (code, message) {
                                          launchSnackbar(
                                              context: context,
                                              mode: code == 200
                                                  ? "SUCCESS"
                                                  : "ERROR",
                                              message: message);
                                          if (code == 200) {
                                            Navigator.pop(context);
                                          }
                                        });
                                  }
                                },
                          padding: const EdgeInsets.symmetric(vertical: 15)),
                      const SizedBox(height: 15),
                    ]),
              ),
            ],
          )),
    );
  }
}

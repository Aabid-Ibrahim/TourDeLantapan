import 'dart:convert';
import 'dart:io';

import 'package:app/models/category_model.dart';
import 'package:app/models/photo_model.dart';
import 'package:app/models/place_model.dart';
import 'package:app/provider/place_provider.dart';
import 'package:app/screens/guest/select_location.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/utilities/string_extensions.dart';
import 'package:app/widgets/add_photo.dart';
import 'package:app/widgets/bottom_modal.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/chips.dart';
import 'package:app/widgets/form/time_table.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:app/widgets/time_table_display.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class AddPlace extends StatefulWidget {
  Map<String, dynamic> arguments;
  AddPlace({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> payload = {
    "name": "",
    "address": "",
    "description": "",
    "latitude": 0.0,
    "longitude": 0.0,
    "categoryId": "",
    "timeTable": [],
    "status": "OPEN"
  };
  Map<String, dynamic> _payload = {};
  List<PlatformFile> photos = [];
  List<Photo> uploadedPhotos = [];
  List<String> status = ["OPEN", "CLOSED"];
  String mode = "";
  var addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _payload = {...payload};
    mode = widget.arguments["mode"];
    if (mode == "EDIT") {
      payload = widget.arguments["payload"].toJson();
      addressController.text = payload["address"];
      payload["categoryId"] = payload["categoryId"].id;
      payload["timeTable"] = payload["timeTable"] ?? [];
      payload
          .removeWhere((key, value) => ["photos", "coordinates"].contains(key));
      uploadedPhotos = widget.arguments["payload"].photos;
    }
  }

  @override
  Widget build(BuildContext context) {
    PlaceProvider placeProvider = context.watch<PlaceProvider>();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          title: Text("${mode.titleCase()} Place"),
          actions: [
            Button(
                label: mode == "EDIT" ? "Save Changes" : "Add Place",
                icon: mode == "EDIT" ? Icons.edit : Icons.add,
                backgroundColor: Colors.transparent,
                borderColor: Colors.transparent,
                textColor: Colors.red,
                onPress: placeProvider.loading.contains("place-add") ||
                        placeProvider.loading.contains("place-edit")
                    ? null
                    : () {
                        if (payload["latitude"] == 0.0) {
                          launchSnackbar(
                              context: context,
                              mode: "ERROR",
                              message: "Pin location on the map.");
                          return;
                        }

                        if (payload["categoryId"].isEmpty) {
                          launchSnackbar(
                              context: context,
                              mode: "ERROR",
                              message: "Select a Category");
                          return;
                        }

                        if (mode == "EDIT" &&
                            _formKey.currentState!.validate()) {
                          Provider.of<PlaceProvider>(context, listen: false)
                              .editPlace(
                                  payload: {
                                ...payload,
                                "timeTable": jsonEncode(payload["timeTable"])
                              },
                                  files: photos,
                                  callback: (code, message) {
                                    if (code == 200) {
                                      launchSnackbar(
                                          context: context,
                                          mode: "SUCCESS",
                                          message: message ?? "Success!");
                                      Navigator.pop(context, true);
                                      return;
                                    }
                                    if (code != 200) {
                                      launchSnackbar(
                                          context: context,
                                          mode:
                                              code == 200 ? "SUCCESS" : "ERROR",
                                          message: message ?? "Error!");
                                    }
                                  });
                        }

                        if (mode == "ADD" &&
                            _formKey.currentState!.validate()) {
                          Provider.of<PlaceProvider>(context, listen: false)
                              .addPlace(
                                  payload: {
                                ...payload,
                                "timeTable": jsonEncode(payload["timeTable"])
                              },
                                  files: photos,
                                  callback: (code, message) {
                                    if (code == 200) {
                                      launchSnackbar(
                                          context: context,
                                          mode: "SUCCESS",
                                          message: message ?? "Success!");
                                      setState(() {
                                        photos = [];
                                        payload = _payload;
                                      });
                                      Navigator.pop(context);
                                      // addressController.clear();
                                      // _formKey.currentState!.reset();
                                      return;
                                    }
                                    if (code != 200) {
                                      launchSnackbar(
                                          context: context,
                                          mode:
                                              code == 200 ? "SUCCESS" : "ERROR",
                                          message: message ?? "Error!");
                                    }
                                  });
                        }
                      })
          ],
        ),
        body: Form(
            key: _formKey,
            child: Column(
              children: [
                if (placeProvider.loading.contains("place-add") ||
                    placeProvider.loading.contains("place-edit"))
                  const LinearProgressIndicator(),
                Expanded(
                  child: ListView(
                      padding: EdgeInsets.symmetric(
                          horizontal: isMobile(context)
                              ? 15
                              : MediaQuery.of(context).size.width * .20,
                          vertical: 15),
                      children: [
                        AddPhotos(
                            photos: photos,
                            onDeletePhoto: (index) =>
                                setState(() => photos.removeAt(index)),
                            onAddPhotos: (List<PlatformFile> photos) {
                              setState(() => this.photos = photos);
                            }),
                        const SizedBox(height: 15),
                        TextFormField(
                          initialValue: payload["name"],
                          onChanged: (e) =>
                              setState(() => payload["name"] = e.trim()),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "This field is required";
                            }
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Name")),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: addressController,
                          onChanged: (e) =>
                              setState(() => payload["address"] = e.trim()),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "This field is required";
                            }
                          },
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              label: const Text("Address"),
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
                                                title:
                                                    "Long press to pin your location",
                                                heightInPercentage: .9,
                                                content: SelectLocation(
                                                    willDetectLocation: false,
                                                    value: LatLng(
                                                        payload['latitude'] ==
                                                                0.0
                                                            ? 8.04218877435775
                                                            : payload[
                                                                'latitude'],
                                                        payload['longitude'] ==
                                                                0.0
                                                            ? 124.94591953989034
                                                            : payload[
                                                                'longitude']),
                                                    onSelectLocation:
                                                        (coordinates, address) {
                                                      payload["latitude"] =
                                                          coordinates.latitude;
                                                      payload["longitude"] =
                                                          coordinates.longitude;
                                                      payload["address"] =
                                                          address;
                                                      addressController.text =
                                                          address;
                                                    }));
                                          });
                                        });
                                  },
                                  icon: const Icon(Icons.pin_drop_rounded))),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          initialValue: payload["description"],
                          maxLines: null,
                          onChanged: (e) =>
                              setState(() => payload["description"] = e.trim()),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "This field is required";
                            }
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Description")),
                        ),
                        const SizedBox(height: 25),
                        IconText(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            label: "Select one category"),
                        const SizedBox(height: 5),
                        Row(
                            children: List.generate(
                                categories.length,
                                (index) => Chippy(
                                    backgroundColor: payload["categoryId"] ==
                                            categories[index].id
                                        ? Colors.black
                                        : Colors.grey,
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    label: categories[index].name,
                                    onPress: () => setState(() =>
                                        payload["categoryId"] =
                                            categories[index].id)))),
                        const SizedBox(height: 15),
                        if (uploadedPhotos.isNotEmpty)
                          Column(children: [
                            const SizedBox(height: 15),
                            IconText(
                              icon: Icons.photo,
                              label: "Photos",
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .25,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: uploadedPhotos.length,
                                    itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15, top: 10),
                                        child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8)),
                                                  child: Image.network(
                                                    uploadedPhotos[index]
                                                        .small!,
                                                    fit: BoxFit.cover,
                                                    width: 200,
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                  )),
                                              Positioned(
                                                right: -20,
                                                top: -10,
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              String input = "";

                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Delete Photo?'),
                                                                actions: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: const Text(
                                                                          "Cancel")),
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        placeProvider
                                                                            .deletePhoto(
                                                                                query: {
                                                                              "dataId": payload["_id"],
                                                                              "schema": "place",
                                                                              "link": uploadedPhotos[index].large
                                                                            },
                                                                                callback: (code, message) {
                                                                                  if (code != 200) {
                                                                                    launchSnackbar(context: context, mode: code == 200 ? "SUCCESS" : "ERROR", message: message ?? "Error!");
                                                                                    return;
                                                                                  }
                                                                                  setState(() {
                                                                                    uploadedPhotos.removeAt(index);
                                                                                  });
                                                                                });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: const Text(
                                                                          "Yes")),
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      icon: const Icon(
                                                        Icons.remove_circle,
                                                        color: Colors.red,
                                                        size: 25,
                                                      )),
                                                ),
                                              ),
                                            ])))),
                            const SizedBox(height: 15),
                          ]),
                        const Divider(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconText(
                                label: "Open/Close Time",
                                icon: Icons.more_time_rounded,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              Button(
                                  label: "Edit",
                                  backgroundColor: Colors.transparent,
                                  borderColor: Colors.transparent,
                                  textColor: Colors.red,
                                  icon: Icons.edit,
                                  onPress: () {
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
                                                title:
                                                    "Set Open and Close Time.",
                                                heightInPercentage: .9,
                                                content: TimeTableManager(
                                                  value: payload["timeTable"] ==
                                                          null
                                                      ? []
                                                      : List<TimeTable>.from(
                                                          payload["timeTable"]
                                                              .map((x) =>
                                                                  TimeTable
                                                                      .fromJson(
                                                                          x))),
                                                  onSave: (value) {
                                                    setState(() =>
                                                        payload["timeTable"] =
                                                            value);
                                                    Navigator.pop(context);
                                                  },
                                                ));
                                          });
                                        });
                                  }),
                            ]),
                        if (payload["timeTable"].isNotEmpty)
                          TimeTableDisplay(
                              isLightMode: true,
                              timeTable: payload["timeTable"] == null
                                  ? []
                                  : List<TimeTable>.from(payload["timeTable"]
                                      .map((x) => TimeTable.fromJson(x)))),

                        // IconText(
                        //     color: Colors.black,
                        //     fontWeight: FontWeight.bold,
                        //     label: "Status"),
                        // const SizedBox(height: 5),
                        // Row(
                        //     children: List.generate(
                        //         status.length,
                        //         (index) => Chippy(
                        //             backgroundColor:
                        //                 payload["status"] == status[index]
                        //                     ? Colors.black
                        //                     : Colors.grey,
                        //             margin: const EdgeInsets.only(right: 10),
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 15, vertical: 10),
                        //             label: status[index],
                        //             onPress: () => setState(() =>
                        //                 payload["status"] = status[index]))))
                      ]),
                ),
              ],
            )));
  }
}

import 'dart:io';

import 'package:app/models/photo_model.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddPhotos extends StatelessWidget {
  List<PlatformFile> photos;
  Function onAddPhotos;
  Function onDeletePhoto;
  Color? foregroundColor;
  AddPhotos(
      {Key? key,
      this.foregroundColor,
      required this.photos,
      required this.onAddPhotos,
      required this.onDeletePhoto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconText(
            size: 15,
            color: foregroundColor ?? Colors.black,
            label: "Add Photos",
            icon: Icons.photo_sharp),
        IconButton(
            onPressed: () async {
              try {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.image,
                    withReadStream: !kIsWeb,
                    withData: kIsWeb,
                    allowMultiple: true);
                if (result == null) return;
                onAddPhotos([...photos, ...result.files]);
              } catch (e) {
                print(e);
              }
            },
            icon: Icon(
              Icons.add,
              color: foregroundColor ?? Colors.black,
            )),
      ]),
      Divider(
        color: foregroundColor ?? Colors.grey,
      ),
      const Divider(height: 5),
      if (photos.isNotEmpty)
        SizedBox(
            height: MediaQuery.of(context).size.height * .15,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: photos.length,
                itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Stack(clipBehavior: Clip.none, children: [
                      ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: photos.isNotEmpty
                              ? kIsWeb
                                  ? Image.memory(
                                      photos[index].bytes!,
                                      fit: BoxFit.cover,
                                      width: 200,
                                      height:
                                          MediaQuery.of(context).size.height,
                                    )
                                  : Image.file(
                                      File(photos[index].path!),
                                      fit: BoxFit.cover,
                                      width: 200,
                                      height:
                                          MediaQuery.of(context).size.height,
                                    )
                              : IconText(
                                  label: "Added photos will show here.",
                                  color: Colors.black26,
                                )),
                      Positioned(
                        right: -20,
                        top: -10,
                        child: Material(
                          color: colorBG2,
                          borderRadius: BorderRadius.circular(100),
                          child: IconButton(
                              onPressed: () => onDeletePhoto(index),
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ])))),
      const SizedBox(
        height: 15,
      ),
    ]);
  }
}

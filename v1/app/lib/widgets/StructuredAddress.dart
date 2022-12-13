import 'package:app/models/philippines_model.dart';
import 'package:app/provider/app_provider.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StructuredAddress extends StatefulWidget {
  Function onSave;
  StructuredAddress({Key? key, required this.onSave}) : super(key: key);

  @override
  State<StructuredAddress> createState() => _StructuredAddressState();
}

class _StructuredAddressState extends State<StructuredAddress> {
  int index = 0;
  List<int> indexes = [-1, -1, -1];

  Map<String, dynamic> address = {
    "region": "",
    "regionId": "",
    "province": "",
    "provinceId": "",
    "cityMunicipality": "",
    "cityMunicipalityId": "",
  };

  @override
  void initState() {
    super.initState();
    Provider.of<AppProvider>(context, listen: false).getPhilippines();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = context.watch<AppProvider>();

    return Column(
      key: ValueKey<int>(index),
      children: [
        Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Row(children: [
            StepNode(
              label: "Region",
              isOk: indexes[0] > -1,
            ),
            StepNode(
              label: "Province",
              isOk: indexes[1] > -1,
            ),
            StepNode(
              label: "City/Municipality",
              isOk: indexes[2] > -1,
            )
          ]),
        ),
        if (index == 0)
          Expanded(
              child: ListView.builder(
                  itemCount: appProvider.philippines.length,
                  itemBuilder: (context, ind) => TextButton(
                      onPressed: () {
                        setState(() {
                          index = 1;
                          indexes[0] = ind;
                          address["region"] = appProvider.philippines[ind].name;
                          address["regionId"] = appProvider.philippines[ind].id;
                        });
                      },
                      child: IconText(
                        padding: const EdgeInsets.only(left: 10),
                        color: indexes[0] == ind ? Colors.red : Colors.black,
                        fontWeight: FontWeight.bold,
                        label: appProvider.philippines[ind].name,
                      )))),
        if (index == 1)
          Expanded(
              child: ListView.builder(
                  itemCount:
                      appProvider.philippines[indexes[0]].provinces.length,
                  itemBuilder: (context, ind) => TextButton(
                      onPressed: () {
                        setState(() {
                          index = 2;
                          indexes[1] = ind;

                          address["province"] = appProvider
                              .philippines[indexes[0]].provinces[ind].name;
                          address["provinceId"] = appProvider
                              .philippines[indexes[0]].provinces[ind].id;
                        });
                      },
                      child: IconText(
                        padding: const EdgeInsets.only(left: 10),
                        color: indexes[1] == ind ? Colors.red : Colors.black,
                        fontWeight: FontWeight.bold,
                        label: appProvider
                            .philippines[indexes[0]].provinces[ind].name,
                      )))),
        if (index == 2)
          Expanded(
              child: ListView.builder(
                  itemCount: appProvider.philippines[indexes[0]]
                      .provinces[indexes[1]].citymunicipalities.length,
                  itemBuilder: (context, ind) => TextButton(
                      onPressed: () {
                        setState(() {
                          index = 2;
                          indexes[2] = ind;

                          address["cityMunicipality"] = appProvider
                              .philippines[indexes[0]]
                              .provinces[indexes[1]]
                              .citymunicipalities[ind]
                              .name;
                          address["cityMunicipalityId"] = appProvider
                              .philippines[indexes[0]]
                              .provinces[indexes[1]]
                              .citymunicipalities[ind]
                              .id;
                        });
                      },
                      child: IconText(
                        padding: const EdgeInsets.only(left: 10),
                        color: indexes[2] == ind ? Colors.red : Colors.black,
                        fontWeight: FontWeight.bold,
                        label: appProvider.philippines[indexes[0]]
                            .provinces[indexes[1]].citymunicipalities[ind].name,
                      )))),
        if (indexes[0] != -1)
          Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(15),
              child: Row(children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconText(
                          label: "Your Address",
                          color: Colors.black,
                        ),
                        Text(
                          "${address['cityMunicipality']}${address['cityMunicipality'].isNotEmpty ? ", " : ""}${address['province']}${address['province'].isNotEmpty ? ", " : ""}${address['region']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ]),
                ),
                Button(label: "Save", onPress: () => widget.onSave(address))
              ]))
      ],
    );
  }
}

class StepNode extends StatelessWidget {
  String label;
  bool isOk;
  StepNode({Key? key, required this.label, required this.isOk})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                color: isOk ? Colors.red : Colors.grey,
                borderRadius: BorderRadius.circular(100))),
        IconText(
          label: label,
          padding: const EdgeInsets.only(left: 5),
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(
          width: 15,
        )
      ],
    );
  }
}

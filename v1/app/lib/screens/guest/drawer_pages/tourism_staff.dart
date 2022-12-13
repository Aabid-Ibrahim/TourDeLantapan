import 'package:app/utilities/constants.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:flutter/material.dart';

class TourismStaff extends StatefulWidget {
  TourismStaff({Key? key}) : super(key: key);

  @override
  State<TourismStaff> createState() => _TourismStaffState();
}

class _TourismStaffState extends State<TourismStaff> {
  Staff president = Staff(
      name: "Nonelita C.\nButaya",
      designation: "Head",
      photo: const AssetImage('assets/images/tourism_staff/butaya.jpg'));

  List<List> staff = [
    [
      Staff(
          name: "Gracel Joy. C\nDaanoy",
          designation: "Staff",
          photo: const AssetImage('assets/images/tourism_staff/daanoy.jpg')),
      Staff(
          name: "Marilyn A.\nApat",
          designation: "Staff",
          photo: const AssetImage('assets/images/tourism_staff/apat.jpg')),
    ],
    [
      Staff(
          name: "Patrocinia J.\nEralino",
          designation: "Staff",
          photo: const AssetImage('assets/images/tourism_staff/eralino.jpg')),
      Staff(
          name: "John Domenic C.\nButaya",
          designation: "Staff",
          photo:
              const AssetImage('assets/images/tourism_staff/john_butaya.jpg'))
    ],
    [
      Staff(
          name: "Angel Mae L.\nHusayan",
          designation: "Staff",
          photo: const AssetImage('assets/images/tourism_staff/husayan.jpg'))
    ]
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorBG1,
      child: Column(children: [
        StaffBadge(staff: president),
        Expanded(
          child: ListView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: isMobile(context)
                      ? 0
                      : MediaQuery.of(context).size.width * .30,
                  vertical: 15),
              itemCount: staff.length,
              itemBuilder: (context, i) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                        staff[i].length,
                        (ind) =>
                            Expanded(child: StaffBadge(staff: staff[i][ind]))),
                  )),
        )
      ]),
    );
  }
}

class StaffBadge extends StatelessWidget {
  final Staff staff;
  const StaffBadge({Key? key, required this.staff}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image(
              image: staff.photo,
              height: 100,
              width: 80,
              fit: BoxFit.cover,
            )),
        const SizedBox(
          height: 15,
        ),
        Text(
          staff.name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17, color: textColor2),
        ),
        IconText(
            label: staff.designation,
            mainAxisAlignment: MainAxisAlignment.center,
            color: textColor1),
      ]),
    );
  }
}

class Staff {
  Staff({required this.name, required this.designation, required this.photo});
  String name;
  String designation;
  AssetImage photo;
}

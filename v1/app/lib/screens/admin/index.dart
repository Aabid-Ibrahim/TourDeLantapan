// ignore_for_file: must_be_immutable

import 'package:app/provider/user_provider.dart';
import 'package:app/screens/admin/dashboard.dart';
import 'package:app/screens/admin/manage_places.dart';
import 'package:app/screens/admin/visitors_table.dart';
import 'package:app/widgets/button.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  PageController page = PageController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    UserProvider userProvider = context.watch<UserProvider>();

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text(
            "Lantapan Admin",
            style: TextStyle(color: Colors.black),
          ),
          actions: [],
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SideMenu(
                controller: page,
                footer:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Button(
                      icon: userProvider.currentUser == null
                          ? Icons.person
                          : Icons.logout_rounded,
                      label: userProvider.currentUser == null
                          ? "Log In/Sign Up"
                          : "Log Out",
                      borderColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      textColor: Colors.black,
                      padding: const EdgeInsets.all(15),
                      mainAxisAlignment: MainAxisAlignment.start,
                      onPress: () async {
                        Navigator.pushNamed(context, '/auth/admin');
                        if (userProvider.currentUser != null) {
                          userProvider.signOut();
                          return;
                        }
                      }),
                ]),
                title: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.admin_panel_settings_rounded,
                              size: 30),
                          if (width > 600)
                            Text("${userProvider.currentUser?.fullName}",
                                style: const TextStyle(fontSize: 15)),
                        ])),
                style: SideMenuStyle(
                    displayMode: SideMenuDisplayMode.auto,
                    hoverColor: Colors.grey[100],
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color: Colors.grey.withOpacity(.2)))),
                    selectedTitleTextStyle:
                        const TextStyle(color: Colors.black87, fontSize: 15),
                    unselectedTitleTextStyle:
                        const TextStyle(color: Colors.black87, fontSize: 15),
                    selectedIconColor: Colors.black87,
                    backgroundColor: Colors.white),
                items: [
                  SideMenuItem(
                    priority: 0,
                    title: 'Dashboard',
                    onTap: () {
                      setState(() => pageIndex = 0);
                      page.jumpToPage(0);
                    },
                    icon: const Icon(Icons.dashboard_rounded),
                  ),
                  SideMenuItem(
                    priority: 1,
                    title: 'Places',
                    onTap: () {
                      setState(() => pageIndex = 1);
                      page.jumpToPage(1);
                    },
                    icon: const Icon(Icons.place_rounded),
                  ),
                  SideMenuItem(
                    priority: 2,
                    title: 'Visitors',
                    onTap: () {
                      setState(() => pageIndex = 2);
                      page.jumpToPage(3);
                    },
                    icon: const Icon(Icons.people_alt_rounded),
                  ),
                ]),
            Expanded(
              child: Container(
                color: const Color.fromARGB(255, 247, 247, 247),
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: page,
                  children: [
                    AdminDashboard(),
                    ManagePlaces(
                      arguments: const {"mode": "admin"},
                    ),
                    VisitorTable()
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

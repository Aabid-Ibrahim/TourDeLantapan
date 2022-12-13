import 'package:app/screens/auth/login.dart';
import 'package:app/screens/auth/signup.dart';
import 'package:app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class Auth extends StatefulWidget {
  Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  void goToLogIn() {
    _tabController.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                elevation: 0,
                backgroundColor: colorBG2,
                foregroundColor: textColor2,
                title: const Text(
                  "Discover Lantapan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  onTap: (index) =>
                      setState(() => _tabController.animateTo(index)),
                  isScrollable: true,
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  labelColor: textColor2,
                  unselectedLabelColor: textColor2.withOpacity(.5),
                  indicator: MaterialIndicator(
                      bottomLeftRadius: 0,
                      bottomRightRadius: 0,
                      color: textColor2,
                      topLeftRadius: 100,
                      topRightRadius: 100),
                  tabs: const [
                    Tab(text: 'Log In'),
                    Tab(text: 'Sign Up'),
                  ],
                )),
            body: TabBarView(
              controller: _tabController,
              children: [
                Login(),
                SignUp(
                  goToLogIn: goToLogIn,
                ),
              ],
            )));
  }
}

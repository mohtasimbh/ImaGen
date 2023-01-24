import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imagen/auth/auth_controller/auth.dart';
import 'package:imagen/auth/auth_screen/login_screen.dart';
import 'package:imagen/features/history_search/view/history_search_view.dart';
import 'package:imagen/features/home/view/home_view.dart';
import 'package:imagen/features/home/view/profile.dart';
import 'package:imagen/features/home/view/showcase.dart';
import 'package:imagen/features/home/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    return Drawer(
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.asset(
                      'images/light_icon.png',
                      height: 150,
                      width: 150,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTilesWidget(
              label: "Home",
              icon: Icons.home,
              fct: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (context) => HomeViewModel(),
                      child: const HomeView(),
                    ),
                  ),
                );
              },
            ),
            ListTilesWidget(
              label: authInstance.currentUser != null ? 'Profile' : 'Login',
              icon: Icons.person,
              fct: () {
                authInstance.currentUser != null
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => ProfileScreen(
                                  uid: FirebaseAuth.instance.currentUser!.uid,
                                ))))
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const LoginScreen())));
              },
            ),
            ListTilesWidget(
              label: "Showcase",
              icon: Icons.photo_library_rounded,
              fct: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Showcase(),
                  ),
                );
              },
            ),
            ListTilesWidget(
              label: "History",
              icon: Icons.history,
              fct: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                      value: viewModel,
                      child: const HistorySearchView(),
                    ),
                  ),
                );
              },
            ),
            ListTilesWidget(
              label: "Logout",
              icon: Icons.logout_rounded,
              fct: () async {
                await AuthMethods().signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ListTilesWidget extends StatelessWidget {
  const ListTilesWidget({
    Key? key,
    required this.label,
    required this.fct,
    required this.icon,
  }) : super(key: key);
  final String label;
  final Function fct;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 20),
      ),
      onTap: () {
        fct();
      },
    );
  }
}

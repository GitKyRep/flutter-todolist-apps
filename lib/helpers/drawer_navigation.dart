import 'package:crud_sqflite_example/screen/categories_screen.dart';
import 'package:crud_sqflite_example/screen/home_screen.dart';
import 'package:flutter/material.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://i.etsystatic.com/21073028/d/il/1b1907/2662292100/il_340x270.2662292100_t37c.jpg?version=0"),
              ),
              accountName: Text("Rikisaraan"),
              accountEmail: Text("rikisaraan2@gmail.com"),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  )),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text("Categories"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoriesScreen(),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

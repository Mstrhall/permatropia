import 'package:admin/screens/budget/budget.dart';
import 'package:admin/screens/expenses/expenses.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Charge.dart';
import '../../quotepart.dart';
import '../../recipe/recipe.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dépenses",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ExpensesScreen()));},
          ),
          DrawerListTile(
            title: "Budget",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {Navigator.push(context, MaterialPageRoute(builder: (context) => BudgetScreen()));},
          ),
          DrawerListTile(
            title: "Recette",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeScreen()));},
          ),
          DrawerListTile(
            title: "Quote Part",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {Navigator.push(context, MaterialPageRoute(builder: (context) => QuotePartScreen()));},
          ),
          DrawerListTile(
            title: "Charges",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ChargesScreen()));},
          ),
          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jumaiah/components/profile_page.dart';
import 'package:jumaiah/screens/signin.dart';
import 'package:jumaiah/utils/custom_transition.dart';
import 'package:jumaiah/utils/shared_prefs.dart';
import 'package:jumaiah/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicons/unicons.dart';

SharedPreferences preferences;

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 200,
              child: DrawerHeader(
                // child: Text(
                //   'القائمة الرئيسية',
                //   style: TextStyle(color: Colors.white, fontSize: 25),
                // ),
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage('assets/logo.png'))),
              ),
            ),

            ListTile(
              leading: Icon(UniconsLine.home, color: AppTheme.primaryColor),
              title: Text('الرئيسية'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(UniconsLine.user, color: AppTheme.primaryColor),
              title: Text('البروفايل'),
              onTap: () =>
                  {Navigator.of(context).push(CustomPageRoute(ProfilePage()))},
            ),
            // ListTile(
            //   leading: Icon(Icons.settings),
            //   title: Text('الاعدادات'),
            //   onTap: () => {Navigator.of(context).pop()},
            // ),
            // ListTile(
            //   leading: Icon(Icons.border_color),
            //   title: Text('المشاركات'),
            //   onTap: () => {Navigator.of(context).pop()},
            // ),
            ListTile(
              leading: Icon(UniconsLine.exit, color: AppTheme.primaryColor),
              title: Text('خروج'),
              onTap: () {
                sharedPrefs.setLogin(false);
                sharedPrefs.saveUserType(null);
                sharedPrefs.saveEmail(null);
                sharedPrefs.saveUserPassword(null);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
                preferences.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}

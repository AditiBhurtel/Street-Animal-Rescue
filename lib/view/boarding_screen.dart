import 'package:flutter/material.dart';
import 'package:street_animal_rescue/view/screens/organization_login.dart';

import 'screens/login_screen.dart';

class BoardingScreen extends StatelessWidget {
  const BoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (c) => LoginScreen()),
                    );
                  },
                  child: Text(
                    'Login As Individual',
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (c) => OrganizationLogin()),
                    );
                  },
                  child: Text(
                    'Login As Organization',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

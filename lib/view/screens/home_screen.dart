import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_animal_rescue/cubit/auth_cubit.dart';
import 'package:street_animal_rescue/view/boarding_screen.dart';
import 'package:street_animal_rescue/view/screens/UrgentRescue.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  var currentUser;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.home, size: 30),
      Icon(Icons.search, size: 30),
      Icon(Icons.add, size: 30),
      Icon(Icons.notifications, size: 30),
      Icon(Icons.person, size: 30),
    ];
    return BlocListener<AuthCubit, AuthState>(
      listener: (ctx, authState) {
        if (authState.userModel == null) {
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (ctx) => BoardingScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.teal.shade200,
          centerTitle: false,
          title: Text(
            "News Feed",
            style: TextStyle(color: Colors.white),
          ),
          //backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () async {
                  await context.read<AuthCubit>().logoutUser(context);
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        ),
        body: ListView.builder(itemCount: 12, itemBuilder: (context, index) => CardItem()),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (c) {
                  return UrgentRescue(
                    gCurrentUser: currentUser,
                  );
                },
              ),
            );
            // await verifyPhoneNumber();
          },
          child: Icon(
            Icons.add_a_photo,
            color: Colors.white,
          ),
          backgroundColor: Colors.red.shade300,
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: IconThemeData(color: Colors.white),
          ),
          child: CurvedNavigationBar(
            color: Colors.teal.shade200,
            backgroundColor: Colors.transparent,
            height: 60,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 300),
            index: index,
            items: items,
            onTap: (index) => setState(() => this.index = index),
          ),
        ),
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 400.0,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    'https://scontent.fktm1-2.fna.fbcdn.net/v/t39.30808-6/271094663_4891381280927233_1662351175346737423_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=oQ6QKG3FwWMAX9Gmv3j&_nc_ht=scontent.fktm1-2.fna&oh=00_AT-gYHJ0Pc1m78wa8GcdBJGkXf7Kf4xiGypGxm0u9HaA3A&oe=62C86627',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text("Aditi"),
              subtitle: Text("Tue July 01 2022"),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage('http://daily.jstor.org/wp-content/uploads/2022/06/how_street_dogs_spend_their_days_1050x700.jpg'),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            SizedBox(
              height: 14.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.thumb_up,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "Like",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.comment, color: Colors.grey),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "Comment",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.share, color: Colors.grey),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "Share",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 12.0,
            ),
          ],
        ),
      ),
    );
  }
}

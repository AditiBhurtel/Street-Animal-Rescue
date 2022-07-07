import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: size.width - 30,
                  height: 45,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                    ),
                    style: TextStyle(color: Colors.white.withOpacity(0.3)),
                    cursorColor: Colors.black.withOpacity(0.5),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

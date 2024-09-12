import 'package:flutter/material.dart';
import 'package:geekhaven/Theme/theme_provider.dart';
import 'package:provider/provider.dart';

import '../Widgets/support_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List category = [
    "Headphones",
    "laptop",
    "watch",
    "TV",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

      body: Container(
            margin: EdgeInsets.only(top: 50.0),
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hey!", style: TextStyle(
                            fontSize: 34.0,
                            fontWeight: FontWeight.bold
                        )),

                        Text("Good Morning", style: AppWidget.lightTextStyle()),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 30.0,),

                Container(
                    padding: EdgeInsets.only(left: 20.0),
                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10.0)),
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      decoration: InputDecoration(border: InputBorder.none, hintText: "Search Products", hintStyle: AppWidget.lightTextStyle(), suffixIcon: Icon(Icons.search, color: Colors.black,)),
                    )),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Categories",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22.0
                        )),
                    Text("See all",
                        style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.w500))
                  ],
                ),
                SizedBox(height: 20.0),
                Container(
                  //margin: EdgeInsets.only(left: 20.0),
                  height: 160,
                  child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        return CategoryTile(image: '', name: '',);
                      }),
                ),
                SizedBox(height: 30.0,),

              ],



            )
        ),
    );
  }
}


class CategoryTile extends StatelessWidget {
  String image, name;
  CategoryTile({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context) => Home()));
      },
      child: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
        ),
        height: 110.0,
        width: 110.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(image , height: 70.0, width: 70.0, fit: BoxFit.cover,),
            SizedBox(height: 20.0,),
            Icon(Icons.arrow_forward)
          ],),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:geekhaven/Pages/Predict.dart';
import 'package:geekhaven/Theme/theme_provider.dart';
import 'package:provider/provider.dart';

import '../Widgets/support_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 2, right: 10),
        child: GestureDetector(
          onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Predict()), // Navigate to LoginPage
              );
          },
          child: Container(
            decoration: BoxDecoration( color: Theme.of(context).colorScheme.primary,borderRadius: BorderRadius.circular(13)),
            margin: EdgeInsets.only(left: 240),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              children: [
                Text("Wanna Predict ? ", style: TextStyle(color: Theme.of(context).colorScheme.background, fontSize: 17),),
                Icon(Icons.sunny_snowing, color:Theme.of(context).colorScheme.background,)
              ],
            )
          ),
        ),
      ),

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
                      decoration: InputDecoration(border: InputBorder.none, hintText: "Search", hintStyle: AppWidget.lightTextStyle(), suffixIcon: Icon(Icons.search, color: Colors.black,)),
                    )),
                SizedBox(
                  height: 20.0,
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("What are you searching for ?",
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
                  height: 310,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      Container(
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        margin: EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                                child: Image.asset("Images/Flight.jpg", height: 230, width: 190, fit: BoxFit.cover,)),
                            SizedBox(height: 10,),
                            Text("Flights", style: TextStyle(color: Theme.of(context).colorScheme.background, fontSize: 26),),
                          ],
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        margin: EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset("Images/Trains.jpg", height: 230, width: 190, fit: BoxFit.cover,)),
                            SizedBox(height: 10,),
                            Text("Trains", style: TextStyle(color: Theme.of(context).colorScheme.background,fontSize: 26),),
                          ],
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        margin: EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset("Images/Hotel.jpg", height: 230, width: 190, fit: BoxFit.cover,)),
                            SizedBox(height: 10,),
                            Text("Hotels", style: TextStyle(color: Theme.of(context).colorScheme.background,fontSize: 26),),
                          ],
                        ),
                      )
                    ],

                      ),
                ),
                
                SizedBox(height: 30,),
                


              ],



            ),
        
        ),
    );
  }
}



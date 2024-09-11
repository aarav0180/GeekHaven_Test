import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../Theme/theme_provider.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  bool firstSwitchValue = false;

  final List locale =[
    {'name':'ENGLISH','locale': Locale('en','US')},
    {'name':'हिंदी','locale': Locale('hi','IN')},
  ];
  updateLanguage(Locale locale){
    Get.back();
    Get.updateLocale(locale);
  }

  buildLanguageDialog(BuildContext context){
    showDialog(context: context,
        builder: (builder){
          return AlertDialog(
            title: Text('Choose Your Language'),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(child: Text(locale[index]['name']),onTap: (){
                        print(locale[index]['name']);
                        updateLanguage(locale[index]['locale']);
                      },),
                    );
                  }, separatorBuilder: (context,index){
                return Divider(
                  color: Colors.blue,
                );
              }, itemCount: locale.length
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: Text("Setting", style: TextStyle(fontSize: 20),),),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(19)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Change Theme", style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),),

                  SizedBox(width: 20,),

                  DefaultTextStyle.merge(
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),
                      child: IconTheme.merge(
                          data: IconThemeData(color: Colors.white),
                          child: AnimatedToggleSwitch.dual(
                            current: firstSwitchValue,
                            first: false,
                            second: true,
                            spacing: 45,
                            animationDuration: Duration(milliseconds: 500 ),
                            style: ToggleStyle(
                              borderColor: Colors.transparent,
                              indicatorColor: Colors.black,
                              backgroundColor: Colors.black,
                            ),
                            customStyleBuilder: (context, local, global) {
                              if(global.position <=0){
                                return ToggleStyle(
                                  backgroundColor: Colors.black45,
                                );
                              }
                              return ToggleStyle(
                                backgroundGradient: LinearGradient(
                                  colors: [Colors.black45, Colors.white],
                                  stops: [
                                    global.position - (1-2 * max(0, global.position - 0.5)) * 0.7,

                                    global.position + max(0, 2 * (global.position - 0.5)) * 0.7,
                                  ]
                                ),
                              );
                            },
                            borderWidth: 6,
                            height: 60,
                            loadingIconBuilder: (context, global) =>
                              CupertinoActivityIndicator(
                                color: Color.lerp(Colors.white, Colors.black45, global.position),
                              ),
                            iconBuilder: (value) => value ? const Icon(Icons.light_mode_rounded,
                            color: Colors.white, size: 32,) : Icon(Icons.dark_mode_rounded, color: Colors.white, size: 32,),
                            textBuilder: (value) => value ? const Center(child: Text("Light")) : const Center(child: Text("Dark"),),

                            //onChanged: (value) => setState(() => firstSwitchValue = value),
                            onChanged: (value) {
                              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                              setState(() {
                                firstSwitchValue = value as bool;
                              });
                            },

                          ),
                      )
                  )
                ],
              ),
            ),
            
            SizedBox(height: 17,),
        
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(19)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Change Language", style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                    ),), 
                
                SizedBox(width: 20,),


                  
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}

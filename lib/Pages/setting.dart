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

  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN')},
  ];

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  buildLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          title: Text('Choose Your Language', style: TextStyle(fontSize: 18)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(locale[index]['name'], style: TextStyle(fontSize: 16)),
                  onTap: () {
                    updateLanguage(locale[index]['locale']);
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Divider(color: Colors.grey);
              },
              itemCount: locale.length,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground, // Adjust for both light and dark themes
          ),
        ),
        centerTitle: true,
        elevation: 2, // Slight shadow to enhance AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: 30),

            // Change Theme Section
            AnimatedContainer( // Added subtle animations when hovered or pressed
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: Colors.grey.shade300.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5), // Adds depth with shadow
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Change Theme",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onBackground, // Dynamic text color
                      ),
                    ),
                    AnimatedToggleSwitch.dual(
                      current: firstSwitchValue,
                      first: false,
                      second: true,
                      spacing: 45,
                      animationDuration: Duration(milliseconds: 300), // Smoothed transition

                      // Original style
                      // style: ToggleStyle(
                      //   borderColor: Colors.transparent,
                      //   indicatorColor: Colors.black,
                      //   backgroundColor: Colors.black,
                      // ),

                      // Slightly enhanced toggle style for smoother UX
                      style: ToggleStyle(
                        borderColor: Colors.transparent,
                        indicatorColor: Colors.black,
                        backgroundColor: Colors.grey.shade800, // More modern color
                      ),
                      customStyleBuilder: (context, local, global) {
                        if (global.position <= 0) {
                          return ToggleStyle(backgroundColor: Colors.black45);
                        }
                        return ToggleStyle(
                          backgroundGradient: LinearGradient(
                            colors: [Colors.black45, Colors.white],
                            stops: [
                              global.position - (1 - 2 * max(0, global.position - 0.5)) * 0.7,
                              global.position + max(0, 2 * (global.position - 0.5)) * 0.7,
                            ],
                          ),
                        );
                      },
                      borderWidth: 6,
                      height: 60,
                      loadingIconBuilder: (context, global) => CupertinoActivityIndicator(
                        color: Color.lerp(Colors.white, Colors.black45, global.position),
                      ),
                      iconBuilder: (value) => value
                          ? const Icon(Icons.light_mode_rounded, color: Colors.white, size: 32)
                          : Icon(Icons.dark_mode_rounded, color: Colors.white, size: 32),
                      textBuilder: (value) => value
                          ? const Center(child: Text("Light", style: TextStyle(fontSize: 16)))
                          : const Center(child: Text("Dark", style: TextStyle(fontSize: 16))),
                      onChanged: (value) {
                        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                        setState(() {
                          firstSwitchValue = value as bool;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Change Language Section
            GestureDetector(
              onTap: () => buildLanguageDialog(context),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5), // Adds shadow on hover/tap
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Change Language",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onBackground, // Dynamic text color
                      ),
                    ),
                    Icon(
                      Icons.language,
                      color: Theme.of(context).colorScheme.primary, // Primary color for language icon
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


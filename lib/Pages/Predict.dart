import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geekhaven/Pages/Weather.dart';
import 'package:intl/intl.dart';

class Predict extends StatefulWidget {
  const Predict({super.key});

  @override
  State<Predict> createState() => _PredictState();
}

class _PredictState extends State<Predict> {



  final TextEditingController placeController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  // Date picker helper for picking start and end dates
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2020);
    DateTime lastDate = DateTime(2100);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (startDate ?? initialDate) : (endDate ?? initialDate),
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
        } else {
          endDate = pickedDate;
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Predicting the Weather", style: TextStyle(fontSize: 27),),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40,),
      
              TextField(
                controller: placeController,
                decoration: InputDecoration(
                  labelText: 'Enter Place Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 20),
      
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
      
                    // Start Date Picker
                    GestureDetector(
                      onTap: () => _selectDate(context, true),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          startDate == null
                              ? 'Select Start Date'
                              : 'Start Date: ${startDate!.toLocal()}'.split(' ')[0],
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ),
                    ),
      
      
                    SizedBox(width: 20),
      
                    // End Date Picker
                    GestureDetector(
                      onTap: () => _selectDate(context, false),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          endDate == null
                              ? 'Select End Date'
                              : 'End Date: ${endDate!.toLocal()}'.split(' ')[0],
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      
      
              SizedBox(height: 30),
      
              // Submit Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // Handle the booking submission logic
                    if (placeController.text.isNotEmpty &&
                        startDate != null &&
                        endDate != null) {
                      
                      
                      Navigator.push(context, MaterialPageRoute(builder: (_) => Weather(location: placeController.text)));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Predicted the weather')),
                      );
                    } else {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill all fields')),
                      );
                    }
                  },
                  child: Text(
                    'Predict',
                    style: TextStyle(color: Theme.of(context).colorScheme.background, fontSize: 18),
                  ),
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}

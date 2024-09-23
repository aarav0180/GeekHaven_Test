import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TripForm extends StatefulWidget {
  @override
  _TripFormState createState() => _TripFormState();
}

class _TripFormState extends State<TripForm> {
  PageController _pageController = PageController();
  int currentStep = 0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tripDetailsController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  DateTime? selectedDate;
  double rating = 0.0;

  @override
  void dispose() {
    _pageController.dispose();
    nameController.dispose();
    emailController.dispose();
    tripDetailsController.dispose();
    experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trip Feedback Form"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildUserDetailsPage(),
                _buildTripDetailsPage(),
                _buildTripExperiencePage(),
                _buildRatingPage(),
              ],
            ),
          ),
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentStep > 0)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentStep--;
                  _pageController.previousPage(
                      duration: Duration(milliseconds: 300), curve: Curves.ease);
                });
              },
              child: Text("Back"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ElevatedButton(
            onPressed: () {
              if (currentStep < 3) {
                setState(() {
                  currentStep++;
                  _pageController.nextPage(
                      duration: Duration(milliseconds: 300), curve: Curves.ease);
                });
              } else {
                _submitForm();
              }
            },
            child: Text(currentStep == 3 ? "Submit" : "Next"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserDetailsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormLabel('Name'),
          TextField(
            controller: nameController,
            style: TextStyle(color: Colors.white),
            decoration: _inputDecoration('Enter your name'),
          ),
          SizedBox(height: 20),
          _buildFormLabel('Email'),
          TextField(
            controller: emailController,
            style: TextStyle(color: Colors.white),
            decoration: _inputDecoration('Enter your email'),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetailsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormLabel('Trip Details'),
          TextField(
            controller: tripDetailsController,
            style: TextStyle(color: Colors.white),
            decoration: _inputDecoration('Describe your trip'),
          ),
          SizedBox(height: 20),
          _buildFormLabel('Trip Date'),
          GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.dark(),
                    child: child!,
                  );
                },
              );
              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                selectedDate == null
                    ? 'Select Date'
                    : '${selectedDate!.toLocal()}'.split(' ')[0],
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripExperiencePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormLabel('Trip Experience'),
          TextField(
            controller: experienceController,
            maxLines: 6,
            style: TextStyle(color: Colors.white),
            decoration: _inputDecoration('How was your experience?'),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildFormLabel('Rate Your Trip'),
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                this.rating = rating;
              });
            },
          ),
          SizedBox(height: 20),
          Text(
            'Your Rating: $rating',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[850],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildFormLabel(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  void _submitForm() {
    // Handle form submission logic here
    print("User Name: ${nameController.text}");
    print("User Email: ${emailController.text}");
    print("Trip Details: ${tripDetailsController.text}");
    print("Trip Date: $selectedDate");
    print("Trip Experience: ${experienceController.text}");
    print("Trip Rating: $rating");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Form Submitted Successfully!"),
    ));
  }
}

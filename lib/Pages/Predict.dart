import 'package:flutter/material.dart';
import 'package:geekhaven/Constants/constant.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class Predict extends StatefulWidget {
  const Predict({super.key});

  @override
  State<Predict> createState() => _PredictState();
}

class _PredictState extends State<Predict> {
  bool _showWeatherCard = false;
  final TextEditingController placeController = TextEditingController();
  DateTime? startDate;
  String? _selectedPlace;

  // Error dialog to handle invalid inputs
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Function to validate inputs and show the weather card
  void _validateAndShowWeather() {
    if (placeController.text.isEmpty || startDate == null) {
      _showErrorDialog("Please enter a place name and select a date.");
    } else {
      setState(() {
        _selectedPlace = placeController.text;
        _showWeatherCard = true;  // Show the weather card
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2020);
    DateTime lastDate = DateTime(2100);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate ?? initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        startDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Predicting the Weather",
          style: TextStyle(fontSize: 27),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),

              // TextField for Place Input
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

              // Start Date Picker
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    startDate == null
                        ? 'Select Date'
                        : 'Selected Date: ${startDate!.toLocal()}'.split(' ')[0],
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Predict Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _validateAndShowWeather,  // Trigger validation and weather display
                  child: Text(
                    'Predict',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Show Weather Card after prediction
              if (_showWeatherCard && _selectedPlace != null)
                WeatherCard(place: _selectedPlace!),  // Pass the place to WeatherCard
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherCard extends StatefulWidget {
  final String place;

  const WeatherCard({required this.place, Key? key}) : super(key: key);

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  final WeatherFactory _wf = WeatherFactory(API_KEY);
  List<Weather> _forecast = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  // Fetch weather and filter for unique days
  void _fetchWeather() async {
    try {
      List<Weather> weatherData = await _wf.fiveDayForecastByCityName(widget.place);

      final filteredData = <Weather>[];
      final Set<String> addedDates = {};

      for (var weather in weatherData) {
        final date = weather.date!;
        final formattedDate = DateFormat('yyyy-MM-dd').format(date); // Extract just the date (no time)

        // Only add one entry per day at midday or first occurrence
        if (!addedDates.contains(formattedDate) && date.hour == 12) {
          addedDates.add(formattedDate);
          filteredData.add(weather);
        }

        // Add first occurrence of the day if no midday entry found
        if (!addedDates.contains(formattedDate) && filteredData.length < 5) {
          addedDates.add(formattedDate);
          filteredData.add(weather);
        }
      }

      setState(() {
        _forecast = filteredData.take(5).toList(); // Limit to 5 days of forecast
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching weather: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Card(
      color: Theme.of(context).colorScheme.secondary,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.place,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _forecast.length,
              itemBuilder: (context, index) {
                final weather = _forecast[index];
                DateTime date = weather.date!;
                String day = DateFormat('EEEE').format(date); // Get the day of the week
                String temperature = weather.temperature?.celsius?.toStringAsFixed(1) ?? 'N/A';
                String description = weather.weatherDescription ?? '';
                String formattedDate = DateFormat('d.M.y').format(date); // Format the date

                return ListTile(
                  title: Text(
                    '$day , $formattedDate',
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    '$temperature °C, $description',
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: Image.network(
                    'http://openweathermap.org/img/wn/${weather.weatherIcon}@2x.png',
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}






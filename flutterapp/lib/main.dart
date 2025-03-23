import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// FastAPI endpoint
const String apiUrl = "https://linear-regression-model-6-pwok.onrender.com";  // Make sure this matches the API URL

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FeedbackScreen(),
    );
  }
}

// Feedback Screen
class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  // Send feedback to FastAPI and get prediction
  Future<void> submitFeedback() async {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        messageController.text.isNotEmpty) {
      // Collect feedback data (replace with your actual input data for prediction)
      Map<String, dynamic> inputData = {
        'itching': 1,  // Example input, replace with actual user feedback
        'skin_rash': 0, // Example input
        'nodal_skin_eruptions': 1,
        'continuous_sneezing': 0,
        'shivering': 0,
        'chills': 0,
        'joint_pain': 1,
        'stomach_pain': 0,
        'acidity': 1,
        'ulcers_on_tongue': 0
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(inputData),
      );

      if (response.statusCode == 200) {
        final prediction = json.decode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ThankYouScreen(prediction: prediction['prediction'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to get prediction from server")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/background.jpg",
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Get in touch.",
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  "We'd love to hear from you! Drop us a message.",
                  style: TextStyle(color: Colors.white54),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Your name",
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Your email",
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: messageController,
                  style: TextStyle(color: Colors.white),
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Your message",
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: submitFeedback,
                    child: Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Thank You Screen
class ThankYouScreen extends StatelessWidget {
  final String prediction;

  ThankYouScreen({required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/background.jpg",
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.pink, size: 50),
                SizedBox(height: 10),
                Text(
                  "Thank you!",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  "Your message has been received.",
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  "Prediction Result: $prediction",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Go home"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

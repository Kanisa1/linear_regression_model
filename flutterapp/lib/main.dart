import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Entry Point
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COVID-19 Severity Predictor',
      debugShowCheckedModeBanner: false,
      home: const InputScreen(),
    );
  }
}

// Screen 1: Input Form Screen
class InputScreen extends StatefulWidget {
  const InputScreen({super.key});
  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController feverController = TextEditingController();
  final TextEditingController coughController = TextEditingController();

  bool isLoading = false;

  Future<void> predictSeverity() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    // API payload
    Map<String, dynamic> data = {
      "Fever": int.parse(feverController.text),
      "Tiredness": 1,
      "Dry_Cough": int.parse(coughController.text),
      "Difficulty_in_Breathing": 1,
      "Sore_Throat": 1,
      "None_Symptom": 1,
      "Pains": 1,
      "Nasal_Congestion": 1,
      "Runny_Nose": 1,
      "Diarrhea": 1,
      "None_Experiencing": 1,
      "Age_0_9": 1,
      "Age_10_19": 1,
      "Age_20_24": 1,
      "Age_25_59": 1,
      "Age_60plus": 1,
      "Gender_Female": 1,
      "Gender_Male": 1,
      "Gender_Transgender": 1,
      "Contact_Dont_Know": 1,
      "Contact_No": 1,
      "Contact_Yes": 1
    };

    try {
      final response = await http.post(
        Uri.parse('https://linear-regression-model-9-ws06.onrender.com/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              severity: result['severity_level'],
              score: result['predicted_score'].toString(),
            ),
          ),
        );
      } else {
        _showError('Failed to get prediction');
      }
    } catch (e) {
      _showError('Error: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  void _showError(String message) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Error'),
              content: Text(message),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dark header background image
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'), // Your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
              child: Column(
                children: [
                  Text(
                      'COVID-19 Severity Predictor',
                     style: TextStyle(
                      fontSize: 25,
                      color: Colors.white, // White text color
                      fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.pink,
                        decorationThickness: 2,
                       ),

                    ),

                  const SizedBox(height: 20),
                  Text('Get instant predictions on the potential severity of COVID-19 based on your symptoms. Enter your details below to receive a personalized risk assessment and stay informed.',
                      style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text('Severity Prediction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: feverController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Fever (0 or 1)'),
                            validator: (value) => value!.isEmpty ? 'Please enter Fever value' : null,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: coughController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Dry Cough (0 or 1)'),
                            validator: (value) => value!.isEmpty ? 'Please enter Dry Cough value' : null,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: isLoading ? null : predictSeverity,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('Predict', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Screen 2: Result Screen
class ResultScreen extends StatelessWidget {
  final String severity;
  final String score;

  const ResultScreen({super.key, required this.severity, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dark header background image
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'), // Same background
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 150, left: 20, right: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Thank you!',
                      style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text('Predicted Severity Level: $severity', style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text('Severity Score: $score', style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                          child: const Text('Go Home', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

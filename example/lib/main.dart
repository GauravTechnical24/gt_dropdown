import 'package:flutter/material.dart';
import 'package:gt_dropdown/gt_dropdown.dart';

/// The main entry point of the Flutter application.
void main() {
  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

/// The state class for the `MyApp` widget.
class _MyAppState extends State<MyApp> {
  /// Key to manage the form state and perform validation.
  final _formKey = GlobalKey<FormState>();

  /// Handles form submission.
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with submission
      debugPrint('Form is valid');
    } else {
      // Form is invalid
      debugPrint('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GTDropdown Example'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              // GTDropdown Widget
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GTDropdown<String>(
                  items: const ['Option 1', 'Option 2', 'Option 3'],
                  defaultText: 'Select an option',
                  dropdownBorderRadius: BorderRadius.circular(8),
                  dropdownBorderColor: Colors.greenAccent,
                  menuBorderRadius: BorderRadius.circular(8),
                  menuBorderColor: Colors.green,
                  highlightSelectedItem: true,
                  selectedHighlightTextStyle: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  selectedItemColor: Colors.blue.shade100,
                  validator: (value) => value != null,
                  validationMessage: 'Please select an option',
                  errorBorderColor: Colors.red,
                  name: 'dropdown1', // Optional: for identification
                ),
              ),
              const SizedBox(height: 20),
              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _yearController = TextEditingController(text: '2030');
  final _countryController = TextEditingController(text: 'Rwanda');

  String? _result;
  String? _errorMessage;
  bool _isLoading = false;

  // ─── CHANGE THIS TO YOUR REAL RENDER URL ─────────────────────────────
  static const String apiBase = 'https://your-service-name.onrender.com';
  static const String predictEndpoint = '$apiBase/predict';

  Future<void> _makePrediction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _result = null;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse(predictEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Year': double.parse(_yearController.text.trim()),
          'Country': _countryController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _result = '${data['predicted_rate']}% (for ${data['country']} in ${data['year']})';
        });
      } else {
        final errBody = jsonDecode(response.body);
        setState(() {
          _errorMessage = errBody['detail'] ?? 'Server error (${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _yearController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Youth Unemployment Predictor'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Predict Youth Unemployment Rate (15-24)\nAfrican Countries',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                TextFormField(
                  controller: _yearController,
                  decoration: InputDecoration(
                    labelText: 'Year',
                    border: const OutlineInputBorder(),
                    helperText: '1990–2040',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    final y = double.tryParse(value);
                    if (y == null || y < 1990 || y > 2040) {
                      return 'Year must be 1990–2040';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _countryController,
                  decoration: InputDecoration(
                    labelText: 'Country',
                    border: const OutlineInputBorder(),
                    helperText: 'e.g. Rwanda, Kenya, Nigeria, South Africa...',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Required';
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: _isLoading ? null : _makePrediction,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : const Text('Predict'),
                ),
                const SizedBox(height: 32),

                if (_result != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[300]!),
                    ),
                    child: Text(
                      'Predicted Rate:\n$_result',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[900],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red[300]!),
                    ),
                    child: Text(
                      'Error:\n$_errorMessage',
                      style: const TextStyle(color: Colors.red[900]),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
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

  static const String apiBase = 'https://linear-regression-model-fg0z.onrender.com';
  static const String predictEndpoint = '$apiBase/predict';

  // Helper function to convert to Title Case (e.g. "rwanda" → "Rwanda")
  String _toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .toLowerCase()
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }

  Future<void> _makePrediction() async {
    if (!_formKey.currentState!.validate()) return;

    // Normalize country name to Title Case before sending
    final normalizedCountry = _toTitleCase(_countryController.text.trim());

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
          'Country': normalizedCountry,   
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _result = '${data['predicted_rate']}%';
        });
      } else {
        final errBody = jsonDecode(response.body);
        setState(() {
          _errorMessage = errBody['detail'] ?? 'Server error';
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
        title: const Text('Youth Unemployment Rate Predictor'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF0F7FF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('🌍', style: TextStyle(fontSize: 48)),
                      SizedBox(width: 12),
                      Text('🇷🇼', style: TextStyle(fontSize: 48)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Predict Youth Unemployment Rate',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1565C0)),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'in Africa & Rwanda',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Supporting job creation by 2035',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  TextFormField(
                    controller: _yearController,
                    decoration: InputDecoration(
                      labelText: 'Year',
                      prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF1565C0)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                      helperText: 'Enter a year between 1990 and 2040',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Required';
                      final y = double.tryParse(value);
                      if (y == null || y < 1990 || y > 2040) return 'Year must be 1990–2040';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _countryController,
                    decoration: InputDecoration(
                      labelText: 'Country',
                      prefixIcon: const Icon(Icons.location_on, color: Color(0xFF1565C0)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                      helperText: 'Examples: Rwanda, Kenya, Nigeria, South Africa...',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _makePrediction,
                    icon: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                          )
                        : const Icon(Icons.trending_up),
                    label: Text(
                      _isLoading ? 'Predicting...' : 'Predict Unemployment Rate',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 40),

                  if (_result != null)
                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      color: const Color(0xFFE8F5E9),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          children: [
                            const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 60),
                            const SizedBox(height: 16),
                            const Text(
                              'Predicted Rate',
                              style: TextStyle(fontSize: 18, color: Color(0xFF2E7D32)),
                            ),
                            Text(
                              _result!,
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (_errorMessage != null)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: const Color(0xFFFFEBEE),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 30),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
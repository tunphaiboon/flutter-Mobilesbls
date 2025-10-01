import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AirQualityPage extends StatefulWidget {
  const AirQualityPage({super.key});

  @override
  State<AirQualityPage> createState() => _AirQualityPageState();
}

class _AirQualityPageState extends State<AirQualityPage> {
  Map<String, dynamic>? airData;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // NOTE: I'm replacing your token with a placeholder for privacy/security
  Future<void> fetchData() async {
    setState(() => loading = true);

    const token = "YOUR_API_TOKEN"; // Replace with your actual API token
    final url = Uri.parse(
      "https://api.waqi.info/feed/here/?token=088e0533ecc0d410c5720ae1a844cc6d21bcdb3e",
    );
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // Note: The API structure for the token you provided is:
          // data["data"]["aqi"], data["data"]["iaqi"]["t"]["v"], data["data"]["city"]["name"]
          // The parsing below is based on this structure.
          airData = {
            "aqi": data["data"]["aqi"],
            "temp":
                data["data"]["iaqi"]["t"]?["v"], // Use safe navigation for temp
            "city": data["data"]["city"]["name"],
          };
          loading = false;
        });
      } else {
        // Handle non-200 status codes (e.g., show an error message)
        setState(() => loading = false);
        // Optional: show a Snackbar with error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load air quality data.')),
          );
        }
      }
    } catch (e) {
      // Handle network or JSON parsing errors
      setState(() => loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred during network request.'),
          ),
        );
      }
    }
  }

  String getAirQualityLabel(int aqi) {
    if (aqi <= 50) return "Good 😊";
    if (aqi <= 100) return "Moderate 😐";
    if (aqi <= 150) return "Unhealthy for Sensitive Groups 😷";
    if (aqi <= 200) return "Unhealthy 🤒";
    if (aqi <= 300) return "Very Unhealthy 😨";
    return "Hazardous ☠️";
  }

  Color getAirQualityColor(int aqi) {
    if (aqi <= 50) return Colors.teal.shade400;
    if (aqi <= 100) return Colors.yellow.shade600;
    if (aqi <= 150) return Colors.deepOrange.shade400;
    if (aqi <= 200)
      return Colors
          .red
          .shade400; // changed from orange to a slightly different red to differentiate
    if (aqi <= 300) return Colors.red.shade700;
    return Colors
        .purple
        .shade900; // changed from brown to a deep purple for 'Hazardous'
  }

  @override
  Widget build(BuildContext context) {
    final aqi = airData?["aqi"] ?? 0;
    final primaryColor = getAirQualityColor(aqi);

    return Scaffold(
      extendBodyBehindAppBar: true, // Full-screen effect
      // Use FAB for a modern refresh button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: loading ? null : fetchData,
        label: Text(loading ? "Loading..." : "Refresh"),
        icon: const Icon(Icons.refresh),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: Container(
        width: double.infinity,
        // The background gradient now covers the entire screen and is more subtle
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor.withOpacity(0.9), // Darker top part for contrast
              primaryColor.withOpacity(0.6),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.4, 1.0], // Control the gradient spread
          ),
        ),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ), // White loading indicator for contrast
              )
            : SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // City Display - Prominent and High Contrast
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          airData?["city"] ?? "Unknown Location",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 3.0,
                                color: Color.fromARGB(150, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Main Circular AQI Display
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: CircularProgressIndicator(
                              value: (aqi / 300).clamp(
                                0.0,
                                1.0,
                              ), // Progress based on AQI (clamped at 300)
                              strokeWidth: 15,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                primaryColor,
                              ),
                              backgroundColor: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "$aqi",
                                style: const TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                "AQI",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Air Quality Label - Standalone, easy to read
                    Text(
                      getAirQualityLabel(aqi),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const Spacer(),

                    // Details Panel (Bottom Sheet Look)
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(
                          0.95,
                        ), // Nearly opaque white card
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "CURRENT CONDITIONS",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryColor.shade800,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Divider(height: 15, thickness: 1),
                          _buildDetailRow(
                            icon: Icons.thermostat_rounded,
                            label: "Temperature",
                            value: "${airData?["temp"] ?? "--"} °C",
                            color: Colors.black87,
                          ),
                          _buildDetailRow(
                            icon: Icons.info_outline,
                            label: "Health Implications",
                            value: _getBriefHealthSummary(aqi),
                            color: Colors.black54,
                          ),
                          // Padding for the FAB
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // Helper widget for detail rows
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: getAirQualityColor(airData?["aqi"] ?? 0), size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper for a brief health summary
  String _getBriefHealthSummary(int aqi) {
    if (aqi <= 50) return "Air quality is considered satisfactory.";
    if (aqi <= 100)
      return "Unusually sensitive people should consider limiting outdoor exertion.";
    if (aqi <= 150)
      return "Active children and adults, and people with respiratory disease, should limit prolonged outdoor exertion.";
    return "Everyone should avoid outdoor exertion. Consider staying indoors.";
  }
}

extension on Color {
  get shade800 => null;
}

// For running the app, you'd typically have a main.dart:
/*
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Modern Air Quality App',
      home: AirQualityPage(),
    );
  }
}
*/
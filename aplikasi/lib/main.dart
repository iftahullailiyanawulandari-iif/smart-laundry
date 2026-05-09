import 'package:flutter/material.dart';

void main() {
  runApp(const SmartLaundryApp());
}

// Data Models
class OrderItem {
  final String id;
  final DateTime date;
  final String status; // 'Dicuci', 'Dijemur', 'Siap Ambil', 'Selesai'
  final int step; // 1: Dicuci, 2: Dijemur, 3: Siap Ambil, 4: Selesai
  final double weight;
  final double price;
  final String type; // Kiloan / Satuan
  final String serviceType; // Cucian Biasa, dsb.

  OrderItem({
    required this.id,
    required this.date,
    required this.status,
    required this.step,
    required this.weight,
    required this.price,
    required this.type,
    required this.serviceType,
  });
}

class SmartLaundryApp extends StatelessWidget {
  const SmartLaundryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Laundry Hub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5), // Blue theme
          primary: const Color(0xFF1E88E5),
          background: const Color(0xFFF8F9FA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        useMaterial3: true,
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ---------------------------------------------------------
// SPLASH SCREEN (Tampilan Awal)
// ---------------------------------------------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E88E5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_laundry_service, size: 80, color: Color(0xFF1E88E5)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Smart Laundry Hub',
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kelola Cucian Lebih Mudah',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

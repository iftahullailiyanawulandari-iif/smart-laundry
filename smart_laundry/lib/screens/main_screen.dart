import 'package:flutter/material.dart';
import '../models/order_item.dart';
import '../tabs/home_tab.dart';
import '../tabs/tracking_tab.dart';
import '../tabs/calculator_tab.dart';
import '../tabs/history_tab.dart';
import '../tabs/maps_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  // State Data Dinamis
  List<OrderItem> orders = [];
  int orderCounter = 1;

  void addOrder(OrderItem order) {
    setState(() {
      orders.insert(0, order);
      orderCounter++;
    });
    // Pindah ke tab tracking setelah pesan
    setState(() {
      _currentIndex = 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order berhasil ditambahkan!')),
    );
  }

  void completeOrder(String id) {
    setState(() {
      final index = orders.indexWhere((o) => o.id == id);
      if (index != -1) {
        var old = orders[index];
        orders[index] = OrderItem(
          id: old.id,
          date: old.date,
          status: 'Selesai',
          step: 4,
          weight: old.weight,
          price: old.price,
          type: old.type,
          serviceType: old.serviceType,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeTab(
        activeOrdersCount: orders.where((o) => o.step < 4).length,
        totalOrdersCount: orders.length,
        totalExpense: orders.fold(0, (sum, item) => sum + item.price),
        latestOrder: orders.isNotEmpty ? orders.first : null,
        onAddOrderTap: () => setState(() => _currentIndex = 2), // Go to Calculator
      ),
      TrackingTab(
        orders: orders,
        onComplete: completeOrder,
      ),
      CalculatorTab(
        orderCounter: orderCounter,
        onSave: addOrder,
      ),
      HistoryTab(
        orders: orders.where((o) => o.step == 4).toList(),
      ),
      const MapsTab(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: const Color(0xFF1E88E5),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search), label: 'Tracking'),
            BottomNavigationBarItem(icon: Icon(Icons.calculate_outlined), activeIcon: Icon(Icons.calculate), label: 'Kalkulator'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Riwayat'),
            BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), activeIcon: Icon(Icons.location_on), label: 'Maps'),
          ],
        ),
      ),
    );
  }
}

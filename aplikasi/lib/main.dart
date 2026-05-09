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
// ---------------------------------------------------------
// MAIN SCREEN (State Holder)
// ---------------------------------------------------------
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
    final List<Widget> _pages = [
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
      body: _pages[_currentIndex],
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

// ---------------------------------------------------------
// 1. HOME TAB
// ---------------------------------------------------------
class HomeTab extends StatelessWidget {
  final int activeOrdersCount;
  final int totalOrdersCount;
  final double totalExpense;
  final OrderItem? latestOrder;
  final VoidCallback onAddOrderTap;

  const HomeTab({
    super.key,
    required this.activeOrdersCount,
    required this.totalOrdersCount,
    required this.totalExpense,
    this.latestOrder,
    required this.onAddOrderTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Blue Header Section
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 60),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E88E5),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Smart\nLaundry Hub',
                              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 1.2),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Kelola cucian jadi lebih mudah\ncepat & praktis',
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      // Notification Bell
                      Container(
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                        child: IconButton(
                          icon: const Badge(
                            label: Text('0'),
                            backgroundColor: Colors.red,
                            child: Icon(Icons.notifications_none, color: Colors.white),
                          ),
                          onPressed: () {
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak ada notifikasi baru.')));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Overlapping Card
                Positioned(
                  bottom: -30,
                  left: 24,
                  right: 24,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.local_laundry_service, color: Color(0xFF1E88E5), size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Cucian Aktif', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('$activeOrdersCount pesanan sedang diproses', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            
            // Content Below Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tambah Order Baru Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onAddOrderTap,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Tambah Order Baru', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Ringkasan Bulan Ini
                  const Text('Ringkasan Keseluruhan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          title: 'Total Pengeluaran',
                          value: 'Rp ${totalExpense.toStringAsFixed(0)}',
                          subtitle: 'Data berdasarkan histori',
                          subtitleColor: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          title: 'Total Cucian',
                          value: '${totalOrdersCount}x',
                          subtitle: 'Data keseluruhan',
                          subtitleColor: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Status Terakhir
                  const Text('Status Terakhir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  latestOrder == null 
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: const Center(
                          child: Text('Belum ada transaksi', style: TextStyle(color: Colors.grey)),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(latestOrder!.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text('${latestOrder!.date.day}/${latestOrder!.date.month}/${latestOrder!.date.year} ${latestOrder!.date.hour}:${latestOrder!.date.minute}', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: (latestOrder!.step == 4 ? Colors.green : Colors.blue).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                              child: Text(latestOrder!.status, style: TextStyle(color: latestOrder!.step == 4 ? Colors.green : Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({required String title, required String value, required String subtitle, required Color subtitleColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(color: subtitleColor, fontSize: 10, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// 2. TRACKING TAB
// ---------------------------------------------------------
class TrackingTab extends StatefulWidget {
  final List<OrderItem> orders;
  final Function(String) onComplete;

  const TrackingTab({super.key, required this.orders, required this.onComplete});

  @override
  State<TrackingTab> createState() => _TrackingTabState();
}

class _TrackingTabState extends State<TrackingTab> {
  String selectedFilter = 'Semua';

  @override
  Widget build(BuildContext context) {
    List<OrderItem> filteredOrders = widget.orders.where((o) {
      if (selectedFilter == 'Aktif') return o.step < 4;
      if (selectedFilter == 'Selesai') return o.step == 4;
      return true; // Semua
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Tracking Cucian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list), 
            onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filter tambahan belum tersedia')));
            }
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Expanded(child: _buildTabButton('Semua', selectedFilter == 'Semua')),
                Expanded(child: _buildTabButton('Aktif', selectedFilter == 'Aktif')),
                Expanded(child: _buildTabButton('Selesai', selectedFilter == 'Selesai')),
              ],
            ),
          ),
          Expanded(
            child: filteredOrders.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final o = filteredOrders[index];
                    Color statusColor = o.step == 4 ? Colors.green : (o.step == 3 ? Colors.orange : Colors.blue);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildTrackingCard(
                        orderId: o.id,
                        date: '${o.date.day}/${o.date.month}/${o.date.year} ${o.date.hour}:${o.date.minute}',
                        status: o.status,
                        statusColor: statusColor,
                        step: o.step,
                        iconColor: statusColor,
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('Belum ada pesanan', style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Data pesanan akan muncul di sini', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = title),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E88E5) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTrackingCard({
    required String orderId,
    required String date,
    required String status,
    required Color statusColor,
    required int step,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.shopping_basket_outlined, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTimeline(step),
          if (step < 4) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => widget.onComplete(orderId),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green,
                  side: const BorderSide(color: Colors.green),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                ),
                child: const Text('Tandai Selesai'),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildTimeline(int step) {
    return Row(
      children: [
        _buildTimelineStep('Dicuci', step >= 1),
        _buildTimelineDivider(step >= 2),
        _buildTimelineStep('Dijemur', step >= 2),
        _buildTimelineDivider(step >= 3),
        _buildTimelineStep('Siap Ambil', step >= 3),
      ],
    );
  }

  Widget _buildTimelineStep(String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1E88E5) : Colors.grey[300],
            shape: BoxShape.circle,
            border: isActive ? Border.all(color: Colors.white, width: 2) : null,
            boxShadow: isActive ? [BoxShadow(color: const Color(0xFF1E88E5).withOpacity(0.4), blurRadius: 4)] : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: isActive ? Colors.black87 : Colors.grey, fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildTimelineDivider(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: isActive ? const Color(0xFF1E88E5) : Colors.grey[300],
      ),
    );
  }
}

// ---------------------------------------------------------
// 3. CALCULATOR TAB
// ---------------------------------------------------------
class CalculatorTab extends StatefulWidget {
  final int orderCounter;
  final Function(OrderItem) onSave;

  const CalculatorTab({super.key, required this.orderCounter, required this.onSave});

  @override
  State<CalculatorTab> createState() => _CalculatorTabState();
}

class _CalculatorTabState extends State<CalculatorTab> {
  double weight = 3.0;
  String type = 'Kiloan';
  String serviceType = 'Cucian Biasa';

  @override
  Widget build(BuildContext context) {
    double pricePerUnit = type == 'Kiloan' ? 7000 : 15000;
    double totalPrice = weight * pricePerUnit;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Kalkulator & Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Jenis Layanan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => type = 'Kiloan'),
                    icon: Icon(Icons.scale, color: type == 'Kiloan' ? Colors.white : Colors.grey),
                    label: Text('Kiloan', style: TextStyle(color: type == 'Kiloan' ? Colors.white : Colors.black87)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: type == 'Kiloan' ? const Color(0xFF1E88E5) : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: type == 'Kiloan' ? Colors.transparent : Colors.grey[300]!),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => type = 'Satuan'),
                    icon: Icon(Icons.checkroom, color: type == 'Satuan' ? Colors.white : Colors.grey),
                    label: Text('Satuan', style: TextStyle(color: type == 'Satuan' ? Colors.white : Colors.black87)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: type == 'Satuan' ? const Color(0xFF1E88E5) : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: type == 'Satuan' ? Colors.transparent : Colors.grey[300]!),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            Text(type == 'Kiloan' ? 'Berat Cucian' : 'Jumlah Pakaian', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (weight > 1) setState(() => weight--);
                    },
                  ),
                  Row(
                    children: [
                      Text(weight.toStringAsFixed(0), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text(type == 'Kiloan' ? 'kg' : 'pcs', style: const TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() => weight++),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Jenis Cucian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: serviceType,
                  isExpanded: true,
                  items: ['Cucian Biasa', 'Cuci Kering', 'Setrika Saja', 'Express 24 Jam'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if(newValue != null) {
                      setState(() {
                        serviceType = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text('Total Harga', style: TextStyle(color: Color(0xFF1E88E5), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Rp ${totalPrice.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFF1E88E5), fontSize: 32, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final order = OrderItem(
                    id: 'Order #${widget.orderCounter.toString().padLeft(3, '0')}',
                    date: DateTime.now(),
                    status: 'Dicuci',
                    step: 1,
                    weight: weight,
                    price: totalPrice,
                    type: type,
                    serviceType: serviceType,
                  );
                  widget.onSave(order);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Simpan Order', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// 4. HISTORY TAB
// ---------------------------------------------------------
class HistoryTab extends StatelessWidget {
  final List<OrderItem> orders;

  const HistoryTab({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    double totalPengeluaran = orders.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Riwayat Transaksi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.calendar_today, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Semua Waktu', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Pengeluaran', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text('Rp ${totalPengeluaran.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFF1E88E5), fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                // Simple placeholder for chart
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBar(20),
                    _buildBar(40),
                    _buildBar(30),
                    _buildBar(50),
                    _buildBar(10),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (orders.isEmpty)
             const Center(
               child: Padding(
                 padding: EdgeInsets.only(top: 40),
                 child: Text('Belum ada riwayat transaksi.', style: TextStyle(color: Colors.grey)),
               ),
             )
          else
            ...orders.map((o) => Column(
              children: [
                _buildHistoryItem(
                  '${o.date.day}/${o.date.month}/${o.date.year}', 
                  o.id, 
                  '${o.weight.toStringAsFixed(0)} ${o.type == 'Kiloan' ? 'kg' : 'pcs'}', 
                  'Rp ${o.price.toStringAsFixed(0)}'
                ),
                const Divider(),
              ],
            )).toList(),
        ],
      ),
    );
  }

  Widget _buildBar(double height) {
    return Container(
      width: 8,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF1E88E5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildHistoryItem(String date, String orderId, String weight, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(orderId, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Text(weight, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// 5. MAPS TAB
// ---------------------------------------------------------
class MapsTab extends StatelessWidget {
  const MapsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Lokasi Laundry', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Cari cabang laundry',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          // Mock Map Area
          Container(
            height: 250,
            width: double.infinity,
            color: Colors.grey[300], // Mock Map background
            child: Stack(
              children: [
                Positioned(top: 50, left: 100, child: InkWell(onTap: () => _showLocationInfo(context, 'Cabang A'), child: const Icon(Icons.location_on, color: Color(0xFF1E88E5), size: 40))),
                Positioned(top: 150, left: 200, child: InkWell(onTap: () => _showLocationInfo(context, 'Cabang B'), child: const Icon(Icons.location_on, color: Color(0xFF1E88E5), size: 40))),
                Positioned(top: 100, left: 250, child: InkWell(onTap: () => _showLocationInfo(context, 'Cabang C'), child: const Icon(Icons.location_on, color: Color(0xFF1E88E5), size: 40))),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.white,
                    onPressed: () {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lokasi Anda ditemukan')));
                    },
                    child: const Icon(Icons.my_location, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildBranchCard(context, 'Laundry Cabang A', 'Jl. Merdeka No. 10, Kota Anda', 'Buka', '07.00 - 21.00', '500 m', true),
                const SizedBox(height: 12),
                _buildBranchCard(context, 'Laundry Cabang B', 'Jl. Sudirman No. 45, Kota Anda', 'Buka', '07.00 - 21.00', '1.2 km', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationInfo(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Menampilkan lokasi: $name')));
  }

  Widget _buildBranchCard(BuildContext context, String name, String address, String status, String hours, String distance, bool isNearest) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(distance, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(address, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(status, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(width: 8),
                    Text('• $hours', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Membuka rute ke $name...')));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E88E5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size.zero,
            ),
            child: const Text('Rute', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

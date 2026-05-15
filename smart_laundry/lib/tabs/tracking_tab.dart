import 'package:flutter/material.dart';
import '../models/order_item.dart';

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

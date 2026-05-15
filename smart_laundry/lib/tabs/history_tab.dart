import 'package:flutter/material.dart';
import '../models/order_item.dart';

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

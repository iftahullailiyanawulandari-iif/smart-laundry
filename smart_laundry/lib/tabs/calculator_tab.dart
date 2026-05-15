import 'package:flutter/material.dart';
import '../models/order_item.dart';

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

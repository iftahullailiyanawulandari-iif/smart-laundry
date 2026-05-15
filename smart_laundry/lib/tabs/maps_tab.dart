import 'package:flutter/material.dart';

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

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

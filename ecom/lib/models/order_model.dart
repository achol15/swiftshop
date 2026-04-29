import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:flutter_ecommerce_firebase/models/cart_item_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final DateTime timestamp;
  final String status;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.timestamp,
    required this.status,
  });

  factory OrderModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return OrderModel(
      id: docId,
      userId: data['userId'] ?? '',
      items: List<Map<String, dynamic>>.from(data['items'] ?? []),
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      status: data['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items,
      'totalAmount': totalAmount,
      'timestamp': FieldValue.serverTimestamp(),
      'status': status,
    };
  }
}

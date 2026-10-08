import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final IconData icon;
  final Color iconColor;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.icon,
    required this.iconColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final cat = json['category'] as String? ?? 'Otros';
    return TransactionModel(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      category: cat,
      date: DateTime.parse(json['date']),
      icon: _getIconForCategory(cat),
      iconColor: _getColorForCategory(cat),
    );
  }

  static IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Comida': return LucideIcons.coffee;
      case 'Transporte': return LucideIcons.bus;
      case 'Entretenimiento': return LucideIcons.tv;
      case 'Servicios': return LucideIcons.zap;
      case 'Salario': return LucideIcons.wallet;
      case 'Inversiones': return LucideIcons.trendingUp;
      case 'Ventas': return LucideIcons.shoppingBag;
      case 'Regalos': return LucideIcons.gift;
      default: return LucideIcons.circle;
    }
  }

  static Color _getColorForCategory(String category) {
    switch (category) {
      case 'Comida': return Colors.orange;
      case 'Transporte': return Colors.blue;
      case 'Entretenimiento': return Colors.purple;
      case 'Servicios': return Colors.yellow;
      case 'Salario': return Colors.green;
      case 'Inversiones': return Colors.teal;
      case 'Ventas': return Colors.indigo;
      case 'Regalos': return Colors.pink;
      default: return Colors.grey;
    }
  }
}

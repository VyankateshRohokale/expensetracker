import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final String name;
  final double amount;
  final DateTime date;
  final String? category;
  final String? invoiceUrl; // Optional URL for an invoice image

  const Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    this.category,
    this.invoiceUrl,
  });

  // Factory constructor to create an Expense from a map (e.g., from JSON/database)
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      category: json['category'] as String?,
      invoiceUrl: json['invoiceUrl'] as String?,
    );
  }

  // Method to convert an Expense to a map (e.g., for JSON/database storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(), // Store date as ISO 8601 string
      'category': category,
      'invoiceUrl': invoiceUrl,
    };
  }

  // copyWith method for immutability
  Expense copyWith({
    String? id,
    String? name,
    double? amount,
    DateTime? date,
    String? category,
    String? invoiceUrl,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      invoiceUrl: invoiceUrl ?? this.invoiceUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, amount, date, category, invoiceUrl];
}
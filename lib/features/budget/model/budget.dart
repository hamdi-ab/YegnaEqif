class Budget {
  final String id;
  final String category;
  final double allocatedAmount;
  final double spentAmount;
  final DateTime startDate;
  final DateTime endDate;

  Budget({
    required this.id,
    required this.category,
    required this.allocatedAmount,
    required this.spentAmount,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'allocatedAmount': allocatedAmount,
      'spentAmount': spentAmount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  static Budget fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'] ?? '',
      category: map['category'] ?? '',
      allocatedAmount: (map['allocatedAmount'] ?? 0).toDouble(),
      spentAmount: (map['spentAmount'] ?? 0).toDouble(),
      startDate:
          DateTime.parse(map['startDate'] ?? DateTime.now().toIso8601String()),
      endDate:
          DateTime.parse(map['endDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  Budget copyWith({
    String? id,
    String? category,
    double? allocatedAmount,
    double? spentAmount,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class Budget {
  final String id; // Unique ID for the budget
  final String category; // Unique ID for the category
  final double allocatedAmount; // Planned budget amount
  final double spentAmount; // Total spent from this budget
  final DateTime startDate; // Budget start date
  final DateTime endDate; // Budget end date

  Budget({
    required this.id,
    required this.category, // Changed to categoryId
    required this.allocatedAmount,
    this.spentAmount = 0.0,
    required this.startDate,
    required this.endDate,
  });

  factory Budget.fromMap(Map<String, dynamic> data) {
    return Budget(
        id: data['id'],
        category: data['category'],
        allocatedAmount: data['allocatedAmount'],
        spentAmount: data['spentAmount'],
        startDate: DateTime.parse(data['startDate']),
        endDate: DateTime.parse(data['endDate']));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'allocatedAmount': allocatedAmount,
      'spentAmount': spentAmount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String()
    };
  }

  Budget copyWith({
    String? id,
    String? category,
    double? amount,
    double? spentAmount,
    DateTime? startDate,
    DateTime? endDate
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      allocatedAmount: amount ?? this.allocatedAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

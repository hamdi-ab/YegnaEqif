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
}
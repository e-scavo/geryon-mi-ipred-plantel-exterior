class OutsidePlantPullCycleResult {
  final int fetchedCount;
  final int insertedCount;
  final int updatedCount;
  final int skippedCount;
  final List<String> errors;

  const OutsidePlantPullCycleResult({
    required this.fetchedCount,
    required this.insertedCount,
    required this.updatedCount,
    required this.skippedCount,
    required this.errors,
  });
}

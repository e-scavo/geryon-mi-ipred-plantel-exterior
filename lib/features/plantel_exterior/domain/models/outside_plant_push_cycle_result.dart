class OutsidePlantPushCycleResult {
  final int processedCount;
  final int successCount;
  final int errorCount;
  final int skippedCount;
  final List<String> errors;

  const OutsidePlantPushCycleResult({
    required this.processedCount,
    required this.successCount,
    required this.errorCount,
    required this.skippedCount,
    required this.errors,
  });

  bool get hasErrors => errors.isNotEmpty;
}

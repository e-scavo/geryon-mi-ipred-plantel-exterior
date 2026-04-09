class OutsidePlantRemotePushResult {
  final bool success;
  final String message;

  const OutsidePlantRemotePushResult({
    required this.success,
    required this.message,
  });

  factory OutsidePlantRemotePushResult.success([String message = 'OK']) {
    return OutsidePlantRemotePushResult(success: true, message: message);
  }

  factory OutsidePlantRemotePushResult.failure(String message) {
    return OutsidePlantRemotePushResult(success: false, message: message);
  }
}

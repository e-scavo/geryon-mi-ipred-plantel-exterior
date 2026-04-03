class OutsidePlantId {
  final String value;

  const OutsidePlantId(this.value);

  bool get isEmpty => value.trim().isEmpty;

  bool get isNotEmpty => !isEmpty;

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is OutsidePlantId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

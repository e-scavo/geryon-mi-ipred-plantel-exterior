class OutsidePlantSearchFilters {
  final String query;
  final String? operationalStatus;
  final int? criticality;
  final String? syncStatus;

  const OutsidePlantSearchFilters({
    this.query = '',
    this.operationalStatus,
    this.criticality,
    this.syncStatus,
  });

  static const empty = OutsidePlantSearchFilters();

  bool get hasActiveFilters {
    return query.trim().isNotEmpty ||
        operationalStatus != null ||
        criticality != null ||
        syncStatus != null;
  }

  OutsidePlantSearchFilters copyWith({
    String? query,
    Object? operationalStatus = _undefined,
    Object? criticality = _undefined,
    Object? syncStatus = _undefined,
  }) {
    return OutsidePlantSearchFilters(
      query: query ?? this.query,
      operationalStatus: identical(operationalStatus, _undefined)
          ? this.operationalStatus
          : operationalStatus as String?,
      criticality: identical(criticality, _undefined)
          ? this.criticality
          : criticality as int?,
      syncStatus: identical(syncStatus, _undefined)
          ? this.syncStatus
          : syncStatus as String?,
    );
  }

  OutsidePlantSearchFilters clear() => empty;

  static const Object _undefined = Object();
}

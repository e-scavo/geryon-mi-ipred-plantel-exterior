import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/models/outside_plant_pull_cycle_result.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/domain/models/outside_plant_push_cycle_result.dart';

class OutsidePlantSyncUiState {
  final bool isPushRunning;
  final bool isPullRunning;
  final String? lastPushSummary;
  final String? lastPullSummary;
  final String? lastErrorMessage;

  const OutsidePlantSyncUiState({
    this.isPushRunning = false,
    this.isPullRunning = false,
    this.lastPushSummary,
    this.lastPullSummary,
    this.lastErrorMessage,
  });

  bool get isBusy => isPushRunning || isPullRunning;

  OutsidePlantSyncUiState copyWith({
    bool? isPushRunning,
    bool? isPullRunning,
    String? lastPushSummary,
    bool clearLastPushSummary = false,
    String? lastPullSummary,
    bool clearLastPullSummary = false,
    String? lastErrorMessage,
    bool clearLastErrorMessage = false,
  }) {
    return OutsidePlantSyncUiState(
      isPushRunning: isPushRunning ?? this.isPushRunning,
      isPullRunning: isPullRunning ?? this.isPullRunning,
      lastPushSummary: clearLastPushSummary
          ? null
          : (lastPushSummary ?? this.lastPushSummary),
      lastPullSummary: clearLastPullSummary
          ? null
          : (lastPullSummary ?? this.lastPullSummary),
      lastErrorMessage: clearLastErrorMessage
          ? null
          : (lastErrorMessage ?? this.lastErrorMessage),
    );
  }
}

class OutsidePlantSyncUiNotifier
    extends StateNotifier<OutsidePlantSyncUiState> {
  OutsidePlantSyncUiNotifier() : super(const OutsidePlantSyncUiState());

  void clearTransientMessages() {
    state = state.copyWith(
      clearLastPushSummary: true,
      clearLastPullSummary: true,
      clearLastErrorMessage: true,
    );
  }

  bool startPush() {
    if (state.isBusy) {
      return false;
    }

    state = state.copyWith(
      isPushRunning: true,
      isPullRunning: false,
      clearLastErrorMessage: true,
    );
    return true;
  }

  void completePush(OutsidePlantPushCycleResult result) {
    state = state.copyWith(
      isPushRunning: false,
      isPullRunning: false,
      lastPushSummary:
          'Push ejecutado. Procesados: ${result.processedCount} | OK: ${result.successCount} | Error: ${result.errorCount}',
      lastErrorMessage:
          result.errors.isNotEmpty ? result.errors.join(' | ') : null,
      clearLastErrorMessage: result.errors.isEmpty,
    );
  }

  void failPush(Object error) {
    state = state.copyWith(
      isPushRunning: false,
      isPullRunning: false,
      lastErrorMessage: 'Push falló. ${error.toString()}',
    );
  }

  bool startPull() {
    if (state.isBusy) {
      return false;
    }

    state = state.copyWith(
      isPullRunning: true,
      isPushRunning: false,
      clearLastErrorMessage: true,
    );
    return true;
  }

  void completePull(OutsidePlantPullCycleResult result) {
    state = state.copyWith(
      isPullRunning: false,
      isPushRunning: false,
      lastPullSummary:
          'Pull ejecutado. Remotos: ${result.fetchedCount} | Insertados: ${result.insertedCount} | Actualizados: ${result.updatedCount} | Omitidos: ${result.skippedCount}',
      lastErrorMessage:
          result.errors.isNotEmpty ? result.errors.join(' | ') : null,
      clearLastErrorMessage: result.errors.isEmpty,
    );
  }

  void failPull(Object error) {
    state = state.copyWith(
      isPullRunning: false,
      isPushRunning: false,
      lastErrorMessage: 'Pull falló. ${error.toString()}',
    );
  }
}

final outsidePlantSyncUiProvider =
    StateNotifierProvider<OutsidePlantSyncUiNotifier, OutsidePlantSyncUiState>(
        (ref) {
  return OutsidePlantSyncUiNotifier();
});

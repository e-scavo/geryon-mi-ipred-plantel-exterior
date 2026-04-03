import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/common_vars.dart';
import 'package:mi_ipred_plantel_exterior/core/session/session_storage.dart';
import 'package:mi_ipred_plantel_exterior/features/billing/controllers/billing_controller.dart';

class ApplicationCoordinator {
  static bool shouldBootstrapBilling({
    required BillingFeatureState state,
    required int? currentClientIndex,
  }) {
    return state.trackedClientIndex == null && currentClientIndex != null;
  }

  static bool shouldReloadBillingForActiveClientChange({
    required BillingFeatureState state,
    required int? currentClientIndex,
  }) {
    return state.trackedClientIndex != null &&
        state.trackedClientIndex != currentClientIndex;
  }

  static Future<void> performLogoutReset({
    required WidgetRef ref,
  }) async {
    await SessionStorage.removeSavedDni();
    ref.read(notifierServiceProvider).logout();
  }
}

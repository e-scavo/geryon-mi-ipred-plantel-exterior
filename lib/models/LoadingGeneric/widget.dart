import 'package:flutter/material.dart';
import 'package:mi_ipred_plantel_exterior/shared/widgets/feature_loading_state.dart';

class LoadingGeneric extends StatelessWidget {
  final String loadingText;

  const LoadingGeneric({
    super.key,
    this.loadingText = 'Cargando...',
  });

  @override
  Widget build(BuildContext context) {
    return FeatureLoadingState(
      title: loadingText,
    );
  }
}

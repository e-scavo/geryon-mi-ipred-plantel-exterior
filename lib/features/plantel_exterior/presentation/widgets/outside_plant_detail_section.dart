import 'package:flutter/material.dart';

class OutsidePlantDetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const OutsidePlantDetailSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

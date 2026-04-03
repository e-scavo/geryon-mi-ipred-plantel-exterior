import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_ipred_plantel_exterior/features/contracts/application_coordinator.dart';
import 'package:mi_ipred_plantel_exterior/features/plantel_exterior/presentation/providers/plantel_navigation_provider.dart';

class PlantelExteriorDrawer extends ConsumerWidget {
  const PlantelExteriorDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSection = ref.watch(plantelExteriorNavigationProvider);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.device_hub,
                    size: 36,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Mi IP·RED\nPlantel Exterior',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _DrawerItem(
              title: 'Inicio',
              icon: Icons.home_outlined,
              selected: currentSection == PlantelExteriorSection.home,
              onTap: () {
                ref.read(plantelExteriorNavigationProvider.notifier).state =
                    PlantelExteriorSection.home;
                Navigator.of(context).pop();
              },
            ),
            _DrawerItem(
              title: 'Cajas PON / ONT',
              icon: Icons.settings_input_component_outlined,
              selected: currentSection == PlantelExteriorSection.cajasPonOnt,
              onTap: () {
                ref.read(plantelExteriorNavigationProvider.notifier).state =
                    PlantelExteriorSection.cajasPonOnt;
                Navigator.of(context).pop();
              },
            ),
            _DrawerItem(
              title: 'Botellas de Empalme',
              icon: Icons.hub_outlined,
              selected:
                  currentSection == PlantelExteriorSection.botellasEmpalme,
              onTap: () {
                ref.read(plantelExteriorNavigationProvider.notifier).state =
                    PlantelExteriorSection.botellasEmpalme;
                Navigator.of(context).pop();
              },
            ),
            const Spacer(),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                Navigator.of(context).pop();
                await ApplicationCoordinator.performLogoutReset(ref: ref);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: selected,
      onTap: onTap,
    );
  }
}

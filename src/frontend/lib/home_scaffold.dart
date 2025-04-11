import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum Breakpoint {
  mobile(maxWidth: 600),
  tablet(maxWidth: 1200),
  desktop(maxWidth: double.infinity);

  const Breakpoint({required this.maxWidth});

  final double maxWidth;

  static Breakpoint fromWidth(double width) {
    if (width <= mobile.maxWidth) {
      return mobile;
    } else if (width <= tablet.maxWidth) {
      return tablet;
    } else {
      return desktop;
    }
  }
}

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  static const _navigationItems = <({IconData icon, String label})>[
    (
      icon: Icons.home,
      label: 'Home',
    ),
    (
      icon: Icons.people,
      label: 'Patienten',
    ),
    (
      icon: Icons.document_scanner,
      label: 'Rezepte',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return switch (Breakpoint.fromWidth(width)) {
      Breakpoint.mobile => Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            destinations: [
              for (final item in _navigationItems)
                NavigationDestination(
                  icon: Icon(item.icon),
                  label: item.label,
                ),
            ],
            onDestinationSelected: _goBranch,
          ),
        ),
      Breakpoint.tablet => Scaffold(
          body: Row(
            children: [
              NavigationRail(
                onDestinationSelected: _goBranch,
                selectedIndex: navigationShell.currentIndex,
                labelType: NavigationRailLabelType.all,
                destinations: [
                  for (final item in _navigationItems)
                    NavigationRailDestination(
                      label: Text(item.label),
                      icon: Icon(item.icon),
                    ),
                ],
              ),
              Expanded(child: navigationShell),
            ],
          ),
        ),
      Breakpoint.desktop => Scaffold(
          body: Row(
            children: [
              NavigationDrawer(
                onDestinationSelected: _goBranch,
                selectedIndex: navigationShell.currentIndex,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 16, 16, 10),
                    child: Text('Physio.ai', style: Theme.of(context).textTheme.titleSmall),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  for (final item in _navigationItems)
                    NavigationDrawerDestination(
                      label: Text(item.label),
                      icon: Icon(item.icon),
                    ),
                  const Padding(padding: EdgeInsets.fromLTRB(28, 16, 28, 10), child: Divider()),
                ],
              ),
              Expanded(child: navigationShell),
            ],
          ),
        ),
    };
  }

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

import 'package:flutter/material.dart' hide NavigationDrawer, NavigationDrawerDestination;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:physio_ai/profile/infrastructure/profile_repository.dart';
import 'package:physio_ai/shared_kernel/presentation/navigation_drawer.dart';

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

  bool isDesktop() {
    return this == Breakpoint.desktop;
  }
}

final profilePictureUrlProvider = FutureProvider((ref) {
  return ref.watch(profileProvider.selectAsync((value) => value.profilePictureUrl));
});

final profileButtonTextProvider = FutureProvider<({String inhaberName, String praxisName})>((ref) {
  return ref.watch(
    profileProvider.selectAsync(
      (value) => (inhaberName: value.inhaberName, praxisName: value.praxisName),
    ),
  );
});

final profileInhaberNameProvider = FutureProvider((ref) {
  return ref.watch(profileProvider.selectAsync((value) => value.inhaberName));
});

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
      icon: Icons.medical_services,
      label: 'Behandlungen',
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
          destinations: <Widget>[
            for (final item in _navigationItems)
              NavigationDestination(
                icon: Icon(item.icon),
                label: item.label,
              ),
            const NavigationDestination(
              icon: _ProfileIcon(),
              label: 'Profile',
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
                const NavigationRailDestination(
                  icon: _ProfileIcon(),
                  label: Text('Profil'),
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
            FocusTraversalGroup(
              child: NavigationDrawer(
                onDestinationSelected: _goBranch,
                selectedIndex: navigationShell.currentIndex,
                padding: const EdgeInsets.all(12),
                header: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: Text('Physio.ai', style: Theme.of(context).textTheme.titleSmall),
                ),
                footer: const NavigationDrawerDestination(
                  label: _ProfileLabel(),
                  icon: _ProfileIcon(),
                ),
                children: <Widget>[
                  for (final item in _navigationItems)
                    NavigationDrawerDestination(
                      label: Text(item.label),
                      icon: Icon(item.icon),
                    ),
                ],
              ),
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

class _ProfileIcon extends ConsumerWidget {
  const _ProfileIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfilePictureUrl = ref.watch(profilePictureUrlProvider);

    return asyncProfilePictureUrl.maybeWhen(
      data: (profilePictureUrl) => profilePictureUrl != null
          ? CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(profilePictureUrl),
            )
          : const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.account_circle),
            ),
      orElse: () => const CircleAvatar(
        child: Icon(Icons.account_circle),
      ),
    );
  }
}

class _ProfileLabel extends ConsumerWidget {
  const _ProfileLabel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfileButtonText = ref.watch(profileButtonTextProvider);

    if (!asyncProfileButtonText.hasValue) {
      return const Text('Profil');
    }

    final data = asyncProfileButtonText.value!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.inhaberName,
        ),
        Text(
          data.praxisName,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

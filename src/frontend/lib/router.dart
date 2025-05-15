import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:physio_ai/home_scaffold.dart';
import 'package:physio_ai/patienten/presentation/create_patient_page.dart';
import 'package:physio_ai/patienten/presentation/patient_detail_page.dart';
import 'package:physio_ai/patienten/presentation/patienten_page.dart';
import 'package:physio_ai/rezepte/home_page.dart';
import 'package:physio_ai/rezepte/presentation/create_rezept_page.dart';
import 'package:physio_ai/rezepte/presentation/rezept_detail_page.dart';
import 'package:physio_ai/rezepte/presentation/upload_rezept_page.dart';
import 'package:physio_ai/rezepte/rezepte_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<StatefulNavigationShellState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorPatientenKey = GlobalKey<NavigatorState>(debugLabel: 'shellPatienten');
final _shellNavigatorRezepteKey = GlobalKey<NavigatorState>(debugLabel: 'shellRezepte');

final _mobileRouterConfig = RoutingConfig(
  routes: [
    StatefulShellRoute.indexedStack(
      pageBuilder: (context, state, navigationShell) => NoTransitionPage(
        child: HomeScaffold(
          navigationShell: navigationShell,
        ),
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/patienten',
              builder: (context, state) => const PatientenPage(),
              routes: [
                GoRoute(
                  path: 'create',
                  pageBuilder: (context, state) => const MaterialPage(
                    fullscreenDialog: true,
                    child: CreatePatientPage(),
                  ),
                ),
                GoRoute(
                  path: ':id',
                  pageBuilder: (context, state) => MaterialPage(
                    fullscreenDialog: true,
                    child: PatientDetailPage(id: state.pathParameters['id']!),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/rezepte',
              builder: (context, state) => const RezeptePage(),
              routes: [
                GoRoute(
                  path: 'create',
                  pageBuilder: (context, state) => const MaterialPage(
                    fullscreenDialog: true,
                    child: CreateRezeptPage(),
                  ),
                ),
                GoRoute(
                  path: 'upload',
                  pageBuilder: (context, state) => const MaterialPage(
                    fullscreenDialog: true,
                    child: UploadRezeptPage(),
                  ),
                ),
                GoRoute(
                  path: ':id',
                  pageBuilder: (context, state) => MaterialPage(
                    fullscreenDialog: true,
                    child: RezeptDetailPage(id: state.pathParameters['id']!),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

final _desktopRouterConfig = RoutingConfig(
  routes: [
    StatefulShellRoute.indexedStack(
      pageBuilder: (context, state, navigationShell) => NoTransitionPage(
        child: HomeScaffold(
          navigationShell: navigationShell,
        ),
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/patienten',
              pageBuilder: (context, state) => NoTransitionPage(
                child: SplittedPatientenPage(
                  rightPane: Container(),
                  isContextCreate: false,
                ),
              ),
            ),
            GoRoute(
              path: '/patienten/create',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SplittedPatientenPage(
                  rightPane: CreatePatientContent(),
                  isContextCreate: true,
                ),
              ),
            ),
            GoRoute(
              path: '/patienten/:id',
              pageBuilder: (context, state) => NoTransitionPage(
                child: SplittedPatientenPage(
                  rightPane: PatientDetailPage(id: state.pathParameters['id']!),
                  isContextCreate: true,
                ),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/rezepte',
              pageBuilder: (context, state) => const NoTransitionPage(
                key: ValueKey('rezeptePage'),
                child: SplittedRezeptePage(
                  rightPane: SizedBox(),
                  isContextCreate: false,
                ),
              ),
            ),
            GoRoute(
              path: '/rezepte/create',
              pageBuilder: (context, state) => const NoTransitionPage(
                key: ValueKey('rezepteCreatePage'),
                child: SplittedRezeptePage(
                  rightPane: CreateRezeptPage(),
                  isContextCreate: true,
                ),
              ),
            ),
            GoRoute(
              path: '/rezepte/upload',
              pageBuilder: (context, state) => const NoTransitionPage(
                key: ValueKey('rezepteUploadPage'),
                child: SplittedRezeptePage(
                  rightPane: UploadRezeptContent(),
                  isContextCreate: true,
                ),
              ),
            ),
            GoRoute(
              path: '/rezepte/:id',
              pageBuilder: (context, state) => NoTransitionPage(
                key: ValueKey('rezepteDetailPage-${state.pathParameters['id']}'),
                child: SplittedRezeptePage(
                  rightPane: RezeptDetailPage(id: state.pathParameters['id']!),
                  isContextCreate: true,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

final _routerConfig = ValueNotifier(_mobileRouterConfig);

void updateRouterConfig(Breakpoint breakpoint) {
  _routerConfig.value = switch (breakpoint) {
    Breakpoint.mobile => _mobileRouterConfig,
    Breakpoint.tablet => _mobileRouterConfig,
    Breakpoint.desktop => _desktopRouterConfig,
  };
}

final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter.routingConfig(
    navigatorKey: _rootNavigatorKey,
    routingConfig: _routerConfig,
  ),
);

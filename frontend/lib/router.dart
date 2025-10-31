import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:physio_ai/behandlungen/presentation/behandlungen_page.dart';
import 'package:physio_ai/home_scaffold.dart';
import 'package:physio_ai/patienten/presentation/create_patient_page.dart';
import 'package:physio_ai/patienten/presentation/patient_detail_page.dart';
import 'package:physio_ai/patienten/presentation/patient_edit_page.dart';
import 'package:physio_ai/patienten/presentation/patienten_page.dart';
import 'package:physio_ai/profile/presentation/profile_page.dart';
import 'package:physio_ai/rezepte/presentation/create_rezept_page.dart';
import 'package:physio_ai/rezepte/presentation/rezept_detail_page.dart';
import 'package:physio_ai/rezepte/presentation/rezept_edit_page.dart';
import 'package:physio_ai/rezepte/presentation/rezepte_page.dart';
import 'package:physio_ai/rezepte/presentation/upload_rezept/upload_rezept_page.dart';
import 'package:physio_ai/shared_kernel/presentation/home_page.dart';
import 'package:physio_ai/shared_kernel/presentation/splitted_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<StatefulNavigationShellState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorPatientenKey = GlobalKey<NavigatorState>(debugLabel: 'shellPatienten');
final _shellNavigatorRezepteKey = GlobalKey<NavigatorState>(debugLabel: 'shellRezepte');
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

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
                  pageBuilder: (context, state) => MaterialPage(
                    fullscreenDialog: true,
                    child: CreatePatientPage(
                      redirectTo: state.uri.queryParameters['to'],
                    ),
                  ),
                ),
                GoRoute(
                  path: ':id',
                  pageBuilder: (context, state) => MaterialPage(
                    fullscreenDialog: true,
                    child: PatientDetailPage(id: state.pathParameters['id']!),
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      pageBuilder: (context, state) => MaterialPage(
                        fullscreenDialog: true,
                        child: PatientEditPage(id: state.pathParameters['id']!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/behandlungen',
              builder: (context, state) => const BehandlungenPage(),
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
                  routes: [
                    GoRoute(
                      path: 'edit',
                      pageBuilder: (context, state) => MaterialPage(
                        fullscreenDialog: true,
                        child: RezeptEditPage(id: state.pathParameters['id']!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
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
              pageBuilder: (context, state) => NoTransitionPage(
                child: SplittedPatientenPage(
                  rightPane: CreatePatientContent(
                    redirectTo: state.uri.queryParameters['to'],
                  ),
                  isContextCreate: true,
                ),
              ),
            ),
            GoRoute(
              path: '/patienten/:id',
              pageBuilder: (context, state) => NoTransitionPage(
                child: SplittedPatientenPage(
                  selectedPatientId: state.pathParameters['id']!,
                  rightPane: PatientDetailPage(id: state.pathParameters['id']!),
                  isContextCreate: false,
                ),
              ),
              routes: [
                GoRoute(
                  path: 'edit',
                  pageBuilder: (context, state) => NoTransitionPage(
                    child: SplittedPatientenPage(
                      selectedPatientId: state.pathParameters['id']!,
                      rightPane: PatientEditPage(id: state.pathParameters['id']!),
                      isContextCreate: true,
                    ),
                  ),
                ),
                GoRoute(
                  path: '/rezepte',
                  redirect: (context, state) {
                    if (state.fullPath == '/patienten/${state.pathParameters['id']!}/rezepte') {
                      return '/patienten/${state.pathParameters['id']!}';
                    }
                    return null;
                  },
                  routes: [
                    GoRoute(
                      path: 'create',
                      pageBuilder: (context, state) => NoTransitionPage(
                        key: ValueKey('rezepteCreatePage'),
                        child: SplittedPage(
                          leftPane: PatientDetailPage(id: state.pathParameters['id']!),
                          rightPane: const CreateRezeptPage(),
                        ),
                      ),
                    ),
                    GoRoute(
                      path: 'upload',
                      pageBuilder: (context, state) => const NoTransitionPage(
                        key: ValueKey('rezepteUploadPage'),
                        child: SplittedRezeptePage(
                          rightPane: UploadRezeptContent(),
                          showCreateButton: false,
                        ),
                      ),
                    ),
                    GoRoute(
                      path: ':rezeptId',
                      pageBuilder: (context, state) => NoTransitionPage(
                        child: SplittedPage(
                          leftPane: PatientDetailPage(id: state.pathParameters['id']!),
                          rightPane: RezeptDetailContent(id: state.pathParameters['rezeptId']!),
                        ),
                      ),
                      routes: [
                        GoRoute(
                          path: 'edit',
                          pageBuilder: (context, state) => NoTransitionPage(
                            key: ValueKey('rezepteEditPage-${state.pathParameters['id']}'),
                            child: SplittedRezeptePage(
                              rightPane: RezeptEditPage(id: state.pathParameters['id']!),
                              showCreateButton: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/behandlungen',
              builder: (context, state) => const BehandlungenPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
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

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:physio_ai/home_scaffold.dart';
import 'package:physio_ai/patienten/domain/patient.dart';
import 'package:physio_ai/patienten/presentation/create_patient_page.dart';
import 'package:physio_ai/patienten/presentation/patient_detail_page.dart';
import 'package:physio_ai/patienten/presentation/patienten_page.dart';
import 'package:physio_ai/rezepte/home_page.dart';
import 'package:physio_ai/rezepte/model/rezept.dart';
import 'package:physio_ai/rezepte/model/rezept_einlesen_response.dart';
import 'package:physio_ai/rezepte/presentation/create_rezept_page.dart';
import 'package:physio_ai/rezepte/presentation/patient_selection_page.dart';
import 'package:physio_ai/rezepte/presentation/patient_selection_view.dart';
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
                  pageBuilder: (context, state) {
                    // Get rezept if passed as extra
                    Rezept? rezept;
                    if (state.extra != null && state.extra is Rezept) {
                      rezept = state.extra! as Rezept;
                    }

                    return MaterialPage(
                      fullscreenDialog: true,
                      child: CreateRezeptPage(
                        prefillRezept: rezept,
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: 'upload',
                  pageBuilder: (context, state) => const MaterialPage(
                    fullscreenDialog: true,
                    child: UploadRezeptPage(),
                  ),
                ),
                GoRoute(
                  path: 'patient-selection',
                  pageBuilder: (context, state) {
                    // Get response if passed as extra
                    final response = state.extra as RezeptEinlesenResponse?;

                    if (response == null) {
                      // Handle navigation without response parameter
                      return const MaterialPage(
                        fullscreenDialog: true,
                        child: Scaffold(
                          body: Center(
                            child: Text('Error: No response data provided'),
                          ),
                        ),
                      );
                    }

                    return MaterialPage(
                      fullscreenDialog: true,
                      child: PatientSelectionPage(
                        response: response,
                      ),
                    );
                  },
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

final _tabletRouterConfig = RoutingConfig(
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
                  pageBuilder: (context, state) {
                    // Get rezept if passed as extra
                    Rezept? rezept;
                    if (state.extra != null && state.extra is Rezept) {
                      rezept = state.extra! as Rezept;
                    }

                    return MaterialPage(
                      fullscreenDialog: true,
                      child: CreateRezeptPage(
                        prefillRezept: rezept,
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: 'upload',
                  pageBuilder: (context, state) => const MaterialPage(
                    fullscreenDialog: true,
                    child: UploadRezeptPage(),
                  ),
                ),
                GoRoute(
                  path: 'patient-selection',
                  pageBuilder: (context, state) {
                    // Get response if passed as extra
                    final response = state.extra as RezeptEinlesenResponse?;

                    if (response == null) {
                      // Handle navigation without response parameter
                      return const MaterialPage(
                        fullscreenDialog: true,
                        child: Scaffold(
                          body: Center(
                            child: Text('Error: No response data provided'),
                          ),
                        ),
                      );
                    }

                    return MaterialPage(
                      fullscreenDialog: true,
                      child: PatientSelectionPage(
                        response: response,
                      ),
                    );
                  },
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
              pageBuilder: (context, state) {
                // Get rezept if passed as extra
                Rezept? rezept;
                if (state.extra != null && state.extra is Rezept) {
                  rezept = state.extra! as Rezept;
                }

                return NoTransitionPage(
                  key: const ValueKey('rezepteCreatePage'),
                  child: SplittedRezeptePage(
                    rightPane: CreateRezeptContent(
                      prefillRezept: rezept,
                    ),
                    isContextCreate: true,
                  ),
                );
              },
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
              path: '/rezepte/patient-selection',
              pageBuilder: (context, state) {
                // Get response if passed as extra
                final response = state.extra as RezeptEinlesenResponse?;

                if (response == null) {
                  // Handle navigation without response parameter
                  return const NoTransitionPage(
                    key: ValueKey('rezeptePatientSelectionPage'),
                    child: SplittedRezeptePage(
                      rightPane: Center(
                        child: Text('Error: No response data provided'),
                      ),
                      isContextCreate: true,
                    ),
                  );
                }

                return NoTransitionPage(
                  key: const ValueKey('rezeptePatientSelectionPage'),
                  child: SplittedRezeptePage(
                    rightPane: PatientSelectionView(
                      response: response,
                      onUseExistingPatient: (patientId) {
                        // Create a rezept from the response with the existing patient
                        final rezept = Rezept(
                          id: '',
                          patient: RezeptPatient(
                            id: patientId,
                            vorname: response.existingPatient!.vorname,
                            nachname: response.existingPatient!.nachname,
                          ),
                          ausgestelltAm: response.rezept.ausgestelltAm,
                          preisGesamt: 0,
                          positionen: response.rezept.rezeptpositionen
                              .map((pos) => RezeptPos(
                                    anzahl: pos.anzahl,
                                    behandlungsart: pos.behandlungsart,
                                  ))
                              .toIList(),
                        );

                        // Navigate to create rezept page with the pre-filled data
                        context.go('/rezepte/create', extra: rezept);
                      },
                      onCreateNewPatient: () {
                        // Create a new patient from the analyzed data
                        final newPatient = Patient(
                          id: '',
                          vorname: response.patient.vorname,
                          nachname: response.patient.nachname,
                          geburtstag: response.patient.geburtstag,
                          titel: response.patient.titel,
                          strasse: response.patient.strasse,
                          hausnummer: response.patient.hausnummer,
                          plz: response.patient.postleitzahl,
                          stadt: response.patient.stadt,
                        );

                        // Pass the original response as well for later rezept creation
                        final patientWithRezeptData = PatientSelectionData(
                          patient: newPatient,
                          response: response,
                        );

                        // Navigate to create patient page with the pre-filled data
                        context.go('/patienten/create', extra: patientWithRezeptData);
                      },
                    ),
                    isContextCreate: true,
                  ),
                );
              },
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
    Breakpoint.tablet => _tabletRouterConfig,
    Breakpoint.desktop => _desktopRouterConfig,
  };
}

final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter.routingConfig(
    navigatorKey: _rootNavigatorKey,
    routingConfig: _routerConfig,
  ),
);

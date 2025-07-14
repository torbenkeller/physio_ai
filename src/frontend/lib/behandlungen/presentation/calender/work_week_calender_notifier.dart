import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/behandlungen/domain/behandlung.dart';
import 'package:physio_ai/behandlungen/infrastructure/behandlung_form_dto.dart';
import 'package:physio_ai/behandlungen/infrastructure/behandlung_verschiebe_dto.dart';
import 'package:physio_ai/behandlungen/infrastructure/behandlungen_repository.dart';

final workWeekCalenderSelectedWeekProvider = NotifierProvider(
  WorkWeekCalenderSelectedWeekNotifier.new,
);

final workWeekCalenderBehandlungenProvider =
    AsyncNotifierProvider.family<
      WorkWeekCalenderBehandlungenNotifier,
      IList<BehandlungKalender>,
      DateTime
    >(WorkWeekCalenderBehandlungenNotifier.new);

final workWeekCalenderCreateBehandlungStartZeitProvider = NotifierProvider(
  WorkWeekCalenderCreateBehandlungStartZeitNotifier.new,
);

class WorkWeekCalenderSelectedWeekNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    return DateTime.now().weekStart();
  }

  void previousWeek() {
    state = state.subtract(const Duration(days: 7));
  }

  void nextWeek() {
    state = state.add(const Duration(days: 7));
  }

  void today() {
    state = DateTime.now().weekStart();
  }
}

class WorkWeekCalenderBehandlungenNotifier
    extends FamilyAsyncNotifier<IList<BehandlungKalender>, DateTime> {
  @override
  Future<IList<BehandlungKalender>> build(DateTime date) async {
    final repository = ref.watch(behandlungenRepositoryProvider);
    final dateString = date.toIso8601String().split('T')[0]; // Format: YYYY-MM-DD
    final behandlungenMap = await repository.getWeeklyCalendar(dateString);
    return behandlungenMap.values.fold<IList<BehandlungKalender>>(
      IList(),
      (f, elem) => f.addAll(elem),
    );
  }

  Future<void> verschiebeBehandlung({
    required BehandlungKalender event,
    required DateTime nach,
  }) async {
    final repository = ref.read(behandlungenRepositoryProvider);
    final selectedWeek = ref.read(workWeekCalenderSelectedWeekProvider);

    await repository.verschiebe(
      event.id,
      BehandlungVerschiebeDto(nach: nach),
    );

    final oldEventWeekStart = event.startZeit.weekStart();
    if (oldEventWeekStart != selectedWeek) {
      ref.invalidate(workWeekCalenderBehandlungenProvider(oldEventWeekStart));
    }

    ref.invalidateSelf(asReload: true);
  }

  Future<void> erstelleBehandlung(BehandlungFormDto dto) async {
    final repository = ref.read(behandlungenRepositoryProvider);

    await repository.createBehandlung(dto);

    ref.invalidateSelf(asReload: true);
  }
}

class WorkWeekCalenderCreateBehandlungStartZeitNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() {
    return null;
  }

  // To make the methods more expressive, we use `startCreating` and `stopCreating`
  // ignore: use_setters_to_change_properties
  void startCreating(DateTime startZeit) {
    state = startZeit;
  }

  void stopCreating() {
    state = null;
  }
}

extension NormalizeWeek on DateTime {
  DateTime weekStart() {
    return DateUtils.dateOnly(this).subtract(Duration(days: weekday - 1));
  }
}

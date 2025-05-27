import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ai/behandlungen/domain/behandlung.dart';
import 'package:physio_ai/behandlungen/infrastructure/behandlungen_repository.dart';

final weeklyCalendarProvider =
    FutureProvider.family<IList<BehandlungKalender>, DateTime>((ref, date) async {
  final repository = ref.watch(behandlungenRepositoryProvider);
  final dateString = date.toIso8601String().split('T')[0]; // Format: YYYY-MM-DD
  final behandlungenMap = await repository.getWeeklyCalendar(dateString);
  return behandlungenMap.values.fold<IList<BehandlungKalender>>(
    IList(),
    (f, elem) => f.addAll(elem),
  );
});

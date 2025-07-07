import 'package:fast_immutable_collections/src/ilist/ilist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:physio_ai/behandlungen/domain/behandlung.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_configuration.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_create_gesture_detector.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_creator.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_drag_targets.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_events.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_grid.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_header.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_timeline.dart';

class WorkWeekCalender extends StatefulWidget {
  const WorkWeekCalender({
    required this.events,
    this.onWeekSelected,
    super.key,
    this.initialWeek,
    this.configuration = const WorkWeekCalenderConfiguration(),
  });

  final DateTime? initialWeek;

  final WorkWeekCalenderConfiguration configuration;

  final IList<BehandlungKalender> events;

  final ValueChanged<DateTime>? onWeekSelected;

  @override
  State<WorkWeekCalender> createState() => _WorkWeekCalenderState();
}

class _WorkWeekCalenderState extends State<WorkWeekCalender> {
  late DateTime _selectedWeek;

  @override
  void initState() {
    super.initState();
    _selectedWeek = _normalizeWeek(widget.initialWeek ?? DateTime.now());
  }

  DateTime _normalizeWeek(DateTime date) {
    return DateUtils.dateOnly(date).subtract(Duration(days: date.weekday - 1));
  }

  void _onWeekSelected(DateTime date) {
    setState(() {
      _selectedWeek = _normalizeWeek(date);
    });

    widget.onWeekSelected?.call(_selectedWeek);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WorkWeekCalenderHeader(
          selectedWeek: _selectedWeek,
          onWeekSelected: _onWeekSelected,
        ),
        Expanded(
          child: WorkWeekCalenderContent(
            configuration: const WorkWeekCalenderConfiguration(),
            selectedWeek: _selectedWeek,
            events: widget.events,
          ),
        ),
      ],
    );
  }
}

class WorkWeekCalenderContent extends StatefulWidget {
  const WorkWeekCalenderContent({
    required this.configuration,
    required this.events,
    required this.selectedWeek,
    super.key,
  });

  final WorkWeekCalenderConfiguration configuration;

  final IList<BehandlungKalender> events;

  final DateTime selectedWeek;

  @override
  State<WorkWeekCalenderContent> createState() => _WorkWeekCalenderContentState();
}

class _WorkWeekCalenderContentState extends State<WorkWeekCalenderContent> {
  DateTime? _createBehandlungStartZeit;

  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Portal(
        child: Row(
          children: [
            SizedBox(
              width: 48,
              child: WorkWeekCalenderTimeline(configuration: widget.configuration),
            ),
            Expanded(
              child: Stack(
                children: [
                  WorkWeekCalenderGrid(configuration: widget.configuration),
                  Positioned.fill(
                    child: WorkWeekCalenderCreateGestureDetector(
                      configuration: widget.configuration,
                      isCreatingBehandlung: _createBehandlungStartZeit != null,
                      selectedWeek: widget.selectedWeek,
                      onCreateBehandlungStarted: (dateTime) {
                        setState(() {
                          _createBehandlungStartZeit = dateTime;
                        });
                      },
                    ),
                  ),
                  Positioned.fill(
                    child: WorkWeekCalenderEvents(
                      events: widget.events,
                      configuration: widget.configuration,
                    ),
                  ),
                  Positioned.fill(
                    child: WorkWeekCalenderDragTargets(
                      events: widget.events,
                      selectedWeek: widget.selectedWeek,
                      configuration: widget.configuration,
                      scrollController: scrollController,
                    ),
                  ),
                  Positioned.fill(
                    child: WorkWeekCalenderCreator(
                      selectedWeek: widget.selectedWeek,
                      configuration: widget.configuration,
                      createBehandlungStartZeit: _createBehandlungStartZeit,
                      onCreateFinished: () {
                        setState(() {
                          _createBehandlungStartZeit = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

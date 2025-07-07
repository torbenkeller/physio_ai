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

class WorkWeekCalender extends StatelessWidget {
  const WorkWeekCalender({
    required this.events,
    super.key,
    this.configuration = const WorkWeekCalenderConfiguration(),
  });

  final WorkWeekCalenderConfiguration configuration;

  final IList<BehandlungKalender> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const WorkWeekCalenderHeader(),
        Expanded(
          child: WorkWeekCalenderContent(
            configuration: const WorkWeekCalenderConfiguration(),
            events: events,
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
    super.key,
  });

  final WorkWeekCalenderConfiguration configuration;

  final IList<BehandlungKalender> events;

  @override
  State<WorkWeekCalenderContent> createState() => _WorkWeekCalenderContentState();
}

class _WorkWeekCalenderContentState extends State<WorkWeekCalenderContent> {
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
                      configuration: widget.configuration,
                      scrollController: scrollController,
                    ),
                  ),
                  Positioned.fill(
                    child: WorkWeekCalenderCreator(
                      configuration: widget.configuration,
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

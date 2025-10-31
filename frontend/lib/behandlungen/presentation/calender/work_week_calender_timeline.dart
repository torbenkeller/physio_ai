import 'package:flutter/material.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_configuration.dart';

class WorkWeekCalenderTimeline extends StatelessWidget {
  const WorkWeekCalenderTimeline({required this.configuration, super.key});

  final WorkWeekCalenderConfiguration configuration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        for (int hour = 1; hour < 24; hour++)
          Container(
            height: configuration.hourHeight,
            alignment: Alignment.centerLeft,
            child: Text(
              '${hour.toString().padLeft(2, '0')}:00',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(137),
              ),
            ),
          ),
      ],
    );
  }
}

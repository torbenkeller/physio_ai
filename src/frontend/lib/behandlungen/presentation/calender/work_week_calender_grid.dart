import 'package:flutter/material.dart';
import 'package:physio_ai/behandlungen/presentation/calender/work_week_calender_configuration.dart';

class WorkWeekCalenderGrid extends StatelessWidget {
  const WorkWeekCalenderGrid({
    required this.configuration,
    super.key,
  });

  final WorkWeekCalenderConfiguration configuration;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: configuration.hourHeight * 24,
      width: double.infinity,
      child: CustomPaint(
        painter: _WorkWeekCalenderGridPainter(
          color: colorScheme.outline.withAlpha(51),
          disabledHourColor: colorScheme.outline.withAlpha(40),
          days: 5,
          hours: 24,
          workingHoursStartHour: configuration.workingHoursStartHour,
          workingHoursEndHour: configuration.workingHoursEndHour,
        ),
      ),
    );
  }
}

class _WorkWeekCalenderGridPainter extends CustomPainter {
  const _WorkWeekCalenderGridPainter({
    required this.color,
    required this.disabledHourColor,
    required this.days,
    required this.hours,
    required this.workingHoursStartHour,
    required this.workingHoursEndHour,
  });

  final Color color;
  final Color disabledHourColor;
  final int days;
  final int hours;
  final int workingHoursStartHour;
  final int workingHoursEndHour;

  @override
  void paint(Canvas canvas, Size size) {
    final disabledPaint = Paint()..color = disabledHourColor;

    final yDisabledEnd = (size.height / hours) * workingHoursStartHour;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, yDisabledEnd), disabledPaint);

    final yDisabledStart = (size.height / hours) * workingHoursEndHour;
    canvas.drawRect(
      Rect.fromLTWH(0, yDisabledStart, size.width, size.height - yDisabledStart),
      disabledPaint,
    );

    final linePaint = Paint()..color = color;

    for (var i = 0; i < days; i++) {
      linePaint.strokeWidth = 1.0;
      final x = (size.width / days) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    for (var i = 1; i < hours; i++) {
      linePaint.strokeWidth = 1.0;
      final y = (size.height / hours) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(_WorkWeekCalenderGridPainter oldPainter) {
    return oldPainter.color != color ||
        oldPainter.disabledHourColor != disabledHourColor ||
        oldPainter.days != days ||
        oldPainter.hours != hours ||
        oldPainter.workingHoursStartHour != workingHoursStartHour ||
        oldPainter.workingHoursEndHour != workingHoursEndHour;
  }

  @override
  bool hitTest(Offset position) => false;
}

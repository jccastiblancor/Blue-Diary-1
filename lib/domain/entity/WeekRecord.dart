
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';
import 'package:todo_app/domain/entity/DayPreview.dart';

class WeekRecord {
  final DateInWeek dateInWeek;
  final bool isCheckPointsLocked;
  final List<CheckPoint> checkPoints;
  final List<DayPreview> dayPreviews;

  String get key => '${dateInWeek.year}-${dateInWeek.month}-${dateInWeek.nthWeek}';

  const WeekRecord({
    this.dateInWeek = const DateInWeek(),
    this.isCheckPointsLocked = false,
    this.checkPoints = const [],
    this.dayPreviews = const [],
  });

  WeekRecord buildNew({
    bool isCheckPointsLocked,
    List<CheckPoint> checkPoints,
    List<DayPreview> dayPreviews,
  }) {
    return WeekRecord(
      dateInWeek: this.dateInWeek,
      isCheckPointsLocked: isCheckPointsLocked ?? this.isCheckPointsLocked,
      checkPoints: checkPoints ?? this.checkPoints,
      dayPreviews: dayPreviews ?? this.dayPreviews,
    );
  }

  WeekRecord buildNewCheckPointUpdated(CheckPoint updated) {
    final updatedCheckPoints = List.of(checkPoints);
    final updatedIndex = updatedCheckPoints.indexWhere((it) => it.key == updated.key);
    if (updatedIndex >= 0) {
      updatedCheckPoints[updatedIndex] = updated;
    }
    return buildNew(checkPoints: updatedCheckPoints);
  }

  WeekRecord buildNewDayPreviewUpdated(DayPreview updated) {
    final updatedDayPreviews = List.of(dayPreviews);
    final updatedIndex = updatedDayPreviews.indexWhere((it) => it.key == updated.key);
    if (updatedIndex >= 0) {
      updatedDayPreviews[updatedIndex] = updated;
    }
    return buildNew(dayPreviews: updatedDayPreviews);
  }
}
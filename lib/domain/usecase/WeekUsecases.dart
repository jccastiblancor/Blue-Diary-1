
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';
import 'package:todo_app/domain/entity/DayPreview.dart';
import 'package:todo_app/domain/entity/WeekRecord.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/LockRepository.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';

class WeekUsecases {
  final MemoRepository _memoRepository;
  final DateRepository _dateRepository;
  final ToDoRepository _toDoRepository;
  final LockRepository _lockRepository;

  const WeekUsecases(this._memoRepository, this._dateRepository, this._toDoRepository, this._lockRepository);

  DateInWeek getCurrentDateInWeek() {
    final currentDate = _dateRepository.getCurrentDate();
    return DateInWeek.fromDate(currentDate);
  }

  Future<WeekRecord> getCurrentWeekRecord() async {
    return _getWeekRecord(_dateRepository.getCurrentDate());
  }

  Future<WeekRecord> getPrevWeekRecord() async {
    return _getWeekRecord(_dateRepository.getCurrentDate().subtract(Duration(days: 7)));
  }

  Future<WeekRecord> getNextWeekRecord() async {
    return _getWeekRecord(_dateRepository.getCurrentDate().add(Duration(days: 7)));
  }

  Future<WeekRecord> _getWeekRecord(DateTime date) async {
    final today = _dateRepository.getToday();
    final isCheckPointsLocked = await _lockRepository.getIsCheckPointsLocked(date);
    final checkPoints = await _memoRepository.getCheckPoints(date);

    final datesInWeek = DateInWeek.fromDate(date).datesInWeek;
    List<DayPreview> dayPreviews = [];
    for (int i = 0; i < datesInWeek.length; i++) {
      final date = datesInWeek[i];
      final toDos = await _toDoRepository.getToDos(date);
      final isLocked = await _lockRepository.getIsDayRecordLocked(date);
      dayPreviews.add(DayPreview(date, toDos, isLocked, i < datesInWeek.length - 1, Utils.isSameDay(date, today)));
    }

    return WeekRecord(isCheckPointsLocked, checkPoints, dayPreviews);
  }
}
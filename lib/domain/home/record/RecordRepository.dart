
import 'package:todo_app/domain/home/record/DayRecord.dart';
import 'package:todo_app/domain/home/record/WeekMemoSet.dart';

abstract class RecordRepository {
  Stream<WeekMemoSet> get weekMemoSet;
  Stream<List<DayRecord>> get days;

  void updateSingleWeekMemo(String updatedText, int index);
  void updateDayRecords(int focusedIndex);
}
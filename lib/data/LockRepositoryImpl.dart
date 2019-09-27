
import 'package:todo_app/data/AppDatabase.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';
import 'package:todo_app/domain/repository/LockRepository.dart';

class LockRepositoryImpl implements LockRepository {
  final AppDatabase _db;

  const LockRepositoryImpl(this._db);

  @override
  Future<bool> getIsCheckPointsLocked(DateTime date) async {
    return await _db.getIsCheckPointsLocked(date);
  }

  @override
  Future<bool> getIsDayRecordLocked(DateTime date) async {
    return await _db.getIsDayRecordLocked(date);
  }

  @override
  void setIsCheckPointsLocked(DateInWeek dateInWeek, bool value) {
    _db.setIsCheckPointsLocked(dateInWeek, value);
  }

  @override
  void setIsDayRecordLocked(DateTime date, bool value) {
    _db.setIsDayRecordLocked(date, value);
  }

}
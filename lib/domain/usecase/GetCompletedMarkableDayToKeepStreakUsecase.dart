
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/usecase/GetCanBeMarkedCompletedUsecase.dart';

class GetCompletedMarkableDayToKeepStreakUsecase {
  final _getCanBeMarkedCompletedUsecase = GetCanBeMarkedCompletedUsecase();

  Future<DateTime> invoke(DateTime date) async {
    final prevDay = date.subtract(const Duration(days: 1));
    final canPrevDayBeMarkedCompleted = await _getCanBeMarkedCompletedUsecase.invoke(prevDay);
    if (canPrevDayBeMarkedCompleted) {
      return prevDay;
    } else {
      return DateRepository.INVALID_DATE;
    }
  }
}
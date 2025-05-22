class FormatTimeAgo {
  static String formatTimeAgo({
    required DateTime now,
    required DateTime createdAt,
  }) {
    // 1시간 미만이면 'n분'
    // 24시간 미만이면 'n시간'
    // 24시간 이상이면 'n월 n일'

    final diffSec = now.difference(createdAt).inSeconds;
    final diffMin = now.difference(createdAt).inMinutes;
    final diffHour = now.difference(createdAt).inHours;

    // log('$diffMin');
    // log('$diffHour');

    if (diffSec <= 0) {
      return '0초';
    } else if (diffSec >= 1 && diffSec < 60) {
      return '$diffSec초';
    } else if (diffSec >= 60 && diffSec < 60 * 60) {
      return '$diffMin분';
    } else if (diffSec >= 60 * 60 && diffSec < 60 * 60 * 24) {
      return '$diffHour시간';
    } else if (diffSec >= 60 * 60 * 24 && createdAt.year == now.year) {
      return '${createdAt.month}월 ${createdAt.day}일';
    } else {
      return '${createdAt.year}년 ${createdAt.month}월 ${createdAt.day}일';
    }
  }
}

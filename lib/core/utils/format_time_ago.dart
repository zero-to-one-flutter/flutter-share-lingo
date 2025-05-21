import 'dart:developer';

class FormatTimeAgo {
  static String formatTimeAgo(DateTime createdAt) {
    // 1시간 미만이면 'n분'
    // 24시간 미만이면 'n시간'
    // 24시간 이상이면 'n월 n일'

    DateTime now = DateTime.now();

    final diffSec = now.difference(createdAt).inSeconds;
    final diffMin = now.difference(createdAt).inMinutes;
    final diffHour = now.difference(createdAt).inHours;

    log('$diffMin');
    log('$diffHour');

    if (diffMin < 1) {
      return '$diffSec초';
    } else if (diffMin > 1 && diffMin < 60) {
      return '$diffMin분';
    } else if (diffMin >= 60 && diffMin < 1440) {
      return '$diffHour시간';
    } else if (diffMin >= 1440 && createdAt.year == now.year) {
      return '${createdAt.month}월 ${createdAt.day}일';
    } else {
      return '${createdAt.year}년 ${createdAt.month}월 ${createdAt.day}일';
    }
  }
}

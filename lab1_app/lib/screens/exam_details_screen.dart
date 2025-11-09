import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/exam.dart';

class ExamDetailsScreen extends StatelessWidget {
  final Exam exam;
  const ExamDetailsScreen({super.key, required this.exam});

  String _formatDateTime(DateTime dt) {
    return DateFormat('dd.MM.yyyy (EEE)', 'mk').format(dt);
  }

  String _formatTime(DateTime dt) {
    return DateFormat('HH:mm', 'mk').format(dt);
  }

  String _remainingTimeString(DateTime dt) {
    final now = DateTime.now();
    final difference = dt.difference(now);

    if (difference.isNegative) {
      final ago = now.difference(dt);
      final days = ago.inDays;
      final hours = ago.inHours.remainder(24);
      return 'Изминат пред $days ден(а) и $hours час(а)';
    } else {
      final days = difference.inDays;
      final hours = difference.inHours.remainder(24);
      return 'Преостануваат $days ден(а) и $hours час(а)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPast = exam.dateTime.isBefore(DateTime.now());

    final Color sideColor = isPast
        ? Colors.grey.shade500
        : Colors.deepPurple.shade100;

    final Color labelColor = isPast ? Colors.grey.shade600 : Colors.white;

    final Color labelColorTwo = isPast ? Colors.grey.shade600 : Colors.grey.shade100;

    final Color iconColor = isPast
        ? Colors.grey.shade600
        : Colors.deepPurple.shade100;

    final Color cardColor = isPast
        ? Colors.grey.shade900
        : Colors.deepPurple.shade700;

    final Color iconColorTwo = isPast
        ? Colors.grey.shade600
        : Colors.deepPurple.shade200;

    final double sideHeight = isPast ? 0 : 90;

    final String dateLabel = _formatDateTime(exam.dateTime);
    final String timeLabel = _formatTime(exam.dateTime);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          exam.title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 4,
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: sideHeight,
                    decoration: BoxDecoration(
                      color: sideColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: iconColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                dateLabel,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: labelColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.schedule, size: 20, color: iconColor),
                              const SizedBox(width: 8),
                              Text(
                                timeLabel,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: labelColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Icon(
                                Icons.room_outlined,
                                size: 20,
                                color: iconColor,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  exam.rooms.join(', '),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: labelColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.av_timer, size: 20, color: iconColor),
                              const SizedBox(width: 6),
                              Text(
                                _remainingTimeString(exam.dateTime),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: labelColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 1,
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 0,
                    decoration: BoxDecoration(
                      color: sideColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.login_outlined,
                                size: 20,
                                color: iconColorTwo,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Пристигнете 15 минути порано',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: labelColorTwo,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Icon(
                                Icons.badge_outlined,
                                size: 20,
                                color: iconColorTwo,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Задолжителна идентификација со индекс',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: labelColorTwo,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Icon(
                                Icons.assignment_outlined,
                                size: 20,
                                color: iconColorTwo,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Електронско полагање на ispiti.finki.ukim.mk',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  color: labelColorTwo,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

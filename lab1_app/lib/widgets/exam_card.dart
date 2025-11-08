import 'package:flutter/material.dart';
import '../models/exam.dart';

class ExamCard extends StatelessWidget {
  final Exam exam;
  final String dateLabel;
  final String timeLabel;

  const ExamCard({
    super.key,
    required this.exam,
    required this.dateLabel,
    required this.timeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPast = exam.dateTime.isBefore(DateTime.now());
    final Color sideColor = isPast
        ? Colors.grey.shade500
        : Colors.deepPurple.shade100;
    final Color titleColor = isPast ? Colors.grey.shade500 : Colors.white;
    final Color labelColor = isPast ? Colors.grey.shade600 : Colors.white;
    final Color iconColor = isPast
        ? Colors.grey.shade600
        : Colors.deepPurple.shade100;

    final cardColor = isPast
        ? Colors.grey.shade900
        : Colors.deepPurple.shade700; // default card color from theme

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Row(
        children: [
          // colored side accent
          Container(
            width: 5,
            height: 80,
            decoration: BoxDecoration(
              color: sideColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 20, color: iconColor),
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
                      const SizedBox(width: 6),
                      Text(
                        timeLabel,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: labelColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.room_outlined, size: 20, color: iconColor),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
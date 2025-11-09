import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/exam.dart';
import '../widgets/exam_card.dart';
import 'exam_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final String studentIndex;
  const HomeScreen({super.key, required this.studentIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Exam> exams;

  @override
  void initState() {
    super.initState();

    exams = [
      Exam(
        title: 'Напредни Бази на Податоци',
        dateTime: DateTime(2025, 10, 30, 9, 0),
        rooms: ['Лаб. 215', 'Лаб. 3'],
      ),
      Exam(
        title: 'Менаџмент Информациски Системи',
        dateTime: DateTime(2025, 11, 05, 14, 30),
        rooms: ['Лаб. 12', 'Лаб. 138'],
      ),
      Exam(
        title: 'Напредно Програмирање',
        dateTime: DateTime(2025, 11, 10, 10, 0),
        rooms: ['Лаб. 200аб', 'Лаб. 13', 'Лаб. 3'],
      ),
      Exam(
        title: 'Мобилни Информациски Системи',
        dateTime: DateTime(2025, 12, 01, 8, 30),
        rooms: ['Лаб. 2'],
      ),
      Exam(
        title: 'Програмирање на Видео Игри',
        dateTime: DateTime(2025, 11, 20, 13, 0),
        rooms: ['Лаб. 200в', 'Лаб. 138'],
      ),
      Exam(
        title: 'Иновации во ИКТ',
        dateTime: DateTime(2025, 9, 20, 11, 0),
        rooms: ['Лаб. 3'],
      ),
      Exam(
        title: 'Персонализирано Учење',
        dateTime: DateTime(2025, 11, 25, 16, 0),
        rooms: ['Лаб. 12', 'Лаб. 215'],
      ),
      Exam(
        title: 'Неструктурирани Бази на Податоци',
        dateTime: DateTime(2025, 11, 15, 12, 0),
        rooms: ['Лаб. 2', 'Лаб. 200аб'],
      ),
      Exam(
        title: 'Дизајн на Образовен Софтвер',
        dateTime: DateTime(2026, 1, 11, 9, 30),
        rooms: ['Лаб. 13', 'Лаб. 200в'],
      ),
      Exam(
        title: 'Имплементација на Системи со Слободен и Отворен Код',
        dateTime: DateTime(2025, 12, 10, 14, 0),
        rooms: ['Лаб. 138', 'Лаб. 12', 'Лаб. 2'],
      ),
    ];

    exams.sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  String _formatDate(DateTime dt) {
    return DateFormat('dd.MM.yyyy (EEE)', 'mk').format(dt);
  }

  String _formatTime(DateTime dt) {
    return DateFormat('HH:mm').format(dt);
  }

  void _openDetails(Exam exam) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ExamDetailsScreen(exam: exam)));
  }

  @override
  Widget build(BuildContext context) {
    final total = exams.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Распоред за испити – ${widget.studentIndex}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: exams.length,
        itemBuilder: (context, index) {
          final exam = exams[index];
          return GestureDetector(
            onTap: () => _openDetails(exam),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: ExamCard(
                exam: exam,
                dateLabel: _formatDate(exam.dateTime),
                timeLabel: _formatTime(exam.dateTime),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              const Icon(Icons.school),
              const SizedBox(width: 15),
              const Text(
                'Вкупно испити:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 12),
              Chip(
                label: Text(
                  '$total',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

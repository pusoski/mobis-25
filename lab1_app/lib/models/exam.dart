class Exam {
  final String title;
  final DateTime dateTime;
  final List<String> rooms;

  Exam({
    required this.title,
    required this.dateTime,
    required this.rooms,
  });

  bool get isPast => dateTime.isBefore(DateTime.now());
}

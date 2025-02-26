class Note {
  late int _id;
  late String _title;
  late String? _description;
  late String _date;
  late String _priority;

  Note({
    required int id,
    required String title,
    String? description,
    required String date,
    required String priority,
  })  : _id = id,
        _title = title,
        _description = description,
        _date = date,
        _priority = priority;

  //getters
  int get id => _id;
  String get title => _title;
  String? get description => _description;
  String get date => _date;
  String get priority => _priority;

  //setters
  set title(String title) {
    if (title.length <= 255) _title = title;
  }

  set description(String? description) {
    if (description!.length <= 255) _description = description;
  }

  set date(String date) => _date = date;
  set priority(String priority) {
    if (priority == 1 || priority == 2) _priority = priority;
  }

  //note obj to map obj
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'title': _title,
      'description': _description,
      'priority': _priority,
      'date': _date,
    };
  }

//   String toMapString() {
//     return '''
// {
//   "id": $id,
//   "title": "$title",
//   "description": "${description ?? 'No description'}",
//   "priority": "$priority",
//   "date": "$date"
// }
// ''';
//   }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'],
      date: map['date'] ?? '',
      priority: map['priority'] ?? '',
    );
  }
}

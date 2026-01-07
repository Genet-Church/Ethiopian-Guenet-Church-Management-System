class Department {
  final String id;
  final String name;
  final String churchId;
  final String? dateCreated;

  Department({
    required this.id,
    required this.name,
    required this.churchId,
    this.dateCreated,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      name: json['name'],
      churchId: json['churchId'],
      dateCreated: json['dateCreated'],
    );
  }
}

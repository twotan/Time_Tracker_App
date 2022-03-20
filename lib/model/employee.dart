class Employee {
  final int id;
  final String name;
  final String email;

  Employee({required this.id, required this.name, required this.email});

  @override
  String toString() {
    return 'Employee{' + ' Id: $id ' + '}';
  }

  //
  Employee copyWith({int? id, String? name, String? email}) {
    return Employee(
        id: id ?? this.id, name: name ?? this.name, email: email ?? this.email);
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': this.id,
      'Name': this.name,
      'Email': this.email,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
        id: map['Id'] as int,
        name: map['Name'].toString(),
        email: map['Email'].toString());
  }
}

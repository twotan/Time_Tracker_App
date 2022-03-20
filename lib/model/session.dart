class Session {
  final int id;
  final String sessionKey;
  final int employeeId;

  Session(
      {required this.id, required this.sessionKey, required this.employeeId});

  //
  Session copyWith({int? id, String? sessionKey, int? employeeId}) {
    return Session(
        id: id ?? this.id,
        sessionKey: sessionKey ?? this.sessionKey,
        employeeId: employeeId ?? this.employeeId);
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': this.id,
      'SessionKey': this.sessionKey,
      'EmployeeId': this.employeeId,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
        id: map['Id'] as int,
        sessionKey: map['SessionKey'].toString(),
        employeeId: map['EmployeeId'] as int);
  }
}

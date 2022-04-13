class WorkScheduleProgress {
  final int id;
  final int employeeId;
  final int year;
  final int month;
  final int status;
  final DateTime workDate;

  WorkScheduleProgress(
      {required this.id,
      required this.employeeId,
      required this.year,
      required this.month,
      required this.status,
      required this.workDate});

  @override
  String toString() {
    return 'WorkScheduleProgress{' + ' Id: $id}';
  }

  //
  WorkScheduleProgress copyWith(
      {int? id,
      int? employeeId,
      int? year,
      int? month,
      int? status,
      DateTime? workDate}) {
    return WorkScheduleProgress(
        id: id ?? this.id,
        employeeId: employeeId ?? this.employeeId,
        year: year ?? this.year,
        month: month ?? this.month,
        status: status ?? this.status,
        workDate: workDate ?? this.workDate);
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': this.id,
      'EmployeeId': this.employeeId,
      'Year': this.year,
      'Month': this.month,
      'Status': this.status,
      'WorkDate': this.workDate
    };
  }

  factory WorkScheduleProgress.fromMap(Map<String, dynamic> map) {
    return WorkScheduleProgress(
        id: map['Id'] as int,
        employeeId: map['EmployeeId'] as int,
        year: map['Year'] as int,
        month: map['Month'] as int,
        status: map['Status'] as int,
        workDate: DateTime.now());
  }
}

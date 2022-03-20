class RouteNames {
  static const String login = '/login';
  static const String first = '/';
  static const String second = '/';
  static const String scheduleYears = '/schedules/years';
  static const String scheduleMonths = '/schedules/months';
  static const String scheduleDetails = '/schedules/details';
  static const String settings = '/settings';
}

class MySqlSettings {
  static const String host = '10.0.2.2';
  static const int port = 3306;
  static const String user = 'timetracker';
  static const String password = 'timetracker';
  static const String db = 'timetracker';
}

class SharedPreferencesKeys {
  static const String loginKey = "loginKey";
}

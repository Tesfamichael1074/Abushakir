///
part of ethiopiancalendar;

class EtDatetime extends EDT {
  int moment;

  // Constructors
  EtDatetime(
      {@required int year,
      int month = 1,
      int day = 1,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0})
      : this.moment =
            _dateToEpoch(year, month, day, hour, minute, second, millisecond) {
    if (moment == null) throw new ArgumentError();
  }

  EtDatetime.now() {
    this.moment =
        (unixEpoch + (DateTime.now().millisecondsSinceEpoch / dayMilliSec))
            .toInt();
  }

  EtDatetime.fromMillisecondsSinceEpoch(int millisecondsSinceEpoch)
      : this._withValue(
            millisecondsSinceEpoch * Duration.microsecondsPerMillisecond);

  static EtDatetime parse(String formattedString) {
    var re = _parseFormat;
    Match match = re.firstMatch(formattedString);
    if (match != null) {
      int parseIntOrZero(String matched) {
        if (matched == null) return 0;
        return int.parse(matched);
      }

      int parseMilliAndMicroseconds(String matched) {
        if (matched == null) return 0;
        int length = matched.length;
        assert(length >= 1);
        int result = 0;
        for (int i = 0; i < 6; i++) {
          result *= 10;
          if (i < matched.length) {
            result += matched.codeUnitAt(i) ^ 0x30;
          }
        }
        return result;
      }

      int years = int.parse(match[1]);
      int month = int.parse(match[2]);
      int day = int.parse(match[3]);
      int hour = parseIntOrZero(match[4]);
      int minute = parseIntOrZero(match[5]);
      int second = parseIntOrZero(match[6]);
      int milliAndMicroseconds = parseMilliAndMicroseconds(match[7]);
      int millisecond =
          milliAndMicroseconds ~/ Duration.microsecondsPerMillisecond;
      if (match[8] != null) {
        // timezone part
        if (match[9] != null) {
          // timezone other than 'Z' and 'z'.
          int sign = (match[9] == '-') ? -1 : 1;
          int hourDifference = int.parse(match[10]);
          int minuteDifference = parseIntOrZero(match[11]);
          minuteDifference += 60 * hourDifference;
          minute -= sign * minuteDifference;
        }
      }
      int value =
          _dateToEpoch(years, month, day, hour, minute, second, millisecond);

      if (value == null) {
        throw FormatException("Time out of range", formattedString);
      }
      return EtDatetime._withValue(value);
    } else {
      throw FormatException("Invalid date format", formattedString);
    }
  }

  static EtDatetime tryParse(String formattedString) {
    try {
      return parse(formattedString);
    } on FormatException {
      return null;
    }
  }

  int get year => ((1 / 1461) * (4 * (moment - ethiopicEpoch) + 1463)).floor();

  int get month =>
      (((1 / 30) * (moment - _dateToEpoch(year, 1, 1, 1, 1, 1, 1))).floor() +
          1);

  String get monthGeez {
    return _months[(month - 1) % 13];
  }

  int get day => moment + 1 - _dateToEpoch(year, month, 1, 1, 1, 1, 1);

  String get dayGeez {
    return _dayNumbers[(day - 1) % 30];
  }

  int get hour {
    int yearRemainder = this.moment % yearMilliSec;
    int monthRemainder = yearRemainder % monthMilliSec;
    int dateRemainder = monthRemainder % dayMilliSec;
    return ((initialHour +
                ((dateRemainder ~/ hourMilliSec) % 12 != 0
                    ? (dateRemainder ~/ hourMilliSec) % 12
                    : 12)) %
            24) -
        6;
  }

  int get minute {
    int yearRemainder = this.moment % yearMilliSec;
    int monthRemainder = yearRemainder % monthMilliSec;
    int dateRemainder = monthRemainder % dayMilliSec;
    int hourRemainder = dateRemainder % hourMilliSec;
    return ((hourRemainder ~/ minMilliSec) % 60 != 0
            ? (hourRemainder ~/ minMilliSec) % 60
            : 60) %
        60;
  }

  int get second {
    int yearRemainder = this.moment % yearMilliSec;
    int monthRemainder = yearRemainder % monthMilliSec;
    int dateRemainder = monthRemainder % dayMilliSec;
    int hourRemainder = dateRemainder % hourMilliSec;
    int minuteRemainder = hourRemainder % minMilliSec;
    return minuteRemainder ~/ secMilliSec;
  }

  int get millisecond {
    int yearRemainder = this.moment % yearMilliSec;
    int monthRemainder = yearRemainder % monthMilliSec;
    int dateRemainder = monthRemainder % dayMilliSec;
    int hourRemainder = dateRemainder % hourMilliSec;
    int minuteRemainder = hourRemainder % minMilliSec;
    return minuteRemainder % secMilliSec;
  }

/*
   * Returns the first day of the year
   */
  int _yearFirstDay() {
    int ameteAlem = _ameteFida + year;
    int rabeet = ameteAlem ~/ 4;
    return (ameteAlem + rabeet) % 7;
  }

  int get yearFirstDay => _yearFirstDay();

/*
   * Returns the first day of the month
   */
  int get weekday => (yearFirstDay + ((month - 1) * 2)) % 7;

/*
   * Returns true if [this._year] is leap year or
   * returns false.
  */
  bool get isLeap => year % 4 == 3;

  static String _fourDigits(int n) {
    int absN = n.abs();
    String sign = n < 0 ? "-" : "";
    if (absN >= 1000) return "$n";
    if (absN >= 100) return "${sign}0$absN";
    if (absN >= 10) return "${sign}00$absN";
    return "${sign}000$absN";
  }

  static String _sixDigits(int n) {
    assert(n < -9999 || n > 9999);
    int absN = n.abs();
    String sign = n < 0 ? "-" : "+";
    if (absN >= 100000) return "$sign$absN";
    return "${sign}0$absN";
  }

  static String _threeDigits(int n) {
    if (n >= 100) return "$n";
    if (n >= 10) return "0$n";
    return "00$n";
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  static int _dateToEpoch(int year, int month, int date, int hour, int minute,
      int second, int millisecond) {
//    int a = ((yearMilliSec * year).abs() +
//            (monthMilliSec * month).abs() +
//            (dayMilliSec * date).abs() +
//            (hourMilliSec * hour).abs() +
//            (millisecondsPerMinute * minute).abs() +
//            (millisecondsPerSecond * second).abs() +
//            millisecond.abs()) -
//        (biginningEpoch * 1000);
//    return a.toInt();
    return (ethiopicEpoch -
        1 +
        365 * (year - 1) +
        (year / 4).floor() +
        30 * (month - 1) +
        date);
  }

  EtDatetime._withValue(this.moment) {
    if (DateTime.now().millisecondsSinceEpoch.abs() >
            _maxMillisecondsSinceEpoch ||
        (DateTime.now().millisecondsSinceEpoch.abs() ==
            _maxMillisecondsSinceEpoch)) {
      throw ArgumentError(
          "Calendar is outside valid range: ${DateTime.now().millisecondsSinceEpoch}");
    }
  }

  String toString() {
    String y = _fourDigits(year);
    String m = _twoDigits(month);
    String d = _twoDigits(day);
    String h = _twoDigits(hour);
    String min = _twoDigits(minute);
    String sec = _twoDigits(second);
    String ms = _threeDigits(millisecond);
    return "$y-$m-$d $h:$min:$sec.$ms";
  }

  String toJson() {
    return json.encode({
      "year": _fourDigits(year),
      "month": _twoDigits(month),
      "date": _twoDigits(day),
      "hour": _twoDigits(hour),
      "min": _twoDigits(minute),
      "sec": _twoDigits(second),
      "ms": _threeDigits(millisecond),
    });
  }

  String toIso8601String() {
    String y =
        (year >= -9999 && year <= 9999) ? _fourDigits(year) : _sixDigits(year);
    String m = _twoDigits(month);
    String d = _twoDigits(day);
    String h = _twoDigits(hour);
    String min = _twoDigits(minute);
    String sec = _twoDigits(second);
    String ms = _threeDigits(millisecond);
    return "$y-$m-${d}T$h:$min:$sec.$ms";
  }

  static final RegExp _parseFormat = RegExp(
      r'^([+-]?\d{4,6})-?(\d\d)-?(\d\d)' // Day part.
      r'(?:[ T](\d\d)(?::?(\d\d)(?::?(\d\d)(?:[.,](\d+))?)?)?$' // Time part.
      r'( ?[zZ]| ?([-+])(\d\d)(?::?(\d\d))?)?)?$');

  Duration difference(EtDatetime date) => Duration(days: moment - date.moment);

  EtDatetime add(Duration duration) {
    return EtDatetime.fromMillisecondsSinceEpoch(this.moment + duration.inDays);
  }

  EtDatetime subtract(Duration duration) {
    return EtDatetime.fromMillisecondsSinceEpoch(moment - duration.inDays);
  }

  bool isBefore(EtDatetime other) => moment < other.moment;

  bool isAfter(EtDatetime other) => moment > other.moment;

  bool isAtSameMomentAs(EtDatetime other) => moment == other.moment;

  int compareTo(EtDatetime other) {
    if (this.isBefore(other))
      return -1;
    else if (this.isAtSameMomentAs(other))
      return 0;
    else
      return 1;
  }

  // OVERRIDES
  @override
  List<Object> get props => null;

  @override
  bool get stringify => true;
}
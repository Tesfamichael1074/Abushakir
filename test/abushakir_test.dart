import 'package:test/test.dart';

import 'package:abushakir/abushakir.dart';

void main() {
  group('Parameterized Constructors :', () {
    EtDatetime ec;

    setUp(() {
      ec = EtDatetime(year: 2012, month: 07, day: 07);
    });

    test('Testing Year on Parameterized Constructor', () {
      expect(ec.year, 2012);
    });

    test('Testing Month on Parameterized Constructor', () {
      expect(ec.month, 07);
    });

    test('Testing Day on Parameterized Constructor', () {
      expect(ec.day, 07);
    });

    test('Testing Date on Parameterized Constructor', () {
      expect(ec.dayGeez, "፯");
    });
  });

  group('Parameterized Constructors (year only) :', () {
    EtDatetime ec;

    setUp(() {
      ec = EtDatetime(year: 2010);
    });

    test('Testing Year on Parameterized Constructor', () {
      expect(ec.year, 2010);
    });

    test('Testing Month on Parameterized Constructor', () {
      expect(ec.month, 01);
    });

    test('Testing Day on Parameterized Constructor', () {
      expect(ec.day, 01);
    });
  });

  group('Named Constructors (.parse) :', () {
    EtDatetime ec;

    setUp(() {
      ec = EtDatetime.parse("2012-07-07 15:12:17.500");
    });
    
    test('Should Print the parsed Date and Time', () {
      expect(ec.toString(), "2012-07-07 15:12:17.500");
    });

    test('Testing Year on Named Constructor', () {
      expect(ec.year, 2012);
    });

    test('Testing Month on Named Constructor', () {
      expect(ec.month, 07);
    });

    test('Testing Day on Named Constructor', () {
      expect(ec.day, 07);
    });

    test('Testing Date with Named Constructor', () {
      expect(ec.dayGeez, "፯");
    });

    test('Testing Hour on Named Constructor', () {
      expect(ec.hour, 15);
    });

    test('Testing Minute on Named Constructor', () {
      expect(ec.minute, 12);
    });

    test('Testing Second on Named Constructor', () {
      expect(ec.second, 17);
    });

    test('Testing Millisecond on Named Constructor', () {
      expect(ec.millisecond, 500);
    });
  });

  group('Named Constructors (.now) :', () {
    EtDatetime ec;

    setUp(() {
      ec = EtDatetime.now();
    });
    test('Testing Minute on .now() Named Constructor', () {
      expect(ec.minute, DateTime.now().minute);
    });

    test('Testing Second on .now() Named Constructor', () {
      expect(ec.second, DateTime.now().second);
    });
  });

  group('Named Constructors (.fromMillisecondsSinceEpoch) :', () {
    EtDatetime ec;

    // 1585742246021 == 2012-07-23 11:57:26.021
    setUp(() {
      ec = EtDatetime.fromMillisecondsSinceEpoch(1585742246021);
    });

    test('Should Print the parsed Date and Time', () {
      expect(ec.toString(), "2012-07-23 11:57:26.021");
    });

    test('Testing Year on Named Constructor', () {
      expect(ec.year, 2012);
    });

    test('Testing Month on Named Constructor', () {
      expect(ec.month, 07);
    });

    test('Testing Day on Named Constructor', () {
      expect(ec.day, 23);
    });

    test('Testing Date with Named Constructor', () {
      expect(ec.dayGeez, "፳፫");
    });

    test('Testing Hour on Named Constructor', () {
      expect(ec.hour, 11);
    });

    test('Testing Minute on Named Constructor', () {
      expect(ec.minute, 57);
    });

    test('Testing Second on Named Constructor', () {
      expect(ec.second, 26);
    });

    test('Testing Millisecond on Named Constructor', () {
      expect(ec.millisecond, 021);
    });
  });

  group('Named Constructors (.now) :', () {
    EtDatetime ec;

    setUp(() {
      ec = EtDatetime.now();
    });
    test('Testing Minute on .now() Named Constructor', () {
      expect(ec.minute, DateTime.now().minute);
    });

    test('Testing Second on .now() Named Constructor', () {
      expect(ec.second, DateTime.now().second);
    });
  });

  group('Testing functions', () {
    EtDatetime ec;
    setUp(() {
      ec = EtDatetime.now();
    });
    // 1585742246021 == 2012-07-23 11:57:26.021
    test('Testing isAfter()', () {
      expect(ec.isAfter(EtDatetime(year: 2011)), true);
    });
    test('Testing isBefore()', () {
      expect(ec.isBefore(EtDatetime(year: 2080)), true);
    });
    test('Testing isAfter()', () {
      expect(
          ec.isAtSameMomentAs(EtDatetime(
              year: ec.year,
              month: ec.month,
              day: ec.day,
              hour: ec.hour,
              minute: ec.minute,
              second: ec.second,
              millisecond: ec.millisecond)),
          true);
    });
  });
  group('BahireHasab :', () {
    BahireHasab bh;

    setUp(() {
      bh = BahireHasab();
    });

    test('Testing Abekte', () {
      expect(bh.getAbekte(), 6);
    });

    test('Testing Metkih', () {
      expect(bh.getMetkih(), 24);
    });

    test('Testing Nenewe', () {
      expect(bh.getNenewe(), {'month': 'የካቲት', 'date': 2});
    });

    // getSingleBealOrTsom

    test("Testing 'ነነዌ' on getSingleBealOrTsom", () {
      expect(bh.getSingleBealOrTsom("ነነዌ"), {'month': 'የካቲት', 'date': 2});
    });
    test("Testing 'ዓቢይ ጾም' on getSingleBealOrTsom", () {
      expect(bh.getSingleBealOrTsom("ዓቢይ ጾም"), {'month': 'የካቲት', 'date': 16});
    });

    test("Testing 'ደብረ ዘይት' on getSingleBealOrTsom", () {
      expect(bh.getSingleBealOrTsom("ደብረ ዘይት"), {'month': 'መጋቢት', 'date': 13});
    });

    test("Testing 'ሆሣዕና' on getSingleBealOrTsom", () {
      expect(bh.getSingleBealOrTsom("ሆሣዕና"), {'month': 'ሚያዝያ', 'date': 4});
    });

    test("Testing 'ስቅለት' on getSingleBealOrTsom", () {
      expect(bh.getSingleBealOrTsom("ስቅለት"), {'month': 'ሚያዝያ', 'date': 9});
    });

    test("Testing 'ትንሳኤ' on getSingleBealOrTsom", () {
      expect(bh.getSingleBealOrTsom("ትንሳኤ"), {'month': 'ሚያዝያ', 'date': 11});
    });

    test("Testing 'ርክበ ካህናት' on getSingleBealOrTsom", () {
      expect(bh.getSingleBealOrTsom("ርክበ ካህናት"), {'month': 'ግንቦት', 'date': 5});
    });

    test("Testing 'ዕርገት' on getSingleBealOrTsom", () {
      expect(bh.getSingleBealOrTsom("ዕርገት"), {'month': 'ግንቦት', 'date': 20});
    });

    test("Testing 'ጰራቅሊጦስ' on getSingleBealOrTsom", () {
      expect(bh.getSingleBealOrTsom("ጰራቅሊጦስ"), {'month': 'ግንቦት', 'date': 30});
    });

    test("Testing 'ጾመ ሐዋርያት' on getSingleBealOrTsom", () {
      expect(bh.getSingleBealOrTsom("ጾመ ሐዋርያት"), {'month': 'ሰኔ', 'date': 1});
    });

    test("Testing 'ጾመ ድህነት' on getSingleBealOrTsom", () {
      expect(bh.getSingleBealOrTsom("ጾመ ድህነት"), {'month': 'ሰኔ', 'date': 3});
    });
  });
}

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver driver;
//  String platform;

  Future<bool> isDeviceBig() => driver
      .getBottomRight(find.byValueKey('FramyApp'))
      .then((offset) => offset.dx >= 1000);

  setUpAll(() async {
    driver = await FlutterDriver.connect();
//    platform = Platform.environment['PLATFORM'] ?? 'default_macos';
  });

  tearDownAll(() async {
    if (driver != null) {
      driver.close();
    }
  });

  group('UserDataCard', () {
    setUpAll(() async {
      if (!await isDeviceBig()) {
        await driver.tap(find.byTooltip('Open navigation menu'));
      }
      await driver.waitFor(find.text('UserDataCard'));
      await driver.tap(find.text('UserDataCard'));
    });

    test('should have UserDataCard in UserDataCard page', () async {
      await driver.waitFor(find.byValueKey('UserDataCard'));
    });

    test('should allow to change user parameters', () async {
      if (!await isDeviceBig()) {
        await driver.tap(find.byValueKey('FramyWidgetDependenciesButton'));
      }
      await driver.waitFor(find.byValueKey('FramyWidgetDependenciesPanel'));
      await driver.waitFor(find.text('user'));
      await driver.waitFor(find.text('firstName'));
      await driver.tap(find.byValueKey('framy_dependency_firstName_input'));
      await driver.enterText('John');
      await driver.tap(find.byValueKey('framy_dependency_lastName_input'));
      await driver.enterText('Doe');
      await driver.tap(find.byValueKey('framy_dependency_age_input'));
      await driver.enterText('17');
      await driver.waitFor(find.text('John Doe'));
      await driver.waitFor(find.text('Age: 17'));
    });

    test('should allow to use a user preset', () async {
      await driver.tap(find.byValueKey('framy_user_preset_dropdown'));
      await driver.tap(find.text('teenageJohn'));
      await driver.waitFor(find.text('John Smith'));
      await driver.waitFor(find.text('Age: 13'));
      await driver
          .waitForAbsent(find.byValueKey('framy_dependency_firstName_input'));
      await driver
          .waitForAbsent(find.byValueKey('framy_dependency_lastName_input'));
      await driver.waitForAbsent(find.byValueKey('framy_dependency_age_input'));
    });

    test('should come back to custom user', () async {
      await driver.tap(find.byValueKey('framy_user_preset_dropdown'));
      await driver.tap(find.text('Custom'));
      await driver.waitFor(find.text('John Doe'));
      await driver.waitFor(find.text('Age: 17'));
    });

    test('should set user to null', () async {
      await driver.tap(find.byValueKey('framy_dependency_user_null_switch'));
      await driver.waitFor(find.text('null null'));
      await driver.waitFor(find.text('Age: null'));
    });
  });
}

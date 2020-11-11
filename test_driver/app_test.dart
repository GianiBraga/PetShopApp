import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

//Comando para executar o teste:
//flutter drive --target=test_driver/app.dart

void main() {
  group('Counter Integration', () {
    final buttonFinder = find.byValueKey('login');
    final emailField = find.byValueKey('enterEmail');
    final senhaField = find.byValueKey('enterSenha');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    // tearDownAll(() async {
    //   if (driver != null) {
    //     driver.close();
    //   }
    // });

    test('Realizando login...', () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(emailField);
        await driver.enterText('augusto@gmail.com');
        await driver.waitFor(find.text('augusto@gmail.com'));
        await driver.tap(senhaField);
        await driver.enterText('123456789');
        await driver.waitFor(find.text('123456789'));
        await driver.tap(buttonFinder);
      });
    });
  });
}

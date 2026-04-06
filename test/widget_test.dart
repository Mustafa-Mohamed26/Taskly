import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/main.dart';
import 'package:taskly/config/di/di.dart';

void main() {
  setUpAll(() {
    configureDependencies();
  });

  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the splash screen shows up
    expect(find.text('Taskly'), findsWidgets);
    
    // Wait for the splash screen animation
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}

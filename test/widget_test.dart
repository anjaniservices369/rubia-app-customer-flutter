import 'package:flutter_test/flutter_test.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:base_project_flutter/main.dart';

void main() {
  testWidgets('app starts at the configured splash screen', (tester) async {
    await tester.pumpWidget(
      MyApp(
        key: MyApp.navigatorKey,
        checkAuth: '',
      ),
    );

    expect(find.byType(MyApp), findsOneWidget);
    expect(find.byType(AnimatedSplashScreen), findsOneWidget);
  });
}

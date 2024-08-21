
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import "package:pomo_app/constants/constants.dart" as con;

import 'package:pomo_app/main.dart';

void main() {
  testWidgets('Settings dialog opens', (WidgetTester tester) async {
    
    await tester.pumpWidget(const ProviderScope(child: PomoApp()));

    // Verify settings not open
    expect(find.text(con.shortBreakLabel), findsOneWidget);
    expect(find.text(con.settingsLabel), findsNothing);

    // Tap the settings icon
    await tester.tap(find.byKey(con.settingsKey));
    await tester.pump();

    // Verify settings dialog open
    expect(find.text(con.settingsLabel), findsOneWidget);
  });
}

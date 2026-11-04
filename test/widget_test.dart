import 'package:flutter_test/flutter_test.dart';
import 'package:mis_teams/app/app.dart';
import 'package:mis_teams/core/bindings/initial_binding.dart';
import 'package:mis_teams/core/localization/app_localization.dart';
import 'package:mis_teams/core/storage/local_storage.dart';

void main() {
  testWidgets('App renders splash screen', (WidgetTester tester) async {
    await AppLocalization.init(InMemoryLocalStorage());
    InitialBinding().dependencies();
    await tester.pumpWidget(const MisTeamsApp());
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('MIS TEAMS'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2500));
  });
}

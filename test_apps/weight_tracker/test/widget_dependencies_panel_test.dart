import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weight_tracker/main.app.framy.dart';
import 'package:weight_tracker/models/user.dart';

import 'test_utils.dart';

void main() {
  group('FramyWidgetDependenciesPanel with User dependency', () {
    List<FramyDependencyModel> dependencies;

    setUp(() {
      dependencies = [FramyDependencyModel<User>('user', 'User', null)];
    });

    testWidgets('should build', (WidgetTester tester) async {
      await tester.pumpWidget(FramyAppWrapperWithScaffold(
        FramyWidgetDependenciesPanel(
          dependencies: dependencies,
          presets: {},
        ),
      ));
      expect(find.byKey(Key('FramyWidgetDependenciesPanel')), findsOneWidget);
    });

    testWidgets('should emit updated user when fields are changed',
        (WidgetTester tester) async {
      //given
      User emitted;
      await tester.pumpWidget(FramyAppWrapperWithScaffold(
        FramyWidgetDependenciesPanel(
          dependencies: dependencies,
          onChanged: (dependency) => emitted = dependency.value,
          presets: {},
        ),
      ));
      //when
      await tester.enterText(
          find.byKey(Key('framy_dependency_firstName_input')), 'John');
      await tester.enterText(
          find.byKey(Key('framy_dependency_age_input')), '23');
      //then
      expect(emitted.firstName, 'John');
      expect(emitted.age, 23);
    });
  });
}

import 'package:counter_app/main.app.framy.dart';
import 'package:counter_app/main.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {
  group('FramyCounterTitleCustomPage', () {
    testWidgets('should build', (tester) async {
      await tester.pumpWidget(FramyAppWrapper(FramyCounterTitleCustomPage()));
      expect(find.byKey(Key('Framy_CounterTitle_Page')), findsOneWidget);
    });

    testWidgets('should have CounterTitle', (tester) async {
      await tester.pumpWidget(FramyAppWrapper(FramyCounterTitleCustomPage()));
      expect(find.byType(CounterTitle), findsOneWidget);
    });

    testWidgets('should have DevicePreview', (tester) async {
      await tester.pumpWidget(FramyAppWrapper(FramyCounterTitleCustomPage()));
      expect(
        find.descendant(
          of: find.byType(FramyCounterTitleCustomPage),
          matching: find.byType(DevicePreview),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should have default title', (tester) async {
      await tester.pumpWidget(FramyAppWrapper(FramyCounterTitleCustomPage()));
      expect(find.text('You have pushed the button this many times:'),
          findsOneWidget);
    });

    testWidgets('should have FramyWidgetDependenciesPanel', (tester) async {
      await tester.pumpWidget(FramyAppWrapper(FramyCounterTitleCustomPage()));
      expect(find.byType(FramyWidgetDependenciesPanel), findsOneWidget);
    });

    testWidgets(
        'should open FramyWidgetDependenciesPanel on FAB tap on smaller devices',
        (tester) async {
      //given
      tester.binding.window.physicalSizeTestValue = Size(500, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpWidget(FramyAppWrapper(FramyCounterTitleCustomPage()));
      expect(find.byType(FramyWidgetDependenciesPanel), findsNothing);
      //when
      await tester.tap(find.byKey(Key('FramyWidgetDependenciesButton')));
      await tester.pumpAndSettle();
      //then
      expect(find.byType(FramyWidgetDependenciesPanel), findsOneWidget);
      tester.binding.window.physicalSizeTestValue = null;
    });

    testWidgets('should change displayed text when typed in panel',
        (tester) async {
      //given
      await tester.pumpWidget(FramyAppWrapper(FramyCounterTitleCustomPage()));
      //when
      await tester.enterText(
          find.byKey(Key('framy_dependency_verb_input')), 'foo');
      await tester.pump();
      //then
      expect(find.text('You have foo the button this many times:'),
          findsOneWidget);
    });

    Future<void> selectInDropdown(
      WidgetTester tester,
      String text,
      String fieldName,
    ) async {
      await tester.tap(find.byKey(Key('framy_${fieldName}_preset_dropdown')));
      await tester.pump();
      await tester.tap(find.text(text).last);
      await tester.pump();
    }

    testWidgets(
        'should restore default value after setting to null and setting back to non-null',
        (tester) async {
      //given
      await tester.pumpWidget(FramyAppWrapper(FramyCounterTitleCustomPage()));
      expect(find.text('You have pushed the button this many times:'),
          findsOneWidget);
      //when
      //set to null
      await selectInDropdown(tester, 'Null', 'verb');
      expect(find.text('You have null the button this many times:'),
          findsOneWidget);
      //set to non-null
      await selectInDropdown(tester, 'Custom', 'verb');
      //then
      expect(
        find.text('You have pushed the button this many times:'),
        findsOneWidget,
      );
    });
  });
}

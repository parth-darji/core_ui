import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_ui/core_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UIColors & UITypography Design Tokens', () {
    test('UIColors definitions match custom design guidelines', () {
      expect(UIColors.primaryBlue, equals(const Color(0xFF0F2C59)));
      expect(UIColors.pitambarGold, equals(const Color(0xFFD4AF37)));
      expect(UIColors.lotusRose, equals(const Color(0xFFF28F8F)));
      expect(UIColors.systemBackground, equals(const Color(0xFFFAF8F5)));
      expect(UIColors.cardBackground, equals(const Color(0xFFFFFFFF)));
      expect(UIColors.textPrimary, equals(const Color(0xFF1A1A1A)));
      expect(UIColors.textSecondary, equals(const Color(0xFF7A7A7A)));
      expect(UIColors.separator, equals(const Color(0xFFEDEDED)));
    });

    test('UITypography styles are mapped to Inter font family', () {
      expect(UITypography.fontFamily, equals('packages/core_ui/Inter'));
      expect(UITypography.displayLarge.fontFamily,
          equals('packages/core_ui/Inter'));
      expect(UITypography.headlineLarge.fontFamily,
          equals('packages/core_ui/Inter'));
      expect(
          UITypography.bodyLarge.fontFamily, equals('packages/core_ui/Inter'));
      expect(
          UITypography.labelLarge.fontFamily, equals('packages/core_ui/Inter'));
    });
  });

  group('Core Reusable Widgets Tests', () {
    testWidgets('UIFilledButton renders correctly and handles presses',
        (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIFilledButton(
              text: 'Click Me',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
      await tester.tap(find.text('Click Me'));
      expect(pressed, isTrue);
    });

    testWidgets('UITextButton renders correctly and handles presses',
        (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UITextButton(
              text: 'Text Link',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Text Link'), findsOneWidget);
      await tester.tap(find.text('Text Link'));
      expect(pressed, isTrue);
    });

    testWidgets('UICard variants render correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                UICard.filled(child: Text('Filled Card')),
                UICard.elevated(child: Text('Elevated Card')),
                UICard.outlined(child: Text('Outlined Card')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Filled Card'), findsOneWidget);
      expect(find.text('Elevated Card'), findsOneWidget);
      expect(find.text('Outlined Card'), findsOneWidget);
    });

    testWidgets('UIBadge renders text content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIBadge(text: 'Active Status'),
          ),
        ),
      );

      expect(find.text('Active Status'), findsOneWidget);
    });

    testWidgets('UIListItem renders layout elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIListItem(
              title: 'Item Title',
              subtitle: 'Item Subtitle',
              trailing: Icon(Icons.arrow_forward),
            ),
          ),
        ),
      );

      expect(find.text('Item Title'), findsOneWidget);
      expect(find.text('Item Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('UIAvatar renders image or initials fallback',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIAvatar(initials: 'JD'),
          ),
        ),
      );

      expect(find.text('JD'), findsOneWidget);
    });

    testWidgets('UISegmentControl switches values',
        (WidgetTester tester) async {
      int selected = 0;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: UISegmentControl(
                  segments: const ['Tab A', 'Tab B'],
                  selectedIndex: selected,
                  onValueChanged: (val) {
                    setState(() {
                      selected = val;
                    });
                  },
                ),
              ),
            );
          },
        ),
      );

      expect(find.text('Tab A'), findsOneWidget);
      expect(find.text('Tab B'), findsOneWidget);
      await tester.tap(find.text('Tab B'));
      await tester.pump();
      expect(selected, equals(1));
    });

    testWidgets('UISpacing builds valid sized boxes',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Top'),
                UISpacing.md(),
                Text('Bottom'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(UISpacing), findsOneWidget);
    });

    testWidgets('UIDivider renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIDivider(
              height: 20,
              thickness: 2,
              indent: 10,
              endIndent: 10,
              color: Colors.red,
            ),
          ),
        ),
      );

      expect(find.byType(UIDivider), findsOneWidget);
    });

    testWidgets('UICheckbox toggles value on tap', (WidgetTester tester) async {
      bool checked = false;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: UICheckbox(
                  label: 'My Checkbox',
                  value: checked,
                  onChanged: (val) {
                    setState(() {
                      checked = val ?? false;
                    });
                  },
                ),
              ),
            );
          },
        ),
      );

      expect(find.text('My Checkbox'), findsOneWidget);
      expect(checked, isFalse);

      await tester.tap(find.text('My Checkbox'));
      await tester.pumpAndSettle();
      expect(checked, isTrue);
    });

    testWidgets('UIRadioGroup selects option on tap',
        (WidgetTester tester) async {
      String selected = 'Option A';
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: UIRadioGroup<String>(
                  options: const ['Option A', 'Option B'],
                  labelBuilder: (opt) => opt,
                  selectedOption: selected,
                  onSelected: (val) {
                    setState(() {
                      selected = val;
                    });
                  },
                ),
              ),
            );
          },
        ),
      );

      expect(find.text('Option A'), findsOneWidget);
      expect(find.text('Option B'), findsOneWidget);
      expect(selected, equals('Option A'));

      await tester.tap(find.text('Option B'));
      await tester.pumpAndSettle();
      expect(selected, equals('Option B'));
    });

    testWidgets('UISafeBottomSpacing renders with correct height',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UISafeBottomSpacing(
              fallbackMargin: 20.0,
            ),
          ),
        ),
      );

      final spacerFinder = find.byType(UISafeBottomSpacing);
      expect(spacerFinder, findsOneWidget);

      final SizedBox spacer = tester.widget(find.descendant(
        of: spacerFinder,
        matching: find.byType(SizedBox),
      ));
      expect(spacer.height, equals(20.0));
    });

    testWidgets('UIProgressBar renders dynamic width',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIProgressBar(
              value: 0.5,
              label: 'Progress Label',
            ),
          ),
        ),
      );

      expect(find.text('Progress Label'), findsOneWidget);
      expect(find.byType(UIProgressBar), findsOneWidget);
    });

    testWidgets(
        'UITooltipInfo renders trigger child and opens tooltip popover on tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: UITooltipInfo(
                title: 'Tooltip Title',
                message: 'Tooltip Message Body',
                child: Text('Tap Me for Info'),
              ),
            ),
          ),
        ),
      );

      // Verify trigger widget is rendered
      expect(find.text('Tap Me for Info'), findsOneWidget);
      expect(find.text('Tooltip Title'), findsNothing);
      expect(find.text('Tooltip Message Body'), findsNothing);

      // Tap to trigger tooltip
      await tester.tap(find.text('Tap Me for Info'));
      // Pump to start the animation and transition
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      // Verify tooltip modal contents are displayed
      expect(find.text('Tooltip Title'), findsOneWidget);
      expect(find.text('Tooltip Message Body'), findsOneWidget);
      expect(find.text('Tap Me for Info'), findsOneWidget);
    });

    testWidgets(
        'UIDialog renders titles and descriptions and closes on confirm',
        (WidgetTester tester) async {
      bool confirmed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    UIDialog.show(
                      context: context,
                      title: 'Dialog Title',
                      message: 'Dialog Content Message',
                      confirmLabel: 'Confirm Key',
                      onConfirm: () => confirmed = true,
                    );
                  },
                  child: const Text('Open Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('Dialog Title'), findsOneWidget);
      expect(find.text('Dialog Content Message'), findsOneWidget);

      await tester.tap(find.text('Confirm Key'));
      await tester.pumpAndSettle();

      expect(confirmed, isTrue);
      expect(find.text('Dialog Title'), findsNothing);
    });

    testWidgets(
        'UIBottomSheet renders details and closes on close button press',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    UIBottomSheet.show(
                      context: context,
                      title: 'Sheet Title',
                      child: const Text('Sheet Content Body'),
                    );
                  },
                  child: const Text('Open Sheet'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Sheet Title'), findsOneWidget);
      expect(find.text('Sheet Content Body'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('Sheet Title'), findsNothing);
    });

    testWidgets('UIDonutChart renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIDonutChart(
              centerTitle: 'Donut Title',
              centerSubtitle: 'Donut Subtitle',
              segments: [
                UIDonutSegment(percentage: 0.4, color: Colors.blue, label: 'A'),
                UIDonutSegment(percentage: 0.6, color: Colors.red, label: 'B'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Donut Title'), findsOneWidget);
      expect(find.text('Donut Subtitle'), findsOneWidget);
      expect(find.byType(UIDonutChart), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('UILineChart renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UILineChart(
              dataPoints: [1.0, 3.0, 2.0, 5.0],
            ),
          ),
        ),
      );

      expect(find.byType(UILineChart), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('UIPinCodeField renders error state and text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIPinCodeField(
              pin: '12',
              length: 4,
              obscure: false,
              hasError: true,
              errorText: 'Wrong passcode entered',
            ),
          ),
        ),
      );

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('Wrong passcode entered'), findsOneWidget);
      expect(find.byType(UIPinCodeField), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('UIErrorState renders title, message, and triggers action button',
        (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIErrorState(
              title: 'Error Header',
              message: 'Detailed error message description',
              errorCode: 'ERR_500',
              actionLabel: 'RETRY ACTION',
              onActionPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Error Header'), findsOneWidget);
      expect(find.text('Detailed error message description'), findsOneWidget);
      expect(find.text('Error Code: ERR_500'), findsOneWidget);
      expect(find.text('RETRY ACTION'), findsOneWidget);
      expect(pressed, isFalse);

      await tester.tap(find.text('RETRY ACTION'));
      await tester.pump();
      expect(pressed, isTrue);
    });

    testWidgets('UIOutlinedButton renders text and prefix icon and handles taps',
        (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIOutlinedButton(
              text: 'CANCEL',
              prefix: const Icon(Icons.close),
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('CANCEL'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(pressed, isFalse);

      await tester.tap(find.text('CANCEL'));
      await tester.pump();
      expect(pressed, isTrue);
    });

    testWidgets('UISnackbar renders normal, error and success variants',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    UISnackbar.show(
                      context,
                      message: 'Test message',
                      title: 'Test Title',
                      isSuccess: true,
                    );
                  },
                  child: const Text('SHOW'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('SHOW'));
      await tester.pumpAndSettle();

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test message'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
    });
  });
}

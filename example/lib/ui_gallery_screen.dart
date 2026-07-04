import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// A premium, beautiful showcase screen to preview and test all reusable Material 3 widgets.
class UIGalleryScreen extends StatefulWidget {
  const UIGalleryScreen({super.key});

  @override
  State<UIGalleryScreen> createState() => _UIGalleryScreenState();
}

class _UIGalleryScreenState extends State<UIGalleryScreen>
    with SingleTickerProviderStateMixin {
  // State for interactive widgets
  bool _checkboxVal1 = true;
  bool _checkboxVal2 = false;
  String _radioVal = 'Option 1';
  int _segmentVal = 0;
  Set<String> _segmentedButtonVal = {'A'};
  bool _switchVal1 = true;
  bool _switchVal2 = false;
  double _sliderVal = 45.0;
  final TextEditingController _inputController =
      TextEditingController(text: 'Antigravity');
  final TextEditingController _pinController =
      TextEditingController(text: '1234');
  bool _hasPinError = false;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      // Force rebuild on tab swipe/animation
      setState(() {});
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _pinController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UIAppBar(
        title: 'Component Gallery',
        centerTitle: true,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabController.index,
        onDestinationSelected: (index) {
          setState(() {
            _tabController.index = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.smart_button),
            label: 'Controls',
          ),
          NavigationDestination(
            icon: Icon(Icons.text_fields),
            label: 'Inputs',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart),
            label: 'Charts',
          ),
          NavigationDestination(
            icon: Icon(Icons.notification_important),
            label: 'Alerts',
          ),
        ],
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildControlsTab(),
            _buildInputsAndCardsTab(),
            _buildDataAndChartsTab(),
            _buildAlertsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlsTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const UISectionHeader(title: 'Buttons'),
        Row(
          children: [
            Expanded(
              child: UIFilledButton(
                text: 'Filled Button',
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: UIFilledButton(
                text: 'Loading',
                isLoading: true,
                onPressed: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: UIFilledButton(
                text: 'Disabled',
                onPressed: null,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: UITextButton(
                text: 'Text Button',
                onPressed: () {},
              ),
            ),
          ],
        ),
        const Divider(color: UIColors.separator, height: 32.0),
        const UISectionHeader(title: 'Selection Controls'),
        UICard(
          child: Column(
            children: [
              UICheckbox(
                label: 'Checkbox Active',
                value: _checkboxVal1,
                onChanged: (val) {
                  setState(() => _checkboxVal1 = val ?? false);
                },
              ),
              UICheckbox(
                label: 'Checkbox Inactive',
                value: _checkboxVal2,
                onChanged: (val) {
                  setState(() => _checkboxVal2 = val ?? false);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        UICard(
          child: UIRadioGroup<String>(
            options: const ['Option 1', 'Option 2', 'Option 3'],
            labelBuilder: (opt) => opt,
            selectedOption: _radioVal,
            onSelected: (val) {
              setState(() => _radioVal = val);
            },
          ),
        ),
        const Divider(color: UIColors.separator, height: 32.0),
        const UISectionHeader(title: 'Sliders & Switches'),
        UICard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Switch Active', style: UITypography.bodyMedium),
                  UISwitch(
                    value: _switchVal1,
                    onChanged: (val) {
                      setState(() => _switchVal1 = val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Switch Inactive', style: UITypography.bodyMedium),
                  UISwitch(
                    value: _switchVal2,
                    onChanged: (val) {
                      setState(() => _switchVal2 = val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  const Icon(Icons.volume_down),
                  Expanded(
                    child: UISlider(
                      value: _sliderVal,
                      onChanged: (val) {
                        setState(() => _sliderVal = val);
                      },
                    ),
                  ),
                  const Icon(Icons.volume_up),
                ],
              ),
            ],
          ),
        ),
        const Divider(color: UIColors.separator, height: 32.0),
        const UISectionHeader(title: 'Segment Controls'),
        UISegmentControl(
          segments: const ['Teal', 'Mint', 'Green'],
          selectedIndex: _segmentVal,
          onValueChanged: (val) {
            setState(() => _segmentVal = val);
          },
        ),
        const SizedBox(height: 12.0),
        UISegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'A', label: Text('Segment A')),
            ButtonSegment(value: 'B', label: Text('Segment B')),
            ButtonSegment(value: 'C', label: Text('Segment C')),
          ],
          selected: _segmentedButtonVal,
          onSelectionChanged: (val) {
            setState(() => _segmentedButtonVal = val);
          },
        ),
      ],
    );
  }

  Widget _buildInputsAndCardsTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const UISectionHeader(title: 'Form Inputs'),
        UIInput(
          labelText: 'Username Input',
          hintText: 'Enter username...',
          controller: _inputController,
        ),
        const UIInput(
          labelText: 'Password Input',
          hintText: 'Enter password...',
          obscureText: true,
        ),
        const UIInput(
          labelText: 'Error State Input',
          hintText: 'Typo here...',
          errorText: 'Username already taken.',
        ),
        UIDropdown<String>(
          value: 'Item 1',
          items: const [
            DropdownMenuItem(value: 'Item 1', child: Text('Option One')),
            DropdownMenuItem(value: 'Item 2', child: Text('Option Two')),
            DropdownMenuItem(value: 'Item 3', child: Text('Option Three')),
          ],
          onChanged: (val) {},
          labelText: 'Dropdown Option Selector',
        ),
        const Divider(color: UIColors.separator, height: 32.0),
        const UISectionHeader(title: 'Pin / OTP Input'),
        UICard(
          child: Column(
            children: [
              const Text('Enter 4-Digit OTP', style: UITypography.titleMedium),
              const SizedBox(height: 12.0),
              UIPinCodeField(
                pin: _pinController.text,
                obscure: false,
                hasError: _hasPinError,
                errorText: 'Incorrect PIN. Hint: Use 1234',
              ),
              const SizedBox(height: 12.0),
              UINumericKeypad(
                onKeyPress: (key) {
                  setState(() {
                    _hasPinError = false; // Reset error state on new key press
                    if (key == '⌫') {
                      if (_pinController.text.isNotEmpty) {
                        _pinController.text = _pinController.text
                            .substring(0, _pinController.text.length - 1);
                      }
                    } else if (_pinController.text.length < 4) {
                      _pinController.text += key;
                      if (_pinController.text.length == 4 &&
                          _pinController.text != '1234') {
                        _hasPinError = true;
                      }
                    }
                  });
                },
              ),
            ],
          ),
        ),
        const Divider(color: UIColors.separator, height: 32.0),
        const UISectionHeader(title: 'Cards'),
        const UICard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Elevated Custom Card', style: UITypography.titleLarge),
              SizedBox(height: 8.0),
              Text('Clean Material 3 elevations applied automatically.',
                  style: UITypography.bodyMedium),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        const UIPictureCard(
          mediaSource:
              'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=500',
          title: 'Nature Banner Card',
          description: 'A premium image header card for content grids.',
        ),
        const Divider(color: UIColors.separator, height: 32.0),
        const UISectionHeader(title: 'List Items & Header Accordions'),
        UICard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              UIListItem(
                title: 'Item One',
                subtitle: 'A detailed explanation of Item One.',
                leading: const UIAvatar(initials: 'O'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(color: UIColors.separator, height: 1.0),
              UIListItem(
                title: 'Item Two',
                subtitle: 'Another detailed item block.',
                leading: const UIAvatar(initials: 'T'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        const UICard(
          padding: EdgeInsets.zero,
          child: UIAccordion(
            title: 'Collapsible Policy Details',
            child: Text(
              'Here is some hidden content. You can tap on the accordion header to expand or collapse this details panel smoothly.',
              style: UITypography.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataAndChartsTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const UISectionHeader(title: 'Badges & Avatars'),
        const UICard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              UIAvatar(initials: 'JD', radius: 24.0),
              UIAvatar(
                imageUrl:
                    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100',
                radius: 24.0,
              ),
              UIBadge(text: 'Active'),
              UIBadge(
                text: 'Premium Member',
                isRound: true,
              ),
            ],
          ),
        ),
        const Divider(color: UIColors.separator, height: 32.0),
        const UISectionHeader(title: 'Charts'),
        const UICard(
          child: Column(
            children: [
              Text('Portfolio Performance Sparkline',
                  style: UITypography.titleMedium),
              SizedBox(height: 16.0),
              UILineChart(
                dataPoints: [20, 45, 28, 80, 55, 95, 120],
                height: 120.0,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        UICard(
          child: Column(
            children: [
              const Text('Asset Allocation Share',
                  style: UITypography.titleMedium),
              const SizedBox(height: 16.0),
              UIDonutChart(
                segments: [
                  UIDonutSegment(
                    percentage: 0.5,
                    color: Theme.of(context).colorScheme.primary,
                    label: 'Teal/Green',
                  ),
                  UIDonutSegment(
                    percentage: 0.3,
                    color: Theme.of(context).colorScheme.secondary,
                    label: 'Lime',
                  ),
                  UIDonutSegment(
                    percentage: 0.2,
                    color: Theme.of(context).colorScheme.error,
                    label: 'Coral',
                  ),
                ],
                centerTitle: '100%',
                centerSubtitle: 'Allocated',
              ),
            ],
          ),
        ),
        const Divider(color: UIColors.separator, height: 32.0),
        const UISectionHeader(title: 'Progress Indicators & Skeletons'),
        UICard(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  UILoading(),
                  UICircularProgressBar(
                    value: 0.72,
                    centerText: '72%',
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const UIProgressBar(
                value: 0.6,
                label: 'Downloading...',
                trailingLabel: '60%',
              ),
              const SizedBox(height: 16.0),
              const UISkeleton(
                width: double.infinity,
                height: 16.0,
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const UISkeleton.circular(size: 40.0),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      children: const [
                        UISkeleton(width: double.infinity, height: 10.0),
                        SizedBox(height: 6.0),
                        UISkeleton(width: 150.0, height: 10.0),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlertsTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const UISectionHeader(title: 'Snackbars'),
        UIFilledButton(
          text: 'Trigger Custom Snackbar',
          onPressed: () {
            UISnackbar.show(
              context,
              message: 'This is a premium M3 alert bar notification!',
            );
          },
        ),
        const Divider(color: UIColors.separator, height: 32.0),
        const UISectionHeader(title: 'Modals & Dialogs'),
        Row(
          children: [
            Expanded(
              child: UIFilledButton(
                text: 'Show Dialog',
                onPressed: () {
                  UIDialog.show(
                    context: context,
                    title: 'Confirm Operation',
                    message:
                        'Are you sure you want to deploy these changes to production?',
                    confirmLabel: 'Deploy Now',
                    cancelLabel: 'Cancel',
                    onConfirm: () {},
                  );
                },
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: UIFilledButton(
                text: 'Show Bottom Sheet',
                onPressed: () {
                  UIBottomSheet.show(
                    context: context,
                    title: 'Profile Settings',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Configure options for this active user account below.',
                          style: UITypography.bodyMedium,
                        ),
                        const SizedBox(height: 16.0),
                        UIFilledButton(
                          text: 'Save and Close',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const Divider(color: UIColors.separator, height: 32.0),
        const UISectionHeader(title: 'Empty States'),
        const UICard(
          child: UIEmptyState(
            title: 'No Transactions',
            description:
                'You haven\'t made any deposits or withdrawals in the last 30 days.',
            actionLabel: 'Refresh Feed',
          ),
        ),
        const Divider(color: UIColors.separator, height: 32.0),
        const UISectionHeader(title: 'Tooltips & Information Overlays'),
        UICard(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Need Information?', style: UITypography.bodyLarge),
                UITooltipInfo(
                  title: 'Security Information',
                  message:
                      'Your personal and transaction data is encrypted using AES-256 standards, backed by local biometrics. We do not store PIN details.',
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.help_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

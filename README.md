# `core_ui` Design System Package

A modular, reusable user interface library under `packages/core_ui` that encapsulates standard Material 3 design tokens, a premium financial color palette, typography styled using the bundled `Inter` font, and clean, elevated layout widgets. 

This design system completely moves away from Cupertino conventions and any custom components like floating tab bars, spring animations, bounce buttons, or glassmorphism/liquid glass overlays in favor of a minimalist, high-end, stock Material 3 design.

---

## 1. Design & Core Specifications

### 1.1 Premium Material 3 Colors
We define a highly curated, premium color palette optimized for high-end financial app aesthetics, fully utilizing Material 3 semantic structure:
* **Primary (Deep Forest Teal)**: `0xFF034443` — Used for main brand elements, high-emphasis buttons, and deep background layers.
* **Secondary / Accent (Bright Acid Lime)**: `0xFFD2F154` — Used for interactive accents, tab indicators, highlighted states, and call-to-actions.
* **Tertiary / Warning (Coral Orange)**: `0xFFF76F55` — Used for expense markers, outflows, and warning states.
* **Background (Premium Off-White)**: `0xFFF6F8F8` — Soft background canvas to give a clean and spacious modern interface.
* **Surface (Solid White)**: `0xFFFFFFFF` — Elevates cards and lists from the main background.
* **Text Primary (Midnight Charcoal)**: `0xFF1A1A1A` — High legibility dark gray text that avoids the harshness of pure black.
* **Text Secondary (Slate Grey)**: `0xFF7A7A7A` — Lower emphasis text for secondary subtitles, dates, and captions.

### 1.2 Layout & Elevation Components
* **Card Container (`CardGroup`)**:
  - Elevated layout cards with solid white background fills.
  - Border-radius values aligned with Material 3 Medium/Large cards (`16.0` to `24.0`).
  - Drop shadows use a soft, subtle blur: `BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10.0, offset: Offset(0, 4))`.
* **Standard Material 3 Navigation Bar**:
  - Main app shell uses the default, docked Material 3 `NavigationBar` inside the main Scaffold's `bottomNavigationBar`.
  - Displays the 5 core tabs (Home, Stats, Scan, History, Setting).
  - Handles the home indicator gesture safety automatically on iOS and Android.

### 1.3 Typography
* Render all text styles using the **Inter** font family.
* Bundle font files locally in `assets/fonts/Inter-Regular.ttf` and `assets/fonts/Inter-Bold.ttf` to guarantee 100% offline availability.
* Typographic scales align with the standard Material 3 TextTheme specifications (display, headline, title, body, label).

---

## 2. Proposed Directory Structure

```
packages/core_ui/
├── .gitignore
├── pubspec.yaml
├── README.md
├── assets/
│   └── fonts/
│       ├── Inter-Regular.ttf     # Local regular font
│       └── Inter-Bold.ttf        # Local bold font
├── lib/
│   ├── core_ui.dart              # Main package exports
│   └── src/
│       ├── tokens/
│       │   ├── ui_colors.dart    # Premium Material 3 color tokens
│       │   └── ui_typography.dart# Font style configurations (Inter-bound)
│       └── widgets/
│           └── card_group.dart   # Grouped list container card
└── test/
    ├── tokens_test.dart
    └── widgets/
        └── card_group_test.dart  # CardGroup layout tests
```

---

## 3. Package Configuration

Define `packages/core_ui/pubspec.yaml` with the following configuration:
```yaml
name: core_ui
description: Material 3 design tokens, clean layout components, and typography.
version: 1.0.0

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.0.0'

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  assets:
    - assets/fonts/
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
        - asset: assets/fonts/Inter-Bold.ttf
          weight: 700
```

---

## 4. Verification Plan

### Automated Widget & Unit Tests
We will implement widget tests to verify correct rendering of components under different theme states:
1. **Card Group Test**: Assert correct rounded corner margins and spacing.

Run tests:
```bash
flutter test packages/core_ui/test
```

Run static analysis:
```bash
flutter analyze packages/core_ui
```

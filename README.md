<p align="center">
	<img src="https://img.shields.io/github/last-commit/CodeWithIsmail/app-development-boot-camp-may-2026?style=flat-square&color=blue" />
	<img src="https://img.shields.io/github/issues/CodeWithIsmail/app-development-boot-camp-may-2026?style=flat-square&color=red" />

<img src="https://img.shields.io/github/issues-closed/CodeWithIsmail/app-development-boot-camp-may-2026?style=flat-square&color=green" />
<img src="https://img.shields.io/github/issues-pr/CodeWithIsmail/app-development-boot-camp-may-2026?style=flat-square&color=orange&label=Open%20PRs" />

<img src="https://img.shields.io/github/issues-pr-closed/CodeWithIsmail/app-development-boot-camp-may-2026?style=flat-square&color=blueviolet&label=Merged%20PRs" />
</p>
<p align="center">
	<a href="https://github.com/users/CodeWithIsmail/projects/5"><img src="https://img.shields.io/badge/Project_Board-Kanban-blue?style=for-the-badge&logo=github" /></a>
</p>

# MExpense

A robust, offline-first personal finance tracker built with Flutter. 

MExpense is an offline-first expense tracking application built with Flutter and Dart. It is structured around feature-first modularity, Separation of Concerns, and predictable state flow. The project is engineered for maintainability, scalability, and production-quality code organization.

<p align="center">
	<img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" />
	<img src="https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" />
	<img src="https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white" />
<img src="https://img.shields.io/badge/Provider-blueviolet?style=for-the-badge&logo=flutter&logoColor=white" /></p>

---

## Demo Video

<p align="center">
  <a href="https://youtube.com/shorts/_9q59Zxy3Wk?feature=share">
    <img src="https://img.youtube.com/vi/_9q59Zxy3Wk/maxresdefault.jpg" width="800"/>
  </a>
</p>

<p align="center">
  🎥 Click the image above to watch the demo video
</p>

---

## UI Screenshots

<p align="center">
  <img src="assets/ui/1-signup.jpg" width="30%"/>
  <img src="assets/ui/2-login.jpg" width="30%"/>
  <img src="assets/ui/3-homepage.jpg" width="30%"/>
</p>

<p align="center">
  <img src="assets/ui/4-add%20transaction.jpg" width="30%"/>
  <img src="assets/ui/5-date-expense%20bar%20chart.jpg" width="30%"/>
  <img src="assets/ui/6-category-expense%20pie%20chart.jpg" width="30%"/>
</p>

---

## Overview

MExpense manages personal finance workflows including authentication, transaction tracking, dashboard summaries, and statistical visualization. The technical focus is on disciplined architecture: clear layering, reusable UI building blocks, and stable local persistence. This architecture matters because it reduces coupling between presentation, state orchestration, and data access, which improves long-term delivery speed and maintainability.

<p align="center">
	<img src="https://img.shields.io/badge/Architecture-Feature--First-green?style=for-the-badge" />
	<img src="https://img.shields.io/badge/Code_Style-Clean_Architecture-orange?style=for-the-badge" />
	<img src="https://img.shields.io/badge/Offline--First-Enabled-success?style=for-the-badge&logo=icloud" />
</p>

---

## Features

- Authentication with secure local credential hashing and session restoration
- Transaction management for income/expense create, update, and delete flows
- Dashboard analytics with aggregated balance, income, and expense totals
- Statistics visualization with category and date-wise charting
- Local-first persistence using SQLite and Shared Preferences
- Responsive, modular UI composed from reusable shared components

---

## Tech Stack

- Flutter
- Dart
- Provider
- SQLite (`sqflite`)
- Shared Preferences
- fl_chart
- intl
- crypto

---

## Architecture

The codebase follows a Feature-First Layered Architecture.

- core/: Shared cross-feature modules (constants, models, utilities, reusable widgets, services, and database access).
- features/: Vertical feature slices (`auth`, `dashboard`, `stats`) that own their presentation behavior.
- data/: Implemented through `core/database` and `core/services`, responsible for local persistence, session handling, and data operations.
- presentation/: Implemented inside each feature under `presentation/`, responsible for providers, screens, and feature widgets.

Responsibility split:

- UI rendering is handled in feature screens and widgets.
- Reactive state transitions are handled by feature providers.
- Persistence and session concerns are handled by database and service modules.

---

## Project Structure

```txt
lib/
├── main.dart                                 # Application bootstrap, MultiProvider wiring, root MaterialApp
├── core/
│   ├── constants/
│   │   ├── constants.dart                    # Shared app-level constants and theme-related values
│   │   └── data.dart                         # Static domain lists and predefined data used by features
│   ├── database/
│   │   └── database_helper.dart              # SQLite schema, connection lifecycle, and CRUD query methods
│   ├── models/
│   │   ├── user.dart                         # User domain model and mapping
│   │   └── transaction.dart                  # Transaction domain model and mapping
│   ├── services/
│   │   └── auth_service.dart                 # Authentication-oriented service abstraction
│   └── widgets/
│       ├── app_floating_button.dart          # Reusable floating action button component
│       ├── app_logo.dart                     # Reusable branding/logo widget
│       ├── app_text_button.dart              # Shared text-button abstraction
│       ├── app_toast.dart                    # Unified toast feedback helper
│       ├── balance_show_group.dart           # Reusable balance summary UI block
│       ├── custom_text_field.dart            # Shared text field abstraction
│       ├── primary_button.dart               # Shared primary button component
│       └── widgets.dart                      # Barrel export for shared widgets
├── features/
│   ├── auth/
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── user_provider.dart        # Auth/session state and user lifecycle management
│   │       ├── screens/
│   │       │   ├── login_screen.dart         # Sign-in UI
│   │       │   ├── register_screen.dart      # Registration UI
│   │       │   └── screens.dart              # Barrel export for auth screens
│   │       └── widgets/
│   │           ├── auth_wrapper.dart         # Route-level auth gate and session bootstrap flow
│   │           └── log_or_regi.dart          # Login/register navigation entry widget
│   ├── dashboard/
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── expense_provider.dart     # Transaction state, aggregation, and user-scoped sync
│   │       ├── screens/
│   │       │   ├── add_expense_screen.dart   # Add/edit transaction UI flow
│   │       │   ├── home_screen.dart          # Primary dashboard screen
│   │       │   ├── main_screen.dart          # Main navigation/screen shell
│   │       │   └── screens.dart              # Barrel export for dashboard screens
│   │       └── widgets/
│   │           └── money_dashboard.dart      # Dashboard summary and analytics widgets
│   └── stats/
│       └── presentation/
│           ├── screens/
│           │   └── visualization_screen.dart # Analytics visualization screen
│           └── widgets/
│               ├── category_chart.dart       # Category-wise chart rendering
│               └── datewise_chart.dart       # Date-range chart rendering
```

---

## Getting Started

### Prerequisites

Ensure you have the following installed on your system:

- **Flutter SDK**: [Download and install Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK**: Comes bundled with Flutter
- **Git**: For cloning the repository

### Complete Setup & Run Flow

#### 1. Clone the Repository

```bash
git clone https://github.com/CodeWithIsmail/app-development-boot-camp-may-2026.git
cd app-development-boot-camp-may-2026
```

#### 2. Get Dependencies

```bash
flutter pub get
```

This command downloads all required packages defined in `pubspec.yaml` (Flutter, Dart, SQLite, Provider, fl_chart, etc.).

#### 3. Verify Setup

Ensure your development environment is properly configured:

```bash
flutter doctor
```

This checks for any missing tools, SDKs, or configurations. Address any warnings or errors reported.

#### 4. Run on Android Emulator or Connected Device

**For Android:**

```bash
# List available emulators or connected devices
flutter devices

# Run the app
flutter run
```

Or run on a specific device:

```bash
flutter run -d <device-id>
```

#### 5. Build for Production

**Build APK (Android):**

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Troubleshooting

**Issue: `flutter pub get` fails**

- Run `flutter clean` and retry
- Check internet connection
- Update Flutter: `flutter upgrade`

**Issue: Build fails**

- Clear build cache: `flutter clean`
- Invalidate Android/iOS build: `rm -rf build/`
- Reinstall dependencies: `flutter pub get`

---
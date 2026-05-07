# 🚀 Quick Reference Guide - MExpense Architecture

## File Location Quick Finder

### 🔐 Authentication Components

| What                  | Location                                                  |
| --------------------- | --------------------------------------------------------- |
| Login Screen          | `features/auth/presentation/screens/login_screen.dart`    |
| Register Screen       | `features/auth/presentation/screens/register_screen.dart` |
| User State (Provider) | `features/auth/presentation/providers/user_provider.dart` |
| Auth Entry Point      | `features/auth/presentation/widgets/auth_wrapper.dart`    |
| Auth Service          | `core/services/auth_service.dart`                         |

### 💰 Dashboard/Expense Components

| What                     | Location                                                          |
| ------------------------ | ----------------------------------------------------------------- |
| Home Screen (Navigation) | `features/dashboard/presentation/screens/home_screen.dart`        |
| Transaction List         | `features/dashboard/presentation/screens/main_screen.dart`        |
| Add/Edit Expense         | `features/dashboard/presentation/screens/add_expense_screen.dart` |
| Balance Display          | `features/dashboard/presentation/widgets/money_dashboard.dart`    |
| Expense State (Provider) | `features/dashboard/presentation/providers/expense_provider.dart` |

### 📊 Analytics/Stats Components

| What                 | Location                                                        |
| -------------------- | --------------------------------------------------------------- |
| Visualization Screen | `features/stats/presentation/screens/visualization_screen.dart` |
| Category Chart (Pie) | `features/stats/presentation/widgets/category_chart.dart`       |
| Datewise Chart (Bar) | `features/stats/presentation/widgets/datewise_chart.dart`       |

### 🎨 Shared UI Components

| What                | Location                               |
| ------------------- | -------------------------------------- |
| Custom Text Field   | `core/widgets/custom_text_field.dart`  |
| Primary Button      | `core/widgets/primary_button.dart`     |
| Logo Widget         | `core/widgets/app_logo.dart`           |
| Balance Cards       | `core/widgets/balance_show_group.dart` |
| Toast Notifications | `core/widgets/app_toast.dart`          |
| All Core Widgets    | `core/widgets/widgets.dart` (barrel)   |

### 📦 Data & Models

| What              | Location                             |
| ----------------- | ------------------------------------ |
| App User Model    | `core/models/app_user.dart`          |
| Expense Model     | `core/models/expense.dart`           |
| Database Helper   | `core/database/database_helper.dart` |
| Constants & Theme | `core/constants/constants.dart`      |
| Category Data     | `core/constants/data.dart`           |

---

## Common Import Patterns

### ✅ Importing Widgets

```dart
// Core widgets (always from core)
import 'package:mexpense/core/widgets/custom_text_field.dart';
import 'package:mexpense/core/widgets/widgets.dart'; // Barrel

// Feature-specific widgets
import 'package:mexpense/features/dashboard/presentation/widgets/money_dashboard.dart';
```

### ✅ Importing Screens

```dart
// From within dashboard feature
import 'package:mexpense/features/dashboard/presentation/screens/home_screen.dart';

// Using barrel files
import 'package:mexpense/features/auth/presentation/screens/screens.dart';
```

### ✅ Importing Providers

```dart
// Individual provider
import 'package:mexpense/features/auth/presentation/providers/user_provider.dart';

// Using barrel with alias to avoid conflicts
import 'package:mexpense/features/auth/presentation/providers/providers.dart' as auth;
import 'package:mexpense/features/dashboard/presentation/providers/providers.dart' as dashboard;
```

### ✅ Importing Constants & Models

```dart
// Theme & constants
import 'package:mexpense/core/constants/constants.dart';

// Models
import 'package:mexpense/core/models/app_user.dart';
import 'package:mexpense/core/models/expense.dart';

// Helpers (re-exports core constants)
import 'package:mexpense/core/utils/helpers.dart';
```

---

## Adding a New Feature

### Step 1: Create Directory Structure

```bash
mkdir -p lib/features/my_feature/data
mkdir -p lib/features/my_feature/presentation/screens
mkdir -p lib/features/my_feature/presentation/widgets
mkdir -p lib/features/my_feature/presentation/providers
```

### Step 2: Create Barrel Files

```dart
// screens/screens.dart
export 'my_screen.dart';

// widgets/widgets.dart
export 'my_widget.dart';

// providers/providers.dart
export 'my_provider.dart';
```

### Step 3: Add Screens

```dart
// screens/my_screen.dart
import 'package:flutter/material.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('My Feature')),
    );
  }
}
```

### Step 4: Add Providers (if needed)

```dart
// providers/my_provider.dart
import 'package:flutter/foundation.dart';

class MyProvider extends ChangeNotifier {
  // Your state management here
}
```

### Step 5: Update main.dart

```dart
// Add to MultiProvider if new state management needed
ChangeNotifierProvider(create: (_) => MyProvider()),
```

---

## Navigating Between Features

### ✅ Good: Using named routes or direct navigation

```dart
// Navigation from auth to dashboard
Navigator.of(context).pushReplacement(
  MaterialPageRoute(builder: (_) => const HomeScreen()),
);

// Using named routes (advanced)
Navigator.of(context).pushNamed('/home');
```

### ✅ Good: Using provider state to control navigation

```dart
// Check user state and navigate accordingly
if (context.watch<UserProvider>().currentUser != null) {
  return const HomeScreen();
} else {
  return const LoginOrRegistration();
}
```

### ❌ Avoid: Direct imports between features

```dart
// ❌ DON'T do this - creates tight coupling
import 'package:mexpense/features/auth/presentation/providers/user_provider.dart';
```

### ✅ Use: App-level state for cross-feature communication

```dart
// Use providers at app level (main.dart)
// Features access shared providers only through context.read/watch
final userProvider = context.read<UserProvider>();
```

---

## State Management Pattern

### Using Provider (Current Implementation)

```dart
// Reading state
final user = context.read<UserProvider>().currentUser;

// Watching state (rebuilds on change)
final user = context.watch<UserProvider>().currentUser;

// Calling methods
await context.read<ExpenseProvider>().addExpense(...);

// In MultiProvider (main.dart)
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProxyProvider<UserProvider, ExpenseProvider>(
      create: (_) => ExpenseProvider(),
      update: (_, userProvider, expenseProvider) {
        // Sync dependent providers
        final provider = expenseProvider ?? ExpenseProvider();
        provider.syncUser(userProvider.currentUser?.id);
        return provider;
      },
    ),
  ],
  child: MaterialApp(...),
)
```

---

## Common Tasks

### Task: Add a new screen to dashboard

```
1. Create: features/dashboard/presentation/screens/my_new_screen.dart
2. Export in: features/dashboard/presentation/screens/screens.dart
3. Import in: home_screen.dart where it's needed
4. Navigate to it using Navigator
```

### Task: Create a reusable widget

```
1. If used across features: features/core/widgets/my_widget.dart
2. If feature-specific: features/feature_name/presentation/widgets/my_widget.dart
3. Update barrel file (widgets.dart) with export
4. Import where needed
```

### Task: Add new state management

```
1. Create: features/feature_name/presentation/providers/my_provider.dart
2. Extend ChangeNotifier for Provider pattern
3. Export in: features/feature_name/presentation/providers/providers.dart
4. Add to MultiProvider in main.dart
5. Access with context.read/watch
```

### Task: Add database operations

```
1. Extend DatabaseHelper in: core/database/database_helper.dart
2. Add methods for new tables/operations
3. Call from feature providers (ExpenseProvider, UserProvider)
4. Keep database layer separate from UI
```

---

## Debugging Tips

### Find files quickly

- **Auth issues**: `features/auth/presentation/`
- **Expense issues**: `features/dashboard/presentation/`
- **Chart issues**: `features/stats/presentation/`
- **Database issues**: `core/database/`
- **UI issues**: `core/widgets/`

### Check import errors

```dart
// Run analyze
flutter analyze

// Check specific file
flutter analyze lib/features/dashboard/

// Format files
dart format lib/
```

### Debug state management

```dart
// In provider
print('State changed: $value'); // Add to notify listeners

// In widget
debugPrint('Building widget'); // Debug builds
```

---

## Performance Tips

### ✅ DO

- Use `Consumer` widget for specific rebuild scopes
- Use `context.read()` inside callbacks (don't rebuild on change)
- Use `context.watch()` only at screen level when possible
- Extract widgets to avoid unnecessary rebuilds

### ❌ DON'T

- Watch entire provider if only using specific value
- Create providers inside build methods
- Import models into UI without going through providers

---

## File Size Guidelines

### Keep screens manageable

- If > 300 lines: Extract widgets to `widgets/` folder
- Each method should do one thing
- Use multiple widgets instead of huge build methods

### Provider file size

- If > 200 lines: Extract related methods to separate file
- Keep business logic separate from UI logic
- Consider repository pattern for complex operations

---

## Testing Patterns

### Unit test a provider

```dart
test('ExpenseProvider adds expense', () {
  final provider = ExpenseProvider();
  // Test logic here
});
```

### Widget test a screen

```dart
testWidgets('LoginScreen renders', (WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
  // Test widgets
});
```

### Integration test

```dart
// Test full feature flow with real database
testWidgets('User can add and view expense', (WidgetTester tester) async {
  // Setup app
  // Navigate through screens
  // Verify data
});
```

---

## Quick Checklist for Code Review

- [ ] Imports organized and correct (core, then features)
- [ ] Layer separation maintained (data/presentation)
- [ ] No circular dependencies between features
- [ ] Barrel files updated with new exports
- [ ] ChangeNotifier used for state management
- [ ] No hardcoded strings (use constants)
- [ ] Error handling implemented
- [ ] Code formatted with `dart format`
- [ ] No unused imports
- [ ] Comments for complex logic

---

## Resources

- **Flutter Architecture**: https://flutter.dev/docs/development/architecture
- **Provider Pattern**: https://pub.dev/packages/provider
- **State Management**: https://flutter.dev/docs/development/data-and-backend/state-mgmt
- **Project Structure**: See `REFACTORING_COMPLETE.md`
- **Full Architecture**: See `ARCHITECTURE_SUMMARY.md`

---

**Happy coding!** 🚀

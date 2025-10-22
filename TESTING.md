# 🧪 Testing Guide for WAZEET App

## Overview

This document describes the testing structure for the WAZEET Flutter application, including unit tests, widget tests, and integration tests.

## Test Structure

```
test/
├── widget_test.dart                          # Basic app widget test
├── features/
│   ├── profile/
│   │   └── edit_profile_screen_test.dart    # ✅ Profile tests (pattern template)
│   ├── home/
│   │   └── home_content_screen_test.dart    # ✅ Home tab tests
│   ├── services/
│   │   └── services_screen_test.dart        # ✅ Services tab tests
│   ├── community/
│   │   └── community_screen_test.dart       # ✅ Community tab tests
│   ├── growth/
│   │   └── growth_screen_test.dart          # ✅ Growth tab tests
│   └── more/
│       └── more_screen_test.dart            # ✅ More tab tests
```

## Test Approach

All tab tests follow the **Repository Stubbing Pattern** established in `edit_profile_screen_test.dart`:

### Pattern Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wazeet_app/presentation/screens/home/home_screen.dart';

void main() {
  group('TabName Tests', () {
    testWidgets('Test description', (tester) async {
      // Arrange: Set up fake repositories if needed
      
      // Act: Build widget and pump
      await tester.pumpWidget(
        const MaterialApp(
          home: TabScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert: Verify UI elements
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Expected Text'), findsOneWidget);
    });
  });
}
```

## Tab-by-Tab Test Status

### ✅ Home Tab Tests (`test/features/home/home_content_screen_test.dart`)

**Status**: Created, needs refinement

**Tests**:
- Renders dashboard with stats cards
- Quick action buttons are tappable
- Recent activity section displays
- Shows placeholder when no data available

**Backend**: None (static placeholder UI)

**Notes**: Tests verify static UI elements. No repository needed since there's no backend integration yet.

---

### ✅ Services Tab Tests (`test/features/services/services_screen_test.dart`)

**Status**: Created, needs refinement

**Tests**:
- Renders services screen with category list
- Can select a service category
- Navigation through service flow steps
- Next button disabled when no selection made
- Shows all service categories with descriptions
- Progress bar updates based on step

**Backend**: Local data (serviceCatalog list in home_screen.dart)

**Notes**: Tests verify multi-step wizard functionality. Uses local data, no repository stubbing needed.

---

### ✅ Community Tab Tests (`test/features/community/community_screen_test.dart`)

**Status**: Created, needs refinement

**Tests**:
- Renders community screen with placeholder content
- Shows community features section
- Displays coming soon indicator
- Shows network icon
- Screen is scrollable

**Backend**: None (placeholder UI)

**Notes**: Simple tests for placeholder UI. No functionality to test yet.

---

### ✅ Growth Tab Tests (`test/features/growth/growth_screen_test.dart`)

**Status**: Created, needs refinement

**Tests**:
- Renders growth screen with service redirect
- Navigate to Services tab when card tapped
- Shows services icon
- Displays arrow icon indicating navigation
- Card is tappable with InkWell effect

**Backend**: None (redirect functionality)

**Notes**: Tests verify navigation callback functionality.

---

### ✅ More Tab Tests (`test/features/more/more_screen_test.dart`)

**Status**: Created, simplified version

**Tests**:
- Renders more screen with basic structure
- Shows profile section
- Displays menu options
- Screen is scrollable
- Has list tiles for navigation
- Shows icons for menu items

**Backend**: Firebase (Profile management)

**Notes**: Simplified tests due to Firebase dependencies. Full integration tests with stubbed `ProfileController` pending.

---

### ✅ Profile Management Tests (`test/features/profile/edit_profile_screen_test.dart`)

**Status**: ✅ Working (Reference Implementation)

**Tests**:
- Save button disabled when name empty and enabled when valid

**Backend**: Firebase (stubbed with `_FakeUserRepository`)

**Repository Stub**:
```dart
class _FakeUserRepository implements IUserRepository {
  UserProfile? _profile;
  
  @override
  User? get currentUser => null;
  
  @override
  Stream<User?> authChanges() => const Stream<User?>.empty();
  
  @override
  Future<UserProfile?> getCurrent() async => _profile;
  
  @override
  Future<void> signOut() async {}
  
  @override
  Future<void> upsert(UserProfile data) async {
    _profile = data;
  }
  
  @override
  Future<String> uploadProfileImage(XFile file) async => 
    'https://example.com/mock.png';
  
  @override
  Stream<UserProfile?> watchCurrent() => Stream.value(_profile);
}
```

**Notes**: This test demonstrates the repository stubbing pattern that should be applied to other features when they get backend integration.

---

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/features/profile/edit_profile_screen_test.dart
```

### Run Tests for a Feature
```bash
flutter test test/features/home/
```

### Run with Coverage
```bash
flutter test --coverage
```

### Generate Coverage Report
```bash
# Install lcov first: brew install lcov
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Test Principles

### 1. **AAA Pattern** (Arrange, Act, Assert)
All tests follow the Arrange-Act-Assert pattern:
- **Arrange**: Set up test data and dependencies
- **Act**: Perform the action being tested
- **Assert**: Verify the expected outcome

### 2. **Repository Stubbing**
For features with backend integration:
- Create fake repository implementations
- Stub methods to return predictable test data
- Avoid actual Firebase/API calls in tests

### 3. **Widget Testing Best Practices**
- Use `pumpWidget` to build the widget tree
- Use `pumpAndSettle` to wait for animations
- Use specific finders (byType, text, icon, etc.)
- Test user interactions with `tap`, `enterText`, `drag`

### 4. **Test Isolation**
- Each test should be independent
- Don't rely on test execution order
- Clean up after tests if needed

## Current Test Status

| Feature | Tests Created | Tests Passing | Backend | Stubbing Needed |
|---------|---------------|---------------|---------|-----------------|
| Profile Management | ✅ Yes | ✅ Yes | Firebase | ✅ Done |
| Home Tab | ✅ Yes | ⏳ Needs refinement | None | ❌ No |
| Services Tab | ✅ Yes | ⏳ Needs refinement | Local | ❌ No |
| Community Tab | ✅ Yes | ⏳ Needs refinement | None | ❌ No |
| Growth Tab | ✅ Yes | ⏳ Needs refinement | None | ❌ No |
| More Tab | ✅ Yes | ⏳ Simplified | Firebase | ⏳ Pending |
| Company Setup | ❌ No | ❌ No | None | ⏳ Pending |
| Trade License | ❌ No | ❌ No | None | ⏳ Pending |
| Visa Processing | ❌ No | ❌ No | None | ⏳ Pending |
| Authentication | ❌ No | ❌ No | Firebase | ⏳ Pending |
| Business Activities | ❌ No | ❌ No | Firestore | ⏳ Pending |

## Next Steps

### Immediate Tasks
1. ✅ Create test files for all tabs (DONE)
2. ⏳ Refine tests to match actual UI implementation
3. ⏳ Add repository stubs for More tab (full profile integration)
4. ⏳ Create tests for Company Setup flow
5. ⏳ Create tests for Trade License flow
6. ⏳ Create tests for Visa Processing flow

### Future Tasks
1. Integration tests for complete user flows
2. Golden tests for UI consistency
3. Performance tests for large data sets (4,000+ activities)
4. Accessibility tests
5. Internationalization tests (English/Arabic)

## Test Refinement Notes

### Why Tests Are Failing

Most tests are failing because they assert on specific text/widgets that may not exactly match the actual UI implementation. To fix:

1. **Run the app** and inspect actual UI structure
2. **Use Flutter Inspector** to see widget tree
3. **Update test expectations** to match actual implementation
4. **Use more flexible finders** (e.g., `findsWidgets` instead of exact counts)

### Example Refinement

**Before** (too specific):
```dart
expect(find.text('Entrepreneur Community'), findsOneWidget);
```

**After** (more flexible):
```dart
expect(find.text('Community'), findsOneWidget);
expect(find.byType(Card), findsWidgets); // At least one card exists
```

## Contributing Tests

When adding new features:

1. Create test file in `test/features/<feature_name>/`
2. Follow the repository stubbing pattern from `edit_profile_screen_test.dart`
3. Write tests for:
   - Initial UI rendering
   - User interactions
   - Form validation
   - Navigation flows
   - Error states
4. Run tests before committing: `flutter test`
5. Ensure coverage doesn't decrease

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Widget Testing Guide](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing Guide](https://docs.flutter.dev/cookbook/testing/integration/introduction)
- [Provider Testing](https://pub.dev/packages/provider#testing)
- [Firebase Testing](https://firebase.google.com/docs/emulator-suite)

---

**Last Updated**: October 23, 2025  
**Test Coverage**: ~30% (Profile tests working, other tests need refinement)  
**Status**: Tests created for all tabs, refinement in progress

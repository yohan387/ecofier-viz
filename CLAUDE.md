# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Ecofier Viz** is a Flutter-based SaaS solution for weighbridge infrastructure management ("gestion des infrastructures"). The application allows clients to view and manage weighing data through a mobile interface.

## Core Architecture

### Clean Architecture with BLoC Pattern

The codebase follows Clean Architecture principles combined with the BLoC (Business Logic Component) pattern:

- **Presentation Layer** (`lib/presentation/`): UI screens and BLoC state management
- **Repository Layer** (`lib/repositories/`): Data access abstraction
- **Models** (`lib/models/`): Domain entities (User, Weighing, WeighingSummary)
- **Core** (`lib/core/`): Shared utilities, constants, error handling, and DI

### State Management

- Uses **flutter_bloc** for state management
- All Cubits follow a consistent pattern: each feature has its own Cubit + State files
- BLoC providers are registered globally in [main.dart](lib/main.dart) via `MultiBlocProvider`

### Dependency Injection

- Uses **GetIt** service locator pattern (imported as `sl`)
- All dependencies are initialized in [lib/core/dependencies_injection.dart](lib/core/dependencies_injection.dart)
- Registration split into: `_initExternalLibraries()`, `_registerAuthDependencies()`, `_registerVisDependencies()`
- Repositories are `LazySingleton`, Cubits are `Factory`

### Error Handling Pattern

The app uses a **functional error handling** approach with `dartz` package:

1. **ResultFuture<T>** type alias = `Future<Either<Failure, T>>`
2. **Exceptions** (`AppException`): Thrown in repositories/mixins
3. **Failures** (`Failure`): Returned to presentation layer via `Either<Failure, T>`
4. **Mixins for error handling**:
   - `RepositoriesMixin`: Provides `executeWithFailureHandling()` and `executeWithConnectionCheck()`
   - `RestApiMixin`: HTTP client wrapper with automatic error conversion

Error types: `api`, `localStorage`, `network`, `internal` (see [lib/core/constants.dart](lib/core/constants.dart))

### API Communication

- **Base URL**: `https://ecofier-backend.onrender.com` (defined in [lib/core/constants.dart](lib/core/constants.dart))
- **REST API Mixin** ([lib/core/mixins/rest_api_mixin.dart](lib/core/mixins/rest_api_mixin.dart)): Centralized HTTP client
- All requests include connection checking via `connectivity_plus`
- Responses are UTF-8 decoded and handled through typed `responseHandler` functions
- User session stored in `SharedPreferences` as JSON

### Key Features

1. **Authentication** (`lib/presentation/authentication/`):
   - Client registration
   - Login/logout with phone number + password
   - Local user persistence via SharedPreferences

2. **Visualization** (`lib/presentation/visualisation/`):
   - Weighing list with filtering (today/week/month/custom)
   - Weighing summary statistics
   - Detail view for individual weighing records

## Development Commands

### Run the Application

```bash
# Development mode (debug)
flutter run

# Specific device
flutter run -d <device-id>

# Release mode
flutter run --release
```

### Build

```bash
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# iOS
flutter build ios

# Web
flutter build web
```

### Dependencies

```bash
# Install/update dependencies
flutter pub get

# Clean build artifacts
flutter clean

# Regenerate platform-specific files
flutter pub get
```

### Code Quality

```bash
# Analyze code (uses package:flutter_lints/flutter.yaml)
flutter analyze

# Format code
flutter format lib/

# Check formatting without changes
flutter format --set-exit-if-changed lib/
```

### Testing

Note: Currently no test files exist in the project. When adding tests:

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/path/to/test_file.dart

# Run with coverage
flutter test --coverage
```

## Important Development Notes

### When Adding New Features

1. **Create the model** in `lib/models/` (extend `Equatable`, include `fromMap`/`toMap`)
2. **Add repository methods** in appropriate repository with `ResultFuture<T>` return type
3. **Register in DI** via [lib/core/dependencies_injection.dart](lib/core/dependencies_injection.dart)
4. **Create Cubit + State** under `lib/presentation/<feature>/state/<cubit_name>/`
5. **Register Cubit** in [main.dart](lib/main.dart) `MultiBlocProvider`
6. **Build UI** using `BlocBuilder`/`BlocListener` to react to state changes

### Adding New API Endpoints

All repositories should:
- Mix in `RestApiMixin` and `RepositoriesMixin`
- Use `executeWithConnectionCheck()` for network calls
- Use `sendRequest()` from `RestApiMixin` with appropriate `ApiMethod`
- Return `ResultFuture<T>` types
- Handle responses via typed `responseHandler` callbacks

Example pattern from [lib/repositories/auth_repository.dart](lib/repositories/auth_repository.dart):

```dart
ResultFuture<User> login(String phoneNumber, String password) async {
  return executeWithConnectionCheck(
    _connectionChecker,
    () async {
      final user = await sendRequest(
        method: ApiMethod.post,
        url: "$apiBaseUrl/login-client",
        body: {"telephone": phoneNumber, "mot_de_passe_en_clair": password},
        responseHandler: (response) {
          final jsonMap = json.decode(utf8.decode(response));
          return User.fromMap(jsonMap);
        },
      );
      // Additional logic (e.g., save to SharedPreferences)
      return user;
    },
  );
}
```

### Platform-Specific Configuration

- **Android**: Internet permission already added in [android/app/src/main/AndroidManifest.xml](android/app/src/main/AndroidManifest.xml)
- Supports: Android, iOS, Linux, macOS, Windows, Web

### Assets

Assets are located in `lib/core/assets/` and must be registered in [pubspec.yaml](pubspec.yaml) (currently: alert.png, bg_1.jpeg, dollar.png, low-income.png, weight-scale.png)

## Code Style

- Follow standard Flutter/Dart conventions
- Linting configured via [analysis_options.yaml](analysis_options.yaml) using `package:flutter_lints/flutter.yaml`
- French language used for user-facing messages (userMessage, howToResolveError)
- Use `AppColors` and `AppIcons` from [lib/core/constants.dart](lib/core/constants.dart) for consistent theming

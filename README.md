# MIS TEAMS

MIS TEAMS is a cross-platform Flutter app for employee operations. It includes authentication, an employee directory, product catalog, attendance, leave requests, missions, schedules, notifications, and profile screens.

## Technology

- Flutter and Dart
- Material 3
- GetX state management and dependency injection
- Repository-based data layer
- SharedPreferences for local session storage
- HTTP client for REST API requests
- English and Khmer localization

## Project structure

~~~text
lib/
  app/                  App entry and MaterialApp configuration
  core/                 Constants, network client, storage, theme, utilities
  data/                 API models and repository implementations
  domain/               Entities and repository contracts
  features/             Authentication, products, employees, and app screens
  navigation/           Routes and navigation services
  shared/               Reusable UI components
~~~

## Requirements

- Flutter SDK compatible with the Dart constraint in pubspec.yaml
- Android Studio with an Android SDK, or Xcode for iOS Simulator
- The Employee & Product API for live login, products, and employees

## Run the app

From the MIS TEAMS project folder:

~~~bash
flutter pub get
flutter devices
flutter run -d <device-id>
~~~

Use the device id printed by flutter devices. In Android Studio, select a device and choose Run or Debug.

## Connect to the backend

Start PostgreSQL and the Spring Boot API first. Follow the backend README for those steps.

The app selects a local default API address by platform:

- Android Emulator: http://10.0.2.2:33033/api
- iOS Simulator, web, or desktop on the same computer: http://localhost:33033/api
- Physical device: pass the host computer's LAN URL, for example:

~~~bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.20:33033/api
~~~

The backend endpoints used by the app are:

- Login and session: POST /api/auth/login, GET /api/auth/me, POST /api/auth/logout
- Products: GET /api/products, GET /api/products/{id}
- Employees: GET, POST /api/employees and GET, PUT, DELETE /api/employees/{id}

The demo backend login is username admin and password Admin@1234. Change it before using a deployed environment.

## Data and feature scope

Products and employees come from the Employee & Product API. The backend returns numeric database IDs; employeeCode is the separate human-readable employee code. Other MIS TEAMS workflows such as leave and mission management require their own backend endpoints if they are to persist remotely.

Password reset, profile update, and password change require backend endpoints that are not part of the current Employee & Product API.

## Localization

Translation files are in assets/translations:

- en-US.json for English
- km-KH.json for Khmer

## Build

~~~bash
flutter build apk
flutter build ios
~~~

For Android, allow local HTTP only in debug builds when testing against the local development API. Use HTTPS for deployed APIs.


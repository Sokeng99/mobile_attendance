# Mobile Attendance App

A Flutter application for attendance tracking using QR codes.

## Features

- 📝 User Registration: Register users with their name and ID.
- 🔄 QR Code Generation: Generate QR codes containing user information.
- 📷 QR Code Scanner: Scan QR codes to record attendance.
- 📊 Attendance Records: View and manage attendance records.
- 💾 Local Database: Store data using Isar NoSQL database.

## Architecture

This project follows GetX pattern with a clean architecture approach:

- **Models**: Data models for the application
- **Views**: UI components
- **Controllers**: Business logic
- **Routes**: Navigation configuration
- **Bindings**: Dependency injection
- **Database**: Local storage using Isar

## Getting Started

### Prerequisites

- Flutter SDK: 3.0.0 or higher
- Dart SDK: 2.17.0 or higher

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/mobile_attendance.git
   ```

2. Navigate to the project directory:
   ```
   cd mobile_attendance
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Generate Isar model files:
   ```
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. Run the app:
   ```
   flutter run
   ```

## Project Structure

```
lib/
  ├── bindings/        # Dependency injection
  ├── controllers/     # Business logic
  ├── db/              # Database services
  ├── models/          # Data models
  ├── routes/          # Navigation routes
  ├── utils/           # Utility functions
  ├── views/           # UI screens
  └── main.dart        # Entry point
```

## Dependencies

- [get](https://pub.dev/packages/get): State management and navigation
- [qr_flutter](https://pub.dev/packages/qr_flutter): QR code generation
- [qr_code_scanner](https://pub.dev/packages/qr_code_scanner): QR code scanning
- [isar](https://pub.dev/packages/isar): Local NoSQL database
- [path_provider](https://pub.dev/packages/path_provider): File path utilities
- [intl](https://pub.dev/packages/intl): Internationalization and formatting
- [permission_handler](https://pub.dev/packages/permission_handler): Request and check permissions

## License

This project is licensed under the MIT License. 
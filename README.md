# Genet Church Portal

This is the frontend application for the Genet Church Management System.

## Features
- **Super Admin Dashboard**: Manage churches, pastors, and global settings.
- **Pastor Dashboard**: Manage members, servants, departments, and church activities.
- **Responsive Design**: Optimized for web and tablet usage.
- **Modern UI**: Glassmorphism effects, animated widgets, and dark/light mode support.

## Getting Started

### Prerequisites
- Flutter SDK (Latest Stable)
- Dart SDK

### Configuration
The application uses environment variables for configuration.
To run with a custom base URL:
```bash
flutter run --dart-define=BASE_URL=https://your-api-url.com
```
If not specified, it defaults to the production API.

### Build
To build for web:
```bash
flutter build web --release
```

## Project Structure
- `lib/core`: Constants, themes, and utilities.
- `lib/data`: Models, repositories, and API services.
- `lib/features`: Feature-specific screens and logic.
- `lib/shared_widgets`: Reusable UI components.
- `lib/state`: Riverpod providers for state management.

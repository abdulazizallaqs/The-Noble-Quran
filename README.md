# Quran App


A modern, feature-rich Quran application built with Flutter, designed to help users connect with the Holy Quran through smart features and a beautiful user interface.

## ✨ Features

- **📖 Reading & Memorization Plans**: Create custom schedules to track your progress in reading or memorizing the Quran.
- **❤️ Smart Mood Verse**: A unique rule-based AI feature that suggests comforting Quranic verses based on your current emotional state (Sad, Happy, Anxious, etc.).
- **🔍 Fast Search**: Instantly find Surahs by name.
- **🔔 Daily Notifications**: Customizable reminders to keep you consistent with your daily wird.
- **🎨 Beautiful UI**: 
  - Dark/Light mode support.
  - Custom Arabic fonts for optimal readability.
  - Centered Splash Screen and polished Navigation Bar.
- **⚡ Offline**: All features work 100% offline without internet connection.

## 🚀 Getting Started

This project is a starting point for a Flutter application.

### Prerequisites
- Flutter SDK (3.x or later)
- Java 17 (Required for build)
- Android Studio / VS Code

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/abdulazizallaqs/QuranApp.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## 🛠️ Build Release APK

To build the release APK for Android:

```bash
flutter build apk --release
```
*Note: This project uses Java 17. Ensure your JAVA_HOME is set correctly.*

## 🔒 Privacy & Permissions

This app requests the following permissions for notifications:
- `SCHEDULE_EXACT_ALARM`
- `POST_NOTIFICATIONS`
- `RECEIVE_BOOT_COMPLETED`

Data is stored locally on the device (Shared Preferences). No personal data is sent to external servers.

## Credits

Developed with ❤️ using Flutter.


Published in December 2023


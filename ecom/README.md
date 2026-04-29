# SwiftShop - Flutter Firebase E-commerce App

A production-ready Flutter e-commerce application featuring Material 3, Provider state management, and Firebase integration.

## Features
-   **Authentication**: Email/Password login and registration via Firebase Auth.
-   **Real-time Products**: Product list synced with Cloud Firestore.
-   **Shopping Cart**: Persistent cart state during the session.
-   **Order History**: Place orders and view them in your profile.
-   **Modern UI**: Material 3 design with Google Fonts (Poppins).

## Prerequisites
-   Flutter SDK: `>=3.0.0`
-   Firebase Account: [Create one here](https://console.firebase.google.com/)
-   FlutterFire CLI: Installed and logged in (`dart pub global activate flutterfire_cli`)

## Installation & Setup

1.  **Clone the project** and navigate to the directory.
2.  **Install dependencies**:
    `flutter pub get`
3.  **Configure Firebase**:
    -   Run `flutterfire configure` in the project root.
    -   Select your Firebase project.
    -   This will automatically update `lib/firebase_options.dart` with your real keys.
4.  **Firestore Rules**:
    In your Firebase Console, set Firestore rules to allow read/write for authenticated users:
    
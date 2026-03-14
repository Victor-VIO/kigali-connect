# Kigali Connect - City Services & Places Directory

## Overview

A Flutter mobile app that helps Kigali residents and visitors find public services and places around the city. Users can browse, search, and add listings for places like hospitals, restaurants, parks, police stations, and more. Built with Firebase for authentication and real-time data storage.

## Features

- Email/password authentication with email verification
- Browse a directory of city services and places
- Search listings by name in real time
- Filter listings by category (Hospital, Restaurant, Cafe, Park, etc.)
- Add, edit, and delete your own listings (full CRUD)
- View listing details with description, contact info, and address
- Google Maps integration — see listings on a map with markers
- Get directions to any listing via Google Maps
- Location notification toggle in settings
- Real-time updates from Firestore (changes reflect instantly)

## Tech Stack

- **Flutter** (Dart)
- **Firebase Authentication** — email/password sign-in with email verification
- **Cloud Firestore** — real-time NoSQL database for listings and user profiles
- **Google Maps Flutter** — map view with markers and directions
- **Provider** — state management with ChangeNotifier

## Project Structure

```
lib/
├── main.dart                     # App entry point, Firebase init, providers, auth gate
├── firebase_options.dart         # Firebase config (auto-generated)
├── models/
│   ├── listing_model.dart        # Listing data model
│   └── user_model.dart           # User profile data model
├── providers/
│   ├── auth_provider.dart        # Auth state management (login, signup, logout)
│   └── listing_provider.dart     # Listings state, search, filtering, CRUD
├── services/
│   ├── auth_service.dart         # Firebase Auth API calls
│   └── firestore_service.dart    # Firestore read/write operations
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart             # Login page
│   │   ├── signup_screen.dart            # Registration page
│   │   └── email_verification_screen.dart # Email verification prompt
│   ├── home/
│   │   ├── main_screen.dart              # Bottom nav bar wrapper
│   │   ├── directory_screen.dart         # Home tab — browse & search listings
│   │   ├── my_listings_screen.dart       # User's own listings with edit/delete
│   │   ├── map_view_screen.dart          # Google Maps with all listing markers
│   │   └── settings_screen.dart          # Profile info, notifications, logout
│   └── listing/
│       ├── listing_detail_screen.dart    # Full listing details with map
│       ├── add_listing_screen.dart       # Form to add a new listing
│       └── edit_listing_screen.dart      # Form to edit an existing listing
├── widgets/
│   ├── listing_card.dart         # Reusable listing card for lists
│   ├── category_chip.dart        # Category filter chip
│   └── search_bar.dart           # Search input widget
└── utils/
    └── app_colors.dart           # App color constants
```

## Firestore Database Structure

### `users` collection
- **Document ID**: user's Firebase Auth UID
- Fields: `email`, `displayName`, `createdAt`

### `listings` collection
- **Document ID**: auto-generated
- Fields: `name`, `category`, `address`, `contactNumber`, `description`, `latitude`, `longitude`, `createdBy` (user UID), `createdAt`, `updatedAt`

## State Management

Uses **Provider** with `ChangeNotifier`. There are two providers:

- **AuthProvider** — listens to `FirebaseAuth.authStateChanges()`, manages login/signup/logout, loads user profile from Firestore
- **ListingProvider** — manages listing streams from Firestore, handles search query and category filtering, and exposes CRUD methods

All Firestore operations go through a service layer (`FirestoreService` and `AuthService`). The UI never calls Firestore directly — it always goes through the providers.

## Setup Instructions

1. Clone this repo
2. Run `flutter pub get`
3. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
4. Enable **Email/Password** authentication in Firebase
5. Create a **Cloud Firestore** database
6. Download `google-services.json` and place it in `android/app/`
7. Add your Google Maps API key in `android/app/src/main/AndroidManifest.xml`
8. Run `flutter run`

## Screenshots

See demo video for full walkthrough.

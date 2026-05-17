# FoodHub 🍔

A beautifully designed, feature-rich recipe application built with **Flutter**, **Riverpod**, and **Firebase**.
This project was created as a final thesis/coursework project to demonstrate advanced Flutter development skills, state management, and cloud integrations.

## ✨ Features

- **Authentication:** Sign in & Sign up using Firebase Auth.
- **Dynamic Content:** Browse categories and recipes powered by TheMealDB API.
- **Meal of the Day:** A featured recipe that changes daily, cached locally using SharedPreferences.
- **Search & Filter:** Search recipes by name or filter them by country of origin (Cuisine).
- **Favorites:** Save your favorite recipes to your profile, synced to Firebase Firestore.
- **Custom Recipes:** Add your own custom recipes with photos (compressed & stored as Base64 in Firestore to keep the project completely free-tier friendly).
- **Internationalization (i18n):** Full support for English (EN), Ukrainian (UK), and Polish (PL). The UI updates instantly when changing languages!
- **Dark Mode:** Seamlessly switch between Light and Dark themes.
- **Polished UI/UX:** Stunning Material 3 design, complete with Hero animations for smooth transitions between screens and skeleton loaders.

## 🛠 Tech Stack

- **Framework:** Flutter (Material 3)
- **State Management:** Riverpod (using Code Generation for type-safe providers)
- **Routing:** GoRouter (declarative routing)
- **Backend:** Firebase (Auth, Firestore)
- **Local Storage:** SharedPreferences (for theme, language, and cache)
- **Network:** http, cached_network_image
- **Code Quality:** flutter_lints, flutter_test (Unit and Widget testing)

## 🚀 Firebase Setup (Local Run)

Since the `google-services.json` and `firebase_options.dart` are included in the repository, you do **not** need to configure Firebase manually to run this project!

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd food_hub
   ```
2. Get packages:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

*(Note: The Firebase project uses the `nam5 (us-central)` region for Firestore to guarantee free-tier access).*

## 🧪 Testing

The project includes both **Unit** and **Widget** tests to ensure code quality and reliability.
To run all tests:
```bash
flutter test
```

## 📸 Screenshots
*(Add your screenshots here for the final GitHub presentation)*

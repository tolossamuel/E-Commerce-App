# 🛒 Flutter E-Commerce App

[![License](https://img.shields.io/github/license/tolossamuel/E-Commerce-App?style=flat-square)](LICENSE)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen?style=flat-square)](#)
[![Version](https://img.shields.io/badge/version-1.0.0-blue?style=flat-square)](#)

## 📦 About

A modern Flutter e-commerce application built with Clean Architecture and BLoC for state management. This project demonstrates best practices for scalable Flutter development, including unit testing for all features. 

**Main Features:**
- 🧩 Display product details
- 💖 Product wishlist
- 🛒 Shopping cart

---

## 🎯 Features

- View detailed information for products
- Add/remove products to your wishlist
- Add/remove products from your cart
- Clean and organized codebase with robust architecture

---

## 🧠 Architecture

This app follows **Clean Architecture** with separation into three layers:

- **Data Layer:** Handles data sources, models, and repositories. Responsible for fetching and persisting data.
- **Domain Layer:** Contains business logic, entities, and use cases. It is platform-independent.
- **Presentation Layer:** UI widgets, BLoC state management, and user interactions.

```
lib/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── blocs/
│   ├── pages/
│   └── widgets/
├── core/
│   ├── error/
│   └── utils/
└── main.dart
```

---

## 📂 Folder Structure

```
ecommerce/
├── android/
├── ios/
├── lib/
│   ├── core/
│   ├── data/
│   ├── domain/
│   ├── presentation/
│   └── main.dart
├── test/
├── web/
├── linux/
├── macos/
├── windows/
├── pubspec.yaml
├── analysis_options.yaml
├── README.md
```

---

## 🛠️ Key Dependencies

- **flutter_bloc** – State management
- **get_it** – Dependency injection
- **dartz** – Functional programming utilities
- **cached_network_image** – Efficient image loading & caching
- **shimmer** – Loading placeholders
- **equatable** – Value equality for Dart objects
- **mockito** – Mocking for unit tests
- **build_runner** – Code generation
- **hive & hive_flutter** – Local data storage
- **go_router** – Routing and navigation
- **shared_preferences** – Simple key-value storage

For all dependencies, see [`pubspec.yaml`](https://github.com/tolossamuel/E-Commerce-App/blob/main/ecommerce/pubspec.yaml).

---

## 🚀 Installation

```sh
# 1. Clone the repo
git clone https://github.com/tolossamuel/E-Commerce-App.git
cd E-Commerce-App/ecommerce

# 2. Get dependencies
flutter pub get

# 3. Generate code (if needed)
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## ▶️ Usage

```sh
# Run the app on your device/emulator
flutter run
```

---

## 🧪 Testing

```sh
# Run all unit tests
flutter test
```

All features (product details, wishlist, cart) have unit tests located in the `test/` directory.

Example:
```dart
test('Should add product to wishlist', () async {
  // Arrange, Act, Assert
});
```

---

## ⚙️ CI/CD

- Automated tests and lint checks can be added via GitHub Actions by placing workflow files in `.github/workflows/`.
- Ensure code quality and reliability before every merge.

---

## 🤝 Contribution

Contributions are welcome!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgements

Thanks to the Flutter community and all package authors for providing amazing tools to build robust apps.

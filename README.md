# Lumi Grocery - Liquid Glass Flutter UI

> 🛒 A premium grocery shopping mobile app UI with iOS-inspired Liquid Glass design - frosted panels, translucent surfaces, and smooth animations built with Flutter.

A premium grocery shopping mobile app UI built with Flutter. The design blends a fresh grocery marketplace experience with an iOS-inspired Liquid Glass visual style: frosted panels, translucent surfaces, soft reflections, floating controls, rounded navigation, and smooth depth-focused layouts.

The app is a complete UI prototype for a luxury grocery marketplace, inspired by Apple Store, Instacart, Whole Foods, and Uber Eats.

## Preview

Run the project locally to explore the full mobile experience:

```bash
flutter pub get
flutter run
```

For web preview:

```bash
flutter run -d chrome
```

## Features

- Splash screen with animated grocery branding
- Onboarding flow with glass cards and page indicators
- Home screen with greeting, address selector, search, hero banner, categories, deals, and product sections
- Categories grid for fruits, vegetables, dairy, bakery, meat, beverages, snacks, and frozen foods
- Product listing with filters, sorting, category chips, ratings, wishlist actions, and discount badges
- Product detail page with image gallery styling, nutrition facts, reviews, quantity selector, add to cart, and buy now actions
- Search screen with recent searches, trending products, suggested categories, live results, and voice search action
- Shopping cart with quantity controls, coupon area, order summary, and checkout CTA
- Checkout flow with delivery address, time slot, payment method, and order summary
- Order tracking screen with delivery map mockup, driver info, ETA, and call action
- Wishlist screen with saved products and move-to-cart actions
- Profile screen with user profile, order history, saved addresses, payments, notifications, settings, and support
- Notifications screen for order updates, offers, promotions, and delivery alerts
- Light and dark theme support

## Design System

The UI uses reusable Liquid Glass components for a consistent premium feel:

- Frosted glass cards
- Floating search fields
- Transparent app bars
- Liquid glass bottom navigation
- Rounded cards and buttons with 28-36px radii
- Soft layered shadows
- Blur-backed panels
- Organic grocery accent colors
- Material 3 and Cupertino-inspired interactions

## Tech Stack

- Flutter
- Dart
- Material 3
- Cupertino widgets
- Riverpod for state management
- GoRouter for navigation

## Project Structure

```text
lib/
  app/
    grocery_app.dart
  core/
    theme/
      app_theme.dart
    widgets/
      glass.dart
  features/
    grocery/
      data/
        grocery_data.dart
      presentation/
        grocery_screens.dart
  main.dart
```

## Getting Started

Make sure Flutter is installed and available on your machine.

```bash
flutter --version
flutter pub get
flutter run
```

Run checks:

```bash
flutter analyze
flutter test
```

Build for web:

```bash
flutter build web
```

## Screens Included

1. Splash
2. Onboarding
3. Home
4. Categories
5. Product Listing
6. Product Details
7. Search
8. Shopping Cart
9. Checkout
10. Order Tracking
11. Wishlist
12. Profile
13. Notifications

## Notes

This repository focuses on production-quality UI structure, visual polish, navigation, reusable components, and mock state. It is ready to connect to real grocery catalog, cart, checkout, and delivery APIs.

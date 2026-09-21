# 🚀 Flutter News App — Full Enhancement Prompt

## Context & Goal

You are tasked with fully transforming an existing Flutter news application into a **professional, modern, and polished mobile app**. The project is located at:

```
c:\Users\Jeki\Documents\IDN'S Carrier\IT\My Project ^w^\News App\news_app
```

The app already has a working foundation using **Flutter + GetX** (state management & routing), consuming the **NewsAPI** REST API. Your job is to **enhance the UI/UX dramatically, enrich the features, and elevate the overall code quality** — without breaking existing functionality.

---

## 📁 Current Project Structure

```
lib/
├── main.dart                  # App entry, GetMaterialApp, theme
├── bindings/
│   └── app_bindings.dart
├── controllers/
│   └── news_controller.dart   # GetxController: fetch, search, selectCategory
├── models/
│   └── news_article.dart      # NewsArticle data model
├── routes/
│   └── app_pages.dart
├── services/
│   └── news_service.dart      # HTTP calls to NewsAPI
├── utils/
│   ├── app_colors.dart        # Static color palette (Material Blue)
│   └── constants.dart
├── views/
│   ├── splash_view.dart
│   ├── home_view.dart         # Category chips + ListView of NewsCards
│   └── news_detail_view.dart  # SliverAppBar + content detail
└── widgets/
    ├── category_chip.dart
    ├── loading_shimmer.dart
    └── news_card.dart         # Card with image, source, title, description
```

**Current dependencies** (`pubspec.yaml`):
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  get: ^4.7.2
  http: ^1.4.0
  url_launcher: ^6.3.1
  share_plus: ^11.0.0
  cached_network_image: ^3.4.1
  timeago: ^3.7.1
  flutter_dotenv: ^5.2.1
```

---

## 🎨 UI/UX Design Direction

### Design Language
- **Style**: Modern editorial / news magazine aesthetic — inspired by apps like Flipboard, CNN, BBC News, or Inshorts.
- **Theme**: Support both **Light and Dark mode** with a toggle. Default: Light.
- **Color Palette (Light)**:
  - Primary: Deep Indigo `#1A1A2E` or a bold accent like `#E63946`
  - Accent: `#4361EE` (electric blue)
  - Background: `#F8F9FA`
  - Card background: `#FFFFFF`
  - Text Primary: `#0D0D0D`
  - Text Secondary: `#6B7280`
- **Color Palette (Dark)**:
  - Background: `#0F0F17`
  - Card: `#1C1C2E`
  - Text: `#EAEAEA`
- **Typography**: Use **Google Fonts** — `Playfair Display` for headlines (bold editorial feel), `Inter` or `Lato` for body text.
- **Animations**: Smooth page transitions (fade/slide), hero animations on article images, staggered list animations for cards loading in.
- **Spacing & Radius**: Generous padding, rounded corners (16–20px on cards), subtle shadows.

---

## ✨ New Features to Implement

### 1. 🏠 Redesigned Home Screen
- **Hero Banner / Featured News**: Display the top 3–5 articles as a horizontally scrollable `PageView` carousel at the top of the home screen, with a large image, overlay gradient, and bold headline text.
- **"Breaking News" ticker**: An animated horizontally scrolling text ticker below the banner showing headlines.
- **Category Pills**: Redesign the category chips into a more polished horizontal scrollable tab bar with icons for each category (e.g., 🌐 General, 💼 Business, 💻 Technology, ❤️ Health, 🔬 Science, ⚽ Sports, 🎬 Entertainment).
- **News List Layout**: Below the banner, show a vertical list of **mixed-layout cards**:
  - First card: Full-width large card with big image.
  - Subsequent cards: Compact horizontal card (thumbnail on right, text on left) to increase information density.
- **Floating Search Bar**: Replace the dialog-based search with a proper `SearchBar` or `SearchDelegate` that opens a dedicated search screen with real-time results as user types (debounced 400ms).

### 2. 📰 Redesigned News Card Widget
- Create two card variants:
  - `FeaturedNewsCard`: Large, image-dominant, glassmorphism overlay on bottom with title + source + time.
  - `CompactNewsCard`: Horizontal layout — small square thumbnail (80x80) on left, title + source + time on right. Max 2 lines for title.
- Add a **bookmark/save icon** button on each card (top-right). Saved articles stored locally with `shared_preferences` or `hive`.
- Add smooth **ripple InkWell** with proper hero tag on images for shared element transition.

### 3. 📖 Redesigned Article Detail Screen
- **Hero animation** from card image to detail screen image.
- **Collapsing AppBar** (`SliverAppBar`) with a parallax image effect.
- **Reading progress indicator**: A thin linear progress bar at the top that fills as user scrolls through the article.
- **Font size controls**: FAB or bottom bar with A−/A+ buttons to adjust article font size, persisted per session.
- **Estimated reading time**: "~3 min read" badge shown near the author/date row.
- **Bottom action bar**: Persistent bottom bar with:
  - 🔖 Bookmark toggle
  - 📤 Share
  - 🌐 Open in Browser
  - 🔗 Copy Link
- **Related articles section** at the bottom (fetch by same category or source).

### 4. 🔍 Search Screen
- Dedicated full-screen search page with:
  - Animated search bar with clear button.
  - **Recent searches** stored locally, shown when search field is empty.
  - **Trending topics** chips (hardcoded or from API).
  - Real-time search results list using `CompactNewsCard`.
  - Empty state illustration when no results.

### 5. 🔖 Bookmarks Screen
- New screen accessible via bottom navigation.
- Shows all bookmarked/saved articles using `CompactNewsCard` layout.
- Swipe-to-delete to remove bookmarks.
- Empty state with a friendly illustration.

### 6. ⚙️ Settings / Profile Screen
- Dark mode toggle.
- Font size preference.
- Notification preferences (UI only, no backend needed).
- About section with app version.

### 7. 🗺️ Bottom Navigation Bar
Replace single-screen routing with a `BottomNavigationBar` (or `NavigationBar` from Material 3):
- 🏠 Home
- 🔍 Search  
- 🔖 Bookmarks
- ⚙️ Settings

Use `GetX` nested navigation or index-based tab switching to maintain state across tabs.

### 8. ✨ Splash Screen Upgrade
- Animated splash: app logo fades/scales in, then transitions smoothly to Home.
- Duration: ~2 seconds.
- Match brand colors.

### 9. 🌐 Offline & Error States
- Beautiful **error state** widget with an illustration/icon, descriptive message, and Retry button.
- **Empty state** widget with an illustration.
- **No internet** detection (use `connectivity_plus`) with a snackbar banner.

---

## 📦 New Dependencies to Add

Add these to `pubspec.yaml` (use latest stable versions from pub.dev):

```yaml
# UI & Theming
google_fonts: ^6.2.1          # Playfair Display + Inter
flutter_animate: ^4.5.0       # Smooth animations (fade, slide, stagger)
shimmer: ^3.0.0               # Better shimmer loading effect (or keep existing)
lottie: ^3.1.0                # Lottie animations for empty/error states

# Features
shared_preferences: ^2.3.2    # Persist bookmarks + settings
connectivity_plus: ^6.0.5     # Detect internet connectivity
flutter_svg: ^2.0.10          # SVG assets for illustrations

# UX
flutter_staggered_animations: ^1.1.1  # Staggered list animations
smooth_page_indicator: ^1.2.0         # Dots indicator for banner carousel
```

> ⚠️ **Important**: Run `flutter pub get` after updating `pubspec.yaml` before making any code changes.

---

## 🏗️ Code Architecture Requirements

1. **Maintain GetX pattern**: Keep using `GetxController`, `Obx`, `GetView`. Do not switch state management libraries.
2. **Add new controllers**:
   - `BookmarkController` — manages saved articles using `shared_preferences`.
   - `ThemeController` — manages light/dark mode toggle.
   - `SearchController` (rename to `NewsSearchController` to avoid conflict) — manages search state, recent queries.
   - `SettingsController` — manages font size preference.
3. **Add new views**: `search_view.dart`, `bookmarks_view.dart`, `settings_view.dart`.
4. **Extract reusable widgets**: `FeaturedNewsCard`, `CompactNewsCard`, `SectionHeader`, `EmptyStateWidget`, `ErrorStateWidget`, `ReadingProgressBar`.
5. **Theme system**: Create `lib/utils/app_theme.dart` with `ThemeData` for both light and dark modes using Google Fonts.
6. **Add `lib/utils/app_text_styles.dart`** for centralized typography.
7. Update `app_pages.dart` and `app_bindings.dart` to register new routes and controllers.

---

## 🔧 Specific Implementation Instructions

### `main.dart`
- Wire up `ThemeController` and bind `GetMaterialApp.theme` / `GetMaterialApp.darkTheme` reactively.
- Use `GetMaterialApp.themeMode` bound to `ThemeController.themeMode`.
- Remove the unused `MyHomePage` boilerplate class.

### `app_colors.dart`
- Expand to include both light and dark color tokens.
- Use `extension` or a separate `AppColors` class with static references.

### `home_view.dart`
- Replace `Scaffold` body's `Column` with a `CustomScrollView` using `Slivers`:
  - `SliverToBoxAdapter` for the featured banner `PageView`.
  - `SliverToBoxAdapter` for the category tab bar.
  - `SliverList` or `SliverAnimatedList` for the news cards.

### `news_card.dart`
- Split into `featured_news_card.dart` and `compact_news_card.dart`.

### `news_detail_view.dart`
- Add `ReadingProgressBar` using a `ScrollController` that measures `scrollOffset / maxScrollExtent`.
- Wrap article image in a `Hero` widget with tag `'article-image-${article.url}'`.

---

## 🧪 Verification Steps

After completing all changes:
1. Run `flutter analyze` — must show **no errors** (warnings acceptable).
2. Run `flutter build apk --debug` — must compile successfully.
3. Manually test on emulator or device:
   - [ ] App launches with animated splash → Home.
   - [ ] Featured carousel scrolls smoothly.
   - [ ] Category selection fetches and displays new articles.
   - [ ] Tapping article opens detail with hero animation.
   - [ ] Search screen shows real-time results.
   - [ ] Bookmarking an article saves it and appears in Bookmarks tab.
   - [ ] Dark mode toggle works and persists.
   - [ ] Font size adjustments work in detail view.
   - [ ] Error and empty states render correctly.
   - [ ] Bottom navigation switches tabs maintaining scroll position.

---

## 📝 Notes & Constraints

- **DO NOT** change the `NewsAPI` service layer logic or the `.env` API key loading. Only enhance UI and add client-side features.
- **DO NOT** remove any existing functionality — only enhance and extend.
- **Preserve all existing comments and docstrings** unless rewriting a file entirely.
- The app targets **Android & iOS** (no desktop-specific features needed).
- Keep the `flutter_dotenv` setup intact — the `.env` file contains the API key.
- If any package version causes a dependency conflict, use the latest compatible version and document the change.
- All new text visible in the UI should be in **English** (the app is currently in English).
- Use `const` constructors wherever possible for performance.

---

## 🎯 Priority Order

If implementing incrementally, follow this order:

1. **Phase 1 — Theme & Typography** (foundation): `app_theme.dart`, `app_colors.dart`, `app_text_styles.dart`, `ThemeController`, dark mode toggle, Google Fonts.
2. **Phase 2 — Core UI Redesign**: Splash animation, Home screen with featured banner + compact cards, `BottomNavigationBar`.
3. **Phase 3 — Detail Screen**: Hero animation, reading progress bar, font size control, bottom action bar.
4. **Phase 4 — New Screens**: Search screen with recent searches, Bookmarks screen with local persistence, Settings screen.
5. **Phase 5 — Polish**: Staggered animations, error/empty states with illustrations, connectivity detection, final `flutter analyze` cleanup.

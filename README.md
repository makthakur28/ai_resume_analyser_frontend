# AI Career Accelerator - Frontend

A highly polished, premium, startup-grade Flutter application for the AI Resume Platform.

## Architecture

This application strictly follows **Feature-First Clean Architecture**.

```text
lib/
├── core/                   # Shared resources (themes, networking, routing, UI components)
│   ├── network/            # Dio API Client, interceptors
│   ├── routes/             # GoRouter configuration
│   └── theme/              # Premium minimalistic color & typography system
├── features/               # Independent feature modules
│   ├── dashboard/          # Entry point and quick actions
│   ├── resume/             # AI Resume Optimizer & Analyzer (BLoC, Domain, Data)
│   └── career_kit/         # AI Cover Letter & Cold Email Generator (BLoC, Domain, Data)
├── injection_container.dart # GetIt dependency injection
└── main.dart               # App entry
```

### Clean Architecture Principles Used
1. **Presentation Layer**: BLoC for state management. `pages/` and `widgets/` for UI. NO business logic in UI.
2. **Domain Layer**: `entities/` and abstract `repositories/`. Pure Dart, no dependencies on Flutter or networking.
3. **Data Layer**: `repositories/` (implementations) and `datasources/` (Dio API calls).

## Design System

The UI is inspired by modern dev-tools (Linear, Vercel, Notion, Raycast).
* **Colors**: Monochromatic base (`#1A1A1A` primary, `#FBFBFB` background) with a single electric blue accent (`#0066FF`).
* **Animations**: Powered by `flutter_animate`. Subtle fade-in, upward slides, and smooth hover state transitions. Avoided flashy/bouncy animations to maintain a calm, intelligent feel.
* **Layouts**: Fully responsive. Desktop web utilizes wide grid wraps, while mobile naturally stacks cards vertically.

## State Management

* **`flutter_bloc`**: Standardized event-driven architecture.
* **`equatable`**: For value-equality in States, preventing unnecessary UI rebuilds.

## Setup Instructions

1. Ensure Flutter is installed (Stable channel).
2. Run `flutter pub get`
3. If connecting to local FastAPI, ensure `http://localhost:8000` is active.
4. Run `flutter run -d macos` or `flutter run -d chrome`.

## Future Scalability

* **Adding Features**: To add "AI Interview Prep", simply duplicate the `features/career_kit` folder structure. The routing and DI easily scale horizontally.
* **Authentication**: A `features/auth` module can be injected using an Interceptor in `ApiClient` to attach JWT tokens seamlessly to all outgoing requests.

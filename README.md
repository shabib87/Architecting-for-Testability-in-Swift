# 🌤 SimpleWeatherApp

A minimal, production-grade SwiftUI demo that showcases how to architect for testability in Swift using the new Swift Testing Framework, [@Mockable](https://github.com/Kolos65/Mockable), and [@Spyable](https://github.com/Matejkob/swift-spyable). Built under the principles of Clean Architecture.

Published by **Code with Shabib** — [codewithshabib.com](https://www.codewithshabib.com)

---

## 🚀 Purpose

This project exists to:

* Demonstrate **testable Clean Architecture** in a real SwiftUI app
* Showcase how to use **Mockable** and **Spyable** for Swift-native test double generation
* Cover the **entire spectrum of test doubles**: mock, stub, spy, fake, and dummy
* Provide a reusable base for unit testing, SwiftUI previews, and architectural validation

---

## 📝 Related Blog Post

This demo project accompanies the blog post **"Architecting for Testability: Swift Testing with Mockable and Spyable"** - [Read the full article](https://www.codewithshabib.com/architecting-for-testability).

---

## 🧱 Architecture Overview

This app uses strict layering:

```
SwiftUI View
    ↓
ViewModel (presentation logic)
    ↓
UseCase (domain logic)
    ↓
Repository (protocol)
    ↓
API Service (data layer)
```

Each layer depends **only inward**, aligned with Clean Architecture.

* **DTOs**: API-specific data structures
* **Entities**: Pure domain models
* **ViewData**: Presentation-layer structs mapped from domain models
* **Mappers**: Pure functions between layers (no mocking needed)

---

## 📂 Project Structure

```
SimpleWeather/
├── WeatherView/
│   ├── Presentation/ (SwiftUI View, ViewModel, ViewData)
│   ├── Domain/ (Entities, Use Cases, Repository interfaces)
│   ├── Data/ (Repository impls, API services, DTOs)
│   └── Shared/ (Utilities, test doubles, etc.)
└── SimpleWeatherTests/
    └── Unit tests for all layers
```

---

## 🧪 Testing Strategy

This project explicitly demonstrates **all 5 types of test doubles**:

| Type    | Used In                                                                                 | Example File(s) / Usage                                                                 |
| ------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| ✅ Dummy | `DummyLogger`, `DummyAnalyticsTracker`                                                  | `WeatherView/Shared/Utilities/Dummies/`<br>Used in previews and as default dependencies |
| ✅ Stub  | `WeatherAPIServiceStub` (configurable return values)                                    | `WeatherView/Data/Stubs/WeatherAPIServiceStub.swift`<br>Used in previews and tests      |
| ✅ Mock  | `MockWeatherRepositoryProtocol`, `MockFetchWeatherUseCaseProtocol` (via Mockable)       | Used in unit tests: `SimpleWeatherTests/FetchWeatherUseCase.swift` etc.                |
| ✅ Spy   | `AnalyticsTrackerSpy`, `LoggerSpy` (via Spyable)                                        | Used in unit tests: `SimpleWeatherTests/WeatherViewModelTests.swift`                   |
| ✅ Fake  | `FakeWeatherAPIService` (returns hardcoded but plausible data)                          | `WeatherView/Data/Fakes/FakeWeatherAPIService.swift`<br>Used in previews and tests     |

Mocks and spies are generated using the [Mockable](https://github.com/Kolos65/Mockable) and [Spyable](https://github.com/Matejkob/swift-spyable) frameworks:

```swift
@mockable protocol FetchWeatherUseCaseProtocol { ... }
@spyable protocol AnalyticsTracker { ... }
```

Generated mocks/spies are shared between:

* ✅ Unit tests
* ✅ SwiftUI previews
* ✅ Integration-style flows

---

## 🔍 Key Concepts in Code

* `WeatherAPIService`: talks to Open-Meteo
* `WeatherRepository`: translates DTO to domain
* `FetchWeatherUseCase`: business logic layer
* `WeatherViewModel`: testable, observable presentation logic
* `Logger` + `AnalyticsTracker`: abstracted observability
* `FakeWeatherAPIService`: replaces real API for local testing

---

## 🧪 SwiftUI Preview with Test Doubles

Here's how to use stubs in SwiftUI previews:

```swift
// Using a stub with configurable return values
let stub = WeatherAPIServiceStub(
  weatherToReturn: WeatherResponseDTO(
    temperature: 28.0,
    condition: "Sunny"
  )
)
let repository = WeatherRepository(api: stub)
let useCase = FetchWeatherUseCase(repository: repository)
let viewModel = WeatherViewModel(
  fetchWeatherUseCase: useCase,
  logger: DummyLogger() // Using dummy for dependencies we don't care about
)
    
return WeatherView(viewModel: viewModel)
```

And here's how to use fakes for previews:

```swift
// Using a fake with fixed behavior
let fakeAPI = FakeWeatherAPIService()
let repository = WeatherRepository(api: fakeAPI)
let useCase = FetchWeatherUseCase(repository: repository)
let viewModel = WeatherViewModel(fetchWeatherUseCase: useCase)

// Fetch the weather when preview loads
Task {
  await viewModel.fetchWeather()
}

return WeatherView(viewModel: viewModel)
```

These approaches ensure UI previews can demonstrate different states without real networking.

---

## 🧠 Why This Matters

Most Swift projects struggle with testability and architectural boundaries. This project demonstrates principles that you can adapt to your own architectural decisions:

* Apply dependency inversion principles strategically
* Create previewable, testable SwiftUI components
* Leverage code generation to reduce boilerplate

Understanding these patterns will help inform your own architectural decisions and testing strategies.

---

## 🧪 Common Testing Patterns

This project demonstrates several testing patterns:

* **Given-When-Then** structure in all test cases
* **Dependency injection** via protocols for testability
* **Arrange-Act-Assert** pattern in test methods
* **Verification of interactions** via Mockable's `verify()` API
* **Capturing arguments** and return values for assertions
* **Testing async/await code** with the Swift Testing framework

---

## 📋 Requirements

* iOS 18+
* Swift 6
* Xcode 16.3+
* [Mockable](https://github.com/Kolos65/Mockable) framework
* [Spyable](https://github.com/Matejkob/swift-spyable) framework

---

## 🛠️ Getting Started

1. Clone this repository
2. Open `SimpleWeather.xcodeproj` in Xcode 16.3 or later
3. Build and run the project

To run the tests:
```bash
# From Xcode: Product > Test or ⌘U
# From command line:
xcodebuild test -scheme SimpleWeather -destination 'platform=iOS Simulator,name=iPhone 15'
```

---

## 📱 App in Action

See the SimpleWeather app in action:

![SimpleWeather App Demo](assets/recording.mov)

The demo shows the clean UI and weather fetching functionality in action, highlighting the architecture's simplicity and effectiveness.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Built by **CodeWithShabib**
🔗 [www.codewithshabib.com](https://www.codewithshabib.com)

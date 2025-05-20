import Testing
import Mockable
import Foundation
@testable import SimpleWeather

@MainActor
@Suite("WeatherViewModelTests")
struct WeatherViewModelTests {
  @Test("Should update weather view data when fetch succeeds")
  func fetchWeather_updatesViewData() async throws {
    // Arrange
    let mockUseCase = MockFetchWeatherUseCaseProtocol()
    let spyAnalytics = AnalyticsTrackerSpy()
    let spyLogger = LoggerSpy()
    let viewModel = WeatherViewModel(
      fetchWeatherUseCase: mockUseCase,
      analytics: spyAnalytics,
      logger: spyLogger
    )
    
    let weather = Weather(temperatureCelsius: 24.1, description: "Partly Cloudy")
    given(mockUseCase)
      .execute(city: .any)
      .willReturn(weather)
    
    // Act
    await viewModel.fetchWeather()
    
    // Assert
    #expect(viewModel.isLoading == false)
    #expect(viewModel.weatherViewData != nil)
    #expect(viewModel.weatherViewData?.displayTemp == "24°C")
    #expect(viewModel.weatherViewData?.displayCondition == "Partly Cloudy")
    #expect(viewModel.errorMessage == nil)
    
    // Verify analytics was called
    #expect(spyAnalytics.trackEventCallsCount == 1)
    #expect(spyAnalytics.trackEventReceivedEvent == "WeatherFetched")
    
    // Verify use case was called with correct city
    verify(mockUseCase)
      .execute(city: .value("Toronto"))
      .called(1)
  }
  
  @Test("Should handle errors when fetch fails")
  func fetchWeather_handlesErrors() async throws {
    // Arrange
    let mockUseCase = MockFetchWeatherUseCaseProtocol()
    let spyLogger = LoggerSpy()
    let viewModel = WeatherViewModel(
      fetchWeatherUseCase: mockUseCase,
      analytics: DummyAnalyticsTracker(),
      logger: spyLogger
    )
    
    let error = NSError(domain: "test", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])
    given(mockUseCase)
      .execute(city: .any)
      .willThrow(error)
    
    // Act
    await viewModel.fetchWeather()
    
    // Assert
    #expect(viewModel.isLoading == false)
    #expect(viewModel.weatherViewData == nil)
    #expect(viewModel.errorMessage == "Failed to fetch weather.")
    
    // Verify logger was called with error
    #expect(spyLogger.logCallsCount == 1)
    #expect(spyLogger.logReceivedInvocations.contains("Error: Server error"))
  }
  
  @Test("Should update loading state correctly")
  func fetchWeather_updatesLoadingState() async throws {
    // Arrange
    let mockUseCase = MockFetchWeatherUseCaseProtocol()
    let viewModel = WeatherViewModel(
      fetchWeatherUseCase: mockUseCase,
      analytics: DummyAnalyticsTracker(),
      logger: DummyLogger()
    )
    
    // Create a delayed weather response
    let weather = Weather(temperatureCelsius: 20.0, description: "Clear")
    
    // Set up a delayed response using a custom action
    given(mockUseCase)
      .execute(city: .any)
      .willProduce { _ in
        Thread.sleep(forTimeInterval: 0.01) // 10 ms blocking delay
        return weather
      }
    
    // Act & Assert
    #expect(viewModel.isLoading == false) // Initial state
    
    // Start the fetch operation but don't await it yet
    let task = Task {
      await viewModel.fetchWeather()
    }
    
    // Small delay to allow the fetch to start
    try await Task.sleep(for: .milliseconds(10))
    #expect(viewModel.isLoading == true) // Loading started
    
    // Wait for task to complete
    await task.value
    #expect(viewModel.isLoading == false) // Loading finished
    #expect(viewModel.weatherViewData != nil) // Data was loaded
  }
  
  @Test("Should pass city parameter correctly")
  func fetchWeather_passesCityParameter() async throws {
    // Arrange
    let mockUseCase = MockFetchWeatherUseCaseProtocol()
    let viewModel = WeatherViewModel(
      fetchWeatherUseCase: mockUseCase,
      analytics: DummyAnalyticsTracker(),
      logger: DummyLogger()
    )
    
    given(mockUseCase)
      .execute(city: .any)
      .willReturn(Weather(temperatureCelsius: 18.0, description: "Cloudy"))
    
    // Set a custom city
    viewModel.city = "Vancouver"
    
    // Act
    await viewModel.fetchWeather()
    
    // Verify use case was called with the correct city
    verify(mockUseCase)
      .execute(city: .value("Vancouver"))
      .called(1)
    // Check that default city wasn't used (using correct verification syntax)
    verify(mockUseCase)
      .execute(city: .value("Toronto"))
      .called(0)
  }
}

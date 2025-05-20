import Testing
import Mockable
import Foundation
@testable import SimpleWeather

@Suite("FetchWeatherUseCaseTests")
struct FetchWeatherUseCaseTests {
  @Test("Should return weather data from repository")
  func execute_returnsWeatherFromRepository() async throws {
    // Arrange
    let mockRepository = MockWeatherRepositoryProtocol()
    let useCase = FetchWeatherUseCase(repository: mockRepository)
    
    let expectedWeather = Weather(temperatureCelsius: 22.5, description: "Sunny")
    given(mockRepository)
      .getWeather(for: .any)
      .willReturn(expectedWeather)
    
    // Act
    let result = try await useCase.execute(city: "Toronto")
    
    // Assert
    #expect(result.temperatureCelsius == expectedWeather.temperatureCelsius)
    #expect(result.description == expectedWeather.description)
    
    // Verify repository was called with correct parameter
    verify(mockRepository)
      .getWeather(for: .value("Toronto"))
      .called(1)
  }
  
  @Test("Should propagate errors from repository")
  func execute_propagatesErrors() async {
    // Arrange
    let mockRepository = MockWeatherRepositoryProtocol()
    let useCase = FetchWeatherUseCase(repository: mockRepository)
    
    let error = URLError(.badServerResponse)
    given(mockRepository)
      .getWeather(for: .any)
      .willThrow(error)
    
    // Act & Assert
    await #expect(throws: URLError.self) {
      try await useCase.execute(city: "Toronto")
    }
    
    // Verify repository was called
    verify(mockRepository)
      .getWeather(for: .value("Toronto"))
      .called(1)
  }
  
  @Test("Should pass city parameter correctly")
  func execute_passesCityParameter() async throws {
    // Arrange
    let mockRepository = MockWeatherRepositoryProtocol()
    let useCase = FetchWeatherUseCase(repository: mockRepository)
    
    // Configure for different cities
    given(mockRepository)
      .getWeather(for: .value("Chicago"))
      .willReturn(Weather(temperatureCelsius: 18.0, description: "Windy"))
    
    given(mockRepository)
      .getWeather(for: .value("Miami"))
      .willReturn(Weather(temperatureCelsius: 30.0, description: "Hot"))
    
    // Act
    let chicago = try await useCase.execute(city: "Chicago")
    let miami = try await useCase.execute(city: "Miami")
    
    // Assert
    #expect(chicago.description == "Windy")
    #expect(miami.description == "Hot")
    
    // Verify exact parameters were passed through
    verify(mockRepository)
      .getWeather(for: .value("Chicago"))
      .called(1)
    
    verify(mockRepository)
      .getWeather(for: .value("Miami"))
      .called(1)
  }
}


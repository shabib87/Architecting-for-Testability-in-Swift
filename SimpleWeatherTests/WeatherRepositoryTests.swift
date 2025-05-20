import Testing
import Mockable
import Foundation
@testable import SimpleWeather

@Suite("WeatherAPIServiceTests")
struct WeatherRepositoryTests {
  @Test("Should transform API response to domain model correctly")
  func getWeather_returnsTransformedData() async throws {
    // Arrange
    let mockAPI = MockWeatherAPIServiceProtocol()
    let repository = WeatherRepository(api: mockAPI)
    let dto = WeatherResponseDTO(temperature: 25.0, condition: "Sunny")
    
    given(mockAPI)
      .fetchWeather(for: .any)
      .willReturn(dto)
    
    // Act
    let result = try await repository.getWeather(for: "Toronto")
    
    // Assert
    #expect(result.temperatureCelsius == 25.0)
    #expect(result.description == "Sunny")
    
    // Verify API was called with correct parameter
    verify(mockAPI)
      .fetchWeather(for: .value("Toronto"))
      .called(1)
  }
  
  @Test("Should propagate errors from API service")
  func getWeather_propagatesErrors() async {
    // Arrange
    let mockAPI = MockWeatherAPIServiceProtocol()
    let repository = WeatherRepository(api: mockAPI)
    let error = Foundation.URLError(.badServerResponse)
    
    given(mockAPI)
      .fetchWeather(for: .any)
      .willThrow(error)
    
    // Act & Assert
    await #expect(throws: Foundation.URLError.self) {
      try await repository.getWeather(for: "Toronto")
    }
    
    // Verify API was called
    verify(mockAPI)
      .fetchWeather(for: .value("Toronto"))
      .called(1)
  }
  
  @Test("Should pass city parameter correctly")
  func getWeather_passesCityParameter() async throws {
    // Arrange
    let mockAPI = MockWeatherAPIServiceProtocol()
    let repository = WeatherRepository(api: mockAPI)
    
    given(mockAPI)
      .fetchWeather(for: .any)
      .willReturn(WeatherResponseDTO(temperature: 20.0, condition: "Clear"))
    
    // Act
    _ = try await repository.getWeather(for: "Chicago")
    
    // Verify the exact parameter was passed through
    verify(mockAPI)
      .fetchWeather(for: .value("Chicago"))
      .called(1)
  }
  
  @Test("Should use mapper to transform data correctly")
  func getWeather_usesMapper() async throws {
    // Arrange
    let mockAPI = MockWeatherAPIServiceProtocol()
    let repository = WeatherRepository(api: mockAPI)
    
    let dto = WeatherResponseDTO(temperature: 15.5, condition: "Cloudy")
    let expectedDomain = Weather(temperatureCelsius: 15.5, description: "Cloudy")
    
    given(mockAPI)
      .fetchWeather(for: .any)
      .willReturn(dto)
    
    // Act
    let result = try await repository.getWeather(for: "Boston")
    
    // Assert - verify the mapping was done correctly
    #expect(result.temperatureCelsius == expectedDomain.temperatureCelsius)
    #expect(result.description == expectedDomain.description)
  }
}

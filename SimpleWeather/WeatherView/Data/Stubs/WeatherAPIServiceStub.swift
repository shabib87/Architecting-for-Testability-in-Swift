import Foundation

/**
 * A stub implementation of the WeatherAPIServiceProtocol for testing purposes.
 * Difference with FakeWeatherAPIService is that this one allows to configure the return values.
 * This is useful for unit tests where you want to simulate different scenarios.
 */

struct WeatherAPIServiceStub: WeatherAPIServiceProtocol {
  // Configurable return values for testing specific scenarios
  var weatherToReturn: WeatherResponseDTO
  var errorToThrow: Error?
  
  init(weatherToReturn: WeatherResponseDTO = WeatherResponseDTO(temperature: 25.0, condition: "Sunny"), 
       errorToThrow: Error? = nil) {
    self.weatherToReturn = weatherToReturn
    self.errorToThrow = errorToThrow
  }
  
  func fetchWeather(for city: String) async throws -> WeatherResponseDTO {
    if let error = errorToThrow {
      throw error
    }
    return weatherToReturn
  }
}

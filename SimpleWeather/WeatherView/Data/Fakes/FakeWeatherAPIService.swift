import Foundation

/**
 * A fake implementation of the WeatherAPIServiceProtocol for testing purposes.
 * This implementation returns a fixed response and is not configurable.
 * It is useful for SwiftUI previews and integration tests where you want to simulate a specific scenario.
 */

struct FakeWeatherAPIService: WeatherAPIServiceProtocol {
  func fetchWeather(for city: String) async throws -> WeatherResponseDTO {
    return WeatherResponseDTO(temperature: 19.5, condition: "Fake Cloudy")
  }
}

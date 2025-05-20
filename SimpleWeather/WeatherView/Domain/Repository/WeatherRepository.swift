import Foundation
import Mockable

@Mockable
protocol WeatherRepositoryProtocol: Sendable {
  func getWeather(for city: String) async throws -> Weather
}

final class WeatherRepository: WeatherRepositoryProtocol {
  private let api: WeatherAPIServiceProtocol
  
  init(api: WeatherAPIServiceProtocol) {
    self.api = api
  }
  
  func getWeather(for city: String) async throws -> Weather {
    let dto = try await api.fetchWeather(for: city)
    return WeatherDTOMapper.map(from: dto)
  }
}

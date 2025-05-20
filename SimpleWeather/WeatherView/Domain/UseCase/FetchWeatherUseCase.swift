import Foundation
import Mockable

@Mockable
protocol FetchWeatherUseCaseProtocol: Sendable {
  func execute(city: String) async throws -> Weather
}

final class FetchWeatherUseCase: FetchWeatherUseCaseProtocol {
  private let repository: WeatherRepositoryProtocol
  
  init(repository: WeatherRepositoryProtocol) {
    self.repository = repository
  }
  
  func execute(city: String) async throws -> Weather {
    try await repository.getWeather(for: city)
  }
}

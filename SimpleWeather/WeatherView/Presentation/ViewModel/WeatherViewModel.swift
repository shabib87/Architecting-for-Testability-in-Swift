import Foundation
import Mockable

@Mockable
@MainActor
protocol WeatherViewModelProtocol: ObservableObject {
  var city: String { get set }
  var weatherViewData: WeatherViewData? { get }
  var isLoading: Bool { get }
  var errorMessage: String? { get }
  
  func fetchWeather() async
}

@MainActor
final class WeatherViewModel: WeatherViewModelProtocol {
  @Published var city: String = "Toronto"
  @Published var weatherViewData: WeatherViewData?
  @Published var isLoading = false
  @Published var errorMessage: String?
  
  // Mark these properties as nonisolated since they're immutable after initialization
  private nonisolated let fetchWeatherUseCase: FetchWeatherUseCaseProtocol
  private nonisolated let analytics: AnalyticsTracker
  private nonisolated let logger: Logger
  
  init(
    fetchWeatherUseCase: FetchWeatherUseCaseProtocol = FetchWeatherUseCase(
      repository: WeatherRepository(api: WeatherAPIService())
    ),
    analytics: AnalyticsTracker = DefaultAnalyticsTracker(),
    logger: Logger = DefaultLogger()
  ) {
    self.fetchWeatherUseCase = fetchWeatherUseCase
    self.analytics = analytics
    self.logger = logger
  }
  
  func fetchWeather() async {
    isLoading = true
    errorMessage = nil
    
    do {
      let weather = try await fetchWeatherUseCase.execute(city: city)
      weatherViewData = WeatherViewDataMapper.map(from: weather)
      analytics.track(event: "WeatherFetched")
    } catch {
      errorMessage = "Failed to fetch weather."
      logger.log("Error: \(error.localizedDescription)")
    }
    
    isLoading = false
  }
}

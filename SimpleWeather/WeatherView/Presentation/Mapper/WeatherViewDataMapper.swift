import Foundation

/**
 * Mapper for converting Weather domain model to Weather View Data model.
 */

struct WeatherViewDataMapper {
  static func map(from weather: Weather) -> WeatherViewData {
    WeatherViewData(
      displayTemp: "\(Int(weather.temperatureCelsius))°C",
      displayCondition: weather.description
    )
  }
}

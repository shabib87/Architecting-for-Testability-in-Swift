import Foundation

/**
 * Pure function mapper for DTO to Domain model.
 */
struct WeatherDTOMapper {
  static func map(from dto: WeatherResponseDTO) -> Weather {
    Weather(temperatureCelsius: dto.temperature, description: dto.condition)
  }
}

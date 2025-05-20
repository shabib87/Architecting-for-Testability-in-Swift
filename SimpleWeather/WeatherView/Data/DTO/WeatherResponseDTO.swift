import Foundation

struct WeatherResponseDTO: Decodable {
  let temperature: Double
  let condition: String
}

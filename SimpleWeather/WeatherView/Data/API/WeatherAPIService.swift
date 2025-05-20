import Foundation
import Mockable

@Mockable
protocol URLSessionProtocol: Sendable {
  func data(from url: URL) async throws -> (Data, URLResponse)
}

// Make URLSession conform to the protocol
extension URLSession: URLSessionProtocol {}

@Mockable
protocol WeatherAPIServiceProtocol: Sendable {
  func fetchWeather(for city: String) async throws -> WeatherResponseDTO
}

final class WeatherAPIService: WeatherAPIServiceProtocol {
  private let session: URLSessionProtocol
  
  init(session: URLSessionProtocol = URLSession.shared) {
    self.session = session
  }
  
  func fetchWeather(for city: String) async throws -> WeatherResponseDTO {
    // Sample API call to Open-Meteo
    // Always uses Toronto coordinates for simplicity
    let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=43.7&longitude=-79.42&current_weather=true")!
    let (data, response) = try await session.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw URLError(.badServerResponse)
    }
    
    do {
      let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
      
      guard
        let current = json?["current_weather"] as? [String: Any],
        let temp = current["temperature"] as? Double,
        let code = current["weathercode"] as? Int
      else {
        throw URLError(.cannotParseResponse)
      }
      
      let condition = code >= 3 ? "Cloudy" : "Clear"
      return WeatherResponseDTO(temperature: temp, condition: condition)
    } catch {
      throw URLError(.cannotParseResponse)
    }
  }
}

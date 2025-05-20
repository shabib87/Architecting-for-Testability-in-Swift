import Testing
import Mockable
import Foundation
@testable import SimpleWeather

@Suite("WeatherAPIServiceTests")
struct WeatherAPIServiceTests {
  @Test("Should parse API response correctly")
  func fetchWeather_parsesResponseCorrectly() async throws {
    // Arrange
    let mockSession = MockURLSessionProtocol()
    let service = WeatherAPIService(session: mockSession)
    
    // Create valid response data
    let jsonString = """
    {
      "current_weather": {
        "temperature": 18.5,
        "weathercode": 1
      }
    }
    """
    let jsonData = jsonString.data(using: .utf8)!
    let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    
    given(mockSession)
      .data(from: .any)
      .willReturn((jsonData, response))
    
    // Act
    let result = try await service.fetchWeather(for: "Toronto")
    
    // Assert
    #expect(result.temperature == 18.5)
    #expect(result.condition == "Clear")
    
    // Verify the URL session was called
    verify(mockSession)
      .data(from: .any)
      .called(1)
  }
  
  @Test("Should throw error when API returns non-200 status")
  func fetchWeather_throwsOnBadResponse() async {
    // Arrange
    let mockSession = MockURLSessionProtocol()
    let service = WeatherAPIService(session: mockSession)
    
    let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)!
    
    given(mockSession)
      .data(from: .any)
      .willReturn((Data(), response))
    
    // Act & Assert
    await #expect(throws: URLError.self) {
      try await service.fetchWeather(for: "Toronto")
    }
  }
  
  @Test("Should throw error when response cannot be parsed")
  func fetchWeather_throwsOnInvalidData() async {
    // Arrange
    let mockSession = MockURLSessionProtocol()
    let service = WeatherAPIService(session: mockSession)
    
    let invalidData = "Not valid JSON".data(using: .utf8)!
    let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    
    given(mockSession)
      .data(from: .any)
      .willReturn((invalidData, response))
    
    // Act & Assert
    await #expect(throws: URLError.self) {
      try await service.fetchWeather(for: "Toronto")
    }
  }
}

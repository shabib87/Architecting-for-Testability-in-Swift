import SwiftUI

struct WeatherView: View {
  @StateObject private var viewModel: WeatherViewModel
  
  init(viewModel: WeatherViewModel = WeatherViewModel()) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    VStack(spacing: 16) {
      TextField("Enter city", text: $viewModel.city)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
      
      if viewModel.isLoading {
        ProgressView()
      } else if let viewData = viewModel.weatherViewData {
        VStack(spacing: 8) {
          Text(viewData.displayTemp)
            .font(.largeTitle)
          Text(viewData.displayCondition)
        }
      } else if let error = viewModel.errorMessage {
        Text(error).foregroundColor(.red)
      }
      
      Button("Fetch Weather") {
        Task { await viewModel.fetchWeather() }
      }
    }
    .padding()
  }
}

#if DEBUG

/**
 * Preview using a stubbed API service.
 */
struct WeatherView_SunnyPreview: PreviewProvider {
  static var previews: some View {
    let stub = WeatherAPIServiceStub(
      weatherToReturn: WeatherResponseDTO(
        temperature: 28.0,
        condition: "Sunny"
      )
    )
    let repository = WeatherRepository(api: stub)
    let useCase = FetchWeatherUseCase(repository: repository)
    let viewModel = WeatherViewModel(
      fetchWeatherUseCase: useCase,
      // Using dummy since we don't care about logging in preview
      logger: DummyLogger()
    )
    
    return WeatherView(viewModel: viewModel)
      .previewDisplayName("Using Stubbed API")
  }
}

/**
 * Preview using a Fake API service.
 */
struct WeatherView_FakePreview: PreviewProvider {
  static var previews: some View {
    let fakeAPI = FakeWeatherAPIService()
    
    let repository = WeatherRepository(api: fakeAPI)
    let useCase = FetchWeatherUseCase(repository: repository)

    let viewModel = WeatherViewModel(fetchWeatherUseCase: useCase)
    
    Task {
      await viewModel.fetchWeather()
    }
    
    return WeatherView(viewModel: viewModel)
      .previewDisplayName("Using Fake API")
  }
}
#endif

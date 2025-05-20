import Foundation
import Spyable

@Spyable
protocol AnalyticsTracker: Sendable {
  func track(event: String)
}

struct DefaultAnalyticsTracker: AnalyticsTracker {
  func track(event: String) {
    print("[Analytics] Event: \(event)")
  }
}

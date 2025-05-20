import Foundation

/**
 * A dummy implementation of the AnalyticsTracker protocol for testing purposes.
 * Use DummyAnalyticsTracker when testing components that require an analytics tracker but you don't care about tracking
 */

struct DummyAnalyticsTracker: AnalyticsTracker {
  func track(event: String) {
    // Intentionally does nothing
  }
}

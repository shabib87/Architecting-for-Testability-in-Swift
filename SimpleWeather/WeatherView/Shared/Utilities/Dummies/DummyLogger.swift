import Foundation

/**
 * A dummy implementation of the Logger protocol for testing purposes.
 * Use DummyLogger when testing components that require a logger but you don't care about logging
 */

struct DummyLogger: Logger {
  func log(_ message: String) {
    // Intentionally does nothing
  }
}

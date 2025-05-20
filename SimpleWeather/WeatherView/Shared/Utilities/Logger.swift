import Foundation
import Spyable

@Spyable
protocol Logger: Sendable {
  func log(_ message: String)
}

struct DefaultLogger: Logger {
  func log(_ message: String) {
    print("[Log] \(message)")
  }
}

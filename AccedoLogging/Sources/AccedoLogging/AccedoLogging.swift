/// It will be exported automatically on depending modules.
/// (No need to import `OSLog` on consumer modules)
@_exported import OSLog
import Foundation

/*
 I've decided to move super simple with logging strategy.
 I will keep it as simple as possible,
 It will be a simple extension on OSLog logger for achieving a decoupled log system.
 */

/// <#Description#>
private let networkCategory = "Network"

/// <#Description#>
private let viewCategory = "View"

public protocol Logging {
    func debug(metadata: String?, message: @autoclosure () -> String)

    func notice(metadata: String?, message: @autoclosure () -> String)

    func error(metadata: String?, message: @autoclosure () -> String)

    func error(metadata: String?, error: some Error, message: @autoclosure () -> String)
}

@available(iOS 14.0, *)
extension OSLog {
    /// Name of subsystem/Subsystem tag.
    private static let subSystem = "com.sajacl.Accedo"

    /// Logger component for logging network interactions.
    public static let networkLogger = Logger(subsystem: subSystem, category: networkCategory)

    /// Logger component for logging view interactions.
    public static let viewLogger = Logger(subsystem: subSystem, category: viewCategory)
}

@available(iOS 14.0, *)
extension Logger: Logging {
    public func debug(metadata: String? = nil, message: @autoclosure () -> String) {
        let _message = message()
        debug("\(_message)")
    }
    
    public func notice(metadata: String? = nil, message: @autoclosure () -> String) {
        let _message = message()
        notice("\(_message)")
    }
    
    public func error(metadata: String? = nil, message: @autoclosure () -> String) {
        let _message = message()
        log(level: .error, "\(_message)")
    }

    public func error(
        metadata: String?,
        error: some Error,
        message: @autoclosure () -> String
    ) {
        let error = message()
        log(level: .error, "\(error)")
    }
}

public struct CustomLogger: Logging {
    private let logResolver: (String) -> Void

    private let category: String

    public static let networkLogger = CustomLogger(category: networkCategory)
    
    public static let viewLogger = CustomLogger(category: viewCategory)

    public init(category: String, logger: @escaping (String) -> Void = { print($0) }) {
        self.category = category
        logResolver = logger
    }

    public func debug(metadata: String? = nil, message: @autoclosure () -> String) {
        dump("Debug", message())
    }

    public func notice(metadata: String? = nil, message: @autoclosure () -> String) {
        dump("Info", message())
    }

    public func error(metadata: String? = nil, message: @autoclosure () -> String) {
        dump("Error", message())
    }

    public func error(
        metadata: String? = nil,
        error: some Error,
        message: @autoclosure () -> String
    ) {
        let _message = "[Underlying error description: \(error.localizedDescription)] [Error message: \(message())]"
        dump("Error", _message)
    }

    private func dump(_ arg: String,_ message: String) {
        logResolver("-[\(arg)] [\(category)] \(message)")
    }
}

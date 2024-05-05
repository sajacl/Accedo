/// It will be exported automatically on depending modules.
/// (No need to import `OSLog` on consumer modules)
@_exported import OSLog
import Foundation

/*
 I've decided to move super simple with logging strategy.
 I will keep it as simple as possible,
 It will be a simple extension on OSLog logger for achieving a decoupled log system.
 */

/// Tag that will be used for categorizing network logs.
private let networkCategory = "Network"

/// Tag that will be used for categorizing database logs.
private let databaseCategory = "Database"

/// Tag that will be used for categorizing view logs.
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
    public static let databaseLogger = Logger(subsystem: subSystem, category: databaseCategory)

    /// Logger component for logging view interactions.
    public static let viewLogger = Logger(subsystem: subSystem, category: viewCategory)
}

@available(iOS 14.0, *)
extension Logger: Logging {
    public func debug(metadata: String? = nil, message: @autoclosure () -> String) {
        let _message = message()
        debug("\(formatLog(metadata: metadata, message: _message))")
    }
    
    public func notice(metadata: String? = nil, message: @autoclosure () -> String) {
        let _message = message()
        notice("\(formatLog(metadata: metadata, message: _message))")
    }
    
    public func error(metadata: String? = nil, message: @autoclosure () -> String) {
        let _message = message()
        log(level: .error, "\(formatLog(metadata: metadata, message: _message))")
    }

    public func error(
        metadata: String?,
        error: some Error,
        message: @autoclosure () -> String
    ) {
        let _message = "[Underlying error description: \(error.localizedDescription)] [Error message: \(message())]"
        let formattedMessage = "\(formatLog(metadata: metadata, message: _message))"
        log(level: .error, "\(formattedMessage)")
    }
}

public struct CustomLogger: Logging {
    private let logResolver: (String) -> Void

    private let category: String

    public static let networkLogger = CustomLogger(category: networkCategory)
    
    public static let databaseLogger = CustomLogger(category: databaseCategory)

    public static let viewLogger = CustomLogger(category: viewCategory)

    public init(category: String, logger: @escaping (String) -> Void = { print($0) }) {
        self.category = category
        logResolver = logger
    }

    public func debug(metadata: String? = nil, message: @autoclosure () -> String) {
        dump("Debug", "\(formatLog(metadata: metadata, message: message()))")
    }

    public func notice(metadata: String? = nil, message: @autoclosure () -> String) {
        dump("Info", "\(formatLog(metadata: metadata, message: message()))")
    }

    public func error(metadata: String? = nil, message: @autoclosure () -> String) {
        dump("Error", "\(formatLog(metadata: metadata, message: message()))")
    }

    public func error(
        metadata: String? = nil,
        error: some Error,
        message: @autoclosure () -> String
    ) {
        let _message = "[Underlying error description: \(error.localizedDescription)] [Error message: \(message())]"
        dump("Error", "\(formatLog(metadata: metadata, message: _message))")
    }

    private func dump(_ arg: String,_ message: String) {
        logResolver("-[\(arg)] [\(category)] \(message)")
    }
}

fileprivate func formatLog(metadata: String? = nil, message: @autoclosure () -> String) -> String {
    var string = ""

    metadata.flatMap { string = "[\($0)] " }

    string += message()

    return string
}

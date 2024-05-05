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
    public static let networkLogger = Logger(subsystem: subSystem, category: "Network")

    /// Logger component for logging view interactions.
    public static let viewLogger = Logger(subsystem: subSystem, category: "View")
}

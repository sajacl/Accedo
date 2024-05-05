import OSLog

/*
 I've decided to move super simple with logging strategy.
 I will keep it as simple as possible,
 It will be a simple extension on OSLog logger for achieving a decoupled log system.
 */

@available(iOS 14.0, *)
extension OSLog {
    /// Name of subsystem/Subsystem tag.
    private static let subSystem = "com.sajacl.Accedo"

    /// Logger component for logging network interactions.
    public static let networkLogger = Logger(subsystem: subSystem, category: "Network")

    /// Logger component for logging view interactions.
    public static let viewLogger = Logger(subsystem: subSystem, category: "View")
}

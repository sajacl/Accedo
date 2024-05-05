import Foundation

extension REST {
    private static let nslock = NSLock()
    private static var taskCount: UInt32 = 0

    static func getTaskIdentifier(name: String) -> String {
        nslock.lock()
        defer { nslock.unlock() }

        let (partialValue, isOverflow) = taskCount.addingReportingOverflow(1)
        let nextValue = isOverflow ? 1 : partialValue
        taskCount = nextValue

        return "\(name).\(nextValue)"
    }
}

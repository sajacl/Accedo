import Foundation

/// Custom actor for handling db/cache interactions.
@globalActor
public final actor DatabaseActor {
    public static var shared = DatabaseActor()
}

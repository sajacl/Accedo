import SwiftUI
import AccedoUI

@main
struct AccedoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            GenreWireframe.create(with: ProcessInfo.processInfo.environment["api_key"])
        }
    }
}

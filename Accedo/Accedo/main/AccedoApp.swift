import SwiftUI
import AccedoUI

// Uncomment next line if you want to visit `SwiftUI` representation.
//@main
struct AccedoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    genreScreen
                }
            } else {
                NavigationView {
                    genreScreen
                }
            }
        }
        .environment(\.cellStyle, SU.AnyCellStyle(style: SU.DefaultCellStyle()))
    }

    private var genreScreen: some View {
        GenreWireframe.create(with: ProcessInfo.processInfo.environment["api_key"])
    }
}

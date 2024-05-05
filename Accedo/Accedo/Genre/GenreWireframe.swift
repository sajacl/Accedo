import Foundation
import SwiftUI
import AccedoREST

@MainActor
enum GenreWireframe {
    static func create(
        with authorizationProvider: @autoclosure () throws -> REST.Authorization?
    ) -> some View {
        guard let authorization = try? authorizationProvider() else {
            fatalError("Please configure your api key, you can find how in README")
        }

        let networkProxy = REST.GenreNetworkProxy(authorizationProvider: authorization)

        let repository = GenreRepository()

        let viewModel = GenreViewModel(
            networkProxy: networkProxy,
            repository: repository
        )

        let view = GenreView(viewModel: viewModel)

        return view
    }
}

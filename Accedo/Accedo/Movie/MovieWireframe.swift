import Foundation
import SwiftUI
import AccedoREST

@MainActor
enum MovieWireframe {
    static func create(
        with authorizationProvider: @autoclosure () throws -> REST.Authorization?
    ) -> some View {
        guard let authorization = try? authorizationProvider() else {
            fatalError("Please configure your api key, you can find how in README")
        }

        let networkProxy = REST.MovieNetworkProxy(authorizationProvider: authorization)

        let repository = MovieRepository()

        let viewModel = MovieViewModel(
            networkProxy: networkProxy,
            repository: repository
        )

        let view = MovieView(viewModel: viewModel)

        return view
    }
}

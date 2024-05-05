import Foundation
import SwiftUI
import AccedoREST

@MainActor
enum GenreWireframe {
    @available(iOS 13.0, *)
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

    static func create(
        with authorizationProvider: @autoclosure () throws -> REST.Authorization?
    ) -> UIViewController {
        guard let authorization = try? authorizationProvider() else {
            fatalError("Please configure your api key, you can find how in README")
        }

        let networkProxy = REST.GenreNetworkProxy(authorizationProvider: authorization)

        let repository = GenreRepository()

        let interactor = GenreInteractor(networkProxy: networkProxy, repository: repository)

        let view = GenreViewController()

        let presenter = GenrePresenter(view: view, interactor: interactor)

        view.presenter = presenter

        return view
    }
}

private struct UIGenreViewController: UIViewControllerRepresentable {
    let authorizationProvider: () throws -> REST.Authorization?

    func makeUIViewController(context: Context) -> some UIViewController {
        guard let authorization = try? authorizationProvider() else {
            fatalError("Please configure your api key, you can find how in README")
        }

        let networkProxy = REST.GenreNetworkProxy(authorizationProvider: authorization)

        let repository = GenreRepository()

        let interactor = GenreInteractor(networkProxy: networkProxy, repository: repository)

        let view = GenreViewController()

        let presenter = GenrePresenter(view: view, interactor: interactor)

        view.presenter = presenter

        return UINavigationController(rootViewController: view)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

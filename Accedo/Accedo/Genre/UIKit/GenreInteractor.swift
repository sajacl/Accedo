import Foundation
import AccedoREST

final class GenreInteractor {
    private let networkProxy: any RESTGenreNetworkProxy
    private let repository: any GenreRepositoryInterface

    init(networkProxy: any RESTGenreNetworkProxy, repository: any GenreRepositoryInterface) {
        self.networkProxy = networkProxy
        self.repository = repository
    }

    
}

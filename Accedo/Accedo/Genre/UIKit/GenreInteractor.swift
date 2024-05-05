import Foundation
import AccedoREST

final class GenreInteractor {
    /// Object responsible for proxy network calls for fetching genres list.
    private let networkProxy: any RESTGenreNetworkProxy
    
    /// Object responsible for handle interactions between database and application.
    private let repository: any GenreRepositoryInterface
    
    /// Token of network request.
    private var requestToken: (any Cancellable)?

    init(networkProxy: any RESTGenreNetworkProxy, repository: any GenreRepositoryInterface) {
        self.networkProxy = networkProxy
        self.repository = repository
    }

    deinit {
        cancel()
    }

    func cancel() {
        requestToken?.cancel()
    }

    func fetchAndUpdateGenreList(
        completionHandler: @escaping (Result<[Genre], Error>) -> Void
    ) {
        getGenres { [weak self] fetchResult in
            switch fetchResult {
                case let .success(genres):
                    self?.fetchedGenres(genres, completionHandler: completionHandler)

                case let .failure(error):
                    completionHandler(.failure(error))
            }
        }
    }

    private func fetchedGenres(
        _ genres: [Genre],
        completionHandler: @escaping (Result<[Genre], Error>) -> Void
    ) {
        guard !genres.isEmpty else {
            return refreshGenres(with: completionHandler)
        }

        completionHandler(.success(genres))
    }

    private func refreshGenres(with completionHandler: @escaping (Result<[Genre], Error>) -> Void) {
        updateGenres { [weak self] result in
            switch result {
                case .success:
                    self?.getGenres { fetchResult in
                        switch fetchResult {
                            case let .success(genres):
                                completionHandler(.success(genres))

                            case let .failure(error):
                                completionHandler(.failure(error))
                        }
                    }

                case let .failure(updateGenresError):
                    completionHandler(.failure(updateGenresError))
            }
        }
    }

    private func getGenres(completionHandler: @escaping (Result<[Genre], Error>) -> Void) {
        Task {
            do {
                let genres = try await repository.getGenres()

                completionHandler(.success(genres))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }

    private func updateGenres(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        requestToken = networkProxy.fetchGenres { [weak self] fetchResult in
            switch fetchResult {
                case let .success(response):
                    Task { [weak self] in
                        do {
                            guard let self else {
                                throw AttemptToSaveWhenAlreadyDeallocatedFailure()
                            }

                            try await self.repository.upsertGenres(response.genres)

                            completionHandler(.success)
                        } catch {
                            completionHandler(.failure(error))
                        }
                    }

                case let .failure(error):
                    completionHandler(.failure(error))
            }
        }
    }
    
    /// Error that can happen in edge case scenario,
    /// Usually when access race occurs.
    // I know it's name is bad, it's 11 pm =D
    struct AttemptToSaveWhenAlreadyDeallocatedFailure: LocalizedError {
        var errorDescription: String? {
            "Attempting to save genre list when interactor is already deallocated."
        }
    }
}

extension Result where Success == Void {
    fileprivate static var success: Result<Void, Error> {
        .success(())
    }
}

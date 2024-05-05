import Foundation
import AccedoREST

final class GenrePresenter {
    /// Light weight state machine.
    enum State {
        case loading

        case empty

        case list(genres: [Genre])
    }

    private unowned let view: GenreViewController

    private let interactor: GenreInteractor

    private let internalQueue = DispatchQueue(label: "GenrePresenter.InternalQueue")

    private var _state: State = .loading
    private var state: State {
        get {
            internalQueue.sync {
                _state
            }
        }

        set {
            internalQueue.sync {
                _state = newValue
            }
        }
    }

    init(view: GenreViewController, interactor: GenreInteractor) {
        self.view = view
        self.interactor = interactor
    }

    func viewDidAppear() {
        updateState(.loading)

        interactor.fetchAndUpdateGenreList { [weak self] result in
            guard let self else {
                // no-op
                return
            }

            switch result {
                case let .success(genres):
                    if genres.isEmpty {
                        updateState(.empty)
                    } else {
                        updateState(.list(genres: genres))
                    }

                case let .failure(error):
                    self.view.showErrorAlert(for: error)
            }
        }
    }

    private func updateState(_ newState: State) {
        state = newState

        DispatchQueue.main.async {
            self.view.stateUpdated(self.state)
        }
    }
}

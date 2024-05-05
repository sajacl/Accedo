import Foundation
import AccedoREST

final class GenrePresenter {
    /// Light weight state machine.
    enum State {
        case loading

        case empty

        case list
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

    }
}

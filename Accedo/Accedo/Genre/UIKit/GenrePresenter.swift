import Foundation
import AccedoREST

final class GenrePresenter {
    private unowned let view: GenreViewController

    private let interactor: GenreInteractor

    init(view: GenreViewController, interactor: GenreInteractor) {
        self.view = view
        self.interactor = interactor
    }
}

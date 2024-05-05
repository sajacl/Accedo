import Foundation
import SwiftUI
import AccedoUI

struct GenreView: View {
    @StateObject private var viewModel = GenreViewModel(authorization: "6f83e26e82a37507bf29b27ff511f452")

    var body: some View {
        List(viewModel.genres) { genre in
            SU.GenreCell(title: genre.name)
        }
        .onAppear(perform: viewModel.viewDidAppear)
    }
}

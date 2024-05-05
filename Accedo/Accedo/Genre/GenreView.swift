import Foundation
import SwiftUI
import AccedoUI

struct GenreView: View {
    @StateObject private var viewModel: GenreViewModel

    private let userInterfaceIdiom: UIUserInterfaceIdiom

    public init(
        viewModel: GenreViewModel,
        userInterfaceIdiom: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.userInterfaceIdiom = userInterfaceIdiom
    }

    var body: some View {
        listView
            .onAppear(perform: viewModel.viewDidAppear)
    }

    @ViewBuilder
    private var listView: some View {
        if userInterfaceIdiom == .phone {
            listCell
        } else {
            gridCell
        }
    }

    private var listCell: some View {
        List(viewModel.genres) { genre in
            LazyVStack {
                SU.GenreCell(title: genre.name)
            }
        }
    }

    private var gridCell: some View {
        ScrollView{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                ForEach(viewModel.genres, id: \.self) { genre in
                    Button(
                        action: {

                        },
                        label: {
                            SU.GenreCell(title: genre.name)
                        }
                    )
                }
            }
        }
    }
}

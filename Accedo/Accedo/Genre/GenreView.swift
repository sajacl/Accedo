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
        mainView
            .onAppear(perform: viewModel.viewDidAppear)
            .alert(
                "Error",
                isPresented: $viewModel.error.isPresented,
                actions: {
                    viewModel.error.flatMap {
                        Text($0.localizedDescription)
                    }

                    Button(
                        action: {
                            viewModel.error = nil
                        },
                        label: {
                            Text("Ok")
                        }
                    )
                }
            )
    }

    @ViewBuilder
    private var mainView: some View {
        switch viewModel.state {
            case .loading:
                loadingView

            case .empty:
                EmptyView()

            case .list:
                listView
        }
    }

    private var loadingView: some View {
        SU.LoadingView()
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

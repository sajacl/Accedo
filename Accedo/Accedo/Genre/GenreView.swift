import Foundation
import SwiftUI
import AccedoUI

struct GenreView: View {
    @StateObject private var viewModel: GenreViewModel

    @State private var userInterfaceIdiom: UIUserInterfaceIdiom

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
            .toolbar {
                Button("Layout") {
                    let newInterface: UIUserInterfaceIdiom = userInterfaceIdiom == .phone ? .pad: .phone

                    withAnimation(.smooth) {
                        userInterfaceIdiom = newInterface
                    }
                }
            }
            .navigationDestination(for: Genre.self) { genre in
                viewModel.createGenreDetail(for: genre)
            }
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
                createCellView(for: genre)
            }
        }
    }

    private var gridCell: some View {
        ScrollView{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                ForEach(viewModel.genres, id: \.self) { genre in
                    createCellView(for: genre)
                }
            }
        }
    }

    private func createCellView(for genre: Genre) -> some View {
        NavigationLink(
            value: genre,
            label: {
                SU.GenreCell(title: genre.name)
            }
        )
    }
}

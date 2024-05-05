import Foundation
import SwiftUI
import AccedoUI

struct MovieView: View {
    private let genreName: String

    @StateObject private var viewModel: MovieViewModel

    private let userInterfaceIdiom: UIUserInterfaceIdiom

    public init(
        genreName: String,
        viewModel: MovieViewModel,
        userInterfaceIdiom: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
    ) {
        self.genreName = genreName
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
            .navigationTitle(genreName)
    }

    @ViewBuilder
    private var mainView: some View {
        switch viewModel.state {
            case .wholeViewLoading:
                loadingView

            case .empty:
                EmptyView()

            case .list:
                listView

            case .loadingMoreItems:
                VStack {
                    listView

                    loadingView
                }
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
        List(viewModel.movies) { movie in
            LazyVStack {
                SU.MovieCell(name: movie.title, imageURL: nil)
            }
        }
    }

    private var gridCell: some View {
        ScrollView{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                ForEach(viewModel.movies, id: \.self) { movie in
                    Button(
                        action: {

                        },
                        label: {
                            SU.GenreCell(title: movie.title)
                        }
                    )
                }
            }
        }
    }
}

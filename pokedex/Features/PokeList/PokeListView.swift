import SwiftUI

struct PokeListView: View {
    // Look up "MVVM" (AKA "Model View ViewModel"). It's a pretty popular architecture that's easily testable. Testability is the name of the game.
    // For this example, `PokeListView` is the view, `PokeListViewModel` is the viewModel, and `Pokemon` is the model.
    @StateObject private var viewModel = PokeListViewModel()

    var body: some View {
        List {
            ForEach(viewModel.pokemon, id: \.name) { pokemon in
                Text(pokemon.name.capitalized)
                    .padding()
            }
        }
        .onAppear {
            viewModel.fetchPokemon()
        }
    }
}

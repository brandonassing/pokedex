import Foundation
import Combine

class PokeListViewModel: ObservableObject {

    // These `@Published` properties are used in combination with the `ObservableObject` at the top, and the `@StateObject` in `PokeListView` so the view knows to refresh when there's an update.
    // Kind of a lot to unpack there, but maybe not worth diving too deep into the inner workings right away.
    @Published var pokemon: [Pokemon] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let pokemonService: PokemonServicing

    // We pass in the dependency bc it makes it easier to test, since for the test we can pass in a fake one.
    // This is a pretty rudimentary example of a powerful concept called "dependency injection".
    init(pokemonService: PokemonServicing = PokemonService()) {
        self.pokemonService = pokemonService
    }

    // Function that the view calls to load data.
    func fetchPokemon(limit: Int = 20, page: Int = 0) {
        Task {
            await updateLoading(true)

            do {
                let response = try await pokemonService.getPokemon(
                    limit: limit,
                    offset: getOffset(limit: limit, page: page)
                )
                
                await updateResponse(response)
            } catch {
                await updateError("Failed to fetch Pokémon: \(error.localizedDescription)")
            }

            await updateLoading(false)
        }
    }

    private func getOffset(limit: Int, page: Int) -> Int {
        return limit * page
    }

    // MARK: UI updaters.
    // These functions need to be called on the main thread since they drive UI (UI updates should always happen on the main thread).
    @MainActor private func updateLoading(_ loading: Bool) {
        isLoading = loading
    }

    @MainActor private func updateResponse(_ response: PokemonResponse) {
        pokemon = response.results
    }

    @MainActor private func updateError(_ message: String) {
        errorMessage = message
    }
}

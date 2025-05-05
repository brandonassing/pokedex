import Foundation

// Protocols are nice for testability.
// You can have your "real" concrete implementation (ie: `NetworkService`), and a "fake" test implementation (ie: `NetworkServiceFake`) which you use to mock your tests.
protocol PokemonServicing {
    func getPokemon(limit: Int, offset: Int) async throws -> PokemonResponse
}

// I like to think of this component as reflecting the REST API. It's responsible for fetching the actual data from the server, so it's nice if it matches the inputs and outputs of the API call.
// Eg: for "/pokemon?limit=<number>&offset=<number2>", `getPokemon(limit: Int, offset: Int) -> PokemonResponse` is the translation.
// The inputs here are `limit` and `offset`, and the output is `results` (which is what's in `PokemonResponse`).
// The app uses this to make the API request.
class PokemonService: PokemonServicing {

    private static let baseURLString = "https://pokeapi.co/api/v2"

    func getPokemon(limit: Int, offset: Int) async throws -> PokemonResponse {
        let urlString = PokemonService.baseURLString + "/pokemon?limit=\(limit)&offset=\(offset)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        let results = try decoder.decode(PokemonResponse.self, from: data)

        return results
    }
}


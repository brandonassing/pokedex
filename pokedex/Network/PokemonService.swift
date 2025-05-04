import Foundation

// Protocols are nice for testability.
// You can have your "real" concrete implementation (ie: `NetworkService`), and a "fake" test implementation (ie: `NetworkServiceFake`) which you use to mock your tests.
protocol NetworkServicing {
    func getPokemon(limit: Int, page: Int) async throws -> PokemonResponse
}

class NetworkService: NetworkServicing {

    private static let baseURLString = "https://pokeapi.co/api/v2"

    func getPokemon(limit: Int, page: Int) async throws -> PokemonResponse {
        let urlString = NetworkService.baseURLString + "/pokemon?limit=\(limit)&offset=\(getOffset(limit: limit, page: page))"
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

    private func getOffset(limit: Int, page: Int) -> Int {
        return limit * page
    }
}


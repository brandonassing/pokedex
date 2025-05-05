
class PokemonServiceFake: PokemonServicing {
    var getPokemonResponseResult: Result<PokemonResponse, Error> = .failure(TestError.test)
    func getPokemon(limit: Int, offset: Int) async throws -> PokemonResponse {
        switch getPokemonResponseResult {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}

enum TestError: Error {
    case test
}

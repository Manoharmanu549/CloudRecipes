import Foundation

protocol RecipeServiceProtocol {
    func fetchRecipes() async throws -> RecipesResponse
}

class RecipeService: RecipeServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchRecipes() async throws -> RecipesResponse {
        guard let url = URL(string: baseURL) else {
            throw NetworkError.noData
        }
        return try await networkService.request(url: url)
    }
}


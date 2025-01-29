import Foundation
@testable import AssignmentSwiftUI

class MockRecipeService: RecipeServiceProtocol {
    var shouldReturnError = false
    var mockRecipes: [Recipe] = []

    func fetchRecipes() async throws -> RecipesResponse {
        if shouldReturnError {
            throw URLError(.badServerResponse)
        }
        return RecipesResponse(recipes: mockRecipes)
    }
}

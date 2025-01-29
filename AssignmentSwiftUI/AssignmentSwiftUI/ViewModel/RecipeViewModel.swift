import Combine
import Foundation

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var errorMessage: String?

    private let recipeService: RecipeServiceProtocol

    init(recipeService: RecipeServiceProtocol) {
        self.recipeService = recipeService
    }

    func loadRecipes() async {
        do {
            let fetchedRecipes = try await recipeService.fetchRecipes()
            self.recipes = fetchedRecipes.recipes
        } catch {
            self.errorMessage = "Failed to load recipes: \(error.localizedDescription)"
        }
    }
}

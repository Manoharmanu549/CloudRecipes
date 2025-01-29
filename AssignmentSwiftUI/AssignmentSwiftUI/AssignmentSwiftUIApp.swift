
import SwiftUI

@main
struct AssignmentSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            RecipeListView(viewModel: RecipeViewModel(recipeService: RecipeService(networkService: NetworkService())))
        }
    }
}

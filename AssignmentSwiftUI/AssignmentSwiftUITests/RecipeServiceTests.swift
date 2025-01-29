import XCTest
@testable import AssignmentSwiftUI

@MainActor
final class RecipeViewModelTests: XCTestCase {
    var viewModel: RecipeViewModel!
    var mockService: MockRecipeService!

    override func setUp() {
        super.setUp()
        mockService = MockRecipeService()
        viewModel = RecipeViewModel(recipeService: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testLoadRecipes_Success() async {
        let mockRecipe = Recipe(
            id: UUID(),
            cuisine: "Test Cuisine",
            name: "Test Recipe",
            photoURLLarge: nil,
            photoURLSmall: nil,
            sourceURL: nil,
            youtubeURL: nil
        )
        mockService.mockRecipes = [mockRecipe]

        await viewModel.loadRecipes()

        XCTAssertEqual(viewModel.recipes.count, 1)
        XCTAssertEqual(viewModel.recipes.first?.name, "Test Recipe")
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoadRecipes_EmptyData() async {
        mockService.mockRecipes = []
        await viewModel.loadRecipes()

        XCTAssertEqual(viewModel.recipes.count, 0)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoadRecipes_Error() async {
        mockService.shouldReturnError = true

        await viewModel.loadRecipes()

        XCTAssertEqual(viewModel.recipes.count, 0)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Failed to load recipes: The operation couldn’t be completed. (NSURLErrorDomain error -1011.)")
    }
}

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel: RecipeViewModel

    init(viewModel: RecipeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            List(viewModel.recipes) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                    RecipeRow(recipe: recipe)
                }
            }
            .navigationTitle("Recipes")
            .refreshable {
                await viewModel.loadRecipes()
            }
            .task {
                await viewModel.loadRecipes()
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}


struct RecipeRow: View {
    let recipe: Recipe
    @StateObject private var imageLoader = ImageLoader()

    var body: some View {
        HStack {
            // Recipe Image
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 50, height: 50)
            }

            // Recipe Details
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            Task {
                await imageLoader.loadImage(from: recipe.photoURLSmall ?? "")
            }
        }
    }
}

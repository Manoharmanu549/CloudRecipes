import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                if let url = recipe.photoURLLarge, let imageUrl = URL(string: url) {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 300)
                }
                
                Text(recipe.name)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                Text(recipe.cuisine)
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                
                if let sourceURL = recipe.sourceURL, let source = URL(string: sourceURL) {
                    Link("View Full Recipe", destination: source)
                        .font(.headline)
                        .padding(.vertical)
                }
                
                if let youtubeURL = recipe.youtubeURL, let youtube = URL(string: youtubeURL) {
                    Link("Watch on YouTube", destination: youtube)
                        .font(.headline)
                        .padding(.vertical)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

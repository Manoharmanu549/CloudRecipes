import SwiftUI


class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    
    @MainActor
    func loadImage(from urlString: String) async {
        if let cachedImage = loadImageFromCache(urlString: urlString) {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: urlString) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let downloadedImage = UIImage(data: data) {
                self.image = downloadedImage
                saveImageToCache(image: downloadedImage, urlString: urlString)
            }
        } catch {
            print("Error loading image: \(error)")
        }
    }

    private func loadImageFromCache(urlString: String) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent(urlString.hashValue.description)
        return UIImage(contentsOfFile: fileURL.path)
    }

    private func saveImageToCache(image: UIImage, urlString: String) {
        let fileURL = cacheDirectory.appendingPathComponent(urlString.hashValue.description)
        if let data = image.pngData() {
            try? data.write(to: fileURL)
        }
    }
}

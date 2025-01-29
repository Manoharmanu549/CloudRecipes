import Foundation

// MARK: - Network Service Protocol
protocol NetworkServiceProtocol {
    func request<T: Decodable>(url: URL) async throws -> T
}

// MARK: - Network Service
class NetworkService: NetworkServiceProtocol {
    func request<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw NetworkError.invalidStatusCode(httpResponse.statusCode)
        }
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch let error {
            print("Error \(error.localizedDescription)")
            throw NetworkError.decodingError
        }
    }
}

// MARK: - Network Error
enum NetworkError: Error {
    case noData
    case decodingError
    case invalidStatusCode(Int)
}

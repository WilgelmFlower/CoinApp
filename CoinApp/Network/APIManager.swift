import Foundation
import UIKit

class APIManager {

    static let shared = APIManager()
    private let apiKey = "7931676f-9e93-4877-ba16-1f3bdda5a97e"

    func getCoinsData(page: Int, completion: @escaping (Result<[CoinModel], Error>) -> Void) {
        guard var urlComponents = URLComponents(string: "https://api.coincap.io/v2/assets") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let queryItems = [
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "offset", value: "\(page)")
        ]
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Accept-Encoding")

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let coinData = try JSONDecoder().decode(CoinModel.self, from: data)
                completion(.success([coinData]))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
}

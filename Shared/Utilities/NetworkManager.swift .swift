//
//  NetworkManager.swift .swift
//  weather_info (iOS)
//
//  Created by vignesh on 22/02/25.
//

import Foundation


enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL provided."
        case .noData:
            return "No data received from the server."
        case .decodingError:
            return "Failed to decode server response."
        case .serverError(let message):
            return message
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()   // Singleton instance
    private init() {}
    
    /// Generic function to fetch and decode data from an API.
    func fetchData<T: Decodable>(from urlString: String, responseType: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        if let jsonString = String(data: data, encoding: .utf8) {
            print("📜 JSON Data: \(jsonString)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError("Server responded with an error.")
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError
        }
    }
}

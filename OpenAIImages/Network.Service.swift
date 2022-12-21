//
//  NetworkService.swift
//  OpenAIImages
//
//  Created by Ingo Boehme on 21.12.22.
//

import Foundation

protocol DataService {
    static func load<T: Decodable>(
        from request: URLRequest,
        convertTo type: T.Type) async throws -> T

}

class NetworkService: DataService {
    static func load<T: Decodable>(
        from request: URLRequest,
        convertTo type: T.Type) async throws -> T
    {
        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode >= 300 {
            throw NetworkError.httpError(httpResponse.statusCode)
        }

        let decodedData = try JSONDecoder().decode(T.self, from: data)

        return decodedData
    }
}

class MockService: DataService {
    static func load<T>(from request: URLRequest, convertTo type: T.Type) async throws -> T where T : Decodable {
        throw NetworkError.noData
    }
    
    
}
